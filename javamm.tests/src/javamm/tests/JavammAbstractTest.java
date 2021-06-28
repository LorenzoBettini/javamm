package javamm.tests;

import static org.eclipse.xtext.xbase.lib.IterableExtensions.last;
import static org.junit.Assert.assertEquals;

import org.eclipse.xtext.testing.util.ParseHelper;
import org.eclipse.xtext.testing.validation.ValidationTestHelper;
import org.eclipse.xtext.xbase.XBinaryOperation;
import org.eclipse.xtext.xbase.XBlockExpression;
import org.eclipse.xtext.xbase.XCastedExpression;
import org.eclipse.xtext.xbase.XExpression;
import org.eclipse.xtext.xbase.XFeatureCall;
import org.eclipse.xtext.xbase.XIfExpression;
import org.eclipse.xtext.xbase.XInstanceOfExpression;
import org.eclipse.xtext.xbase.XMemberFeatureCall;
import org.eclipse.xtext.xbase.XUnaryOperation;
import org.eclipse.xtext.xbase.lib.Extension;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;

import com.google.inject.Inject;

import javamm.javamm.JavammMethod;
import javamm.javamm.JavammProgram;
import javamm.tests.inputs.JavammInputs;
import jbase.jbase.XJArrayAccessExpression;
import jbase.jbase.XJArrayConstructorCall;
import jbase.jbase.XJArrayLiteral;
import jbase.jbase.XJConditionalExpression;
import jbase.jbase.XJSemicolonStatement;
import jbase.jbase.XJVariableDeclaration;

public abstract class JavammAbstractTest {
	@Inject
	@Extension
	protected ParseHelper<JavammProgram> parseHelper;

	@Inject
	@Extension
	protected ValidationTestHelper validationTestHelper;

	@Inject
	@Extension
	protected JavammInputs javammInputs;

	protected JavammProgram parseAndAssertNoErrors(CharSequence input) throws Exception {
		JavammProgram result = parseHelper.parse(input);
		validationTestHelper.assertNoErrors(result);
		return result;
	}

	protected JavammProgram parseAndAssertNoIssues(CharSequence input) throws Exception {
		JavammProgram result = parseHelper.parse(input);
		validationTestHelper.assertNoIssues(result);
		return result;
	}

	protected void assertEqualsStrings(CharSequence expected, CharSequence actual) {
		assertEquals(
			expected.toString().replace("\r", ""),
			actual.toString());
	}

	protected void assertMainLastExpression(CharSequence input, Procedure1<? super XExpression> tester) throws Exception {
		XExpression last = getMainLastExpression(input);
		applyTester(last, tester);
	}

	protected XExpression getMainLastExpression(CharSequence input) throws Exception {
		XBlockExpression main = getMainBlock(input);
		return last(main.getExpressions());
	}

	protected XBlockExpression getMainBlock(CharSequence input) throws Exception {
		return parseHelper.parse(input).getMain();
	}

	protected void applyTester(XExpression last, Procedure1<? super XExpression> tester) {
		if ((last instanceof XJSemicolonStatement)) {
			tester.apply(((XJSemicolonStatement) last).getExpression());
		} else {
			tester.apply(last);
		}
	}

	protected void assertLastMethodLastExpression(CharSequence input, Procedure1<? super XExpression> tester) throws Exception {
		JavammMethod method = IterableExtensions.<JavammMethod>last(parseHelper.parse(input).getJavammMethods());
		applyTester(last(((XBlockExpression) method.getBody()).getExpressions()), tester);
	}

	protected XJArrayConstructorCall getVariableDeclarationRightAsArrayConstructorCall(XExpression it) {
		return (XJArrayConstructorCall) getVariableDeclaration(it).getRight();
	}

	protected XExpression getVariableDeclarationRight(XExpression it) {
		return getVariableDeclaration(it).getRight();
	}

	protected XJVariableDeclaration getVariableDeclaration(XExpression it) {
		return (XJVariableDeclaration) it;
	}

	protected XJArrayLiteral getArrayLiteral(XExpression it) {
		return (XJArrayLiteral) it;
	}

	protected XMemberFeatureCall getMemberFeatureCall(XExpression it) {
		return (XMemberFeatureCall) it;
	}

	protected XJArrayAccessExpression getMemberCallTargetArrayAccess(XExpression it) {
		return getArrayAccess(getMemberFeatureCall(it).getMemberCallTarget());
	}

	protected XJArrayAccessExpression getArrayAccess(XExpression it) {
		return (XJArrayAccessExpression) it;
	}

	protected XFeatureCall getFeatureCall(XExpression it) {
		return (XFeatureCall) it;
	}

	protected XCastedExpression getCasted(XExpression it) {
		return (XCastedExpression) it;
	}

	protected XJConditionalExpression getConditional(XExpression it) {
		return (XJConditionalExpression) it;
	}

	protected XInstanceOfExpression getInstanceOf(XExpression it) {
		return (XInstanceOfExpression) it;
	}

	protected XIfExpression getIfStatement(XExpression it) {
		return (XIfExpression) it;
	}

	protected XBinaryOperation getXBinaryOperation(XExpression it) {
		return (XBinaryOperation) it;
	}

	protected XUnaryOperation getXUnaryOperation(XExpression it) {
		return (XUnaryOperation) it;
	}
}
