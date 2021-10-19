package javamm.ui.tests;

import static javamm.tests.utils.ui.PluginProjectHelper.assertNoErrors;
import static org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.cleanWorkspace;
import static org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.createFile;
import static org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.monitor;
import static org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.root;
import static org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.waitForBuild;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.jobs.Job;
import org.eclipse.jface.text.IDocument;
import org.eclipse.xtext.testing.InjectWith;
import org.eclipse.xtext.testing.XtextRunner;
import org.eclipse.xtext.ui.editor.XtextEditor;
import org.eclipse.xtext.ui.editor.reconciler.XtextReconciler;
import org.eclipse.xtext.ui.testing.AbstractEditorTest;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import javamm.tests.utils.ui.ProjectImportUtil;

@RunWith(XtextRunner.class)
@InjectWith(JavammUiInjectorProvider.class)
public class JavammEditorTest extends AbstractEditorTest {

	private static String TEST_PROJECT = "javamm.ui.tests.project";

	private static String TEST_FILE = "TestFile";

	@Before
	public void importTestProject() throws Exception {
		cleanWorkspace();
		ProjectImportUtil.importProject(TEST_PROJECT);
		waitForBuild();
	}

	public IFile createTestFile(CharSequence contents) throws Exception {
		return createFile(
				TEST_PROJECT + "/src/" + TEST_FILE + ".javamm",
				contents.toString());
	}

	@Test
	public void testModificationInEditorDoesNotGenerateXtextReconcilerJobException() throws Exception {
		// see https://github.com/LorenzoBettini/javamm/issues/132
		// see https://github.com/LorenzoBettini/jbase/issues/131
		String testProgram = "System.out.println();\n"
				+ "System.out.println(\"\");\n";
		IFile createTestFile = createTestFile(testProgram);
		waitForBuild();
		assertNoErrors();
		XtextEditor openEditor = openEditor(createTestFile);
		IDocument document = openEditor.getDocumentProvider()
				.getDocument(openEditor.getEditorInput());
		int offset = document.get().indexOf('"');
		document.replace(offset+1, 0, "h");
		assertEquals("System.out.println();\n"
				+ "System.out.println(\"h\");\n", document.get());
		Job.getJobManager().join(XtextReconciler.class.getName(), monitor());
		assertNoXtextReconcilerJobInLog();
		openEditor.doSave(monitor());
		waitForBuild();
		assertNoErrors();
	}

	private void assertNoXtextReconcilerJobInLog() throws IOException {
		IPath location = root().getLocation();
		Path logPath = Paths.get(location + "/.metadata/.log");
		if (!Files.exists(logPath))
			return;
		List<String> readAllLines = Files.readAllLines(logPath);
		for (String string : readAllLines) {
			if (string.contains("An internal error occurred during: \"XtextReconcilerJob\""))
				fail("found XtextReconcilerJob exception:\n" +
					readAllLines.stream().collect(Collectors.joining("\n")));
		}
	}
}
