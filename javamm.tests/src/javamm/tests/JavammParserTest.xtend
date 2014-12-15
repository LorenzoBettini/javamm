package javamm.tests

import javamm.JavammInjectorProvider
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.runner.RunWith
import org.junit.Test

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammInjectorProvider))
class JavammParserTest extends JavammAbstractTest {

	@Test def void testEmptyProgram() {
		"".parseAndAssertNoErrors
	}

	@Test def void testHelloWorld() {
		helloWorld.parseAndAssertNoErrors
	}
}