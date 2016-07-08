package javamm.tests

import com.google.inject.Inject
import javamm.javamm.JavammProgram
import javamm.tests.inputs.JavammInputs
import jbase.jbase.XJArrayAccessExpression
import jbase.jbase.XJArrayConstructorCall
import jbase.jbase.XJArrayLiteral
import jbase.jbase.XJConditionalExpression
import jbase.jbase.XJSemicolonStatement
import jbase.jbase.XJVariableDeclaration
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipse.xtext.xbase.XBinaryOperation
import org.eclipse.xtext.xbase.XBlockExpression
import org.eclipse.xtext.xbase.XCastedExpression
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.XFeatureCall
import org.eclipse.xtext.xbase.XIfExpression
import org.eclipse.xtext.xbase.XInstanceOfExpression
import org.eclipse.xtext.xbase.XMemberFeatureCall
import org.eclipse.xtext.xbase.XUnaryOperation

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
		val last = getMainLastExpression(input)
		applyTester(last, tester)
	}
	
	protected def getMainLastExpression(CharSequence input) {
		val main = input.mainBlock
		val last = main.expressions.last
		last
	}

	protected def getMainBlock(CharSequence input) {
		input.parse.main
	}

	protected def applyTester(XExpression last, (XExpression)=>void tester) {
		if (last instanceof XJSemicolonStatement) {
			tester.apply(last.expression)
		} else {
			tester.apply(last)
		}
	}

	def protected assertLastMethodLastExpression(CharSequence input, (XExpression)=>void tester) {
		val method = input.parse.javammMethods.last
		applyTester((method.body as XBlockExpression).expressions.last, tester)
	}

	protected def getVariableDeclarationRightAsArrayConstructorCall(XExpression it) {
		getVariableDeclaration.right as XJArrayConstructorCall
	}
	
	protected def getVariableDeclarationRight(XExpression it) {
		getVariableDeclaration.right
	}

	protected def getVariableDeclaration(XExpression it) {
		it as XJVariableDeclaration
	}

	protected def getArrayLiteral(XExpression it) {
		it as XJArrayLiteral
	}

	protected def getMemberFeatureCall(XExpression it) {
		it as XMemberFeatureCall
	}

	protected def getMemberCallTargetArrayAccess(XExpression it) {
		memberFeatureCall.memberCallTarget.arrayAccess
	}

	protected def getArrayAccess(XExpression it) {
		it as XJArrayAccessExpression
	}

	protected def getFeatureCall(XExpression it) {
		it as XFeatureCall
	}

	protected def getCasted(XExpression it) {
		it as XCastedExpression
	}

	protected def getConditional(XExpression it) {
		it as XJConditionalExpression
	}

	protected def getInstanceOf(XExpression it) {
		it as XInstanceOfExpression
	}

	protected def getIfStatement(XExpression it) {
		it as XIfExpression
	}

	protected def getXBinaryOperation(XExpression it) {
		it as XBinaryOperation
	}

	protected def getXUnaryOperation(XExpression it) {
		it as XUnaryOperation
	}
}