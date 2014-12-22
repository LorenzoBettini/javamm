package javamm.typesystem

import javamm.javamm.JavammArrayAccess
import javamm.javamm.JavammXAssignment
import javamm.javamm.JavammXFeatureCall
import javamm.validation.JavammValidator
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.xtext.common.types.JvmIdentifiableElement
import org.eclipse.xtext.diagnostics.Severity
import org.eclipse.xtext.validation.EObjectDiagnosticImpl
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.XbasePackage
import org.eclipse.xtext.xbase.typesystem.computation.IFeatureLinkingCandidate
import org.eclipse.xtext.xbase.typesystem.computation.ILinkingCandidate
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
		} else if (expression instanceof JavammXFeatureCall) {
			_computeTypes(expression, state)
		} else {
			super.computeTypes(expression, state)
		}
	}
	
	def protected _computeTypes(JavammXAssignment assignment, ITypeComputationState state) {
		val candidates = state.getLinkingCandidates(assignment);
		val best = getBestCandidate(candidates);
		best.applyToComputationState();
		computeTypesOfArrayAccess(assignment, best, state, XbasePackage.Literals.XASSIGNMENT__ASSIGNABLE)
	}

	def protected _computeTypes(JavammXFeatureCall featureCall, ITypeComputationState state) {
		val candidates = state.getLinkingCandidates(featureCall);
		val best = getBestCandidate(candidates) as IFeatureLinkingCandidate;
		val expState = state as ExpressionTypeComputationState
		val actualType = expState.resolvedTypes.getActualType(best.feature)
		if (featureCall.index != null) {
			computeTypesOfArrayAccess(featureCall, best, state, XbasePackage.Literals.XABSTRACT_FEATURE_CALL__FEATURE)
			if (actualType instanceof ArrayTypeReference) {
				expState.reassignType(best.feature, actualType.componentType)
			}
		}
		super._computeTypes(featureCall, state)
	}

	
	private def computeTypesOfArrayAccess(JavammArrayAccess arrayAccess, 
		ILinkingCandidate best, ITypeComputationState state, EStructuralFeature featureForError
	) {
		if (arrayAccess.index != null) {
			val conditionExpectation = state.withExpectation(getTypeForName(Integer.TYPE, state))
			conditionExpectation.computeTypes(arrayAccess.index);
			val expressionState = state as ExpressionTypeComputationState
			val featureType = getDeclaredType(best.feature, expressionState)
			if (!(featureType instanceof ArrayTypeReference)) {
				val diagnostic = new EObjectDiagnosticImpl(
					Severity.ERROR,
					JavammValidator.NOT_ARRAY_TYPE, 
					"The type of the expression must be an array type but it resolved to " + featureType.simpleName,
					arrayAccess,
					featureForError,
					-1,
					null);
				state.addDiagnostic(diagnostic);
			}
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