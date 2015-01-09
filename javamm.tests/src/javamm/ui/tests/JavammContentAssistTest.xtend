package javamm.ui.tests

import javamm.JavammUiInjectorProvider
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.junit.ui.AbstractContentAssistTest
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammUiInjectorProvider))
class JavammContentAssistTest extends AbstractContentAssistTest {
	
	@Test def void testKeywordInEmptyProgram() {
		newBuilder.append("w").assertProposal("while")
	}

	@Test def void testArgsProposed() {
		newBuilder.append("while (").assertProposal("args")
	}

	@Test def void testVariableReferenceInAssignment() {
		newBuilder.append("int myVar = 0; myVar = my").assertProposal("myVar")
	}
}