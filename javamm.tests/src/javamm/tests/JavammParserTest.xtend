package javamm.tests

import javamm.JavammInjectorProvider
import javamm.javamm.JavammArrayAccessExpression
import javamm.javamm.JavammArrayConstructorCall
import javamm.javamm.JavammCharLiteral
import javamm.javamm.JavammXAssignment
import javamm.javamm.JavammXVariableDeclaration
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.XAssignment
import org.eclipse.xtext.xbase.XBinaryOperation
import org.eclipse.xtext.xbase.XBlockExpression
import org.eclipse.xtext.xbase.XConstructorCall
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.XFeatureCall
import org.eclipse.xtext.xbase.XListLiteral
import org.eclipse.xtext.xbase.XMemberFeatureCall
import org.eclipse.xtext.xbase.XNumberLiteral
import org.eclipse.xtext.xbase.XStringLiteral
import org.eclipse.xtext.xbase.XVariableDeclaration
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*
import org.eclipse.xtext.xbase.XWhileExpression

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammInjectorProvider))
class JavammParserTest extends JavammAbstractTest {

	@Test def void testAssignmentLeft() {
		'''
		i = 1;
		'''.assertMainLastExpression [
			(it as XAssignment).feature as XFeatureCall
		]
	}

	@Test def void testAssignmentRight() {
		'''
		int m() { return null; }
		int i;
		i = m();
		'''.assertMainLastExpression [
			(it as XAssignment).value as XFeatureCall
		]
	}

	@Test def void testAssignmentRight2() {
		'''
		int j;
		int i;
		i = j;
		'''.assertMainLastExpression [
			(it as XAssignment).value as XFeatureCall
		]
	}

	@Test def void testAssignmentIndex() {
		'''
		i[0] = 1;
		'''.assertMainLastExpression [
			assertTrue((it as JavammXAssignment).indexes.head instanceof XNumberLiteral)
		]
	}

//	@Test def void testFeatureCallIndex() {
//		'''
//		int[] m() { return null; }
//		m()[0] = 1;
//		'''.parse => [
//			assertTrue((main.expressions.head as JavammXAssignment).index instanceof XNumberLiteral)
//		]
//	}

	@Test def void testFeatureCallIndex2() {
		'''
		int[] m() { return null; }
		int i;
		i = m()[0];
		'''.assertMainLastExpression [
			assertTrue(((it as XAssignment).value as JavammArrayAccessExpression).indexes.head instanceof XNumberLiteral)
		]
	}

	@Test def void testArrayAccessInParenthesizedExpression() {
		arrayAccessInParenthesizedExpression.assertMainLastExpression [
			assertTrue(((it as XAssignment).value as JavammArrayAccessExpression).indexes.head instanceof XNumberLiteral)
		]
	}

	@Test def void testMultiArrayAccessInRightHandsideExpression() {
		multiArrayAccessInRightHandsideExpression.assertMainLastExpression [
			val indexes = ((it as XAssignment).value as JavammArrayAccessExpression).indexes
			assertTrue(indexes.head instanceof XNumberLiteral)
			assertTrue(indexes.last instanceof XBinaryOperation)
		]
	}

	@Test def void testSystemOut() {
		'''
		System.out;
		'''.assertMainLastExpression [
			(it as XMemberFeatureCall).memberCallTarget
		]
	}

	@Test def void testSystemOutPrintln() {
		'''
		System.out.println("a");
		'''.assertMainLastExpression [
			// the whole call
			(it as XMemberFeatureCall) => [
				// System.out
				(memberCallTarget as XMemberFeatureCall)
				// the argument
				(memberCallArguments.head as XStringLiteral)
			]
		]
	}

	@Test def void testConstructorCall() {
		'''
		new String();
		'''.assertMainLastExpression [
			(it as XConstructorCall).arguments
		]
	}

