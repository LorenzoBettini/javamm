package javamm.tests

import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammInjectorProvider))
class JavammSmokeTest extends JavammAbstractTest {

	@Test def void testNoDimensionInArrayConstructorCall() {
		'''
		int[] i = new int[
		'''.parseAndValidate
	}

	@Test def void testSwitchWithoutThen() {
		'''
		byte b;
		switch (b) {
			case 10:
		'''.parseAndValidate
	}

	def private parseAndValidate(CharSequence input) {
		input.parse.validate
	}
}