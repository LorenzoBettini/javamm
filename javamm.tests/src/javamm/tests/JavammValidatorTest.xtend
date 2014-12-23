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

	@Test def void testEmptyProgram() {
		"".parseAndAssertNoErrors
	}

	@Test def void testHelloWorld() {
		helloWorld.parseAndAssertNoErrors
	}

	@Test def void testJavaLikeVariableDeclarations() {
		javaLikeVariableDeclarations.parseAndAssertNoErrors
	}

	@Test def void testSimpleArrayAccess() {
		simpleArrayAccess.parseAndAssertNoErrors
	}

	@Test def void testArrayAccess() {
		arrayAccess.parseAndAssertNoErrors
	}

	@Test def void testArrayAssign() {
		arrayAssign.parseAndAssertNoErrors
	}

	@Test def void testArrayAccessInRightHandsideExpression() {
		arrayAccessInRightHandsideExpression.parseAndAssertNoErrors
	}

	@Test def void testArrayAccessFromFeatureCall() {
		arrayAccessFromFeatureCall.parseAndAssertNoErrors
	}

	@Test def void testArrayAccessAsArgument() {
		arrayAccessAsArgument.parseAndAssertNoErrors
	}

	@Test def void testArrayAccessInForLoop() {
		arrayAccessInForLoop.parseAndAssertNoErrors
	}

	@Test def void testArrayConstrcutorCallInVarDecl() {
		arrayConstructorCallInVarDecl.parseAndAssertNoErrors
	}

	@Test def void testIfThenElseWithoutBlocks() {
		ifThenElseWithoutBlocks.parseAndAssertNoErrors
	}

	@Test def void testIfThenElseWithBlocks() {
		ifThenElseWithBlocks.parseAndAssertNoErrors
	}

	@Test def void testArrayLiteral() {
		arrayLiteral.parseAndAssertNoErrors
	}

	@Test def void testWhileWithoutBlock() {
		whileWithoutBlock.parseAndAssertNoErrors
	}

	@Test def void testWhileWithBlock() {
		whileWithBlock.parseAndAssertNoErrors
	}

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
			javammPack.javammXFeatureCall,
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

	def assertTypeMismatch(EObject o, EClass c, String expectedType, String actualType) {
		o.assertError(
			c,
			IssueCodes.INCOMPATIBLE_TYPES,
			'''Type mismatch: cannot convert from «actualType» to «expectedType»'''
		)
	}
}