package javamm.util;

import static com.google.common.collect.Iterables.filter;
import static org.eclipse.xtext.xbase.lib.IterableExtensions.head;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.common.types.JvmGenericType;
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations;

import com.google.inject.Inject;
import com.google.inject.Singleton;

import javamm.javamm.JavammProgram;

/**
 * Utility methods for accessing the Javamm model.
 * 
 * @author Lorenzo Bettini
 */
@Singleton
public class JavammModelUtil {
	@Inject
	private IJvmModelAssociations jvmModelAssociations;

	public JvmGenericType getInferredJavaClass(final JavammProgram p) {
		return head(filter(jvmModelAssociations.getJvmElements(p), JvmGenericType.class));
	}

	public EObject getOriginalSource(final EObject o) {
		return jvmModelAssociations.getPrimarySourceElement(o);
	}
}
