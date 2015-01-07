package javamm.tests

import javamm.JavammInjectorProvider
import javamm.javamm.JavammPackage
import javamm.validation.JavammValidator
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.XbasePackage
import org.eclipse.xtext.xbase.validation.IssueCodes
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammInjectorProvider))
class JavammValidatorTest extends JavammAbstractTest {
	
	val javammPack = JavammPackage.eINSTANCE

	@Test def void testArrayIndexNotIntegerLeft() {
		'''
		args[true] = 0;
		'''.parse.assertTypeMismatch(
			XbasePackage.eINSTANCE.XBooleanLiteral,
			"int",
			"boolean"
		)
	}

	@Test def void testArrayIndexNotIntegerRight() {
		'''
		String s = args[true];
		'''.parse.assertTypeMismatch(
			XbasePackage.eINSTANCE.XBooleanLiteral,
			"int",
			"boolean"
		)
	}

	@Test def void testArrayIndexNotIntegerInArrayConstructorCall() {
		'''
		int[] i = new int[true];
		'''.parse.assertTypeMismatch(
			XbasePackage.eINSTANCE.XBooleanLiteral,
			"int",
			"boolean"
		)
	}

	@Test def void testNotArrayTypeLeft() {
		'''
		int i;
		i[0] = 0;
		'''.parse.assertError(
			javammPack.javammXAssignment,
			JavammValidator.NOT_ARRAY_TYPE,
			"The type of the expression must be an array type but it resolved to int"
		)
	}

	@Test def void testNotArrayTypeRight() {
		'''
		int i;
		i = i[0];
		'''.parse.assertError(
			javammPack.javammArrayAccessExpression,
			JavammValidator.NOT_ARRAY_TYPE,
			"The type of the expression must be an array type but it resolved to int"
		)
	}

	@Test def void testNotMultiArrayTypeRight() {
		'''
		int[] i;
		i = i[0][1];
		'''.parse.assertError(
			javammPack.javammArrayAccessExpression,
			JavammValidator.NOT_ARRAY_TYPE,
			"The type of the expression must be an array type but it resolved to int"
		)
	}

	@Test def void testWrongElementInArrayLiteral() {
		'''
		int[] i = {0, true};
		'''.parse.assertTypeMismatch(
			XbasePackage.eINSTANCE.XBooleanLiteral,
			"int",
			"boolean"
		)
	}

	@Test def void testStringLiteralAsStatement() {
		'''
		"test";
		'''.parse.assertNoSideEffectError(XbasePackage.eINSTANCE.XStringLiteral)
	}

	@Test def void testBooleanExpressionAsStatement() {
		'''
		"test" != "a";
		'''.parse => [
			assertNoSideEffectError(XbasePackage.eINSTANCE.XBinaryOperation)
			assertErrorsAsStrings("This expression is not allowed in this context, since it doesn't cause any side effects.")
		]
	}

	@Test def void testDeadCodeAfterReturn() {
		'''
		void m() {
			return;
			System.out.println("");
		}
		'''.parse.assertUnreachableExpression(XbasePackage.eINSTANCE.XMemberFeatureCall)
	}

	@Test def void testInvalidContinue() {
		'''
		void m() {
			if (true)
				continue;
		}
		'''.parse.assertInvalidContinueStatement
	}

	@Test def void testInvalidContinue2() {
		'''
		if (true)
			continue;
		'''.parse.assertInvalidContinueStatement
	}

	@Test def void testInvalidBreak() {
		'''
		void m() {
			if (true)
				break;
		}
		'''.parse.assertInvalidBreakStatement
	}

	@Test def void testInvalidBreak2() {
		'''
		if (true)
			break;
		'''.parse.assertInvalidBreakStatement
	}

	def private assertTypeMismatch(EObject o, EClass c, String expectedType, String actualType) {
		o.assertError(
			c,
			IssueCodes.INCOMPATIBLE_TYPES,
			'''Type mismatch: cannot convert from «actualType» to «expectedType»'''
		)
	}

	def private assertNoSideEffectError(EObject o, EClass c) {
		o.assertError(
			c,
			IssueCodes.INVALID_INNER_EXPRESSION,
			'''This expression is not allowed in this context, since it doesn't cause any side effects.'''
		)
	}

	def private assertUnreachableExpression(EObject o, EClass c) {
		o.assertError(
			c,
			IssueCodes.UNREACHABLE_CODE,
			'''Unreachable expression.'''
		)
	}

	def private assertInvalidContinueStatement(EObject o) {
		o.assertError(
			javammPack.javammContinueStatement,
			JavammValidator.INVALID_BRANCHING_STATEMENT,
			"continue cannot be used outside of a loop"
		)
	}

	def private assertInvalidBreakStatement(EObject o) {
		o.assertError(
			javammPack.javammBreakStatement,
			JavammValidator.INVALID_BRANCHING_STATEMENT,
			"break cannot be used outside of a loop"
		)
	}

	def private assertErrorsAsStrings(EObject o, CharSequence expected) {
		expected.toString.trim.assertEqualsStrings(
			o.validate.map[message].join("\n"))
	}
	
}