	@Test def void testArrayConstructorCall() {
		'''
		int[] a = new int[0];
		'''.assertMainLastExpression [
			assertTrue(((it as XVariableDeclaration).right as JavammArrayConstructorCall).indexes.head instanceof XNumberLiteral)
		]
	}

	@Test def void testFeatureCallIndexAsArg() {
		arrayAccessAsArgument.assertMainLastExpression [
			assertTrue(
				((it as XFeatureCall).
					actualArguments.head as JavammArrayAccessExpression
				).indexes.head instanceof XNumberLiteral
			)
		]
	}

	@Test def void testArrayLiteral() {
		arrayLiteral.assertMainLastExpression [
			assertEquals(
				3,
				((it as JavammXVariableDeclaration).right
					as XListLiteral
				).elements.size
			)
		]
	}

	@Test def void testStringLiteral() {
		'''
		"a";
		'''.assertMainLastExpression[
			assertEquals(1, (it as XStringLiteral).value.length)
		]
	}

	@Test def void testCharLiteral() {
		'''
		'a';
		'''.assertMainLastExpression[
			assertEquals(1, (it as JavammCharLiteral).value.length)
		]
	}

	@Test def void testIncompleteVariableDeclaration() {
		'''
		int i = a
		'''.assertMainLastExpression[
			(it as JavammXVariableDeclaration).right.assertNotNull
		]
	}

	@Test def void testIncompleteVariableDeclaration2() {
		'''
		int i =
		'''.assertMainLastExpression[
			(it as XVariableDeclaration).right.assertNull
		]
	}

	@Test def void testIncompleteVariableDeclaration3() {
		'''
		int i = ;
		'''.assertMainLastExpression[
			(it as XVariableDeclaration).right.assertNull
		]
	}

	@Test def void testIncompleteMethodDefinition() {
		'''
		int i(
		'''.parse.javammMethods.last.assertNotNull
	}

	@Test def void testIncompleteFeatureCall() {
		'''
		void myMeth() {}
		my
		'''.assertMainLastExpression[
			(it as XFeatureCall).actualReceiver.assertNull
		]
	}

	@Test def void testIncompleteFeatureCall2() {
		'''
		my
		'''.assertMainLastExpression[
			(it as XFeatureCall).actualReceiver.assertNull
		]
	}

	@Test def void testIncompleteMemberCall() {
		'''
		String s = "";
		s.m
		'''.assertMainLastExpression[
			(it as XMemberFeatureCall).actualReceiver.assertNotNull
		]
	}

	@Test def void testIncompleteMemberCall2() {
		'''
		s.m
		'''.assertMainLastExpression[
			(it as XMemberFeatureCall).actualReceiver.assertNotNull
		]
	}

	@Test def void testIncompleteMemberCall3() {
		'''
		void m() {
			s.
		}
		'''.assertLastMethodLastExpression[
			(it as XMemberFeatureCall).actualReceiver.assertNotNull
		]
	}

	@Test def void testIncompleteMemberCall4() {
		'''
		s.
		'''.assertMainLastExpression[
			(it as XMemberFeatureCall).actualReceiver.assertNotNull
		]
	}

	@Test def void testWhileWithBlocks() {
		'''
		while (i < 10) {
			i = i + 1;
		}
		'''.assertMainLastExpression[
			(it as XWhileExpression).predicate.assertNotNull
		]
	}

	@Test def void testSeveralVariableDeclarations() {
		'''
		int i, j = 0, k;
		'''.assertMainLastExpression[
			(it as JavammXVariableDeclaration) => [
				type.assertNotNull
				additionalVariables => [
					2.assertEquals(size)
					get(0).right.assertNotNull
					get(1).right.assertNull
				]	
			]
		]
	}

	def private assertMainLastExpression(CharSequence input, (XExpression)=>void tester) {
		val main = input.parse.main
		tester.apply(main.expressions.last)
	}

	def private assertLastMethodLastExpression(CharSequence input, (XExpression)=>void tester) {
		val method = input.parse.javammMethods.last
		tester.apply((method.body as XBlockExpression).expressions.last)
	}

}