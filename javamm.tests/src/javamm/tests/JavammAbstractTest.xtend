package javamm.tests

import com.google.inject.Inject
import javamm.javamm.JavammProgram
import javamm.tests.inputs.JavammInputs
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper

import static org.junit.Assert.*

abstract class JavammAbstractTest {
	@Inject protected extension ParseHelper<JavammProgram>
	@Inject protected extension ValidationTestHelper
	@Inject protected extension JavammInputs
	
	def protected parseAndAssertNoErrors(CharSequence input) {
		input.parse => [
			assertNoErrors
		]
	}

	def protected parseAndAssertNoIssues(CharSequence input) {
		input.parse => [
			assertNoIssues
		]
	}

	def protected assertEqualsStrings(CharSequence expected, CharSequence actual) {
		assertEquals(expected.toString().replaceAll("\r", ""), actual.toString());
	}
}