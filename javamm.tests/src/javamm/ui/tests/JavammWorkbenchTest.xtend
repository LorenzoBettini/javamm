package javamm.ui.tests

import com.google.inject.Inject
import javamm.JavammUiInjectorProvider
import javamm.tests.utils.ui.PDETargetPlatformUtils
import javamm.tests.utils.ui.PluginProjectHelper
import org.eclipse.core.resources.IProject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.ui.AbstractWorkbenchTest
import org.junit.Before
import org.junit.BeforeClass
import org.junit.Test
import org.junit.runner.RunWith

import static org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammUiInjectorProvider))
class JavammWorkbenchTest extends AbstractWorkbenchTest {
	
	@Inject PluginProjectHelper projectHelper
	
	val TEST_PROJECT = "mytestproject"

	val TEST_FILE = "TestFile"
	
	var IProject project
	
	@BeforeClass
	def static void beforeClass() {
		PDETargetPlatformUtils.setTargetPlatform();
	}

	@Before
	override void setUp() {
		super.setUp
		project = projectHelper.createJavaPluginProject
			(TEST_PROJECT, newArrayList("javamm.runtime")).project
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
		
		reallyWaitForAutoBuild
		projectHelper.assertNoErrors
		reallyWaitForAutoBuild
		val srcGenFolder = project.getFolder("src-gen/javamm")
		assertTrue(srcGenFolder.exists)
		val genfile = srcGenFolder.getFile(TEST_FILE + ".java")
		assertTrue(genfile.exists())
	}

}