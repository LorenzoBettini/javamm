package javamm.ui.tests

import javamm.JavammUiInjectorProvider
import javamm.ui.internal.JavammActivator
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.ui.tests.editor.outline.AbstractOutlineWorkbenchTest
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammUiInjectorProvider))
class JavammOutlineTest extends AbstractOutlineWorkbenchTest {
	
//	@Inject PluginProjectHelper projectHelper
	
	override protected getEditorId() {
		JavammActivator.JAVAMM_JAVAMM
	}

//	@BeforeClass
//	def static void setUpTargetPlatform() {
//		PDETargetPlatformUtils.setTargetPlatform();
//	}

//	override protected createjavaProject(String projectName) throws CoreException {
//		projectHelper.createJavaPluginProject
//			(projectName, newArrayList("javamm.runtime"))
//	}

	@Test
	def void testOutlineOfJavammFile() {
		'''
void m() {
	
}

String n(boolean b, int i) {
	return null;
}

m();
n(true, 0);
		'''.assertAllLabels(
'''
test
  m() : void
  n(boolean, int) : String
  main(String[]) : void
'''
		)
	}

}