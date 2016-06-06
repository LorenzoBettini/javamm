/**
 * 
 */
package javamm.tests.utils.ui;

import org.eclipse.xtext.ui.wizard.IExtendedProjectInfo;
import org.eclipse.xtext.ui.wizard.IProjectCreator;

import com.google.inject.Inject;

import javamm.ui.wizard.JavammNewProjectWizardCustom;

/**
 * Manually set the project name (usually set in the dialog text edit)
 * 
 * @author Lorenzo Bettini
 */
public class JavammTestableNewProjectWizard extends JavammNewProjectWizardCustom {

	public static final String TEST_PROJECT = "TestProject";

	@Inject
	public JavammTestableNewProjectWizard(IProjectCreator projectCreator) {
		super(projectCreator);
	}

	@Override
	public IExtendedProjectInfo getProjectInfo() {
		IExtendedProjectInfo projectInfo = super.getProjectInfo();
		projectInfo.setProjectName(TEST_PROJECT);
		return projectInfo;
	}
}
