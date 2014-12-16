package javamm.typesystem

import javamm.javamm.JavammXAssignment
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.typesystem.computation.ITypeComputationState
import org.eclipse.xtext.xbase.typesystem.computation.XbaseTypeComputer
import org.eclipse.xtext.xbase.typesystem.internal.ExpressionTypeComputationState
import org.eclipse.xtext.xbase.typesystem.references.ArrayTypeReference
import org.eclipse.xtext.common.types.JvmIdentifiableElement
import org.eclipse.xtext.xbase.typesystem.conformance.ConformanceFlags

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
			if (featureType instanceof ArrayTypeReference) {
				val valueExpectation = state.withExpectation(featureType.componentType)
				valueExpectation.computeTypes(assignment.value)
				
//				val expectation = expressionState.expectations.head
//				expectation.acceptActualType(featureType.componentType, ConformanceFlags.UNCHECKED);
//				expressionState.getStackedResolvedTypes().mergeIntoParent();
				expressionState.acceptActualType(featureType.componentType, ConformanceFlags.UNCHECKED);
				// the following is required to make resolution of feature work
				// executed later from RootResolvedTypes.resolveProxies
				expressionState.acceptCandidate(assignment, best)
			}
		} else {
			best.applyToComputationState();
		}
	}

	def private getDeclaredType(JvmIdentifiableElement feature, ExpressionTypeComputationState state) {
		val result = state.getResolvedTypes().getActualType(feature);
		if (result == null) {
			return state.getReferenceOwner().newAnyTypeReference();
		}
		return result;
	}
	
}