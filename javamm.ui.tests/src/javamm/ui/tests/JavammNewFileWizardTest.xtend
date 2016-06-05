package javamm.ui.tests

import com.google.inject.Inject
import com.google.inject.Provider
import javamm.tests.utils.ui.JavammTestableNewFileWizard
import javamm.tests.utils.ui.JavammTestableNewProjectWizard
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.ui.PlatformUI
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammUiInjectorProvider))
class JavammNewFileWizardTest extends JavammAbstractWizardTest {
	
	@Inject Provider<JavammTestableNewFileWizard> fileWizardProvider
	
	@Test def void testJavammNewFileWizard() {
		println("Creating project...")
		val project = projectHelper.createJavaPluginProject
			(JavammTestableNewProjectWizard.TEST_PROJECT, newArrayList("javamm.runtime")).project
		val srcFolder = project.getFolder("src")
		assertTrue(srcFolder.exists)
		val wizard = fileWizardProvider.get
		wizard.init(PlatformUI.getWorkbench(), new StructuredSelection(srcFolder))
		println("Using new file wizard...")
		createAndFinishWizardDialog(wizard)
		val file = srcFolder.getFile(JavammTestableNewFileWizard.TEST_FILE + ".javamm")
		assertTrue(file.exists())
		println("Waiting for build...")
		waitForBuild
		projectHelper.assertNoErrors
		println("Waiting for build...")
		waitForBuild
		val srcGenFolder = project.getFolder("src-gen/javamm")
		assertTrue("src-gen/javamm does not exist", srcGenFolder.exists)
		val genfile = srcGenFolder.getFile(JavammTestableNewFileWizard.TEST_FILE + ".java")
		assertTrue(JavammTestableNewFileWizard.TEST_FILE + ".java does not exist" , genfile.exists())
		projectHelper.assertNoErrors
		println("No errors in project, OK!")
	}

}