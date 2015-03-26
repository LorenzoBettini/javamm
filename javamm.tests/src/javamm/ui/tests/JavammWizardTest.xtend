package javamm.ui.tests

import com.google.inject.Inject
import com.google.inject.Provider
import javamm.JavammUiInjectorProvider
import javamm.tests.utils.ui.JavammTestableNewFileWizard
import javamm.tests.utils.ui.JavammTestableNewProjectWizard
import javamm.tests.utils.ui.PDETargetPlatformUtils
import javamm.tests.utils.ui.PluginProjectHelper
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.jface.wizard.Wizard
import org.eclipse.jface.wizard.WizardDialog
import org.eclipse.ui.PlatformUI
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.ui.AbstractWorkbenchTest
import org.junit.BeforeClass
import org.junit.Test
import org.junit.runner.RunWith

import static org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammUiInjectorProvider))
class JavammWizardTest extends AbstractWorkbenchTest {
	
	@Inject Provider<JavammTestableNewProjectWizard> wizardProvider

	@Inject Provider<JavammTestableNewFileWizard> fileWizardProvider
	
	@Inject PluginProjectHelper projectHelper
	
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

	@BeforeClass
	def static void beforeClass() {
		PDETargetPlatformUtils.setTargetPlatform();
	}

	@Test def void testJavammNewProjectWizard() {
		val wizard = wizardProvider.get
		wizard.init(PlatformUI.getWorkbench(), new StructuredSelection());
		createAndFinishWizardDialog(wizard)
		val project = root.getProject(JavammTestableNewProjectWizard.TEST_PROJECT)
		assertTrue(project.exists())
		waitForAutoBuild
		projectHelper.assertNoErrors
	}

	@Test def void testJavammNewFileWizard() {
		val project = projectHelper.createJavaPluginProject
			(JavammTestableNewProjectWizard.TEST_PROJECT, newArrayList("javamm.runtime")).project
		val srcFolder = project.getFolder("src")
		assertTrue(srcFolder.exists)
		val wizard = fileWizardProvider.get
		wizard.init(PlatformUI.getWorkbench(), new StructuredSelection(srcFolder))
		createAndFinishWizardDialog(wizard)
		val file = srcFolder.getFile(JavammTestableNewFileWizard.TEST_FILE + ".javamm")
		assertTrue(file.exists())
		waitForAutoBuild
		projectHelper.assertNoErrors
		val srcGenFolder = project.getFolder("src-gen/javamm")
		assertTrue(srcGenFolder.exists)
		val genfile = srcGenFolder.getFile(JavammTestableNewFileWizard.TEST_FILE + ".java")
		assertTrue(genfile.exists())
	}

}