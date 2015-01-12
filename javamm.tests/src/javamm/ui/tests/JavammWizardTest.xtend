package javamm.ui.tests

import com.google.inject.Inject
import com.google.inject.Provider
import javamm.JavammUiInjectorProvider
import javamm.tests.utils.ui.JavammTestableNewProjectWizard
import org.eclipse.core.resources.IMarker
import org.eclipse.core.resources.IResource
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.jface.wizard.Wizard
import org.eclipse.jface.wizard.WizardDialog
import org.eclipse.ui.PlatformUI
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.ui.AbstractWorkbenchTest
import org.junit.Test
import org.junit.runner.RunWith

import static org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammUiInjectorProvider))
class JavammWizardTest extends AbstractWorkbenchTest {
	
	@Inject Provider<JavammTestableNewProjectWizard> wizardProvider
	
	/**
	 * Create the wizard dialog, open it and press Finish.
	 */
	def protected int createAndFinishWizardDialog(Wizard wizard) {
		val dialog = new WizardDialog(wizard.shell, wizard) {
			override open() {
				val thread = new Thread("Press Finish") {
					override run() {
						// wait for the shell to become active
						while (getShell() == null) {
							Thread.sleep(1000)
						}
						getShell().getDisplay().asyncExec[
							finishPressed();
						]					
					}			
				};
				thread.start();
				return super.open();
			}
		};
		return dialog.open();
	}

	@Test def void testJavammNewProjectWizard() {
		val wizard = wizardProvider.get
		wizard.init(PlatformUI.getWorkbench(), new StructuredSelection());
		createAndFinishWizardDialog(wizard)
		val project = root.getProject(JavammTestableNewProjectWizard.TEST_PROJECT)
		assertTrue(project.exists())
		waitForAutoBuild
		assertNoErrors
	}

	def private assertNoErrors() {
		val markers = root.findMarkers(IMarker.PROBLEM, true, IResource.DEPTH_INFINITE);
		assertEquals(
			"unexpected errors:\n" +
			markers.map[getAttribute(IMarker.LOCATION) + 
				", " + getAttribute(IMarker.MESSAGE)].join("\n"),
			0, 
			markers.size
		)
	}
}