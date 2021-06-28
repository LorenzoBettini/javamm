package javamm.tests;

import org.eclipse.xtext.testing.InjectWith;
import org.eclipse.xtext.testing.XtextRunner;
import org.junit.Test;
import org.junit.runner.RunWith;

import com.google.inject.Inject;

import javamm.javamm.JavammFactory;
import javamm.jvmmodel.JavammJvmModelInferrer;

@RunWith(XtextRunner.class)
@InjectWith(JavammInjectorProvider.class)
public class JavammJvmModelInferrerTest {
	@Inject
	private JavammJvmModelInferrer inferrer;

	@Test
	public void testWithANonJavammProgram() { // NOSONAR just check it does not throw
		inferrer.infer(JavammFactory.eINSTANCE.createJavammMethod(), null, false);
	}

	@Test(expected = IllegalArgumentException.class)
	public void testWithNull() {
		inferrer.infer(null, null, false);
	}
}
