package javamm.ui.tests

import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.ui.testing.AbstractContentAssistTest
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammUiInjectorProvider))
class JavammContentAssistTest extends AbstractContentAssistTest {

	@Test def void testKeywordInEmptyProgram() throws Exception {
		newBuilder.append("w").assertProposal("while")
	}

	@Test def void testKeywordContinue() throws Exception {
		newBuilder.append("c").assertProposal("continue")
	}

	@Test def void testKeywordBreak() throws Exception {
		newBuilder.append("b").assertProposal("break")
	}

	@Test def void testFinal() throws Exception {
		newBuilder.append("fi").assertProposal("final")
	}

	@Test def void testFinalParam() throws Exception {
		newBuilder.append("int m(fi").assertProposal("final")
	}

	@Test def void testArgsProposed() throws Exception {
		newBuilder.append("a").assertProposal("args")
	}

	@Test def void testArgsProposedAsExpression() throws Exception {
		newBuilder.append("while (").assertProposal("args")
	}

	@Test def void testVariableReferenceInAssignment() throws Exception {
		newBuilder.append("int myVar = 0; myVar = my").assertProposal("myVar")
	}

	@Test def void testVariableReferenceInAssignment2() throws Exception {
		newBuilder.append("int myVar = 0; myVar = ").assertProposal("myVar")
	}

	@Test def void testVariableReferenceInVariableDeclaration() throws Exception {
		newBuilder.append("int myVar = 0; int i = my").assertProposal("myVar")
	}

	@Test def void testVariableReferenceInVariableDeclaration2() throws Exception {
		newBuilder.append("int myVar = 0; int i = ").assertProposal("myVar")
	}

	@Test def void testVariableReferenceInAssignmentInMethod() throws Exception {
		newBuilder.append("void foo() { int myVar = 0; myVar = my").assertProposal("myVar")
	}

	@Test def void testVariableReferenceInAssignmentInMethod2() throws Exception {
		newBuilder.append("void foo() { int myVar = 0; myVar = ").assertProposal("myVar")
	}

	@Test def void testVariableReferenceInVariableDeclarationInMethod() throws Exception {
		newBuilder.append("void foo() { int myVar = 0; int i = my").assertProposal("myVar")
	}

	@Test def void testVariableReferenceInVariableDeclarationInMethod2() throws Exception {
		newBuilder.append("void foo() { int myVar = 0; int i = ").assertProposal("myVar")
	}

	@Test def void testMethodCallProposalInMain() throws Exception {
		newBuilder.append("int myMeth() { return 0; } my").assertProposal("myMeth")
	}

	@Test def void testMethodCallProposalInExpressio() throws Exception {
		newBuilder.append("int myMeth() { return 0; } while(my").assertProposal("myMeth")
	}

	@Test def void testMemberFeatureCallProposalInMethod() throws Exception {
		newBuilder.append('void m() { String s = ""; s.to').assertProposal("toString")
	}

	@Test def void testMemberFeatureCallProposalInMain() throws Exception {
		newBuilder.append('String s = ""; s.to').assertProposal("toString")
	}

	@Test def void testVariableReferenceInArrayAccess() throws Exception {
		newBuilder.append("int myVar = 0; int[] ar; ar[").assertProposal("myVar")
	}

	@Test def void testVariableReferenceInArrayAccess2() throws Exception {
		newBuilder.append("int myVar = 0; int[] ar; ar[my<|>]").assertProposalAtCursor("myVar")
	}

	@Test def void testMemberFeatureCallOnArrayAccess() throws Exception {
		newBuilder.append('int[][] arr; arr[0].').assertProposal("toString")
	}

	@Test def void testMemberFeatureCallOnArrayAccess2() throws Exception {
		newBuilder.append('int[][] arr; arr[0].to').assertProposal("toString")
	}

	@Test def void testVariableReferenceInConditional() throws Exception {
		newBuilder.append("int myVar = 0; myVar = true ? my").assertProposal("myVar")
	}

	@Test def void testVariableReferenceInConditional2() throws Exception {
		newBuilder.append("int myVar = 0; myVar = true ? ").assertProposal("myVar")
	}

	@Test def void testForExpression() throws Exception {
		newBuilder.append('''
		java.util.List<String> strings;
		for (String e : ''').assertProposal("strings")
	}

	@Test def void testForExpression2() throws Exception {
		newBuilder.append('''
		java.util.List<String> strings;
		for (String e : s''').assertProposal("strings")
	}

	@Test
	def void testProposalAndImportForListType() throws Exception {
		newBuilder.append(
'''
int m(LinkedL''').applyProposal("LinkedList").expectContent(
			'''
import java.util.LinkedList;

int m(LinkedList'''
		)

	}
}
