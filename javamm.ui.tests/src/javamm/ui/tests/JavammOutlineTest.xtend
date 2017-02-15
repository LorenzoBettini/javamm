package javamm.ui.tests

import javamm.ui.internal.JavammActivator
import org.eclipse.xtext.junit4.ui.AbstractOutlineTest
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammUiInjectorProvider))
class JavammOutlineTest extends AbstractOutlineTest {
	
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