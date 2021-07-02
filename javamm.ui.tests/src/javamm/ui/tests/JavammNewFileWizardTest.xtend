package javamm.ui.tests

import com.google.inject.Inject
import com.google.inject.Provider
import javamm.tests.utils.ui.JavammTestableNewFileWizard
import javamm.tests.utils.ui.ProjectImportUtil
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.ui.PlatformUI
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.*
import org.junit.Before
import org.eclipse.core.resources.IProject
import org.eclipse.core.runtime.Path

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammUiInjectorProvider))
class JavammNewFileWizardTest extends JavammAbstractWizardTest {

	@Inject Provider<JavammTestableNewFileWizard> fileWizardProvider

	val static TEST_PROJECT = "javamm.ui.tests.project"

	var IProject project

	@Before
	def void importProject() {
		project = ProjectImportUtil.importProject(TEST_PROJECT)
		waitForBuild
	}

	@Test def void testJavammNewFileWizard() {
		val srcFolder = project.getFolder("src")
		assertTrue(srcFolder.exists)
		val wizard = fileWizardProvider.get
		wizard.init(PlatformUI.getWorkbench(), new StructuredSelection(srcFolder))
		println("Using new file wizard...")
		createAndFinishWizardDialog(wizard)
		val filePath = new Path("src")
			.append(TEST_PROJECT.replace(".", "/"))
			.append(JavammTestableNewFileWizard.TEST_FILE + ".javamm")
		val file = project.getFile(filePath)
		assertTrue(file.exists())
		println("Waiting for build...")
		waitForBuild
		projectHelper.assertNoErrors
		println("Waiting for build...")
		waitForBuild
		val srcGenFolder = project.getFolder("src-gen/javamm")
		assertTrue("src-gen/javamm does not exist", srcGenFolder.exists)
		val genfile = srcGenFolder.getFile(JavammTestableNewFileWizard.TEST_FILE + ".java")
		assertTrue(JavammTestableNewFileWizard.TEST_FILE + ".java does not exist", genfile.exists())
		projectHelper.assertNoErrors
		println("No errors in project, OK!")
	}

}
