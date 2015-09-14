/**
 * 
 */
package javamm.ui.wizard.selfassessment;

import org.eclipse.ui.dialogs.WizardNewProjectCreationPage;
import org.eclipse.xtext.ui.wizard.IProjectInfo;

import com.google.inject.Inject;

import javamm.selfassessment.builder.builder.JavammSelfAssessmentNature;
import javamm.ui.wizard.JavammNewProjectWizard;
import javamm.ui.wizard.JavammProjectInfo;

/**
 * We need to redefine it just to change Javamm to Java--
 * 
 * @author Lorenzo Bettini
 *
 */
public class JavammNewSelfAssessmentProjectWizard extends JavammNewProjectWizard {

	private WizardNewProjectCreationPage mainPage;

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
		mainPage = new WizardNewProjectCreationPage("basicNewProjectPage");
		mainPage.setTitle("Java-- Self-Assessment Projects");
		mainPage.setDescription("Create a new Java-- self-assessment project set.");
		addPage(mainPage);
	}

	/**
	 * Use this method to read the project settings from the wizard pages and feed them into the project info class.
	 */
	@Override
	protected IProjectInfo getProjectInfo() {
		JavammProjectInfo projectInfo = new JavammProjectInfo();
		projectInfo.setProjectName(getTeacherStudentProjectName());
		return projectInfo;
	}

	protected String getMainPageProjectName() {
		return mainPage.getProjectName();
	}

	protected String getTeacherStudentProjectName() {
		return getMainPageProjectName() + JavammSelfAssessmentNature.STUDENT_PROJECT_SUFFIX;
	}
}
