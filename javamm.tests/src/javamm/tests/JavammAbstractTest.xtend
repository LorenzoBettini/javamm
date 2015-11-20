package javamm.tests

import com.google.inject.Inject
import javamm.javamm.JavammArrayAccessExpression
import javamm.javamm.JavammArrayConstructorCall
import javamm.javamm.JavammArrayLiteral
import javamm.javamm.JavammConditionalExpression
import javamm.javamm.JavammProgram
import javamm.javamm.JavammXVariableDeclaration
import javamm.tests.inputs.JavammInputs
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipse.xtext.xbase.XBlockExpression
import org.eclipse.xtext.xbase.XCastedExpression
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.XFeatureCall
import org.eclipse.xtext.xbase.XIfExpression
import org.eclipse.xtext.xbase.XInstanceOfExpression
import org.eclipse.xtext.xbase.XMemberFeatureCall

import static org.junit.Assert.*

abstract class JavammAbstractTest {
	@Inject protected extension ParseHelper<JavammProgram>
	@Inject protected extension ValidationTestHelper
	@Inject protected extension JavammInputs
	
	def protected parseAndAssertNoErrors(CharSequence input) {
		input.parse => [
			assertNoErrors
		]
	}

	def protected parseAndAssertNoIssues(CharSequence input) {
		input.parse => [
			assertNoIssues
		]
	}

	def protected assertEqualsStrings(CharSequence expected, CharSequence actual) {
		assertEquals(expected.toString().replaceAll("\r", ""), actual.toString());
	}

	def protected assertMainLastExpression(CharSequence input, (XExpression)=>void tester) {
		val main = input.parse.main
		tester.apply(main.expressions.last)
	}

	def protected assertLastMethodLastExpression(CharSequence input, (XExpression)=>void tester) {
		val method = input.parse.javammMethods.last
		tester.apply((method.body as XBlockExpression).expressions.last)
	}

	protected def getVariableDeclarationRightAsArrayConstructorCall(XExpression it) {
		getVariableDeclaration.right as JavammArrayConstructorCall
	}
	
	protected def getVariableDeclarationRight(XExpression it) {
		getVariableDeclaration.right
	}

	protected def getVariableDeclaration(XExpression it) {
		it as JavammXVariableDeclaration
	}

	protected def getArrayLiteral(XExpression it) {
		it as JavammArrayLiteral
	}

	protected def getMemberFeatureCall(XExpression it) {
		it as XMemberFeatureCall
	}

	protected def getMemberCallTargetArrayAccess(XExpression it) {
		memberFeatureCall.memberCallTarget.arrayAccess
	}

	protected def getArrayAccess(XExpression it) {
		it as JavammArrayAccessExpression
	}

	protected def getFeatureCall(XExpression it) {
		it as XFeatureCall
	}

	protected def getCasted(XExpression it) {
		it as XCastedExpression
	}

	protected def getConditional(XExpression it) {
		it as JavammConditionalExpression
	}

	protected def getInstanceOf(XExpression it) {
		it as XInstanceOfExpression
	}

	protected def getIfStatement(XExpression it) {
		it as XIfExpression
	}
}