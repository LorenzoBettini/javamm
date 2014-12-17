package javamm.typesystem

import javamm.javamm.JavammXAssignment
import org.eclipse.xtext.common.types.JvmIdentifiableElement
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.typesystem.computation.ITypeComputationState
import org.eclipse.xtext.xbase.typesystem.computation.XbaseTypeComputer
import org.eclipse.xtext.xbase.typesystem.internal.ExpressionTypeComputationState
import org.eclipse.xtext.xbase.typesystem.references.ArrayTypeReference
import org.eclipse.xtext.validation.EObjectDiagnosticImpl
import org.eclipse.xtext.diagnostics.Severity
import javamm.validation.JavammValidator
import org.eclipse.xtext.xbase.XbasePackage

/**
 * @author Lorenzo Bettini
 */
class JavammTypeComputer extends XbaseTypeComputer {
	
	override computeTypes(XExpression expression, ITypeComputationState state) {
		if (expression instanceof JavammXAssignment) {
			_computeTypes(expression, state)
		} else {
			super.computeTypes(expression, state)
		}
	}
	
	def protected _computeTypes(JavammXAssignment assignment, ITypeComputationState state) {
		val candidates = state.getLinkingCandidates(assignment);
		val best = getBestCandidate(candidates);
		if (assignment.index != null) {
			val conditionExpectation = state.withExpectation(getTypeForName(Integer.TYPE, state))
			conditionExpectation.computeTypes(assignment.index);
			val expressionState = state as ExpressionTypeComputationState
			val featureType = getDeclaredType(best.feature, expressionState)
			if (!(featureType instanceof ArrayTypeReference)) {
				val diagnostic = new EObjectDiagnosticImpl(
					Severity.ERROR,
					JavammValidator.NOT_ARRAY_TYPE, 
					"The type of the expression must be an array type but it resolved to " + featureType.simpleName,
					assignment,
					XbasePackage.Literals.XASSIGNMENT__ASSIGNABLE,
					-1,
					null);
				state.addDiagnostic(diagnostic);
			}
		}
		best.applyToComputationState();
	}

	def private getDeclaredType(JvmIdentifiableElement feature, ExpressionTypeComputationState state) {
		val result = state.getResolvedTypes().getActualType(feature);
		if (result == null) {
			return state.getReferenceOwner().newAnyTypeReference();
		}
		return result;
	}
	
}