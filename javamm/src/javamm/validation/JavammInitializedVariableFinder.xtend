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
import javamm.javamm.JavammAdditionalXVariableDeclaration

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
	 * Calls the acceptor's accept method with all the references to
	 * variables which are not considered initialized.
	 * 
	 * Method to be called from clients.
	 */
	def void detectNotInitialized(XBlockExpression e, NotInitializedAcceptor acceptor) {
		detectNotInitializedDispatch(e, new InitializedVariables, acceptor)
	}

	/**
	 * We handle null case gracefully
	 */
	def void detectNotInitializedDispatch(XExpression e,
		InitializedVariables initialized, NotInitializedAcceptor acceptor) {
		if (e != null) {
			detectNotInitialized(e, initialized, acceptor)
		}
	}

	def dispatch void detectNotInitialized(XExpression e,
		InitializedVariables initialized, NotInitializedAcceptor acceptor) {
		inspectContents(e, initialized, acceptor)
	}

	def dispatch void detectNotInitialized(XAssignment e,
		InitializedVariables initialized, NotInitializedAcceptor acceptor) {
		val feature = e.feature
		if (feature instanceof XVariableDeclaration) {
			detectNotInitializedDispatch(
				e.value, initialized, acceptor
			)
			initialized += feature
		} else {
			inspectContents(e, initialized, acceptor)
		}
	}

	def dispatch void detectNotInitialized(JavammXVariableDeclaration e,
		InitializedVariables initialized, NotInitializedAcceptor acceptor) {
		inspectVariableDeclaration(e, initialized, acceptor)
		loopOverExpressions(
			e.additionalVariables, initialized, acceptor
		)
	}

	def dispatch void detectNotInitialized(JavammAdditionalXVariableDeclaration e,
		InitializedVariables initialized, NotInitializedAcceptor acceptor) {
		inspectVariableDeclaration(e, initialized, acceptor)
	}

	def protected void inspectVariableDeclaration(XVariableDeclaration e,
		InitializedVariables initialized, NotInitializedAcceptor acceptor) {
		if (e.right != null) {
			detectNotInitializedDispatch(
				e.right, initialized, acceptor
			)
			initialized += e
		}
	}

	def dispatch void detectNotInitialized(XBasicForLoopExpression e,
		InitializedVariables initialized, NotInitializedAcceptor acceptor) {
		loopOverExpressions(e.initExpressions, initialized, acceptor)

		// discard information collected
		loopOverExpressions(
			newArrayList(e.expression) +
				e.updateExpressions +
				newArrayList(e.eachExpression),
			initialized.createCopy,
			acceptor
		)
	}

	def dispatch void detectNotInitialized(XForLoopExpression e,
		InitializedVariables initialized, NotInitializedAcceptor acceptor) {
		// discard information collected
		detectNotInitializedDispatch(e.eachExpression, initialized.createCopy, acceptor)
	}

	def dispatch void detectNotInitialized(XWhileExpression e,
		InitializedVariables initialized, NotInitializedAcceptor acceptor) {
		detectNotInitializedDispatch(e.predicate, initialized, acceptor)

		// discard information collected
		detectNotInitializedDispatch(e.body, initialized.createCopy, acceptor)
	}

	def dispatch void detectNotInitialized(XDoWhileExpression e,
		InitializedVariables initialized, NotInitializedAcceptor acceptor) {
		// use information collected, since the body is surely executed
		detectNotInitializedDispatch(e.body, initialized, acceptor)
		detectNotInitializedDispatch(e.predicate, initialized, acceptor)
	}

	def dispatch void detectNotInitialized(XSwitchExpression e, InitializedVariables initialized,
		NotInitializedAcceptor acceptor) {
		// use information collected, since the body is surely executed
		detectNotInitializedDispatch(e.^switch, initialized, acceptor)

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
			effectiveOrNotEffectiveBranches.get(false), initialized.createCopy, acceptor
		)

		inspectBranchesAndIntersect(
			effectiveOrNotEffectiveBranches.get(true),
			initialized,
			acceptor
		)
	}

	def dispatch void detectNotInitialized(XBlockExpression b,
		InitializedVariables initialized, NotInitializedAcceptor acceptor) {
		loopOverExpressions(b.expressions, initialized, acceptor)
	}

	def dispatch void detectNotInitialized(XAbstractFeatureCall o,
			InitializedVariables initialized, NotInitializedAcceptor acceptor) {

		val actualArguments = o.actualArguments
		if (actualArguments.empty) {
			val feature = o.feature
			if (feature instanceof XVariableDeclaration) {
				if (!initialized.exists[it == feature]) {
					acceptor.accept(o)
				}
			}
		} else {
			loopOverExpressions(actualArguments, initialized, acceptor)
		}
	}

	def dispatch void detectNotInitialized(XIfExpression e,
			InitializedVariables initialized, NotInitializedAcceptor acceptor) {
		detectNotInitializedDispatch(e.^if, initialized, acceptor)

		inspectBranchesAndIntersect(
			newArrayList(e.then, e.^else), initialized, acceptor
		)
	}

	protected def inspectContents(XExpression e, InitializedVariables initialized, NotInitializedAcceptor acceptor) {
		val contents = e.eContents.filter(XExpression)
		loopOverExpressions(contents, initialized, acceptor)
	}

	/**
	 * Inspects all the branches and computes the initialized variables
	 * as the intersection of the results for all inspected branches.
	 * 
	 * IMPORTANT: the intersection assumes that branches contains at least two branches;
	 * callers must ensure this.  If there's only one branch, then the intersection
	 * will simply be the result for the single branch.  This works when
	 * the single branch is the 'default' branch of a switch.
	 */
	protected def void inspectBranchesAndIntersect(Iterable<? extends XExpression> branches,
		InitializedVariables initialized, NotInitializedAcceptor acceptor) {
		val intersection = 
			branches.
				map[inspectBranch(initialized, acceptor)].
				reduce[
					$0.retainAll($1) 
					$0
				]

		initialized += intersection
	}

	protected def inspectBranch(XExpression b, InitializedVariables initialized, NotInitializedAcceptor acceptor) {
		var copy = initialized.createCopy
		detectNotInitializedDispatch(b, copy, acceptor)
		return copy.toSet
	}

	def protected void loopOverExpressions(Iterable<? extends XExpression> expressions, InitializedVariables initialized,
		NotInitializedAcceptor acceptor) {
		for (e : expressions) {
			detectNotInitializedDispatch(e, initialized, acceptor)
		}
	}

	def private createCopy(InitializedVariables initialized) {
		new InitializedVariables() => [
			addAll(initialized)
		]
	}

}