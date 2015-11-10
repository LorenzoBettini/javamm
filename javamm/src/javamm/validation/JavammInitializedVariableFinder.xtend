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

	def dispatch Iterable<XVariableDeclaration> detectNotInitialized(XAssignment e,
		Iterable<XVariableDeclaration> current, NotInitializedAcceptor acceptor) {
		val feature = e.feature
		if (feature instanceof XVariableDeclaration) {
			val initialized = detectNotInitializedDispatch(
				e.value, current, acceptor
			).toList
			initialized += feature
			return initialized
		} else {
			return inspectNonBlockContents(e, current, acceptor)
		}
	}

	def dispatch Iterable<XVariableDeclaration> detectNotInitialized(JavammXVariableDeclaration e,
		Iterable<XVariableDeclaration> current, NotInitializedAcceptor acceptor) {
		if (e.right != null) {
			var initialized = detectNotInitializedDispatch(
				e.right, current, acceptor
			).toList
			initialized = loopOverExpressions(
				e.additionalVariables, initialized, acceptor
			).toList
			initialized += e
			return initialized
		}
		return current
	}

	def dispatch Iterable<XVariableDeclaration> detectNotInitialized(XBasicForLoopExpression e,
		Iterable<XVariableDeclaration> current, NotInitializedAcceptor acceptor) {
		var initialized = loopOverExpressions(e.initExpressions, current, acceptor)

		// discard information collected
		loopOverExpressions(
			newArrayList(e.expression) +
				e.updateExpressions +
				newArrayList(e.eachExpression),
			initialized,
			acceptor
		)

		return initialized
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

		val thenInfo = detectNotInitializedDispatch(e.then, current.createCopy, acceptor)
		val elseInfo = detectNotInitializedDispatch(e.^else, current.createCopy, acceptor)

		return initialized
	}

	def protected Iterable<XVariableDeclaration> loopOverExpressions(Iterable<? extends XExpression> expressions, Iterable<XVariableDeclaration> current,
		NotInitializedAcceptor acceptor) {
		var initialized = current.createCopy
		for (e : expressions) {
			initialized += detectNotInitializedDispatch(e, initialized, acceptor)
			initialized += e.findInitializedVariables
		}
		return initialized
	}

	def private createCopy(Iterable<XVariableDeclaration> current) {
		newArrayList(current.clone)
	}

}