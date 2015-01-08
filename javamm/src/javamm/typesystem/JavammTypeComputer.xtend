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
import javamm.javamm.JavammBranchingStatement
import org.eclipse.xtext.xbase.XStringLiteral
import javamm.javamm.JavammCharLiteral

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
		} else if (expression instanceof JavammBranchingStatement) {
			_computeTypes(expression, state)
		} else if (expression instanceof JavammCharLiteral) {
			_computeTypes(expression, state)
		} else {
			super.computeTypes(expression, state)
		}
	}

	/**
	 * In our case an XStringLiteral is always a String
	 */
	override protected _computeTypes(XStringLiteral object, ITypeComputationState state) {
		val result = getTypeForName(String, state);
		state.acceptActualType(result);
	}

	def protected _computeTypes(JavammCharLiteral object, ITypeComputationState state) {
		val result = getTypeForName(Character.TYPE, state);
		state.acceptActualType(result);
	}
	
	def protected _computeTypes(JavammXAssignment assignment, ITypeComputationState state) {
		val candidates = state.getLinkingCandidates(assignment);
		val best = getBestCandidate(candidates);
		best.applyToComputationState();
		computeTypesOfArrayAccess(assignment, best, state, XbasePackage.Literals.XASSIGNMENT__ASSIGNABLE)
	}

	def protected _computeTypes(JavammArrayAccessExpression arrayAccess, ITypeComputationState state) {
		val actualType = state.withNonVoidExpectation.computeTypes(arrayAccess.array).actualExpressionType
		val type = componentTypeOfArrayAccess(arrayAccess, actualType, state, XbasePackage.Literals.XABSTRACT_FEATURE_CALL__FEATURE)
		state.acceptActualType(type)

		checkArrayIndexHasTypeInt(arrayAccess, state);
	}

	def protected _computeTypes(JavammArrayConstructorCall call, ITypeComputationState state) {
		checkArrayIndexHasTypeInt(call, state)
		val typeReference = services.typeReferences.createTypeRef(call.type)
		val lightweight = state.getReferenceOwner().toLightweightTypeReference(typeReference)
		val arrayTypeRef = state.referenceOwner.newArrayTypeReference(lightweight)
		state.acceptActualType(arrayTypeRef)
	}

	def protected _computeTypes(JavammBranchingStatement st, ITypeComputationState state) {
		state.acceptActualType(state.primitiveVoid)
	}
	
	private def computeTypesOfArrayAccess(JavammArrayAccess arrayAccess, 
		ILinkingCandidate best, ITypeComputationState state, EStructuralFeature featureForError
	) {
		if (!arrayAccess.indexes.empty) {
			checkArrayIndexHasTypeInt(arrayAccess, state);
			val expressionState = state as ExpressionTypeComputationState
			val featureType = getDeclaredType(best.feature, expressionState)
			componentTypeOfArrayAccess(arrayAccess, featureType, state, featureForError)
		}
	}
	
	private def componentTypeOfArrayAccess(JavammArrayAccess arrayAccess, LightweightTypeReference type, ITypeComputationState state, EStructuralFeature featureForError) {
		var currentType = type
		for (index : arrayAccess.indexes) {
			if (currentType instanceof ArrayTypeReference) {
				currentType = currentType.componentType
			} else {
				val diagnostic = new EObjectDiagnosticImpl(
					Severity.ERROR,
					JavammValidator.NOT_ARRAY_TYPE, 
					"The type of the expression must be an array type but it resolved to " + currentType.simpleName,
					arrayAccess,
					featureForError,
					-1,
					null);
				state.addDiagnostic(diagnostic);
				return currentType
			}
		}
		return currentType
	}
	
	private def checkArrayIndexHasTypeInt(JavammArrayAccess arrayAccess, ITypeComputationState state) {
		for (index : arrayAccess.indexes) {
			val conditionExpectation = state.withExpectation(getTypeForName(Integer.TYPE, state))
			conditionExpectation.computeTypes(index)
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