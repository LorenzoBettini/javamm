package javamm.tests

import com.google.inject.Inject
import javamm.JavammInjectorProvider
import javamm.javamm.JavammArrayConstructorCall
import javamm.util.JavammModelUtil
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*
import org.eclipse.xtext.xbase.XNumberLiteral

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammInjectorProvider))
class JavammModelUtilTest extends JavammAbstractTest {

	@Inject extension JavammModelUtil

	@Test def void testArrayContructorCallOneDimensionHasExpression() {
		'''
		new int[0]
		'''.assertArrayDimensionIndexAssociations("[0]")
	}

	@Test def void testArrayContructorCallOneDimensionWithoutExpression() {
		'''
		new int[]
		'''.assertArrayDimensionIndexAssociations("[null]")
	}

	@Test def void testArrayContructorCallEachDimensionHasAnExpression() {
		'''
		new int[0][1][2]
		'''.assertArrayDimensionIndexAssociations("[0, 1, 2]")
	}

	@Test def void testArrayContructorCallNoDimensionHasAnExpression() {
		'''
		new int[][][]
		'''.assertArrayDimensionIndexAssociations("[null, null, null]")
	}

	@Test def void testArrayContructorCallSomeDimensionHasExpression1() {
		'''
		new int[0][][]
		'''.assertArrayDimensionIndexAssociations("[0, null, null]")
	}

	@Test def void testArrayContructorCallSomeDimensionHasExpression2() {
		'''
		new int[][1][]
		'''.assertArrayDimensionIndexAssociations("[null, 1, null]")
	}

	@Test def void testArrayContructorCallSomeDimensionHasExpression3() {
		'''
		new int[][][2]
		'''.assertArrayDimensionIndexAssociations("[null, null, 2]")
	}

	@Test def void testArrayContructorCallSomeDimensionHasExpression4() {
		'''
		new int[0][][2]
		'''.assertArrayDimensionIndexAssociations("[0, null, 2]")
	}

	@Test def void testRightVariableReferences() {
		'''
		int i = 0;
		int j = 1;
		int k = i + j + foo;
		'''.
		assertRightVariableReferences("i, j")
		// foo is unresolved
	}

	@Test def void testRightVariableReferences2() {
		'''
		int i = 0;
		int k = i;
		'''.
		assertRightVariableReferences("i")
	}

	@Test def void testRightVariableReferences3() {
		'''
		int i = 0;
		int j = 1;
		System.out.println(i + j + foo);
		'''.
		assertRightVariableReferences("i, j")
		// foo is unresolved
	}

	@Test def void testRightVariableReferences4() {
		'''
		int i = 0;
		int j = 1;
		int k1 = i, k2 = j, k3 = foo, k4 = j;
		'''.
		assertRightVariableReferences("i, j, j")
		// foo is unresolved, j appears twice
	}

	/**
	 * Assumes that dimension expressions, if given, are number literals
	 */
	private def assertArrayDimensionIndexAssociations(CharSequence input, CharSequence expected) {
		expected.
			assertEquals(
				input.lastArrayConstructorCall.arrayDimensionIndexAssociations.
					map[
						e |
						if (e == null) {
							"null"
						} else {
							(e as XNumberLiteral).value
						}
					].toString
			)
	}

	private def lastArrayConstructorCall(CharSequence input) {
		input.parse.main.expressions.last as JavammArrayConstructorCall
	}

	private def assertRightVariableReferences(CharSequence input, CharSequence expected) {
		assertEqualsStrings(expected,
			input.parse.main.expressions.last.getAllRighthandVariableReferences.map[toString].join(", ")
		)
	}

}