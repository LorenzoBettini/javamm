package javamm.tests

import javamm.JavammInjectorProvider
import javamm.javamm.JavammArrayAccessExpression
import javamm.javamm.JavammArrayConstructorCall
import javamm.javamm.JavammArrayLiteral
import javamm.javamm.JavammCharLiteral
import javamm.javamm.JavammPrefixOperation
import javamm.javamm.JavammXAssignment
import javamm.javamm.JavammXMemberFeatureCall
import javamm.javamm.JavammXVariableDeclaration
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.XAssignment
import org.eclipse.xtext.xbase.XBasicForLoopExpression
import org.eclipse.xtext.xbase.XBinaryOperation
import org.eclipse.xtext.xbase.XBlockExpression
import org.eclipse.xtext.xbase.XBooleanLiteral
import org.eclipse.xtext.xbase.XCastedExpression
import org.eclipse.xtext.xbase.XConstructorCall
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.XFeatureCall
import org.eclipse.xtext.xbase.XListLiteral
import org.eclipse.xtext.xbase.XMemberFeatureCall
import org.eclipse.xtext.xbase.XNumberLiteral
import org.eclipse.xtext.xbase.XPostfixOperation
import org.eclipse.xtext.xbase.XStringLiteral
import org.eclipse.xtext.xbase.XVariableDeclaration
import org.eclipse.xtext.xbase.XWhileExpression
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*

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

	@Test def void testMultiArrayAccessInLeftHandsideExpression() {
		'''
		int[][] a;
		a[0][1+2] = 1;
		'''.assertMainLastExpression [
			val indexes = (it as JavammXAssignment).indexes
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

	@Test def void testMultiArrayConstructorCall() {
		'''
		// of course true is not a valid array index
		// but we only test parsing here
		int[][] a = new int[0][true];
		'''.assertMainLastExpression [
			getVariableDeclarationRightAsArrayConstructorCall.indexes => [
				assertTrue(head instanceof XNumberLiteral)
				assertTrue(last instanceof XBooleanLiteral)
			]
		]
	}

	@Test def void testIncompleteArrayConstructorCall() {
		'''
		int[] a = new int[
		'''.assertMainLastExpression [
			assertTrue(getVariableDeclarationRightAsArrayConstructorCall.indexes.empty)
		]
	}

	@Test def void testIncompleteArrayConstructorCall2() {
		'''
		int[] a = new int[][
		'''.assertMainLastExpression [
			getVariableDeclarationRightAsArrayConstructorCall => [
				indexes.empty.assertTrue
				// the second dimension is parsed
				assertEquals(2, dimensions.size)
			]
		]
	}

	@Test def void testArrayConstructorCallWithDimensionsAndNoIndexes() {
		'''
		int[] a = new int[][][];
		'''.assertMainLastExpression [
			getVariableDeclarationRightAsArrayConstructorCall => [
				indexes.empty.assertTrue
				assertEquals(3, dimensions.size)
			]
		]
	}

	@Test def void testArrayConstructorCallWithDimensionsAndIndexes() {
		'''
		int[] a = new int[0][0][0];
		'''.assertMainLastExpression [
			getVariableDeclarationRightAsArrayConstructorCall => [
				assertEquals(3, indexes.size)
				assertEquals(3, dimensions.size)
			]
		]
	}

	@Test def void testArrayConstructorCallWithDimensionsAndSomeIndexes() {
		'''
		int[] a = new int[0][][0];
		'''.assertMainLastExpression [
			getVariableDeclarationRightAsArrayConstructorCall => [
				assertEquals(2, indexes.size)
				assertEquals(3, dimensions.size)
			]
		]
	}

	@Test def void testArrayConstructorCallWithDimensionsAndArrayLiteral() {
		'''
		int[] a = new int[][][] {};
		'''.assertMainLastExpression [
			getVariableDeclarationRightAsArrayConstructorCall => [
				assertEquals(3, dimensions.size)
				arrayLiteral.assertNotNull
			]
		]
	}

	@Test def void testArrayConstructorCallWithDimensionsAndIncompleteArrayLiteral() {
		'''
		int[] a = new int[][][] {
		'''.assertMainLastExpression [
			getArrayLiteral
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

	@Test def void testSeveralVariableDeclarationsInForLoop() {
		'''
		for (int i, j = 0, k; i < 0; i++) {}
		'''.assertMainLastExpression[
			((it as XBasicForLoopExpression).initExpressions.head as JavammXVariableDeclaration) => [
				type.assertNotNull
				additionalVariables => [
					2.assertEquals(size)
					get(0).right.assertNotNull
					get(1).right.assertNull
				]	
			]
		]
	}

	@Test def void testSeveralAssignmentsInForLoop() {
		'''
		int i;
		int j;
		int k;
		for (i = 0, j = 0, k = 0; i < 0; i++) {}
		'''.assertMainLastExpression[
			3.assertEquals((it as XBasicForLoopExpression).initExpressions.size)
		]
	}

	@Test def void testPostfixOperation() {
		'''
		int i = 0;
		i++;
		'''.assertMainLastExpression[
			assertTrue((it as XPostfixOperation).operand instanceof XFeatureCall)
		]
	}

	@Test def void testPrefixOperation() {
		'''
		int i = 0;
		++i;
		'''.assertMainLastExpression[
			assertTrue((it as JavammPrefixOperation).operand instanceof XFeatureCall)
		]
	}

	@Test def void testMemberFeatureCallIndex() {
		'''
		int[][] arr;
		arr[0].length;
		'''.assertMainLastExpression [
			assertFalse(memberFeatureCall.indexes.empty)
		]
	}

	@Test def void testIncompleteMemberFeatureCallIndex() {
		'''
		int[][] arr;
		arr[0].;
		'''.assertMainLastExpression [
			assertFalse(memberFeatureCall.indexes.empty)
		]
	}

	@Test def void testMemberCallTargetOfJavammMemberFeatureCallIsArrayAccessExpression() {
		'''
		int[][] arr;
		arr[0].length;
		'''.assertMainLastExpression [
			memberFeatureCall => [
				assertTrue(memberCallTarget instanceof JavammArrayAccessExpression)
				val arrayAccessExpression = memberCallTarget as JavammArrayAccessExpression
				// getIndexes is redirected to the contained array access expression
				assertSame(indexes, arrayAccessExpression.indexes)
			]
		]
	}

	@Test def void testCastedExpression() {
		'''
		(int) 10;
		'''.assertMainLastExpression[
			casted => [
				assertEquals("int", type.simpleName)
				assertTrue(target instanceof XNumberLiteral)
			]
		]
	}

	@Test def void testIncompleteCastedExpressionParsedAsParenthesizedExpression() {
		'''
		(int) ;
		'''.assertMainLastExpression[
			featureCall
		]
	}

	@Test def void testCastedExpressionWithParenthesis() {
		'''
		(char) ((int) 10);
		'''.assertMainLastExpression[
			casted => [
				assertEquals("char", type.simpleName)
				getCasted(target) => [
					assertEquals("int", type.simpleName)
					assertTrue(target instanceof XNumberLiteral)
				]
			]
		]
	}

	@Test def void testCastedExpressionRightAssociativity() {
		'''
		(char) (int) 10; // equivalent to (char) ((int) 10)
		'''.assertMainLastExpression[
			casted => [
				assertEquals("char", type.simpleName)
				getCasted(target) => [
					assertEquals("int", type.simpleName)
					assertTrue(target instanceof XNumberLiteral)
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

	private def getVariableDeclarationRightAsArrayConstructorCall(XExpression it) {
		(it as XVariableDeclaration).right as JavammArrayConstructorCall
	}

	private def getArrayLiteral(XExpression it) {
		it as JavammArrayLiteral
	}

	private def getMemberFeatureCall(XExpression it) {
		it as JavammXMemberFeatureCall
	}

	private def getFeatureCall(XExpression it) {
		it as XFeatureCall
	}

	private def getCasted(XExpression it) {
		it as XCastedExpression
	}
}