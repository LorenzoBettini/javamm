package javamm.ui.tests

import com.google.inject.Inject
import com.google.inject.Provider
import javamm.selfassessment.builder.builder.JavammSelfAssessmentNature
import javamm.tests.utils.ui.JavammTestableNewProjectWizard
import javamm.tests.utils.ui.JavammTestableNewSelfAssessmentProjectWizard
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.ui.PlatformUI
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.*
import javamm.tests.utils.ui.PluginProjectHelper

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammUiInjectorProvider))
class JavammNewSelfAssessmentProjectWizardTest extends JavammAbstractWizardTest {

	@Inject Provider<JavammTestableNewSelfAssessmentProjectWizard> wizardProvider

	@Test def void testJavammNewProjectWizard() {
		println("Creating new project wizard...")
		val wizard = wizardProvider.get
		wizard.init(PlatformUI.getWorkbench(), new StructuredSelection());
		println("Using wizard...")
		createAndFinishWizardDialog(wizard)
		val studentProject = root.getProject(JavammTestableNewProjectWizard.TEST_PROJECT +
			JavammSelfAssessmentNature.STUDENT_PROJECT_SUFFIX)
		assertTrue("student project does not exist", studentProject.exists())
		val teacherProject = root.getProject(JavammTestableNewProjectWizard.TEST_PROJECT +
			JavammSelfAssessmentNature.TEACHER_PROJECT_SUFFIX)
		assertTrue("teacher project does not exist", teacherProject.exists())
		println("Waiting for build...")
		// we wait for the .class file to be copied in the student's project
		waitForBuild
		// we wait for the student's project to be recompiled
		waitForBuild
		PluginProjectHelper.assertNoErrors
		println("No errors in project, OK!")
	}

}