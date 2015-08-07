package javamm.ui.tests

import com.google.inject.Inject
import com.google.inject.Provider
import javamm.JavammUiInjectorProvider
import javamm.tests.utils.ui.JavammTestableNewFileWizard
import javamm.tests.utils.ui.JavammTestableNewProjectWizard
import javamm.tests.utils.ui.PDETargetPlatformUtils
import javamm.tests.utils.ui.PluginProjectHelper
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.jface.wizard.Wizard
import org.eclipse.jface.wizard.WizardDialog
import org.eclipse.ui.PlatformUI
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.ui.AbstractWorkbenchTest
import org.junit.BeforeClass
import org.junit.Test
import org.junit.runner.RunWith

import static org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammUiInjectorProvider))
class JavammWizardTest extends AbstractWorkbenchTest {
	
	@Inject Provider<JavammTestableNewProjectWizard> wizardProvider

	@Inject Provider<JavammTestableNewFileWizard> fileWizardProvider
	
	@Inject PluginProjectHelper projectHelper
	
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
						while (getShell() == null && (attempt++) < 5) {
							println("Waiting for shell to become active")
							Thread.sleep(5000)
						}
						getShell().getDisplay().asyncExec[
							println("pressing finish button")
							finishPressed();
						]					
					}			
				};
				thread.start();
				return super.open();
			}
		};
		return dialog.open();
	}

	@BeforeClass
	def static void beforeClass() {
		PDETargetPlatformUtils.setTargetPlatform();
	}

	@Test def void testJavammNewProjectWizard() {
		println("Creating new project wizard...")
		val wizard = wizardProvider.get
		wizard.init(PlatformUI.getWorkbench(), new StructuredSelection());
		println("Using wizard...")
		createAndFinishWizardDialog(wizard)
		val project = root.getProject(JavammTestableNewProjectWizard.TEST_PROJECT)
		assertTrue(project.exists())
		println("Waiting for build...")
		waitForBuild
		projectHelper.assertNoErrors
		println("No errors in project, OK!")
	}

	@Test def void testJavammNewFileWizard() {
		println("Creating project...")
		val project = projectHelper.createJavaPluginProject
			(JavammTestableNewProjectWizard.TEST_PROJECT, newArrayList("javamm.runtime")).project
		val srcFolder = project.getFolder("src")
		assertTrue(srcFolder.exists)
		val wizard = fileWizardProvider.get
		wizard.init(PlatformUI.getWorkbench(), new StructuredSelection(srcFolder))
		println("Using new file wizard...")
		createAndFinishWizardDialog(wizard)
		val file = srcFolder.getFile(JavammTestableNewFileWizard.TEST_FILE + ".javamm")
		assertTrue(file.exists())
		println("Waiting for build...")
		waitForBuild
		projectHelper.assertNoErrors
		println("Waiting for build...")
		waitForBuild
		val srcGenFolder = project.getFolder("src-gen/javamm")
		assertTrue("src-gen/javamm does not exist", srcGenFolder.exists)
		val genfile = srcGenFolder.getFile(JavammTestableNewFileWizard.TEST_FILE + ".java")
		assertTrue(JavammTestableNewFileWizard.TEST_FILE + ".java does not exist" , genfile.exists())
		projectHelper.assertNoErrors
		println("No errors in project, OK!")
	}

}