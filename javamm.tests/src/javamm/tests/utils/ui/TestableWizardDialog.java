/**
 * 
 */
package javamm.tests.utils.ui;

import org.eclipse.jface.wizard.IWizard;
import org.eclipse.jface.wizard.WizardDialog;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.xtext.xbase.lib.Exceptions;

import com.google.common.base.Objects;

/**
 * A utility class for testing an {@link IWizard}
 * 
 * @author Lorenzo Bettini
 *
 */
public class TestableWizardDialog extends WizardDialog {

	/**
	 * @param parentShell
	 * @param newWizard
	 */
	public TestableWizardDialog(Shell parentShell, IWizard newWizard) {
		super(parentShell, newWizard);
	}

	@Override
	public int open() {
		final Thread thread = new Thread("Press Finish") {
			@Override
			public void run() {
				try {
					while (Objects.equal(getShell(), null)) {
						Thread.sleep(1000);
					}
					Shell _shell = getShell();
					Display _display = _shell.getDisplay();
					final Runnable _function = new Runnable() {
						public void run() {
							finishPressed();
						}
					};
					_display.asyncExec(_function);
				} catch (Throwable _e) {
					throw Exceptions.sneakyThrow(_e);
				}
			}
		};
		thread.start();
		return super.open();
	}

}
