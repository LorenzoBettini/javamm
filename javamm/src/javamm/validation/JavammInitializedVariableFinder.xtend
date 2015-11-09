package javamm.validation

import javamm.javamm.JavammXVariableDeclaration
import org.eclipse.xtext.xbase.XAssignment
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.XVariableDeclaration

/**
 * @author Lorenzo Bettini
 */
class JavammInitializedVariableFinder {
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

}