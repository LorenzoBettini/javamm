package javamm.ui.tests

import com.google.inject.Inject
import com.google.inject.Provider
import javamm.JavammUiInjectorProvider
import javamm.tests.utils.ui.JavammTestableNewFileWizard
import javamm.tests.utils.ui.JavammTestableNewProjectWizard
import javamm.tests.utils.ui.PluginProjectHelper
import javamm.tests.utils.ui.TestableWizardDialog
import org.eclipse.core.resources.IMarker
import org.eclipse.core.resources.IResource
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.jface.wizard.Wizard
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

	@Inject Provider<JavammTestableNewFileWizard> fileWizardProvider
	
	@Inject PluginProjectHelper projectHelper
	
	/**
	 * Create the wizard dialog, open it and press Finish.
	 */
	def protected int createAndFinishWizardDialog(Wizard wizard) {
		new TestableWizardDialog(wizard.shell, wizard).open();
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
		assertNoErrors
		val srcGenFolder = project.getFolder("src-gen/javamm")
		assertTrue(srcGenFolder.exists)
		val genfile = srcGenFolder.getFile(JavammTestableNewFileWizard.TEST_FILE + ".java")
		assertTrue(genfile.exists())
	}

	def private assertNoErrors() {
		val markers = root.findMarkers(IMarker.PROBLEM, true, IResource.DEPTH_INFINITE).
			filter[
				getAttribute(IMarker.SEVERITY, IMarker.SEVERITY_INFO) == IMarker.SEVERITY_ERROR
			]
		assertEquals(
			"unexpected errors:\n" +
			markers.map[getAttribute(IMarker.LOCATION) + 
				", " + getAttribute(IMarker.MESSAGE)].join("\n"),
			0, 
			markers.size
		)
	}
}