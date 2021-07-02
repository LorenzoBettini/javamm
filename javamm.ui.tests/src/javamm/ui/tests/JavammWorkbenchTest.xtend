package javamm.ui.tests

import javamm.tests.utils.ui.PluginProjectHelper
import javamm.tests.utils.ui.ProjectImportUtil
import org.eclipse.core.resources.IProject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.BeforeClass
import org.junit.Test
import org.junit.runner.RunWith

import static org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.cleanWorkspace
import static org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.createFile
import static org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.waitForBuild

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammUiInjectorProvider))
class JavammWorkbenchTest extends CustomAbstractWorkbenchTest {

	val static TEST_PROJECT = "javamm.ui.tests.project"

	val static TEST_FILE = "TestFile"

	var static IProject project

	@BeforeClass
	def static void importTestProject() throws Exception {
		cleanWorkspace();
		project = ProjectImportUtil.importProject(TEST_PROJECT);
		waitForBuild();
	}

	def createTestFile(CharSequence contents) {
		createFile(TEST_PROJECT + "/src/" + TEST_FILE + ".javamm", contents.toString)
	}

	@Test
	def void testJavaFileIsGeneratedInSrcGen() {
		createTestFile(
			'''
			System.out.println("Hello " + "world!");
			'''
		)

		waitForBuild
		PluginProjectHelper.assertNoErrors
		var srcGenFolder = project.getFolder("src-gen/javamm")
		assertTrue("src-gen/javamm does not exist", srcGenFolder.exists)
		val genfile = srcGenFolder.getFile(TEST_FILE + ".java")
		assertTrue(TEST_FILE + ".java does not exist", genfile.exists())
	}

	@Test
	def void testErrorInGeneratedJavaCode() {
		createTestFile(
			'''
			int a = 2;
			int b = 2;
			int c = 2;
			if (a==b==c==2) {
				System.out.println("TRUE");
			}
			'''
		)

		waitForBuild
		// one error in the generated Java file, and one in the original file
		PluginProjectHelper.assertErrors(
			'''
			Java problem: Incompatible operand types Boolean and Integer
			Incompatible operand types Boolean and Integer'''
		)
	}
}
