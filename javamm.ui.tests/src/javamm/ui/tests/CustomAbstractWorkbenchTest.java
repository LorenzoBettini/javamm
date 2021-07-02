package javamm.ui.tests;

import static org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.cleanWorkspace;
import static org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.waitForBuild;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.xtext.ui.testing.AbstractWorkbenchTest;
import org.junit.BeforeClass;

/**
 * Custom version that avoids removing projects from the workspace.
 * 
 * @author Lorenzo Bettini
 *
 */
public abstract class CustomAbstractWorkbenchTest extends AbstractWorkbenchTest {

	@BeforeClass
	public static void clean() throws CoreException {
		closeEditors();
		cleanWorkspace();
		waitForBuild();
	}

	@Override
	public void setUp() throws Exception {
		closeWelcomePage();
		closeEditors();
	}

	/**
	 * Avoids deleting project
	 */
	@Override
	public void tearDown() {
		waitForEventProcessing();
		closeEditors();
		waitForEventProcessing();
	}

}
