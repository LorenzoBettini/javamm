package javamm.tests

import javamm.JavammInjectorProvider
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.XbasePackage
import org.eclipse.xtext.xbase.validation.IssueCodes
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammInjectorProvider))
class JavammValidatorTest extends JavammAbstractTest {
	
//	val javammPack = JavammPackage.eINSTANCE

	@Test def void testEmptyProgram() {
		"".parseAndAssertNoErrors
	}

	@Test def void testHelloWorld() {
		helloWorld.parseAndAssertNoErrors
	}

	@Test def void testJavaLikeVariableDeclarations() {
		javaLikeVariableDeclarations.parseAndAssertNoErrors
	}

	@Test def void testArrayAccess() {
		arrayAccess.parseAndAssertNoErrors
	}

	@Test def void testArrayIndexNotInteger() {
		'''
		args[true] = 0;
		'''.parse.assertError(
			XbasePackage.eINSTANCE.XBooleanLiteral,
			IssueCodes.INCOMPATIBLE_TYPES,
			"Type mismatch: cannot convert from boolean to int"
		)
	}
}