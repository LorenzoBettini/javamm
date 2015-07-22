package javamm.typesystem

import com.google.inject.Inject
import javamm.javamm.JavammArrayAccess
import javamm.javamm.JavammArrayAccessExpression
import javamm.javamm.JavammArrayConstructorCall
import javamm.javamm.JavammBranchingStatement
import javamm.javamm.JavammCharLiteral
import javamm.javamm.JavammXAssignment
import javamm.javamm.JavammXMemberFeatureCall
import javamm.javamm.JavammXVariableDeclaration
import javamm.validation.JavammValidator
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.xtext.common.types.JvmIdentifiableElement
import org.eclipse.xtext.common.types.util.Primitives
import org.eclipse.xtext.diagnostics.Severity
import org.eclipse.xtext.validation.EObjectDiagnosticImpl
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.XInstanceOfExpression
import org.eclipse.xtext.xbase.XStringLiteral
import org.eclipse.xtext.xbase.XSwitchExpression
import org.eclipse.xtext.xbase.XVariableDeclaration
import org.eclipse.xtext.xbase.XbasePackage
import org.eclipse.xtext.xbase.typesystem.computation.ILinkingCandidate
import org.eclipse.xtext.xbase.typesystem.computation.ITypeComputationState
import org.eclipse.xtext.xbase.typesystem.internal.AbstractTypeComputationState
import org.eclipse.xtext.xbase.typesystem.internal.ExpressionTypeComputationState
import org.eclipse.xtext.xbase.typesystem.references.ArrayTypeReference
import org.eclipse.xtext.xbase.typesystem.references.LightweightTypeReference
import org.eclipse.xtext.xbase.typesystem.util.CommonTypeComputationServices

/**
 * @author Lorenzo Bettini
 */
class JavammTypeComputer extends PatchedTypeComputer {
	
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
		} else if (expression instanceof JavammXVariableDeclaration) {
			_computeTypes(expression, state)
		} else if (expression instanceof JavammXMemberFeatureCall) {
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

	override protected addLocalToCurrentScope(XVariableDeclaration localVariable, ITypeComputationState state) {
		super.addLocalToCurrentScope(localVariable, state)
		if (localVariable instanceof JavammXVariableDeclaration) {
			for (additional : localVariable.additionalVariables) {
				addLocalToCurrentScope(additional, state)
			}
		}
	}

	/**
	 * In Javamm the switch statement is simpler, and it must type check the
	 * case expressions 
	 */
	override protected _computeTypes(XSwitchExpression object, ITypeComputationState state) {
		val computedType = state.withNonVoidExpectation.computeTypes(object.getSwitch());
		val expressionType = computedType.getActualExpressionType();

		for (c : object.cases) {
			val caseState = state.withExpectation(expressionType)
			caseState.computeTypes(c.^case)
			state.withoutExpectation.computeTypes(c.then)
		}

		if (object.^default != null) {
			state.withoutExpectation.computeTypes(object.^default)
		}
		state.acceptActualType(getPrimitiveVoid(state));
	}

	/**
	 * In Javamm we must keep the semantics and typing of Java for instanceof expressions,
	 * which do not imply a subsequent implicit cast like in Xbase.
	 */
	override protected reassignCheckedType(XExpression condition, XExpression guardedExpression, ITypeComputationState state) {
		if (condition instanceof XInstanceOfExpression) {
			return state
		}
		return super.reassignCheckedType(condition, guardedExpression, state)
	}

	def protected _computeTypes(JavammXVariableDeclaration object, ITypeComputationState state) {
		super._computeTypes(object, state)
		// and also comput types for possible additional declarations
		for (additional : object.additionalVariables) {
			state.computeTypes(additional)
		}
	}

	/**
	 * We must consider possible type expectations since a char literal can be
	 * assigned also to a primitive numeric type.
	 */
	def protected _computeTypes(JavammCharLiteral object, ITypeComputationState state) {
		val expectations = state.expectations
		for (typeExpectation : expectations.map[expectedType].filterNull) {
			val primitive = typeExpectation.primitiveKind
			if (primitive != null && primitive != Primitives.Primitive.Void &&
				primitive != Primitives.Primitive.Boolean
			) {
				state.acceptActualType(typeExpectation)
				return;
			}
		}
		
		val result = getTypeForName(Character.TYPE, state);
		state.acceptActualType(result);
	}
	
	def protected _computeTypes(JavammXAssignment assignment, ITypeComputationState state) {
		val candidates = state.getLinkingCandidates(assignment);
		val best = getBestCandidate(candidates);
		best.applyToComputationState();
		computeTypesOfArrayAccess(assignment, best, state, XbasePackage.Literals.XASSIGNMENT__ASSIGNABLE)
	}

	def protected _computeTypes(JavammXMemberFeatureCall call, ITypeComputationState state) {
		super._computeTypes(call, state)
		checkArrayIndexHasTypeInt(call, state)
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
		val lightweight = getReferenceOwner(state).toLightweightTypeReference(typeReference)
		var arrayTypeRef = lightweight
		for (i : 0..<call.dimensions.size) {
			arrayTypeRef = getReferenceOwner(state).newArrayTypeReference(arrayTypeRef)
		}
		if (call.arrayLiteral != null) {
			state.withExpectation(arrayTypeRef).computeTypes(call.arrayLiteral)
		}
		state.acceptActualType(arrayTypeRef)
	}
	
	private def getReferenceOwner(ITypeComputationState state) {
		state.referenceOwner
	}

	def protected _computeTypes(JavammBranchingStatement st, ITypeComputationState state) {
		state.acceptActualType(state.primitiveVoid)
	}
	
	private def computeTypesOfArrayAccess(JavammArrayAccess arrayAccess, 
		ILinkingCandidate best, ITypeComputationState state, EStructuralFeature featureForError
	) {
		checkArrayIndexHasTypeInt(arrayAccess, state);
		val expressionState = state as ExpressionTypeComputationState
		val featureType = getDeclaredType(best.feature, expressionState)
		componentTypeOfArrayAccess(arrayAccess, featureType, state, featureForError)
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

	def private getDeclaredType(JvmIdentifiableElement feature, AbstractTypeComputationState state) {
		val result = state.getResolvedTypes().getActualType(feature);
		if (result == null) {
			return state.getReferenceOwner().newAnyTypeReference();
		}
		return result;
	}
	
}