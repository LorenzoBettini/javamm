package javamm.tests

import com.google.inject.Inject
import javamm.JavammInjectorProvider
import javamm.validation.JavammVariableReferenceFinder
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammInjectorProvider))
class JavammVariableReferenceFinderTest extends JavammAbstractTest {

	@Inject extension JavammVariableReferenceFinder

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

	@Test def void testRightVariableReferencesNull() {
		'''
		int j;
		'''.
		assertRightVariableReferences("")
	}

	@Test def void testRightVariableReferencesInIf() {
		'''
		int i;
		int j;
		int k;
		if (i < j) {
			System.out.println(k);
		}
		'''.
		assertRightVariableReferences("i, j, k")
	}

	private def assertRightVariableReferences(CharSequence input, CharSequence expected) {
		assertEqualsStrings(expected,
			input.parse.main.expressions.last.getAllRighthandVariableReferences.map[toString].join(", ")
		)
	}

}