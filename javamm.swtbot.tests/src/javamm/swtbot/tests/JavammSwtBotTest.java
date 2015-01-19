/**
 * 
 */
package javamm.swtbot.tests;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.swtbot.swt.finder.junit.SWTBotJunit4ClassRunner;
import org.eclipse.swtbot.swt.finder.widgets.SWTBotTreeItem;
import org.junit.Test;
import org.junit.runner.RunWith;

/**
 * @author Lorenzo Bettini
 *
 */
@RunWith(SWTBotJunit4ClassRunner.class)
public class JavammSwtBotTest extends AbstractJavammSwtbotTest {
	
	@Test
	public void canCreateANewJavammProject() throws CoreException {
		createProjectAndAssertNoErrorMarker(PROJECT_TYPE);
	}

	@Test
	public void canImportJavammExamples() throws CoreException {
		importExampleProjectAndAssertNoErrorMarker(
			"Some Javamm Examples", "javamm.examples");
	}

	@Test
	public void canRunAJavammFileAsJavaApplication() throws CoreException {
		createProject(PROJECT_TYPE);
		SWTBotTreeItem tree = 
				getProjectTreeItem(TEST_PROJECT).
				expand().expandNode("src").
				expandNode("javamm").
				getNode("HelloWorld.javamm");
		contextMenu(tree, "Run As", "1 Java Application");
		contextMenu(tree, "Debug As", "1 Java Application");
	}

}
