package javamm.validation

import com.google.inject.Inject
import javamm.javamm.JavammXVariableDeclaration
import org.eclipse.xtext.xbase.XAbstractFeatureCall
import org.eclipse.xtext.xbase.XAssignment
import org.eclipse.xtext.xbase.XBasicForLoopExpression
import org.eclipse.xtext.xbase.XBinaryOperation
import org.eclipse.xtext.xbase.XBlockExpression
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.XFeatureCall
import org.eclipse.xtext.xbase.XIfExpression
import org.eclipse.xtext.xbase.XVariableDeclaration

/**
 * @author Lorenzo Bettini
 */
class JavammInitializedVariableFinder {

	@Inject extension JavammVariableReferenceFinder

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
		inspectVariableReferences(e, current, acceptor)
		return current
	}
	
	protected def inspectVariableReferences(XExpression e, Iterable<XVariableDeclaration> current, NotInitializedAcceptor acceptor) {
		for (ref : e.allRighthandVariableReferences) {
			if (!current.exists[it == ref.feature]) {
				acceptor.accept(ref)
			}
		}
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

	def dispatch Iterable<XVariableDeclaration> detectNotInitialized(XAbstractFeatureCall o,
		Iterable<XVariableDeclaration> current, NotInitializedAcceptor acceptor) {
		var initialized = current.toList
		val actualArguments = o.actualArguments
		if (actualArguments.empty) {
			inspectVariableReferences(o, current, acceptor)
		} else {
			for (a : actualArguments) {
				initialized += detectNotInitialized(a, initialized, acceptor)
				initialized += a.findInitializedVariables
			}
		}
		return initialized
	}

}