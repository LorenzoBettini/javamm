package javamm.util

import com.google.inject.Inject
import com.google.inject.Singleton
import javamm.javamm.JavammMethod
import javamm.javamm.JavammProgram
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.xbase.XBasicForLoopExpression
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations

import static extension org.eclipse.xtext.EcoreUtil2.*

/**
 * Utility methods for accessing the Javamm model.
 * 
 * @author Lorenzo Bettini
 * 
 */
@Singleton
class JavammModelUtil {

	@Inject extension IJvmModelAssociations

	def getContainingForLoop(XExpression e) {
		e.getContainerOfType(XBasicForLoopExpression)
	}

	def getInferredOperation(JavammMethod m) {
		m.jvmElements.filter(JvmOperation).head
	}

	def getInferredJavaClass(JavammProgram p) {
		p.jvmElements.filter(JvmGenericType).head
	}

	def getOriginalSource(EObject o) {
		o.primarySourceElement
	}
}