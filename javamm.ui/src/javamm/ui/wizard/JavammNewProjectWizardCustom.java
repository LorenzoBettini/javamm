/**
 * 
 */
package javamm.ui.wizard;

import org.eclipse.xtext.ui.wizard.IProjectCreator;

import com.google.inject.Inject;

/**
 * We need to redefine it just to change Javamm to Java--
 * 
 * @author Lorenzo Bettini
 *
 */
public class JavammNewProjectWizardCustom extends JavammNewProjectWizard {

	@Inject
	public JavammNewProjectWizardCustom(IProjectCreator projectCreator) {
		super(projectCreator);
		setWindowTitle("New Java-- Project");
	}

	/**
	 * Use this method to add pages to the wizard. The one-time generated
	 * version of this class will add a default new project page to the wizard.
	 */
	@Override
	public void addPages() {
		super.addPages();
		JavammWizardNewProjectCreationPage mainPage = getMainPage();
		mainPage.setTitle("Java-- Project");
		mainPage.setDescription("Create a new Java-- project.");
	}

}
