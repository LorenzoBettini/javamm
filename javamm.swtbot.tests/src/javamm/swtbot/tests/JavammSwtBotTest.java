/**
 * 
 */
package javamm.swtbot.tests;

import static org.junit.Assert.assertTrue;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.swtbot.swt.finder.exceptions.WidgetNotFoundException;
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
		checkLaunchContextMenu("Run As", tree);
		checkLaunchContextMenu("Debug As", tree);
	}

	protected void checkLaunchContextMenu(String runOrDebugAs, SWTBotTreeItem tree) {
		// depending on the installed features, on a new workbench, any file has "Run As Java Application" as the
		// first menu, so we need to look for the second entry
		try {
			tree.contextMenu(runOrDebugAs).menu("1 Java-- Application");
		} catch (WidgetNotFoundException e) {
			tree.contextMenu(runOrDebugAs).menu("2 Java-- Application");
		}
	}

}
