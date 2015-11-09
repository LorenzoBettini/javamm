package javamm.tests

import com.google.inject.Inject
import javamm.JavammInjectorProvider
import javamm.validation.JavammInitializedVariableFinder
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammInjectorProvider))
class JavammInitializedVariableFinderTest extends JavammAbstractTest {

	@Inject extension JavammInitializedVariableFinder

	@Test(expected=IllegalArgumentException) def void testNull() {
		null.findInitializedVariables
	}

	@Test def void testInitializedVariables() {
		'''
			int i = 0;
		'''.assertInitializedVariables("i")
	}

	@Test def void testInitializedVariables2() {
		'''
			int i;
		'''.assertInitializedVariables("")
	}

	@Test def void testInitializedVariables3() {
		'''
			int i = 0, j;
		'''.assertInitializedVariables("i")
	}

	@Test def void testInitializedVariables4() {
		'''
			int i = 0, j = 1;
		'''.assertInitializedVariables("i, j")
	}

	@Test def void testInitializedVariables5() {
		'''
			int i;
			i = 0;
		'''.assertInitializedVariables("i")
	}

	@Test def void testInitializedVariables6() {
		'''
			foo = 0;
		'''.assertInitializedVariables("")
	}

	@Test def void testInitializedVariables7() {
		'''
			int i;
			System.out.println(i);
		'''.assertInitializedVariables("")
	}

	@Test def void testInitializedVariablesInForLoop() {
		'''
			for (int i = 0; i < 0; i++);
		'''.assertInitializedVariables("i")
	}

	@Test def void testInitializedVariablesInForLoop2() {
		'''
			for (int i = 0, j = 1; i < 0; i++);
		'''.assertInitializedVariables("i, j")
	}

	@Test def void testInitializedVariablesInForLoop3() {
		'''
			for (int i, j = 1; i < 0; i++);
		'''.assertInitializedVariables("j")
	}

	@Test def void testInitializedVariablesInForLoop4() {
		'''
			int i;
			for (i = 1; i < 0; i++);
		'''.assertInitializedVariables("i")
	}

	@Test def void testInitializedVariablesInIf() {
		'''
			int i;
			if ((i = 1) < 0);
		'''.assertInitializedVariables("i")
	}

	@Test def void testInitializedVariablesInIf2() {
		'''
			int i
			int j;
			if ((i = 1) < (j = 2));
		'''.assertInitializedVariables("i, j")
	}

	private def assertInitializedVariables(CharSequence input, CharSequence expected) {
		assertEqualsStrings(
			expected,
			input.parse.main.expressions.last.findInitializedVariables.map[name].join(", ")
		)
	}
}