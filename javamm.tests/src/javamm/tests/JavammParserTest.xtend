package javamm.tests

import javamm.JavammInjectorProvider
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.runner.RunWith
import org.junit.Test
import javamm.javamm.JavammXAssignment
import org.eclipse.xtext.xbase.XNumberLiteral

import static extension org.junit.Assert.*
import javamm.javamm.JavammXFeatureCall
import org.eclipse.xtext.xbase.XMemberFeatureCall
import org.eclipse.xtext.xbase.XFeatureCall

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammInjectorProvider))
class JavammParserTest extends JavammAbstractTest {

	@Test def void testAssignmentLeft() {
		'''
		i = 1;
		'''.parse => [
			(main.expressions.head as JavammXAssignment).feature as XFeatureCall
		]
	}

	@Test def void testAssignmentRight() {
		'''
		int m() { return null; }
		int i;
		i = m();
		'''.parse => [
			(main.expressions.last as JavammXAssignment).value as XFeatureCall
		]
	}

	@Test def void testAssignmentIndex() {
		'''
		i[0] = 1;
		'''.parse => [
			assertTrue((main.expressions.head as JavammXAssignment).index instanceof XNumberLiteral)
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

	@Test def void testSystemOut() {
		'''
		System.out;
		'''.parse => [
			main.expressions.head as XMemberFeatureCall
		]
	}
}