package javamm.tests

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
		override possibleBreak(XExpression e) {
			super.possibleBreak(e)
		}

		override containsPossibleBreak(XExpression e) {
			super.containsPossibleBreak(e)
		}
	}

	val detector = new JavammBreakStatementDetectorCustom

	@Test(expected=IllegalArgumentException) 
	def void testNullInDispatchMethod() {
		detector.containsPossibleBreak(null)
	}

	@Test(expected=IllegalArgumentException) 
	def void testNullInDispatchMethod2() {
		detector.possibleBreak(null)
	}

	@Test
	def void testNull() {
		detector.containsPossibleBreakStatement(null).assertFalse
	}

	@Test
	def void testNull2() {
		detector.isPossibleBreakStatement(null).assertFalse
	}

	@Test
	def void testAnyStatement() {
		'''int i = 0;'''.assertIsPossibleBreakStatement(false)
	}

	@Test
	def void testAnyStatement2() {
		'''int i = 0;'''.assertContainsBreakStatement(false)
	}

	@Test
	def void testContinue() {
		'''continue;'''.assertIsPossibleBreakStatement(false)
	}

	@Test
	def void testBreak() {
		'''break;'''.assertIsPossibleBreakStatement(true)
	}

	@Test
	def void testBreakInSingleThenBranch() {
		'''
		if (true)
			break;
		'''.assertIsPossibleBreakStatement(true)
	}

	@Test
	def void testBreakInSingleElseBranch() {
		'''
		if (true) ;
		else
			break;
		'''.assertIsPossibleBreakStatement(true)
	}

	@Test
	def void testBreakInThenBranch() {
		'''
		if (true)
			break;
		else {
			
		}
		'''.assertIsPossibleBreakStatement(true)
	}

	@Test
	def void testBreakInElseBranch() {
		'''
		if (true) {
			
		} else {
			break;
		}
		'''.assertIsPossibleBreakStatement(true)
	}

	@Test
	def void testBreakInBothBranches() {
		'''
		if (true)
			break;
		else
			break;
		'''.assertIsPossibleBreakStatement(true)
	}

	@Test
	def void testBreakInBothBranchesWithBlocks() {
		'''
		if (true) {
			break;
		} else {
			break;
		}
		'''.assertIsPossibleBreakStatement(true)
	}

	@Test
	def void testBreakAndContinueInBranchesWithBlocks() {
		'''
		if (true) {
			break;
		} else {
			continue;
		}
		'''.assertIsPossibleBreakStatement(true)
	}

	@Test
	def void testBreakInWhile() {
		'''
		while (true) {
			break;
		}
		'''.assertContainsBreakStatement(true)
	}

	@Test
	def void testBreakInNestedWhileIgnore() {
		'''
		while (true) {
			while (true)
				break;
		}
		'''.assertContainsBreakStatement(false)
	}

	@Test
	def void testBreakInWhileInThenBranch() {
		'''
		while (true) {
			if (true)
				break;
		}
		'''.assertContainsBreakStatement(true)
	}

	@Test
	def void testBreakInWhileInElseBranch() {
		'''
		while (true) {
			if (true);
			else
				break;
		}
		'''.assertContainsBreakStatement(true)
	}

	@Test
	def void testBreakInWhileNoBreakInIf() {
		'''
		while (true) {
			if (true);
		}
		'''.assertContainsBreakStatement(false)
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
		'''.assertContainsBreakStatement(true)
	}

	@Test
	def void testBreakInWhileNotBothBranchesOfIf() {
		'''
		while (true) {
			if (true)
				break;
			else
				System.out.println("");
		}
		'''.assertContainsBreakStatement(true)
	}

	@Test
	def void testBreakInWhileNotBothBranchesOfIf2() {
		'''
		while (true) {
			if (true)
				break;
			else
				continue;
		}
		'''.assertContainsBreakStatement(true)
	}

	@Test
	def void testBreakInDoWhile() {
		'''
		do {
			break;
		} while (true);
		'''.assertContainsBreakStatement(true)
	}

	@Test
	def void testBreakInBasicForLoop() {
		'''
		for (;;) {
			break;
		}
		'''.assertContainsBreakStatement(true)
	}

	def private void assertIsPossibleBreakStatement(CharSequence input, boolean expected) {
		input.parse.main.expressions.last => [
			assertEquals(it.toString, expected, detector.isPossibleBreakStatement(it))			
		]
	}

	def private void assertContainsBreakStatement(CharSequence input, boolean expected) {
		input.parse.main.expressions.last => [
			assertEquals(it.toString, expected, detector.containsPossibleBreakStatement(it))			
		]
	}
}