/**
 * 
 */
package javamm.tests.utils.ui;

import org.eclipse.xtext.ui.wizard.IProjectCreator;
import org.eclipse.xtext.ui.wizard.IProjectInfo;

import com.google.inject.Inject;

import javamm.ui.wizard.JavammNewProjectWizard;

/**
 * Manually set the project name (usually set in the dialog text edit)
 * 
 * @author Lorenzo Bettini
 */
public class JavammTestableNewProjectWizard extends JavammNewProjectWizard {

	public static final String TEST_PROJECT = "TestProject";

	@Inject
	public JavammTestableNewProjectWizard(IProjectCreator projectCreator) {
		super(projectCreator);
	}

	@Override
	public IProjectInfo getProjectInfo() {
		IProjectInfo projectInfo = super.getProjectInfo();
		projectInfo.setProjectName(TEST_PROJECT);
		return projectInfo;
	}
}
