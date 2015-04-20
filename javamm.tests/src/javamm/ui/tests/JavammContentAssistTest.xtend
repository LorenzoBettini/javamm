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

	@Test def void testFinal() {
		newBuilder.append("fi").assertProposal("final")
	}

	@Test def void testArgsProposed() {
		newBuilder.append("a").assertProposal("args")
	}

	@Test def void testArgsProposedAsExpression() {
		newBuilder.append("while (").assertProposal("args")
	}

	@Test def void testVariableReferenceInAssignment() {
		newBuilder.append("int myVar = 0; myVar = my").assertProposal("myVar")
	}

	@Test def void testVariableReferenceInAssignment2() {
		newBuilder.append("int myVar = 0; myVar = ").assertProposal("myVar")
	}

	@Test def void testVariableReferenceInVariableDeclaration() {
		newBuilder.append("int myVar = 0; int i = my").assertProposal("myVar")
	}

	@Test def void testVariableReferenceInVariableDeclaration2() {
		newBuilder.append("int myVar = 0; int i = ").assertProposal("myVar")
	}

	@Test def void testVariableReferenceInAssignmentInMethod() {
		newBuilder.append("void foo() { int myVar = 0; myVar = my").assertProposal("myVar")
	}

	@Test def void testVariableReferenceInAssignmentInMethod2() {
		newBuilder.append("void foo() { int myVar = 0; myVar = ").assertProposal("myVar")
	}

	@Test def void testVariableReferenceInVariableDeclarationInMethod() {
		newBuilder.append("void foo() { int myVar = 0; int i = my").assertProposal("myVar")
	}

	@Test def void testVariableReferenceInVariableDeclarationInMethod2() {
		newBuilder.append("void foo() { int myVar = 0; int i = ").assertProposal("myVar")
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

	@Test def void testVariableReferenceInArrayAccess() {
		newBuilder.append("int myVar = 0; int[] ar; ar[").assertProposal("myVar")
	}

	@Test def void testVariableReferenceInArrayAccess2() {
		newBuilder.append("int myVar = 0; int[] ar; ar[my<|>]").assertProposalAtCursor("myVar")
	}

	@Test def void testMemberFeatureCallOnArrayAccess() {
		newBuilder.append('int[][] arr; arr[0].').assertProposal("toString")
	}

	@Test def void testMemberFeatureCallOnArrayAccess2() {
		newBuilder.append('int[][] arr; arr[0].to').assertProposal("toString")
	}

	@Test def void testVariableReferenceInConditional() {
		newBuilder.append("int myVar = 0; myVar = true ? my").assertProposal("myVar")
	}

	@Test def void testVariableReferenceInConditional2() {
		newBuilder.append("int myVar = 0; myVar = true ? ").assertProposal("myVar")
	}

	@Test
	def void testProposalAndImportForListType() {
		newBuilder.
		append(
'''
int m(LinkedL''').
		applyProposal("LinkedList").
		expectContent(
'''
import java.util.LinkedList;

int m(LinkedList'''
		)	

	}
}