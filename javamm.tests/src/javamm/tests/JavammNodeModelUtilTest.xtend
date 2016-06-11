package javamm.tests

import com.google.inject.Inject
import javamm.util.JavammNodeModelUtil
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.XBlockExpression
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammInjectorProvider))
class JavammNodeModelUtilTest extends JavammAbstractTest {

	@Inject extension JavammNodeModelUtil

	@Test def void testTerminatingSemicolon() {
		'''
			i = 1;
		'''.assertMainLastExpressionText(
			"i = 1;"
		)
	}

	@Test def void testTerminatingSemicolon2() {
		'''
			i = 1;
			j = 0 ;
		'''.assertMainLastExpressionText(
			"j = 0 ;"
		)
	}

	@Test def void testAdditionalSemicolon() {
		'''
			i = 1 ;;
		'''.assertMainLastExpressionText(
			";"
		)
	}

	@Test def void testMissingSemicolon() {
		'''
			i = 1
		'''.assertMainLastExpressionText(
			"i = 1"
		)
	}

	@Test def void testSemicolonInMethod() {
		'''
			void m() {
				i = 1;
		'''.assertMethodLastExpressionText(
			"i = 1;"
		)
	}

	@Test def void testMissingSemicolonInMethod() {
		'''
			void m() {
				i = 1
		'''.assertMethodLastExpressionText(
			"i = 1"
		)
	}

	@Test def void testMissingSemicolonInMethodDetected() {
		'''
			void m() {
				i = 1
		'''.lastMethodBody.lastBlockExpression.hasSemicolon.assertFalse
	}

	@Test def void testSemicolonInMethodDetected() {
		'''
			void m() {
				i = 1;
		'''.lastMethodBody.lastBlockExpression.hasSemicolon.assertTrue
	}

	@Test def void testMissingSemicolonDetected() {
		'''
			i = 1
		'''.parse.main.lastBlockExpression.hasSemicolon.assertFalse
	}

	@Test def void testSemicolonDetected() {
		'''
			i = 1;
		'''.parse.main.lastBlockExpression.hasSemicolon.assertTrue
	}

	@Test def void testSemicolonDetectedOnNextLine() {
		'''
			i = 1
			;
		'''.parse.main.lastBlockExpression.hasSemicolon.assertTrue
	}

	def private assertMainLastExpressionText(CharSequence input, CharSequence expected) {
		val block = input.parse.main
		assertBlockLastExpressionText(block, expected)
	}

	def private assertMethodLastExpressionText(CharSequence input, CharSequence expected) {
		val block = lastMethodBody(input)
		assertBlockLastExpressionText(block, expected)
	}

	private def lastMethodBody(CharSequence input) {
		input.parse.javammMethods.last.body as XBlockExpression
	}

	private def assertBlockLastExpressionText(XBlockExpression block, CharSequence expected) {
		expected.assertEquals(
			lastBlockExpression(block).programText
		)
	}

	private def lastBlockExpression(XBlockExpression block) {
		block.expressions.last
	}

}