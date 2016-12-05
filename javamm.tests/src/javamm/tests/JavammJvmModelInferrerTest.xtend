package javamm.tests

import com.google.inject.Inject
import javamm.javamm.JavammFactory
import javamm.jvmmodel.JavammJvmModelInferrer
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammInjectorProvider))
class JavammJvmModelInferrerTest {

	@Inject JavammJvmModelInferrer inferrer

	@Test def void testWithANonJavammProgram() {
		inferrer.infer(JavammFactory.eINSTANCE.createJavammMethod, null, false)
	}

	@Test(expected=IllegalArgumentException)
	def void testWithNull() {
		inferrer.infer(null, null, false)
	}
}
