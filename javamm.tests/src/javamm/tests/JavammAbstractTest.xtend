package javamm.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import javamm.javamm.JavammProgram
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import javamm.tests.inputs.JavammInputs

abstract class JavammAbstractTest {
	@Inject protected extension ParseHelper<JavammProgram>
	@Inject protected extension ValidationTestHelper
	@Inject protected extension JavammInputs
	
	def protected parseAndAssertNoErrors(CharSequence input) {
		input.parse => [
			assertNoErrors
		]
	}
}