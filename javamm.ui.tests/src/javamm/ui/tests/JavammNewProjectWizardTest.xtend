package javamm.ui.tests

import com.google.inject.Inject
import com.google.inject.Provider
import javamm.tests.utils.ui.JavammTestableNewProjectWizard
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.ui.PlatformUI
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammUiInjectorProvider))
class JavammNewProjectWizardTest extends JavammAbstractWizardTest {

	@Inject Provider<JavammTestableNewProjectWizard> wizardProvider

	@Test def void testJavammNewProjectWizard() {
		println("Creating new project wizard...")
		val wizard = wizardProvider.get
		wizard.init(PlatformUI.getWorkbench(), new StructuredSelection());
		println("Using wizard...")
		createAndFinishWizardDialog(wizard)
		val project = root.getProject(JavammTestableNewProjectWizard.TEST_PROJECT)
		assertTrue(project.exists())
		println("Waiting for build...")
		waitForBuild
		projectHelper.assertNoErrors
		println("No errors in project, OK!")
	}

}