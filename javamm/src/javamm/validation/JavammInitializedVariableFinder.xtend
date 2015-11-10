package javamm.validation

import javamm.javamm.JavammXVariableDeclaration
import javamm.validation.JavammInitializedVariableFinder.NotInitializedAcceptor
import org.eclipse.xtext.xbase.XAbstractFeatureCall
import org.eclipse.xtext.xbase.XAssignment
import org.eclipse.xtext.xbase.XBasicForLoopExpression
import org.eclipse.xtext.xbase.XBinaryOperation
import org.eclipse.xtext.xbase.XBlockExpression
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.XIfExpression
import org.eclipse.xtext.xbase.XVariableDeclaration

/**
 * @author Lorenzo Bettini
 */
class JavammInitializedVariableFinder {

	interface NotInitializedAcceptor {
		def void accept(XAbstractFeatureCall call);
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
		return inspectNonBlockContents(e, current, acceptor)
	}

	protected def inspectNonBlockContents(XExpression e, Iterable<XVariableDeclaration> current, NotInitializedAcceptor acceptor) {
		val contents = e.eContents.
			filter[c | !(c instanceof XBlockExpression)].
			filter(XExpression)
		return loopOverExpressions(contents, current, acceptor)
	}

	def dispatch Iterable<XVariableDeclaration> detectNotInitialized(XBlockExpression b,
		Iterable<XVariableDeclaration> current, NotInitializedAcceptor acceptor) {
		return loopOverExpressions(b.expressions, current, acceptor)
	}

	def dispatch Iterable<XVariableDeclaration> detectNotInitialized(XAbstractFeatureCall o,
			Iterable<XVariableDeclaration> current, NotInitializedAcceptor acceptor) {

		val actualArguments = o.actualArguments
		if (actualArguments.empty) {
			val feature = o.feature
			if (feature instanceof XVariableDeclaration) {
				if (!current.exists[it == feature]) {
					acceptor.accept(o)
				}
			}
			return current
		} else {
			return loopOverExpressions(actualArguments, current, acceptor)
		}
	}

	def dispatch Iterable<XVariableDeclaration> detectNotInitialized(XIfExpression e,
			Iterable<XVariableDeclaration> current, NotInitializedAcceptor acceptor) {

		val initialized = inspectNonBlockContents(e, current, acceptor)
		
		return initialized
	}

	def protected Iterable<XVariableDeclaration> loopOverExpressions(Iterable<XExpression> expressions, Iterable<XVariableDeclaration> current,
		NotInitializedAcceptor acceptor) {
		var initialized = current.toList
		for (e : expressions) {
			initialized += detectNotInitializedDispatch(e, initialized, acceptor)
			initialized += e.findInitializedVariables
		}
		return initialized
	}

}