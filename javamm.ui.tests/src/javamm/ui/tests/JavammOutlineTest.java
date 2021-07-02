package javamm.ui.tests;

import org.eclipse.xtext.testing.InjectWith;
import org.eclipse.xtext.testing.XtextRunner;
import org.eclipse.xtext.ui.editor.outline.IOutlineNode;
import org.eclipse.xtext.ui.testing.AbstractOutlineTest;
import org.junit.Test;
import org.junit.runner.RunWith;

import javamm.ui.internal.JavammActivator;

@RunWith(XtextRunner.class)
@InjectWith(JavammUiInjectorProvider.class)
public class JavammOutlineTest extends AbstractOutlineTest {
	@Override
	protected String getEditorId() {
		return JavammActivator.JAVAMM_JAVAMM;
	}

	/**
	 * We must make sure to get rid of "\r" because in Windows
	 * Java text blocks do not contain "\r" and the comparison would fail.
	 */
	@Override
	protected String outlineStringRepresentation(IOutlineNode node) {
		return super.outlineStringRepresentation(node)
			.replace("\r", "");
	}

	@Test
	public void testOutlineOfJavammFile() throws Exception {
		assertAllLabels(

			"void m() {\n"
			+ "	\n"
			+ "}\n"
			+ "\n"
			+ "String n(boolean b, int i) {\n"
			+ "	return null;\n"
			+ "}\n"
			+ "\n"
			+ "m();\n"
			+ "n(true, 0);",

			"test\n"
			+ "  m() : void\n"
			+ "  n(boolean, int) : String\n"
			+ "  main(String[]) : void\n"
			+ ""

		);
	}
}
