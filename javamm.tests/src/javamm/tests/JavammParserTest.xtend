package javamm.tests

import javamm.JavammInjectorProvider
import javamm.javamm.JavammXAssignment
import javamm.javamm.JavammXFeatureCall
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.XAssignment
import org.eclipse.xtext.xbase.XFeatureCall
import org.eclipse.xtext.xbase.XMemberFeatureCall
import org.eclipse.xtext.xbase.XNumberLiteral
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.*
import org.eclipse.xtext.xbase.XExpression

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
			assertTrue((it as JavammXAssignment).index instanceof XNumberLiteral)
		]
	}

	@Test def void testFeatureCallIndex() {
		'''
		int[] m() { return null; }
		m()[0] = 1;
		'''.parse => [
			assertTrue((main.expressions.head as JavammXFeatureCall).index instanceof XNumberLiteral)
		]
	}

	@Test def void testFeatureCallIndex2() {
		'''
		int[] m() { return null; }
		int i;
		i = m()[0];
		'''.assertMainLastExpression [
			assertTrue(((it as XAssignment).value as JavammXFeatureCall).index instanceof XNumberLiteral)
		]
	}

	@Test def void testSystemOut() {
		'''
		System.out;
		'''.assertMainLastExpression [
			(it as XMemberFeatureCall).memberCallTarget
		]
	}

	@Test def void testFeatureCallIndexAsArg() {
		arrayAccessAsArgument.assertMainLastExpression [
			assertTrue(
				((it as JavammXFeatureCall).
					actualArguments.head as JavammXFeatureCall
				).index instanceof XNumberLiteral
			)
		]
	}

	def private assertMainLastExpression(CharSequence input, (XExpression)=>void tester) {
		tester.apply(input.parse.main.expressions.last)
	}
}