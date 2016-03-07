package javamm.tests

import javamm.JavammInjectorProvider
import javamm.controlflow.JavammBreakStatementDetector
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.XExpression
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammInjectorProvider))
class JavammBreakStatementDetectorTest extends JavammAbstractTest {

	static class JavammBreakStatementDetectorCustom extends JavammBreakStatementDetector {
		// make it public to test it
		override sureBranch(XExpression e) {
			super.sureBranch(e)
		}
	}

	val detector = new JavammBreakStatementDetectorCustom

	@Test(expected=IllegalArgumentException) 
	def void testNullInDispatchMethod() {
		detector.sureBranch(null)
	}

	@Test
	def void testNull() {
		detector.isSureBranchStatement(null).assertFalse
	}

	@Test
	def void testAnyStatement() {
		'''int i = 0;'''.assertIsSureBreakStatement(false)
	}

	@Test
	def void testContinue() {
		'''continue;'''.assertIsSureBreakStatement(false)
	}

	@Test
	def void testBreak() {
		'''break;'''.assertIsSureBreakStatement(true)
	}

	@Test
	def void testBreakInSingleThenBranch() {
		'''
		if (true)
			break;
		'''.assertIsSureBreakStatement(true)
	}

	@Test
	def void testBreakInSingleElseBranch() {
		'''
		if (true) ;
		else
			break;
		'''.assertIsSureBreakStatement(false)
	}

	@Test
	def void testBreakInThenBranch() {
		'''
		if (true)
			break;
		else {
			
		}
		'''.assertIsSureBreakStatement(false)
	}

	@Test
	def void testBreakInElseBranch() {
		'''
		if (true) {
			
		} else {
			break;
		}
		'''.assertIsSureBreakStatement(false)
	}

	@Test
	def void testBreakInBothBranches() {
		'''
		if (true)
			break;
		else
			break;
		'''.assertIsSureBreakStatement(true)
	}

	@Test
	def void testBreakInBothBranchesWithBlocks() {
		'''
		if (true) {
			break;
		} else {
			break;
		}
		'''.assertIsSureBreakStatement(true)
	}

	@Test
	def void testBreakAndContinueInBranchesWithBlocks() {
		'''
		if (true) {
			break;
		} else {
			continue;
		}
		'''.assertIsSureBreakStatement(false)
	}

	@Test
	def void testBreakInWhile() {
		'''
		while (true) {
			break;
		}
		'''.assertContainsSureBreakStatement(true)
	}

	@Test
	def void testBreakInNestedWhileIgnore() {
		'''
		while (true) {
			while (true)
				break;
		}
		'''.assertContainsSureBreakStatement(false)
	}

	@Test
	def void testBreakInWhileBothBranchesOfIf() {
		'''
		while (true) {
			if (true)
				break;
			else
				break;
		}
		'''.assertContainsSureBreakStatement(true)
	}

	@Test
	def void testBreakInWhileNotBothBranchesOfIf() {
		'''
		while (true) {
			if (true)
				break;
			else
				continue;
		}
		'''.assertContainsSureBreakStatement(false)
	}

	@Test
	def void testBreakInDoWhile() {
		'''
		do {
			break;
		} while (true);
		'''.assertContainsSureBreakStatement(true)
	}

	def private void assertIsSureBreakStatement(CharSequence input, boolean expected) {
		input.parse.main.expressions.last => [
			assertEquals(it.toString, expected, detector.isSureBranchStatement(it))			
		]
	}

	def private void assertContainsSureBreakStatement(CharSequence input, boolean expected) {
		input.parse.main.expressions.last => [
			assertEquals(it.toString, expected, detector.containsSureBreakStatement(it))			
		]
	}
}