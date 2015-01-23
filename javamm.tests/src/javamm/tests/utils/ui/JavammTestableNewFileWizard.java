/**
 * 
 */
package javamm.tests.utils.ui;

import org.eclipse.xtext.ui.IImageHelper.IImageDescriptorHelper;

import com.google.inject.Inject;

import javamm.ui.wizard.file.NewJavammFileWizard;
import javamm.ui.wizard.file.NewJavammFileWizardPage;

/**
 * Manually set the file name (usually set in the dialog text edit)
 * 
 * @author Lorenzo Bettini
 *
 */
public class JavammTestableNewFileWizard extends NewJavammFileWizard {
	
	public static final String TEST_FILE = "TestFile";

	@Inject
	public JavammTestableNewFileWizard(IImageDescriptorHelper imgHelper,
			NewJavammFileWizardPage page, String title) {
		super(imgHelper, page, title);
	}

	@Override
	public boolean performFinish() {
		getPage().setTypeName(TEST_FILE, true);

		return super.performFinish();
	}
}
