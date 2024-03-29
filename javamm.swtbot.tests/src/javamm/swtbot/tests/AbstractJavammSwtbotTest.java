package javamm.swtbot.tests;

import static org.eclipse.swtbot.swt.finder.waits.Conditions.shellCloses;
import static org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.*;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import org.eclipse.core.resources.IMarker;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.TreeItem;
import org.eclipse.swtbot.eclipse.finder.SWTWorkbenchBot;
import org.eclipse.swtbot.eclipse.finder.widgets.SWTBotView;
import org.eclipse.swtbot.swt.finder.exceptions.WidgetNotFoundException;
import org.eclipse.swtbot.swt.finder.finders.UIThreadRunnable;
import org.eclipse.swtbot.swt.finder.results.ListResult;
import org.eclipse.swtbot.swt.finder.utils.SWTBotPreferences;
import org.eclipse.swtbot.swt.finder.widgets.SWTBotMenu;
import org.eclipse.swtbot.swt.finder.widgets.SWTBotShell;
import org.eclipse.swtbot.swt.finder.widgets.SWTBotTree;
import org.eclipse.swtbot.swt.finder.widgets.SWTBotTreeItem;
import org.eclipse.ui.PlatformUI;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.BeforeClass;

public abstract class AbstractJavammSwtbotTest {

	public static final String PACKAGE_EXPLORER = "Package Explorer";
	public static final String CATEGORY_NAME = "Java--";
	protected static final String PROJECT_TYPE = "Java-- Project";
	protected static final String SELF_ASSESSMENT_PROJECT_TYPE = "Java-- Self-Assessment Projects";
	protected static final String TEST_PROJECT = "MyTestProject";
	protected static SWTWorkbenchBot bot;

	@BeforeClass
	public static void beforeClass() throws Exception {
		bot = new SWTWorkbenchBot();

		closeWelcomePage();

		bot.menu("Window").menu("Show View").menu(PACKAGE_EXPLORER).click();
	}

	@AfterClass
	public static void afterClass() {
		bot.resetWorkbench();
	}
	
	@After
	public void runAfterEveryTest() throws CoreException {
		cleanWorkspace();
		waitForBuild();
	}

	protected static void closeWelcomePage() throws InterruptedException {
		Display.getDefault().syncExec(new Runnable() {
			@Override
			public void run() {
				if (PlatformUI.getWorkbench().getIntroManager().getIntro() != null) {
					PlatformUI.getWorkbench().getIntroManager()
							.closeIntro(PlatformUI.getWorkbench().getIntroManager().getIntro());
				}
			}
		});
	}

	protected void disableBuildAutomatically() {
		clickOnBuildAutomatically(false);
	}

	protected void enableBuildAutomatically() {
		clickOnBuildAutomatically(true);
	}

	private void clickOnBuildAutomatically(boolean shouldBeEnabled) {
		if (buildAutomaticallyMenu().isChecked() == shouldBeEnabled)
			return;
		// see http://www.eclipse.org/forums/index.php/mv/msg/165852/#msg_525521
		// for the reason why we need to specify 1
		buildAutomaticallyMenu().click();
		assertEquals(shouldBeEnabled, buildAutomaticallyMenu().isChecked());
	}

	private SWTBotMenu buildAutomaticallyMenu() {
		return bot.menu("Project", 1).menu("Build Automatically");
	}

	protected boolean isProjectCreated(String name) {
		try {
			getProjectTreeItem(name);
			return true;
		} catch (WidgetNotFoundException e) {
			return false;
		}
	}

	protected boolean isFileCreated(String project, String... filePath) {
		try {
			getProjectTreeItem(project).expand().expandNode(filePath);
			return true;
		} catch (WidgetNotFoundException e) {
			return false;
		}
	}

	protected static SWTBotTree getProjectTree() {
		SWTBotView packageExplorer = getPackageExplorer();
		SWTBotTree tree = packageExplorer.bot().tree();
		return tree;
	}

	protected static SWTBotView getPackageExplorer() {
		SWTBotView view = bot.viewByTitle(PACKAGE_EXPLORER);
		return view;
	}

	protected SWTBotTreeItem getProjectTreeItem(String myTestProject) {
		return getProjectTree().getTreeItem(myTestProject);
	}

	protected void assertErrorsInProject(int numOfErrors) throws CoreException {
		IMarker[] markers = root().findMarkers(IMarker.PROBLEM, true,
				IResource.DEPTH_INFINITE);
		List<IMarker> errorMarkers = new LinkedList<IMarker>();
		for (int i = 0; i < markers.length; i++) {
			IMarker iMarker = markers[i];
			if (iMarker.getAttribute(IMarker.SEVERITY).toString()
					.equals("" + IMarker.SEVERITY_ERROR)) {
				errorMarkers.add(iMarker);
			}
		}
		assertEquals(
				"error markers: " + printMarkers(errorMarkers), numOfErrors,
				errorMarkers.size());
	}

