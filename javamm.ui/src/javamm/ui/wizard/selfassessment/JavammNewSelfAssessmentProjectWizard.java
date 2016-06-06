/**
 * 
 */
package javamm.ui.wizard.selfassessment;

import org.eclipse.xtext.ui.wizard.IExtendedProjectInfo;

import com.google.inject.Inject;

import javamm.selfassessment.builder.builder.JavammSelfAssessmentNature;
import javamm.ui.wizard.JavammNewProjectWizard;
import javamm.ui.wizard.JavammWizardNewProjectCreationPage;

/**
 * We need to redefine it just to change titles, descriptions and project names.
 * 
 * @author Lorenzo Bettini
 *
 */
public class JavammNewSelfAssessmentProjectWizard extends JavammNewProjectWizard {

	@Inject
	public JavammNewSelfAssessmentProjectWizard(JavammSelfAssessmentProjectCreator projectCreator) {
		super(projectCreator);
		setWindowTitle("New Java-- Self-Assessment Projects");
	}

	/**
	 * Use this method to add pages to the wizard.
	 * The one-time generated version of this class will add a default new project page to the wizard.
	 */
	@Override
	public void addPages() {
		super.addPages();
		JavammWizardNewProjectCreationPage mainPage = getMainPage();
		mainPage.setTitle("Java-- Self-Assessment Projects");
		mainPage.setDescription("Create a new Java-- self-assessment project set.");
	}

	/**
	 * Use this method to read the project settings from the wizard pages and feed them into the project info class.
	 */
	@Override
	protected IExtendedProjectInfo getProjectInfo() {
		IExtendedProjectInfo projectInfo = super.getProjectInfo();
		projectInfo.setProjectName(getTeacherStudentProjectName());
		return projectInfo;
	}

	protected String getMainPageProjectName() {
		return getMainPage().getProjectName();
	}

	protected String getTeacherStudentProjectName() {
		return getMainPageProjectName() + JavammSelfAssessmentNature.STUDENT_PROJECT_SUFFIX;
	}
}
