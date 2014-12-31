package javamm.typesystem

import com.google.inject.Inject
import javamm.javamm.JavammArrayAccess
import javamm.javamm.JavammArrayAccessExpression
import javamm.javamm.JavammArrayConstructorCall
import javamm.javamm.JavammXAssignment
import javamm.validation.JavammValidator
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.xtext.common.types.JvmIdentifiableElement
import org.eclipse.xtext.diagnostics.Severity
import org.eclipse.xtext.validation.EObjectDiagnosticImpl
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.XbasePackage
import org.eclipse.xtext.xbase.typesystem.computation.ILinkingCandidate
import org.eclipse.xtext.xbase.typesystem.computation.ITypeComputationState
import org.eclipse.xtext.xbase.typesystem.computation.XbaseTypeComputer
import org.eclipse.xtext.xbase.typesystem.internal.ExpressionTypeComputationState
import org.eclipse.xtext.xbase.typesystem.references.ArrayTypeReference
import org.eclipse.xtext.xbase.typesystem.references.LightweightTypeReference
import org.eclipse.xtext.xbase.typesystem.util.CommonTypeComputationServices

/**
 * @author Lorenzo Bettini
 */
class JavammTypeComputer extends XbaseTypeComputer {
	
	@Inject 
	private CommonTypeComputationServices services;
	
	override computeTypes(XExpression expression, ITypeComputationState state) {
		if (expression instanceof JavammXAssignment) {
			_computeTypes(expression, state)
		} else if (expression instanceof JavammArrayConstructorCall) {
			_computeTypes(expression, state)
		} else if (expression instanceof JavammArrayAccessExpression) {
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

//	def protected _computeTypes(JavammXFeatureCall featureCall, ITypeComputationState state) {
//		val candidates = state.getLinkingCandidates(featureCall);
//		val best = getBestCandidate(candidates) as IFeatureLinkingCandidate;
//		val expState = state as ExpressionTypeComputationState
//		val actualType = expState.resolvedTypes.getActualType(best.feature)
//		if (featureCall.index != null) {
//			computeTypesOfArrayAccess(featureCall, best, state, XbasePackage.Literals.XABSTRACT_FEATURE_CALL__FEATURE)
//			if (actualType instanceof ArrayTypeReference) {
//				expState.reassignType(best.feature, actualType.componentType)
//			}
//		}
//		super._computeTypes(featureCall, state)
//	}

	def protected _computeTypes(JavammArrayAccessExpression arrayAccess, ITypeComputationState state) {
//		super.computeTypes(arrayAccess.featureCall, state)

//		for (expectation : state.expectations) {
//			val expectedType = expectation.expectedType
//			val arrayTypeRef = state.referenceOwner.newArrayTypeReference(expectedType)
//			val actualType = state.withExpectation(arrayTypeRef).computeTypes(arrayAccess.featureCall).actualExpressionType
//			if (actualType.isArray) {
//				state.acceptActualType(actualType.componentType)
//			} else {
//				state.acceptActualType(actualType)
//			}
//		}
		
		val actualType = state.withNonVoidExpectation.computeTypes(arrayAccess.featureCall).actualExpressionType
		val type = componentTypeOfArrayAccess(arrayAccess, actualType, state, XbasePackage.Literals.XABSTRACT_FEATURE_CALL__FEATURE)
		state.acceptActualType(type)

//		val actualType = state.computeTypes(arrayAccess.featureCall).actualExpressionType
		if (arrayAccess.index != null) {
			checkArrayIndexHasTypeInt(arrayAccess, state);
//			val type = computeTypesOfArrayAccess(arrayAccess, actualType, state, XbasePackage.Literals.XABSTRACT_FEATURE_CALL__FEATURE)
//			state.acceptActualType(type)
		}
	}

	def protected _computeTypes(JavammArrayConstructorCall call, ITypeComputationState state) {
		checkArrayIndexHasTypeInt(call, state)
		val typeReference = services.typeReferences.createTypeRef(call.type)
		val lightweight = state.getReferenceOwner().toLightweightTypeReference(typeReference)
		val arrayTypeRef = state.referenceOwner.newArrayTypeReference(lightweight)
		state.acceptActualType(arrayTypeRef)
	}
	
	private def computeTypesOfArrayAccess(JavammArrayAccess arrayAccess, 
		ILinkingCandidate best, ITypeComputationState state, EStructuralFeature featureForError
	) {
		if (arrayAccess.index != null) {
			checkArrayIndexHasTypeInt(arrayAccess, state);
			val expressionState = state as ExpressionTypeComputationState
			val featureType = getDeclaredType(best.feature, expressionState)
			componentTypeOfArrayAccess(arrayAccess, featureType, state, featureForError)
		}
	}
	
	private def componentTypeOfArrayAccess(JavammArrayAccess arrayAccess, LightweightTypeReference featureType, ITypeComputationState state, EStructuralFeature featureForError) {
		if (featureType instanceof ArrayTypeReference) {
			return featureType.componentType
		} else {
			val diagnostic = new EObjectDiagnosticImpl(
				Severity.ERROR,
				JavammValidator.NOT_ARRAY_TYPE, 
				"The type of the expression must be an array type but it resolved to " + featureType.simpleName,
				arrayAccess,
				featureForError,
				-1,
				null);
			state.addDiagnostic(diagnostic);
			return featureType
		}
	}
	
	private def checkArrayIndexHasTypeInt(JavammArrayAccess arrayAccess, ITypeComputationState state) {
		val conditionExpectation = state.withExpectation(getTypeForName(Integer.TYPE, state))
		conditionExpectation.computeTypes(arrayAccess.index)
	}

	def private getDeclaredType(JvmIdentifiableElement feature, ExpressionTypeComputationState state) {
		val result = state.getResolvedTypes().getActualType(feature);
		if (result == null) {
			return state.getReferenceOwner().newAnyTypeReference();
		}
		return result;
	}
	
}