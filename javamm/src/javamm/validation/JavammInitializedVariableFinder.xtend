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
	def void detectNotInitializedDispatch(XExpression e,
		InitializedVariables current, NotInitializedAcceptor acceptor) {
		if (e != null) {
			detectNotInitialized(e, current, acceptor)
		}
	}

	def dispatch void detectNotInitialized(XExpression e,
		InitializedVariables current, NotInitializedAcceptor acceptor) {
		inspectContents(e, current, acceptor)
	}

	def dispatch void detectNotInitialized(XAssignment e,
		InitializedVariables current, NotInitializedAcceptor acceptor) {
		val feature = e.feature
		if (feature instanceof XVariableDeclaration) {
			detectNotInitializedDispatch(
				e.value, current, acceptor
			)
			current += feature
		} else {
			inspectContents(e, current, acceptor)
		}
	}

	def dispatch void detectNotInitialized(JavammXVariableDeclaration e,
		InitializedVariables current, NotInitializedAcceptor acceptor) {
		if (e.right != null) {
			detectNotInitializedDispatch(
				e.right, current, acceptor
			)
			loopOverExpressions(
				e.additionalVariables, current, acceptor
			)
			current += e
		}
	}

	def dispatch void detectNotInitialized(XBasicForLoopExpression e,
		InitializedVariables current, NotInitializedAcceptor acceptor) {
		loopOverExpressions(e.initExpressions, current, acceptor)

		// discard information collected
		loopOverExpressions(
			newArrayList(e.expression) +
				e.updateExpressions +
				newArrayList(e.eachExpression),
			current.createCopy,
			acceptor
		)
	}

	def dispatch void detectNotInitialized(XForLoopExpression e,
		InitializedVariables current, NotInitializedAcceptor acceptor) {
		// discard information collected
		detectNotInitializedDispatch(e.eachExpression, current.createCopy, acceptor)
	}

	def dispatch void detectNotInitialized(XWhileExpression e,
		InitializedVariables current, NotInitializedAcceptor acceptor) {
		detectNotInitializedDispatch(e.predicate, current, acceptor)

		// discard information collected
		detectNotInitializedDispatch(e.body, current.createCopy, acceptor)
	}

	def dispatch void detectNotInitialized(XDoWhileExpression e,
		InitializedVariables current, NotInitializedAcceptor acceptor) {
		// use information collected, since the body is surely executed
		detectNotInitializedDispatch(e.body, current, acceptor)
		detectNotInitializedDispatch(e.predicate, current, acceptor)
	}

	def dispatch void detectNotInitialized(XSwitchExpression e, InitializedVariables current,
		NotInitializedAcceptor acceptor) {
		// use information collected, since the body is surely executed
		detectNotInitializedDispatch(e.^switch, current, acceptor)

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
			effectiveOrNotEffectiveBranches.get(false), current.createCopy, acceptor
		)

		inspectBranchesAndIntersect(
			effectiveOrNotEffectiveBranches.get(true),
			current,
			acceptor
		)
	}

	def dispatch void detectNotInitialized(XBlockExpression b,
		InitializedVariables current, NotInitializedAcceptor acceptor) {
		loopOverExpressions(b.expressions, current, acceptor)
	}

	def dispatch void detectNotInitialized(XAbstractFeatureCall o,
			InitializedVariables current, NotInitializedAcceptor acceptor) {

		val actualArguments = o.actualArguments
		if (actualArguments.empty) {
			val feature = o.feature
			if (feature instanceof XVariableDeclaration) {
				if (!current.exists[it == feature]) {
					acceptor.accept(o)
				}
			}
		} else {
			loopOverExpressions(actualArguments, current, acceptor)
		}
	}

	def dispatch void detectNotInitialized(XIfExpression e,
			InitializedVariables current, NotInitializedAcceptor acceptor) {
		detectNotInitializedDispatch(e.^if, current, acceptor)

		inspectBranchesAndIntersect(
			newArrayList(e.then, e.^else), current, acceptor
		)
	}

	protected def inspectContents(XExpression e, InitializedVariables current, NotInitializedAcceptor acceptor) {
		val contents = e.eContents.filter(XExpression)
		loopOverExpressions(contents, current, acceptor)
	}

	/**
	 * Inspects all the branches and computes the initialized variables
	 * as the intersection of the results for all inspected branches.
	 */
	protected def void inspectBranchesAndIntersect(Iterable<? extends XExpression> branches,
		InitializedVariables current, NotInitializedAcceptor acceptor) {
		val intersection = inspectBranch(branches.head, current, acceptor)
		for (b : branches.tail) {
			val branchResult = inspectBranch(b, current, acceptor)
			intersection.retainAll(branchResult)
		}

		current += intersection
	}

	protected def inspectBranch(XExpression b, InitializedVariables current, NotInitializedAcceptor acceptor) {
		var copy = current.createCopy
		detectNotInitializedDispatch(b, copy, acceptor)
		return copy.toSet
	}

	def protected void loopOverExpressions(Iterable<? extends XExpression> expressions, InitializedVariables current,
		NotInitializedAcceptor acceptor) {
		for (e : expressions) {
			detectNotInitializedDispatch(e, current, acceptor)
		}
	}

	def private createCopy(InitializedVariables current) {
		new InitializedVariables() => [
			addAll(current)
		]
	}

}