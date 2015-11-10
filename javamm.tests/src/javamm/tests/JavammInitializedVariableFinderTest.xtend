package javamm.tests

import com.google.inject.Inject
import javamm.JavammInjectorProvider
import javamm.util.JavammNodeModelUtil
import javamm.validation.JavammInitializedVariableFinder
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammInjectorProvider))
class JavammInitializedVariableFinderTest extends JavammAbstractTest {

	@Inject extension JavammInitializedVariableFinder
	@Inject extension JavammNodeModelUtil

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

	@Test def void testNotInitializedNull() {
		// test it does not throw
		null.detectNotInitialized[]
	}

	@Test(expected=IllegalArgumentException)
	def void testNotInitializedInternalNull() {
		null.detectNotInitialized(emptyList)[]
	}

	@Test def void testNotInitializedWithNotVariableReference() {
		'''
		foo;
		'''.
		assertNotInitializedReferences("")
	}

	@Test def void testNotInitializedInCall() {
		'''
		int i;
		int j = 0;
		System.out.println(i);
		System.out.println(j);
		'''.
		assertNotInitializedReferences("i in System.out.println(i);")
	}

	@Test def void testNotInitializedInCall2() {
		'''
		int i;
		int j = 0;
		System.out.println( i );
		i = 1; // now initialized
		System.out.println(i);
		System.out.println(j);
		'''.
		assertNotInitializedReferences("i in System.out.println( i );")
	}

	@Test def void testNotInitializedInCall3() {
		'''
		int i;
		int j = 0;
		System.out.println( j < i );
		'''.
		assertNotInitializedReferences("i in j < i")
	}

	@Test def void testInitializedInCall() {
		'''
		int i;
		int j = 0;
		System.out.println( (i = j) == (j = i) );
		System.out.println(i); // now initialized
		'''.
		assertNotInitializedReferences("")
	}

	@Test def void testNotInitializedInCall4() {
		'''
		int i;
		int j = 0;
		System.out.println( (j = i) == (i = j) );
		'''.
		assertNotInitializedReferences("i in (j = i)")
	}

	@Test def void testNotInitializedInUnaryOperation() {
		'''
		int i;
		int j = -i;
		'''.
		assertNotInitializedReferences("i in -i")
	}

	@Test def void testNotInitializedInAssignment() {
		'''
		int i;
		int j;
		j = i;
		'''.
		assertNotInitializedReferences("i in j = i;")
	}

	@Test def void testNotInitializedInAssignment2() {
		'''
		int i;
		foo = i;
		'''.
		assertNotInitializedReferences("i in foo = i;")
		// even if foo is unresolved we still inspect the contents
	}

	@Test def void testNotInitializedInVariableDeclaration() {
		'''
		int i;
		int j = i;
		i = j; // OK
		'''.
		assertNotInitializedReferences("i in int j = i;")
	}

	@Test def void testNotInitializedInSeveralVariableDeclarations() {
		'''
		int i;
		int z = 0;
		int j = i, k = i, w = z;
		i = j; // OK
		'''.
		assertNotInitializedReferences(
		'''
		i in int j = i, k = i, w = z;
		i in k = i'''
		)
	}

	@Test def void testNotInitializedAfterBlock() {
		'''
		int i;
		int j;
		int k;
		{
			j = 0;
		}
		k = i; // ERROR
		k = j; // OK
		'''.
		assertNotInitializedReferences("i in k = i;")
		// even if foo is unresolved we still inspect the contents
	}

	@Test def void testNotInitializedInIf() {
		'''
		int i;
		if (i) {
			
		}
		'''.
		assertNotInitializedReferences("i in if (i) { }")
	}

	@Test def void testNotInitializedInIf2() {
		'''
		int j=0;
		int i;
		if (j) {
			j = i;
		}
		'''.
		assertNotInitializedReferences("i in j = i;")
	}

	private def assertInitializedVariables(CharSequence input, CharSequence expected) {
		assertEqualsStrings(
			expected,
			input.parse.main.expressions.last.findInitializedVariables.map[name].join(", ")
		)
	}

	private def assertNotInitializedReferences(CharSequence input, CharSequence expected) {
		val builder = new StringBuilder
		// we record the container of not initialized reference
		// so that it's easier to tell the occurrence in the test input
		input.parse.main.detectNotInitialized[
			ref |
			if (builder.length > 0) {
				builder.append("\n")
			}
			builder.append(ref.toString + " in " + ref.eContainer.programText)
		]
		assertEqualsStrings(
			expected,
			builder.toString
		)
	}
}