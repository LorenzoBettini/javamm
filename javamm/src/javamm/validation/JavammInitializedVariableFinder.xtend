package javamm.validation

import javamm.javamm.JavammXVariableDeclaration
import org.eclipse.xtext.xbase.XAssignment
import org.eclipse.xtext.xbase.XBasicForLoopExpression
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.XIfExpression
import org.eclipse.xtext.xbase.XVariableDeclaration
import org.eclipse.xtext.xbase.XBinaryOperation

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

	def dispatch Iterable<XVariableDeclaration> findInitializedVariables(XBasicForLoopExpression e) {
		return e.initExpressions.map[findInitializedVariables].flatten
	}

	def dispatch Iterable<XVariableDeclaration> findInitializedVariables(XIfExpression e) {
		return e.^if.findInitializedVariables
	}

	def dispatch Iterable<XVariableDeclaration> findInitializedVariables(XBinaryOperation e) {
		return e.leftOperand.findInitializedVariables + e.rightOperand.findInitializedVariables
	}

}