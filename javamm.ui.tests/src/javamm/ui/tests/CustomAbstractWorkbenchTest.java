package javamm.ui.tests;

import org.eclipse.xtext.ui.testing.AbstractWorkbenchTest;

/**
 * Custom version that avoids removing projects from the workspace.
 * 
 * @author Lorenzo Bettini
 *
 */
public abstract class CustomAbstractWorkbenchTest extends AbstractWorkbenchTest {

	/**
	 * Avoids deleting project
	 */
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
