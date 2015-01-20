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
import org.eclipse.xtext.diagnostics.Diagnostic
import org.eclipse.xtext.diagnostics.Severity

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

	@Test def void testTypeMismatchInArrayDimensionExpression() {
		'''
		int[] i = new int[] { 1, true, 2};
		int[][] j = new int[][] {{ 1, 2}, { 1, "foo", 2}};
		int[][] j = new int[][] { 1 };
		'''.parse => [
			assertTypeMismatch(
				XbasePackage.eINSTANCE.XBooleanLiteral,
				"int",
				"boolean"
			)
			assertTypeMismatch(
				XbasePackage.eINSTANCE.XStringLiteral,
				"int",
				"String"
			)
			assertTypeMismatch(
				XbasePackage.eINSTANCE.XNumberLiteral,
				"int[]",
				"int"
			)
		]
	}

	@Test def void testArrayConstructorSpecifiesNeitherDimensionExpressionNorInitializer() {
		'''
		int[] a = new int[];
		'''.parse.assertError(
			javammPack.javammArrayConstructorCall,
			JavammValidator.ARRAY_CONSTRUCTOR_EITHER_DIMENSION_EXPRESSION_OR_INITIALIZER,
			"Constructor must provide either dimension expressions or an array initializer"
		)
	}

	@Test def void testArrayConstructorSpecifiesBothDimensionExpressionAndInitializer() {
		'''
		int[] j = new int[1] {};
		'''.parse.assertError(
			javammPack.javammArrayConstructorCall,
			JavammValidator.ARRAY_CONSTRUCTOR_BOTH_DIMENSION_EXPRESSION_AND_INITIALIZER,
			"Cannot define dimension expressions when an array initializer is provided"
		)
	}

	@Test def void testArrayConstructorSpecifiesDimensionExpressionAfterEmptyDimension() {
		'''
		int[][] j = new int[][0];
		'''.parse.assertError(
			XbasePackage.eINSTANCE.XNumberLiteral,
			JavammValidator.ARRAY_CONSTRUCTOR_DIMENSION_EXPRESSION_AFTER_EMPTY_DIMENSION,
			"Cannot specify an array dimension after an empty dimension"
		)
	}

	@Test def void testArrayConstructorSpecifiesDimensionExpressionAfterEmptyDimension2() {
		'''
		int[][][] j = new int[0][][1];
		'''.parse.assertError(
			XbasePackage.eINSTANCE.XNumberLiteral,
			JavammValidator.ARRAY_CONSTRUCTOR_DIMENSION_EXPRESSION_AFTER_EMPTY_DIMENSION,
			"Cannot specify an array dimension after an empty dimension"
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

	@Test def void testNotMultiArrayTypeLeft() {
		'''
		int[] i;
		i[0][1] = 1;
		'''.parse.assertError(
			javammPack.javammXAssignment,
			JavammValidator.NOT_ARRAY_TYPE,
			"The type of the expression must be an array type but it resolved to int"
		)
	}

	@Test def void testWrongMultiArrayConstructor() {
		'''
		int[] i = new int[0][1];
		'''.parse.assertTypeMismatch(
			javammPack.javammArrayConstructorCall,
			"int[]", "int[][]"
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

	@Test def void testInvalidCharAssignment() {
		'''
		char c = "c";
		'''.parse.assertTypeMismatch(
			XbasePackage.eINSTANCE.XStringLiteral,
			"char", "String"
		)
	}

	@Test def void testInvalidStringAssignment() {
		'''
		String s = 's';
		'''.parse.assertTypeMismatch(
			javammPack.javammCharLiteral,
			"String", "char"
		)
	}

	@Test def void testInvalidCharLiteralAssignmentToBoolean() {
		// https://bugs.eclipse.org/bugs/show_bug.cgi?id=457779
		'''
		boolean b = 's';
		'''.parse.assertTypeMismatch(
			javammPack.javammCharLiteral,
			"boolean", "char"
		)
	}

	@Test def void testBooleanLiteralAssignableToBoolean() {
		'''
		boolean b = true;
		'''.parseAndAssertNoErrors
	}

	@Test def void testInvalidSwitchCaseType() {
		'''
		String firstArg = args[0];
		char arg = firstArg.toCharArray()[0];
		switch (arg) {
			case "f" : 
				System.out.println("0");
				break;
			default: 
				System.out.println("default");
				break;
		}
		'''.parse.assertTypeMismatch(
			XbasePackage.eINSTANCE.XStringLiteral,
			"char", "String"
		)
	}

	@Test def void testMissingSemicolonInAssignment() {
		'''
		int i = 0;
		i = 1
		'''.parse.assertMissingSemicolon(XbasePackage.eINSTANCE.XAssignment)
	}

	@Test def void testMissingSemicolonInVariableDeclaration() {
		'''
		int i = 0
		'''.parse.assertMissingSemicolon(XbasePackage.eINSTANCE.XVariableDeclaration)
	}

	@Test def void testMissingSemicolonInContinue() {
		'''
		continue
		'''.parse.assertMissingSemicolon(javammPack.javammContinueStatement)
	}

	@Test def void testMissingSemicolonInBreak() {
		'''
		break
		'''.parse.assertMissingSemicolon(javammPack.javammBreakStatement)
	}

	@Test def void testMissingSemicolonInReturn() {
		'''
		void m() {
			return
		}
		'''.parse.assertMissingSemicolon(XbasePackage.eINSTANCE.XReturnExpression)
	}

	@Test def void testMissingSemicolonInDoWhile() {
		'''
		do {
			
		} while (true)
		'''.parse.assertMissingSemicolon(XbasePackage.eINSTANCE.XDoWhileExpression)
	}

	@Test def void testMissingSemicolonInFeatureCall() {
		'''
		i
		'''.parse.assertMissingSemicolon(XbasePackage.eINSTANCE.XFeatureCall)
	}

	@Test def void testMissingSemicolonInFeatureCall2() {
		'''
		i()
		'''.parse.assertMissingSemicolon(XbasePackage.eINSTANCE.XFeatureCall)
	}

	@Test def void testMissingSemicolonInMemberFeatureCall() {
		'''
		System.out.println()
		'''.parse.assertMissingSemicolon(XbasePackage.eINSTANCE.XMemberFeatureCall)
	}

	@Test def void testMissingParenthesesForMemberCall() {
		'''
		System.out.println;
		'''.parse.assertMissingParentheses(XbasePackage.eINSTANCE.XMemberFeatureCall)
	}

	@Test def void testMissingParenthesesForMemberCall2() {
		'''
		System.out.println
		'''.parse.assertMissingParentheses(XbasePackage.eINSTANCE.XMemberFeatureCall)
	}

	@Test def void testMissingParenthesesForMethodCall() {
		'''
		void m() {}
		m;
		'''.parse.assertMissingParentheses(XbasePackage.eINSTANCE.XFeatureCall)
	}

	@Test def void testMissingParenthesesForMethodCall2() {
		'''
		void m() {}
		m
		'''.parse.assertMissingParentheses(XbasePackage.eINSTANCE.XFeatureCall)
	}

	@Test def void testMissingParenthesesForArrayLengthOK() {
		'''
		int i = args.length;
		'''.parseAndAssertNoErrors
	}

	@Test def void testInvalidXbaseOperator() {
		'''
		int i;
		System.out.println(i === 0);
		'''.parse.assertError(
			XbasePackage.eINSTANCE.XBinaryOperation,
			Diagnostic.SYNTAX_DIAGNOSTIC,
			"no viable alternative at input '='"
		)
	}

	@Test def void testDuplicateMethods() {
		'''
		void m() {}
		void n() {}
		int m() { return 0; }
		'''.parse.assertErrorsAsStrings(
		'''
		Duplicate definition 'm'
		Duplicate definition 'm' '''
		)
	}

	@Test def void testParams() {
		'''
		void m(int i, boolean b, String i) {}
		'''.parse.assertErrorsAsStrings(
		'''Duplicate local variable i'''
		)
	}

	@Test def void testWrongVariableDeclarationInSeveralDeclarations() {
		'''
		int i = 0, j = "a", k = true;
		'''.parse.assertErrorsAsStrings(
		'''
		Type mismatch: cannot convert from String to int
		Type mismatch: cannot convert from boolean to int'''
		)
	}

	@Test def void testVariableDeclarationsNoUnusedWarningsWhenUsed() {
		'''
		int i, j, k;

		System.out.println(i);
		System.out.println(j);
		System.out.println(k);
		'''.parse.assertNoIssues
	}

	@Test def void testUnusedSeveralVariableDeclarations() {
		'''
		int i, j, k;
		System.out.println(j);
		'''.parse.assertIssuesAsStrings(
		'''
		The value of the local variable i is not used
		The value of the local variable k is not used
		'''
		)
	}

	@Test def void testPostfixOnWrongExpression() {
		'''
		"a"++;
		'''.parse.assertIssuesAsStrings(
		'''
		The method ++() is undefined
		'''
		)
	}

	@Test def void testWrongPostfixOnMethodCall() {
		'''
		int m() { return 0; }
		
		int i = m()++;
		'''.parse.assertErrorsAsStrings(
		'''
		The left-hand side of an assignment must be a variable
		'''
		)
	}

	@Test def void testPrefixOnWrongExpression() {
		'''
		++"a";
		'''.parse.assertIssuesAsStrings(
		'''
		The method ++() is undefined
		'''
		)
	}

	@Test def void testWrongPrefixOnMethodCall() {
		'''
		int m() { return 0; }
		
		int i = ++m();
		'''.parse.assertErrorsAsStrings(
		'''
		The left-hand side of an assignment must be a variable
		'''
		)
	}

	@Test def void testArrayAccessOnMemberFeatureCallNotAnArray() {
		'''
		int a;
		int l = a[0].length;
		'''.parse.assertErrorsAsStrings(
		'''
		Couldn't resolve reference to JvmIdentifiableElement 'length'.
		The type of the expression must be an array type but it resolved to int
		'''
		)
	}

	@Test def void testIntegerCannotBeAssignedToByte() {
		"byte b = 1000;".parse.assertNumberLiteralTypeMismatch("byte", "int")
	}

	@Test def void testIntegerCannotBeAssignedToChar() {
		"char c = 100000;".parse.assertNumberLiteralTypeMismatch("char", "int")
	}

	@Test def void testIntegerCannotBeAssignedToChar2() {
		"char c = -10000;".parse.assertTypeMismatch(XbasePackage.eINSTANCE.XUnaryOperation, "char", "int")
	}

	@Test def void testMaxValueChar() {
		"char c = 65535;".parseAndAssertNoErrors
	}

	@Test def void testIntegerCannotBeAssignedToShort() {
		"short s = 100000;".parse.assertNumberLiteralTypeMismatch("short", "int")
	}

	@Test def void testIntegerCannotBeAssignedToShort2() {
		"short s = -10000;".parse.assertTypeMismatch(XbasePackage.eINSTANCE.XUnaryOperation, "short", "int")
	}

	def private assertNumberLiteralTypeMismatch(EObject o, String expectedType, String actualType) {
		o.assertTypeMismatch(XbasePackage.eINSTANCE.XNumberLiteral, expectedType, actualType)
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
			"break cannot be used outside of a loop or a switch"
		)
	}

	def private assertErrorsAsStrings(EObject o, CharSequence expected) {
		expected.toString.trim.assertEqualsStrings(
			o.validate.filter[severity == Severity.ERROR].map[message].join("\n"))
	}

	def private assertIssuesAsStrings(EObject o, CharSequence expected) {
		expected.toString.trim.assertEqualsStrings(
			o.validate.map[message].join("\n"))
	}

	def private assertMissingSemicolon(EObject o, EClass c) {
		o.assertError(
			c,
			JavammValidator.MISSING_SEMICOLON,
			'Syntax error, insert ";" to complete Statement'
		)
	}

	def private assertMissingParentheses(EObject o, EClass c) {
		o.assertError(
			c,
			JavammValidator.MISSING_PARENTHESES,
			'Syntax error, insert "()" to complete method call'
		)
	}	
}
