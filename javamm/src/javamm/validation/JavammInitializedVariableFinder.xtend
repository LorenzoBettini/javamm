package javamm.validation

import javamm.javamm.JavammXVariableDeclaration
import org.eclipse.xtext.xbase.XAbstractFeatureCall
import org.eclipse.xtext.xbase.XAssignment
import org.eclipse.xtext.xbase.XBasicForLoopExpression
import org.eclipse.xtext.xbase.XBlockExpression
import org.eclipse.xtext.xbase.XDoWhileExpression
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.XForLoopExpression
import org.eclipse.xtext.xbase.XIfExpression
import org.eclipse.xtext.xbase.XVariableDeclaration
import org.eclipse.xtext.xbase.XWhileExpression
import java.util.ArrayList
import org.eclipse.xtext.xbase.XSwitchExpression
import com.google.inject.Inject
import javamm.controlflow.JavammBranchingStatementDetector

/**
 * @author Lorenzo Bettini
 */
class JavammInitializedVariableFinder {

	@Inject extension JavammBranchingStatementDetector

	interface NotInitializedAcceptor {
		def void accept(XAbstractFeatureCall call);
	}

	static class InitializedVariables extends ArrayList<XVariableDeclaration> {
	}

	/**
	 * Method to be called from clients
	 */
	def void detectNotInitialized(XBlockExpression e, NotInitializedAcceptor acceptor) {
		detectNotInitializedDispatch(e, new InitializedVariables, acceptor)
	}

	/**
	 * We handle null case gracefully
	 */
	def InitializedVariables detectNotInitializedDispatch(XExpression e,
		InitializedVariables current, NotInitializedAcceptor acceptor) {
		if (e == null) {
			return current
		} else {
			return detectNotInitialized(e, current, acceptor)
		}
	}

	def dispatch InitializedVariables detectNotInitialized(XExpression e,
		InitializedVariables current, NotInitializedAcceptor acceptor) {
		return inspectContents(e, current, acceptor)
	}

	def dispatch InitializedVariables detectNotInitialized(XAssignment e,
		InitializedVariables current, NotInitializedAcceptor acceptor) {
		val feature = e.feature
		if (feature instanceof XVariableDeclaration) {
			val initialized = detectNotInitializedDispatch(
				e.value, current, acceptor
			)
			initialized += feature
			return initialized
		} else {
			return inspectContents(e, current, acceptor)
		}
	}

	def dispatch InitializedVariables detectNotInitialized(JavammXVariableDeclaration e,
		InitializedVariables current, NotInitializedAcceptor acceptor) {
		if (e.right != null) {
			var initialized = detectNotInitializedDispatch(
				e.right, current, acceptor
			)
			initialized = loopOverExpressions(
				e.additionalVariables, initialized, acceptor
			)
			initialized += e
			return initialized
		}
		return current
	}

	def dispatch InitializedVariables detectNotInitialized(XBasicForLoopExpression e,
		InitializedVariables current, NotInitializedAcceptor acceptor) {
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

	def dispatch InitializedVariables detectNotInitialized(XForLoopExpression e,
		InitializedVariables current, NotInitializedAcceptor acceptor) {
		// discard information collected
		detectNotInitializedDispatch(e.eachExpression, current, acceptor)

		return current
	}

	def dispatch InitializedVariables detectNotInitialized(XWhileExpression e,
		InitializedVariables current, NotInitializedAcceptor acceptor) {
		var initialized = detectNotInitializedDispatch(e.predicate, current, acceptor)

		// discard information collected
		detectNotInitializedDispatch(e.body, initialized, acceptor)

		return initialized
	}

	def dispatch InitializedVariables detectNotInitialized(XDoWhileExpression e,
		InitializedVariables current, NotInitializedAcceptor acceptor) {
		// use information collected, since the body is surely executed
		var initialized = detectNotInitializedDispatch(e.body, current, acceptor)
		initialized = detectNotInitializedDispatch(e.predicate, initialized, acceptor)
		return initialized
	}

	def dispatch InitializedVariables detectNotInitialized(XSwitchExpression e, InitializedVariables current,
		NotInitializedAcceptor acceptor) {
		// use information collected, since the body is surely executed
		val initialized = detectNotInitializedDispatch(e.^switch, current, acceptor)

		// we consider effective branches the cases that end with a break
		// cases without a break will not be considered as branches, as in Java
		val effectiveOrNotEffectiveBranches =
			e.cases.map[then].groupBy[isSureBranchStatement]

		if (effectiveOrNotEffectiveBranches.get(true) == null) {
			effectiveOrNotEffectiveBranches.put(true, newArrayList)
		}
		if (effectiveOrNotEffectiveBranches.get(false) == null) {
			effectiveOrNotEffectiveBranches.put(false, newArrayList)
		}

		effectiveOrNotEffectiveBranches.get(true) += e.^default

		// the cases not considered as effective branches are simply inspected
		loopOverExpressions(
			effectiveOrNotEffectiveBranches.get(false), current, acceptor
		)

		val intersection = inspectBranchesAndIntersect(
			effectiveOrNotEffectiveBranches.get(true),
			current,
			acceptor
		)

		return new InitializedVariables => [addAll(initialized + intersection)]
	}

	def dispatch InitializedVariables detectNotInitialized(XBlockExpression b,
		InitializedVariables current, NotInitializedAcceptor acceptor) {
		return loopOverExpressions(b.expressions, current, acceptor)
	}

	def dispatch InitializedVariables detectNotInitialized(XAbstractFeatureCall o,
			InitializedVariables current, NotInitializedAcceptor acceptor) {

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

	def dispatch InitializedVariables detectNotInitialized(XIfExpression e,
			InitializedVariables current, NotInitializedAcceptor acceptor) {
		val initialized = detectNotInitializedDispatch(e.^if, current, acceptor)

		val intersection = inspectBranchesAndIntersect(
			newArrayList(e.then, e.^else), current, acceptor
		)
		return new InitializedVariables => [ addAll(initialized + intersection) ]
	}

	protected def inspectContents(XExpression e, InitializedVariables current, NotInitializedAcceptor acceptor) {
		val contents = e.eContents.filter(XExpression)
		return loopOverExpressions(contents, current, acceptor)
	}

	protected def inspectBranchesAndIntersect(Iterable<? extends XExpression> branches, InitializedVariables current,
		NotInitializedAcceptor acceptor) {
		val copy = current.createCopy
		val intersection = 
			detectNotInitializedDispatch(
				branches.head, copy, acceptor
			).toSet
		for (b : branches.tail) {
			val result = detectNotInitializedDispatch(b, copy, acceptor)
			intersection.retainAll(result.toSet)
		}

		return intersection
	}

	def protected InitializedVariables loopOverExpressions(Iterable<? extends XExpression> expressions, InitializedVariables current,
		NotInitializedAcceptor acceptor) {
		var initialized = current.createCopy
		for (e : expressions) {
			initialized = detectNotInitializedDispatch(e, initialized, acceptor)
		}
		return initialized
	}

	def private createCopy(InitializedVariables current) {
		new InitializedVariables() => [
			addAll(current)
		]
	}

}