package javamm.tests

import javamm.JavammInjectorProvider
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith
import javamm.controlflow.JavammBranchingStatementDetector
import org.eclipse.xtext.xbase.XExpression

import static extension org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammInjectorProvider))
class JavammBranchingStatementDetectorTest extends JavammAbstractTest {
	
	static class JavammBranchingStatementDetectorCustom extends JavammBranchingStatementDetector {
		
		// make it public to test it
		override sureBranch(XExpression e) {
			super.sureBranch(e)
		}
		
	}
	
	val detector = new JavammBranchingStatementDetectorCustom

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
		'''int i = 0;'''.assertIsSureBranchStatement(false)
	}

	@Test
	def void testContinue() {
		'''continue;'''.assertIsSureBranchStatement(true)
	}

	@Test
	def void testContinueInSingleThenBranch() {
		'''
		if (true)
			continue;
		'''.assertIsSureBranchStatement(true)
	}

	@Test
	def void testContinueInSingleElseBranch() {
		'''
		if (true)
		else
			continue;
		'''.assertIsSureBranchStatement(true)
	}

	@Test
	def void testContinueInThenBranch() {
		'''
		if (true)
			continue;
		else {
			
		}
		'''.assertIsSureBranchStatement(false)
	}

	@Test
	def void testContinueInElseBranch() {
		'''
		if (true) {
			
		} else {
			continue;
		}
		'''.assertIsSureBranchStatement(false)
	}

	@Test
	def void testContinueInBothBranches() {
		'''
		if (true)
			continue;
		else
			continue;
		'''.assertIsSureBranchStatement(true)
	}

	@Test
	def void testContinueInBothBranchesWithBlocks() {
		'''
		if (true) {
			continue;
		} else {
			continue;
		}
		'''.assertIsSureBranchStatement(true)
	}

	def private void assertIsSureBranchStatement(CharSequence input, boolean expected) {
		input.parse.main.expressions.last => [
			assertEquals(it.toString, expected, detector.isSureBranchStatement(it))			
		]
	}
}