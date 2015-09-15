/**
 * 
 */
package javamm.ui.wizard;

import org.eclipse.ui.dialogs.WizardNewProjectCreationPage;
import org.eclipse.xtext.ui.wizard.IProjectCreator;
import org.eclipse.xtext.ui.wizard.IProjectInfo;

import com.google.inject.Inject;

/**
 * We need to redefine it just to change Javamm to Java--
 * 
 * @author Lorenzo Bettini
 *
 */
public class JavammNewProjectWizardCustom extends JavammNewProjectWizard {

	private WizardNewProjectCreationPage mainPage;

	@Inject
	public JavammNewProjectWizardCustom(IProjectCreator projectCreator) {
		super(projectCreator);
		setWindowTitle("New Java-- Project");
	}
	
	/**
	 * Use this method to add pages to the wizard.
	 * The one-time generated version of this class will add a default new project page to the wizard.
	 */
	@Override
	public void addPages() {
		mainPage = new WizardNewProjectCreationPage("basicNewProjectPage");
		mainPage.setTitle("Java-- Project");
		mainPage.setDescription("Create a new Java-- project.");
		addPage(mainPage);
	}

	/**
	 * Use this method to read the project settings from the wizard pages and feed them into the project info class.
	 */
	@Override
	protected IProjectInfo getProjectInfo() {
		JavammProjectInfo projectInfo = new JavammProjectInfo();
		projectInfo.setProjectName(mainPage.getProjectName());
		return projectInfo;
	}
	
}
