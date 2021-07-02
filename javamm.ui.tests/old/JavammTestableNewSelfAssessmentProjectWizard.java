/**
 * 
 */
package javamm.tests.utils.ui;

import com.google.inject.Inject;

import javamm.ui.wizard.selfassessment.JavammNewSelfAssessmentProjectWizard;
import javamm.ui.wizard.selfassessment.JavammSelfAssessmentProjectCreator;

/**
 * Manually set the project name (usually set in the dialog text edit)
 * 
 * @author Lorenzo Bettini
 */
public class JavammTestableNewSelfAssessmentProjectWizard extends JavammNewSelfAssessmentProjectWizard {

	public static final String TEST_PROJECT = "TestProject";

	@Inject
	public JavammTestableNewSelfAssessmentProjectWizard(JavammSelfAssessmentProjectCreator projectCreator) {
		super(projectCreator);
	}

	@Override
	protected String getMainPageProjectName() {
		// to have code coverage
		super.getMainPageProjectName();
		return TEST_PROJECT;
	}
}