	private String printMarkers(List<IMarker> errorMarkers) {
		StringBuffer buffer = new StringBuffer();
		for (IMarker iMarker : errorMarkers) {
			try {
				buffer.append(iMarker.getAttribute(IMarker.MESSAGE) + "\n");
				buffer.append(iMarker.getAttribute(IMarker.SEVERITY) + "\n");
			} catch (CoreException e) {
			}
		}
		return buffer.toString();
	}

	protected void createProjectAndAssertNoErrorMarker(String projectType)
			throws CoreException {
		createProject(projectType);
		assertErrorsInProject(0);
	}

	protected void createProject(String projectType) {
		createProjectAndAssertCreated(projectType, TEST_PROJECT);
	}

	protected void createProjectAndAssertCreated(String projectType, String projectName) {
		bot.menu("File").menu("New").menu("Project...").click();

		SWTBotShell shell = bot.shell("New Project");
		shell.activate();
		SWTBotTreeItem categoryNode = bot.tree().expandNode(CATEGORY_NAME);
		waitForNodes(categoryNode);
		categoryNode.select(projectType);
		bot.button("Next >").click();

		bot.textWithLabel("Project name:").setText(TEST_PROJECT);

		bot.button("Finish").click();

		// creation of a project might require some time
		bot.waitUntil(shellCloses(shell), SWTBotPreferences.TIMEOUT);
		assertProjectCreated(projectName);
		
		reallyWaitForAutoBuild();
	}

	protected void assertProjectCreated(String projectName) {
		assertTrue("Project doesn't exist", isProjectCreated(projectName));
	}

	protected void createFile(String fileType, String name, String...path) {
		bot.menu("File").menu("New").menu(fileType).click();

		SWTBotShell shell = bot.shell(fileType);
		shell.activate();
		bot.textWithLabel("Name:").setText(name);

		bot.button("Finish").click();

		// creation of a file might require some time
		bot.waitUntil(shellCloses(shell), SWTBotPreferences.TIMEOUT);
		assertTrue("File doesn't exist", isFileCreated(TEST_PROJECT, path));
		
		reallyWaitForAutoBuild();
	}

	protected void importExampleProjectAndAssertNoErrorMarker(String projectType,
			String mainProjectId) throws CoreException {
		bot.menu("File").menu("New").menu("Other...").click();

		SWTBotShell shell = bot.shell("Select a wizard");
		shell.activate();
		SWTBotTreeItem categoryNode = bot.tree().expandNode(CATEGORY_NAME);
		waitForNodes(categoryNode);
		SWTBotTreeItem examplesNode = categoryNode.expandNode("Examples");
		waitForNodes(examplesNode);
		examplesNode.select(projectType);
		bot.button("Next >").click();

		bot.button("Finish").click();

		// creation of a project might require some time
		bot.waitUntil(shellCloses(shell), SWTBotPreferences.TIMEOUT);
		assertProjectCreated(mainProjectId);

		reallyWaitForAutoBuild();
		assertErrorsInProject(0);
	}

	public void waitForNodes(final SWTBotTreeItem treeItem) {
		int retries = 3;
		int msecs = 2000;
		int count = 0;
		while (count < retries) {
			System.out.println("Checking that tree item " + treeItem.getText() + " has children...");
			List<SWTBotTreeItem> foundItems = UIThreadRunnable.syncExec(new ListResult<SWTBotTreeItem>() {
				@Override
				public List<SWTBotTreeItem> run() {
					TreeItem[] items = treeItem.widget.getItems();
					List<SWTBotTreeItem> results = new ArrayList<SWTBotTreeItem>();
					for (TreeItem treeItem : items) {
						results.add(new SWTBotTreeItem(treeItem));
					}
					return results;
				}
			});
			if (foundItems.isEmpty()) {
				treeItem.collapse();
				System.out.println("No chilren... retrying in " + msecs + " milliseconds..."); //$NON-NLS-1$
				try {
					Thread.sleep(msecs); // NOSONAR
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				treeItem.expand();
			} else if (foundItems.size() == 1 && foundItems.get(0).getText().trim().isEmpty()) {
				treeItem.collapse();
				System.out.println("Only one child with empty text... retrying in " + msecs + " milliseconds..."); //$NON-NLS-1$
				try {
					Thread.sleep(msecs); // NOSONAR
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				treeItem.expand();
			} else {
				System.out.println("Found " + foundItems.size() + " items. OK!");
				return;
			}
			
			count++;
		}
	}
	
}
