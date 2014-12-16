package javamm.tests

import com.google.inject.Inject
import javamm.JavammInjectorProvider
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.TemporaryFolder
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammInjectorProvider))
class JavammCompilerTest extends JavammAbstractTest {

	@Rule @Inject public TemporaryFolder temporaryFolder
	@Inject extension CompilationTestHelper

	@Test def void testEmptyProgram() {
		"".compile[assertGeneratedJavaCodeCompiles]
	}

	@Test def void testHelloWorld() {
		helloWorld.compile[
			assertGeneratedJavaCode(
'''
@SuppressWarnings("all")
public class MyFile {
  public static void main(final String... args) {
    System.out.println("Hello world!");
  }
}
'''
			)
			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testHelloWorldMethod() {
		helloWorldMethod.compile[
			assertGeneratedJavaCode(
'''
@SuppressWarnings("all")
public class MyFile {
  public static void sayHelloWorld(final String m) {
    System.out.println(m);
  }
  
  public static void main(final String... args) {
    MyFile.sayHelloWorld("Hello world!");
  }
}
'''
			)
			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testJavaLikeVariableDeclarations() {
		javaLikeVariableDeclarations.compile[
			assertGeneratedJavaCode(
'''
@SuppressWarnings("all")
public class MyFile {
  public static boolean foo() {
    int i = 0;
    int j = 0;
    j = 1;
    return (i > 0);
  }
  
  public static void main(final String... args) {
    int i = 0;
    boolean b = false;
    boolean cond = (i > 0);
  }
}
'''
			)
			assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testArrayAccess() {
		arrayAccess.compile[
			assertGeneratedJavaCode(
'''
@SuppressWarnings("all")
public class MyFile {
  public static void main(final String... args) {
    String[] a = null;
    a = "test";
  }
}
'''
			)
			// the above generated code is not valid Java code
			// we need to customize XbaseCompiler
			//assertGeneratedJavaCodeCompiles
		]
	}

	@Test def void testSimpleAccess() {
		'''
		int i;
		i = 0;
		'''.compile[
			assertGeneratedJavaCode(
'''
@SuppressWarnings("all")
public class MyFile {
  public static void main(final String... args) {
    int i = 0;
    i = 0;
  }
}
'''
			)
			assertGeneratedJavaCodeCompiles
		]
	}

	def private assertGeneratedJavaCode(CompilationTestHelper.Result r, CharSequence expected) {
		expected.toString.assertEquals(r.singleGeneratedCode)
	}

	def private assertGeneratedJavaCodeCompiles(CompilationTestHelper.Result r) {
		r.compiledClass // check Java compilation succeeds
	}

}