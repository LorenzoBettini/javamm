/**
 * 
 */
package javamm.swtbot.tests;

import static org.junit.Assert.assertTrue;

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
	
	private static final String JAVAMM_APPLICATION = "2 Java-- Application";

	@Test
	public void canCreateANewJavammProject() throws CoreException {
		createProjectAndAssertNoErrorMarker(PROJECT_TYPE);
	}

	@Test
	public void canCreateANewJavammFile() throws CoreException {
		String name = "TestFile";
		createProjectAndAssertNoErrorMarker(PROJECT_TYPE);
		createFile("Java-- File", name, "src", "javamm", name + ".javamm");
		assertTrue(isFileCreated(TEST_PROJECT, "src-gen", "javamm", name + ".java"));
	}

	@Test
	public void canImportJavammExamples() throws CoreException {
		importExampleProjectAndAssertNoErrorMarker(
			"Some Java-- Examples", "javamm.examples");
	}

	@Test
	public void canRunAJavammFileAsJavaApplication() throws CoreException {
		createProject(PROJECT_TYPE);
		SWTBotTreeItem tree = 
				getProjectTreeItem(TEST_PROJECT).
				expand().expandNode("src").
				expandNode("javamm").
				getNode("HelloWorld.javamm");
		// apparently, on a new workbench, any file has "Run As Java Application" as the
		// first menu, so we need to look for the second entry
		tree.contextMenu("Run As").menu(JAVAMM_APPLICATION);
		tree.contextMenu("Debug As").menu(JAVAMM_APPLICATION);
	}

}
