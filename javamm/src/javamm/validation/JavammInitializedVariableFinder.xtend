package javamm.validation

import javamm.javamm.JavammXVariableDeclaration
import org.eclipse.xtext.xbase.XAssignment
import org.eclipse.xtext.xbase.XBasicForLoopExpression
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.XIfExpression
import org.eclipse.xtext.xbase.XVariableDeclaration
import org.eclipse.xtext.xbase.XBinaryOperation
import org.eclipse.xtext.xbase.XFeatureCall
import com.google.inject.Inject
import javamm.util.JavammModelUtil
import org.eclipse.xtext.xbase.XBlockExpression

/**
 * @author Lorenzo Bettini
 */
class JavammInitializedVariableFinder {

	@Inject extension JavammModelUtil

	interface NotInitializedAcceptor {
		def void accept(XFeatureCall call);
	}

	def dispatch Iterable<XVariableDeclaration> findInitializedVariables(XExpression e) {
		emptyList
	}

	def dispatch Iterable<XVariableDeclaration> findInitializedVariables(JavammXVariableDeclaration e) {
		val initialized = newArrayList()
		if (e.right != null) {
			initialized += e
		}
		return initialized + e.additionalVariables.filter[right != null]
	}

	def dispatch Iterable<XVariableDeclaration> findInitializedVariables(XAssignment e) {
		val feature = e.feature
		val initialized = newArrayList()
		if (feature instanceof XVariableDeclaration) {
			initialized += feature
		}
		return initialized
	}

	def dispatch Iterable<XVariableDeclaration> findInitializedVariables(XBasicForLoopExpression e) {
		return e.initExpressions.map[findInitializedVariables].flatten
	}

	def dispatch Iterable<XVariableDeclaration> findInitializedVariables(XIfExpression e) {
		return e.^if.findInitializedVariables
	}

	def dispatch Iterable<XVariableDeclaration> findInitializedVariables(XBinaryOperation e) {
		return e.leftOperand.findInitializedVariables + e.rightOperand.findInitializedVariables
	}

	/**
	 * Method to be called from clients
	 */
	def void detectNotInitialized(XBlockExpression e, NotInitializedAcceptor acceptor) {
		detectNotInitializedDispatch(e, newArrayList(), acceptor)
	}

	/**
	 * We handle null case gracefully
	 */
	def Iterable<XVariableDeclaration> detectNotInitializedDispatch(XExpression e,
		Iterable<XVariableDeclaration> current, NotInitializedAcceptor acceptor) {
			if (e == null) {
				return current
			} else {
				return detectNotInitialized(e, current, acceptor)
			}
	}

	def dispatch Iterable<XVariableDeclaration> detectNotInitialized(XExpression e,
		Iterable<XVariableDeclaration> current, NotInitializedAcceptor acceptor) {
		for (ref : e.allRighthandVariableReferences) {
			if (!current.exists[it == ref.feature]) {
				acceptor.accept(ref)
			}
		}
		return current
	}

	def dispatch Iterable<XVariableDeclaration> detectNotInitialized(XBlockExpression b,
		Iterable<XVariableDeclaration> current, NotInitializedAcceptor acceptor) {
		var initialized = current.toList
		for (e : b.expressions) {
			detectNotInitialized(e, initialized, acceptor)
			initialized += e.findInitializedVariables
		}
		return initialized
	}

}