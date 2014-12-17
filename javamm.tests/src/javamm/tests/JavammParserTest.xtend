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

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammInjectorProvider))
class JavammParserTest extends JavammAbstractTest {

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