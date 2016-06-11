package javamm.util

import com.google.inject.Inject
import com.google.inject.Singleton
import javamm.javamm.JavammProgram
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations

/**
 * Utility methods for accessing the Javamm model.
 * 
 * @author Lorenzo Bettini
 * 
 */
@Singleton
class JavammModelUtil {

	@Inject extension IJvmModelAssociations

	def getInferredJavaClass(JavammProgram p) {
		p.jvmElements.filter(JvmGenericType).head
	}

	def getOriginalSource(EObject o) {
		o.primarySourceElement
	}
}