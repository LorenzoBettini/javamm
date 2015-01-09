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

	@Test def void testKeywordContinue() {
		newBuilder.append("c").assertProposal("continue")
	}

	@Test def void testKeywordBreak() {
		newBuilder.append("b").assertProposal("break")
	}

	@Test def void testArgsProposed() {
		newBuilder.append("while (").assertProposal("args")
	}

	@Test def void testVariableReferenceInAssignment() {
		newBuilder.append("int myVar = 0; myVar = my").assertProposal("myVar")
	}

	@Test def void testMethodCallProposalInMain() {
		newBuilder.append("int myMeth() { return 0; } my").assertProposal("myMeth")
	}

	@Test def void testMethodCallProposalInExpressio() {
		newBuilder.append("int myMeth() { return 0; } while(my").assertProposal("myMeth")
	}

	@Test def void testMemberFeatureCallProposalInMethod() {
		newBuilder.append('void m() { String s = ""; s.to').assertProposal("toString")
	}

	@Test def void testMemberFeatureCallProposalInMain() {
		newBuilder.append('String s = ""; s.to').assertProposal("toString")
	}
}