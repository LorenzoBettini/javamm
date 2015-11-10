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

	@Test def void testNotInitializedInIf3() {
		'''
		int j=0;
		int i;
		if (j) {
			j = 0;
		} else {
			int k = i;
		}
		'''.
		assertNotInitializedReferences("i in int k = i;")
	}

	@Test def void testNotInitializedInIf4() {
		'''
		int j=0;
		int i;
		if (j) {
			i = 0;
		}
		System.out.println(i); // ERROR
		'''.
		assertNotInitializedReferences("i in System.out.println(i);")
	}

	@Test def void testInitializedInIfBothBranches() {
		'''
		int j=0;
		int i;
		if (j) {
			i = 0;
		} else {
			i = 1;
		}
		System.out.println(i); // OK
		'''.
		assertNotInitializedReferences("")
	}

	@Test def void testInitializedInFor() {
		'''
		int j=0;
		int i;
		for (i = 0; i < 0; i++) {
			j = i;
		}
		'''.
		assertNotInitializedReferences("")
	}

	@Test def void testInitializedInFor2() {
		'''
		int j=0;
		for (int i = 0; i < 0; i++) {
			j = i;
		}
		'''.
		assertNotInitializedReferences("")
	}

	@Test def void testInitializedInFor3() {
		'''
		int j=0;
		int i;
		for (i = 0; i < 0; i++) {
			j = i;
		}
		System.out.println(i);  // OK
		'''.
		assertNotInitializedReferences("")
	}

	@Test def void testNotInitializedInFor() {
		'''
		int j=0;
		int i;
		for (; i < 0; i++) {
			j = i;
		}
		'''.
		assertNotInitializedReferences(
		'''
		i in i < 0
		i in i++
		i in j = i;'''
		)
	}

	@Test def void testNotInitializedInFor2() {
		'''
		int j;
		int i = 0;
		int k;
		for (k = 0; k < 0; j = i + 1) {
			j = i;
		}
		System.out.println(j); // ERROR
		System.out.println(k); // OK
		'''.
		assertNotInitializedReferences("j in System.out.println(j);")
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