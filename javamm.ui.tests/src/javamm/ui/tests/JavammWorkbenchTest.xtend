package javamm.ui.tests

import com.google.inject.Inject
import javamm.tests.utils.ui.PluginProjectHelper
import org.eclipse.core.resources.IProject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.ui.testing.AbstractWorkbenchTest
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith

import static org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammUiInjectorProvider))
class JavammWorkbenchTest extends AbstractWorkbenchTest {

	@Inject PluginProjectHelper projectHelper

	val TEST_PROJECT = "mytestproject"

	val TEST_FILE = "TestFile"

	var IProject project

	@Before
	override void setUp() {
		super.setUp
		project = projectHelper.createJavammPluginProject(TEST_PROJECT).project
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
		projectHelper.assertNoErrors
		reallyWaitForAutoBuild
		var srcGenFolder = project.getFolder("src-gen/javamm")
		if (!srcGenFolder.exists) {
			println("pausing since src-gen/javamm folder does not exist yet...")
			Thread.sleep(5000)
		}
		srcGenFolder = project.getFolder("src-gen/javamm")
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
		projectHelper.assertErrors(
			'''
			Java problem: Incompatible operand types Boolean and Integer
			Incompatible operand types Boolean and Integer'''
		)
	}
}
