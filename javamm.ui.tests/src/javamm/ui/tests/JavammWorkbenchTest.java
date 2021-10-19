package javamm.ui.tests;

import static javamm.tests.utils.ui.PluginProjectHelper.assertErrors;
import static javamm.tests.utils.ui.PluginProjectHelper.assertNoErrors;
import static org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.cleanWorkspace;
import static org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.createFile;
import static org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.waitForBuild;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IFolder;
import org.eclipse.core.resources.IProject;
import org.eclipse.xtext.testing.InjectWith;
import org.eclipse.xtext.testing.XtextRunner;
import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.runner.RunWith;

import javamm.tests.utils.ui.ProjectImportUtil;

@RunWith(XtextRunner.class)
@InjectWith(JavammUiInjectorProvider.class)
public class JavammWorkbenchTest extends CustomAbstractWorkbenchTest {
	private static String TEST_PROJECT = "javamm.ui.tests.project";

	private static String TEST_FILE = "TestFile";

	private static IProject project;

	@BeforeClass
	public static void importTestProject() throws Exception {
		cleanWorkspace();
		project = ProjectImportUtil.importProject(TEST_PROJECT);
		waitForBuild();
	}

	public IFile createTestFile(CharSequence contents) throws Exception {
		return createFile(
				TEST_PROJECT + "/src/" + TEST_FILE + ".javamm",
				contents.toString());
	}

	@Test
	public void testJavaFileIsGeneratedInSrcGen() throws Exception {
		createTestFile("System.out.println(\"Hello \" + \"world!\");");
		waitForBuild();
		assertNoErrors();
		IFolder srcGenFolder = project.getFolder("src-gen/javamm");
		assertTrue("src-gen/javamm does not exist", srcGenFolder.exists());
		IFile genfile = srcGenFolder.getFile(TEST_FILE + ".java");
		assertTrue(TEST_FILE + ".java does not exist", genfile.exists());
	}

	@Test
	public void testErrorInGeneratedJavaCode() throws Exception {
		createTestFile("int a = 2;\n"
				+ "int b = 2;\n"
				+ "int c = 2;\n"
				+ "if (a==b==c==2) {\n"
				+ "	System.out.println(\"TRUE\");\n"
				+ "}");
		waitForBuild();
		// one error in the generated Java file, and one in the original file
		assertErrors(
				"Java problem: Incompatible operand types Boolean and Integer\n"
				+ "Incompatible operand types Boolean and Integer");
	}
}
