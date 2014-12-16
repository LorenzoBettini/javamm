package javamm.typesystem

import javamm.javamm.JavammXAssignment
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.typesystem.computation.ITypeComputationState
import org.eclipse.xtext.xbase.typesystem.computation.XbaseTypeComputer
import org.eclipse.xtext.xbase.typesystem.internal.ExpressionTypeComputationState
import org.eclipse.xtext.xbase.typesystem.references.ArrayTypeReference

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
			val featureType = expressionState.resolvedTypes.getActualType(best.feature)
			if (featureType instanceof ArrayTypeReference) {
				val valueExpectation = state.withExpectation(featureType.componentType)
				valueExpectation.computeTypes(assignment.value)
			}
		} else {
			best.applyToComputationState();			
		}
	}
	
}