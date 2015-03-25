package javamm.ui.tests

import com.google.inject.Inject
import javamm.JavammUiInjectorProvider
import javamm.tests.utils.ui.PluginProjectHelper
import javamm.ui.internal.JavammActivator
import org.eclipse.core.resources.IProject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.ui.AbstractEditorTest
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith

import static org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammUiInjectorProvider))
class JavammEditorTest extends AbstractEditorTest {
	
	@Inject PluginProjectHelper projectHelper
	
	val TEST_PROJECT = "mytestproject"

	val TEST_FILE = "TestFile"
	
	var IProject project
	
	override protected getEditorId() {
		JavammActivator.JAVAMM_JAVAMM
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
	def void testEditorContentsModifiedInvalidatesComputedModelFeatures() {
		createTestFile(
'''
System.out.println("Hello " + "world!");
'''
		)
		
		waitForAutoBuild
		projectHelper.assertNoErrors
		val srcGenFolder = project.getFolder("src-gen/javamm")
		assertTrue(srcGenFolder.exists)
		val genfile = srcGenFolder.getFile(TEST_FILE + ".java")
		assertTrue(genfile.exists())
	}

}