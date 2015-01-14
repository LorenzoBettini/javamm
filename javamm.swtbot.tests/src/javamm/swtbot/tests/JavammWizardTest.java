/**
 * 
 */
package javamm.swtbot.tests;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.swtbot.swt.finder.junit.SWTBotJunit4ClassRunner;
import org.junit.Test;
import org.junit.runner.RunWith;

/**
 * @author Lorenzo Bettini
 *
 */
@RunWith(SWTBotJunit4ClassRunner.class)
public class JavammWizardTest extends AbstractJavammSwtbotTest {
	
	@Test
	public void canCreateANewJavammProject() throws CoreException {
		createProjectAndAssertNoErrorMarker(PROJECT_TYPE);
	}

	@Test
	public void canImportJavammExamples() throws CoreException {
		importExampleProjectAndAssertNoErrorMarker(
			"Some Javamm Examples", "javamm.examples");
	}
}
