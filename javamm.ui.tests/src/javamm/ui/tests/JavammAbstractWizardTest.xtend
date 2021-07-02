package javamm.ui.tests

import org.eclipse.jface.wizard.Wizard
import org.eclipse.jface.wizard.WizardDialog
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.ui.testing.AbstractWorkbenchTest
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammUiInjectorProvider))
abstract class JavammAbstractWizardTest extends AbstractWorkbenchTest {

	/**
	 * Create the wizard dialog, open it and press Finish.
	 */
	def protected int createAndFinishWizardDialog(Wizard wizard) {
		val dialog = new WizardDialog(wizard.shell, wizard) {
			override open() {
				val thread = new Thread("Press Finish") {
					override run() {
						// wait for the shell to become active
						var attempt = 0
						while (getShell() === null && (attempt++) < 5) {
							println("Waiting for shell to become active")
							Thread.sleep(5000)
						}
						getShell().getDisplay().syncExec[
							println("perform finish")
							//finishPressed();
							wizard.performFinish
							println("finish performed")
							println("closing shell")
							getShell().close;
						]
						attempt = 0
						while (getShell() !== null && (attempt++) < 5) {
							println("Waiting for shell to be disposed")
							Thread.sleep(5000)
						}
					}
				};
				thread.start();
				return super.open();
			}
		};
		return dialog.open();
	}

}