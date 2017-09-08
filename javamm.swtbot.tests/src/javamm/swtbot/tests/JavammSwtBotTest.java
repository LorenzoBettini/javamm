/**
 * 
 */
package javamm.swtbot.tests;

import static org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.waitForBuild;
import static org.junit.Assert.assertTrue;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.swtbot.eclipse.finder.widgets.SWTBotEditor;
import org.eclipse.swtbot.swt.finder.exceptions.WidgetNotFoundException;
import org.eclipse.swtbot.swt.finder.junit.SWTBotJunit4ClassRunner;
import org.eclipse.swtbot.swt.finder.widgets.SWTBotMenu;
import org.eclipse.swtbot.swt.finder.widgets.SWTBotTreeItem;
import org.junit.Test;
import org.junit.runner.RunWith;

import javamm.selfassessment.builder.builder.JavammSelfAssessmentNature;

/**
 * @author Lorenzo Bettini
 *
 */
@RunWith(SWTBotJunit4ClassRunner.class)
public class JavammSwtBotTest extends AbstractJavammSwtbotTest {
	
	private static final String HELLO_WORLD_JAVAMM = "HelloWorld.javamm";

	@Test
	public void canCreateANewJavammProject() throws CoreException {
		createProjectAndAssertNoErrorMarker(PROJECT_TYPE);
	}

	@Test
	public void canCreateNewJavammSelfAssessmentProjects() throws CoreException {
		createProjectAndAssertCreated(SELF_ASSESSMENT_PROJECT_TYPE,
				TEST_PROJECT + JavammSelfAssessmentNature.STUDENT_PROJECT_SUFFIX);
		assertProjectCreated(TEST_PROJECT + JavammSelfAssessmentNature.TEACHER_PROJECT_SUFFIX);
		waitForBuild();
		waitForBuild();
		assertErrorsInProject(0);
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
				getNode(HELLO_WORLD_JAVAMM);
		checkLaunchContextMenu(tree.contextMenu("Run As"));
		checkLaunchContextMenu(tree.contextMenu("Debug As"));
	}

	@Test
	public void canRunAJavammEditorAsJavaApplication() throws CoreException {
		createProject(PROJECT_TYPE);
		SWTBotEditor editor = bot.editorByTitle(HELLO_WORLD_JAVAMM);
		checkLaunchContextMenu(editor.toTextEditor().contextMenu("Run As"));
		checkLaunchContextMenu(editor.toTextEditor().contextMenu("Debug As"));
	}

	private void checkLaunchContextMenu(SWTBotMenu contextMenu) {
		try {
			// depending on the installed features, on a new workbench, any file has "Run As Java Application" as the
			// first menu, so we need to look for the second entry
			contextMenu.menu("1 Java-- Application");
		} catch (WidgetNotFoundException e) {
			contextMenu.menu("2 Java-- Application");
		}
	}

}
