/**
 * 
 */
package javamm.compiler;

import java.util.List;

import javamm.javamm.JavammArrayAccess;
import javamm.javamm.JavammArrayAccessExpression;
import javamm.javamm.JavammArrayConstructorCall;

import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.xtext.common.types.JvmField;
import org.eclipse.xtext.common.types.JvmIdentifiableElement;
import org.eclipse.xtext.common.types.JvmOperation;
import org.eclipse.xtext.xbase.XAbstractFeatureCall;
import org.eclipse.xtext.xbase.XAssignment;
import org.eclipse.xtext.xbase.XExpression;
import org.eclipse.xtext.xbase.XbasePackage;
import org.eclipse.xtext.xbase.compiler.Later;
import org.eclipse.xtext.xbase.compiler.XbaseCompiler;
import org.eclipse.xtext.xbase.compiler.output.ITreeAppendable;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.typesystem.IResolvedTypes;
import org.eclipse.xtext.xbase.typesystem.references.ArrayTypeReference;
import org.eclipse.xtext.xbase.typesystem.references.CompoundTypeReference;
import org.eclipse.xtext.xbase.typesystem.references.LightweightTypeReference;

/**
 * @author Lorenzo Bettini
 *
 */
public class JavammXbaseCompiler extends XbaseCompiler {
	
	@Override
	protected void doInternalToJavaStatement(XExpression obj,
			ITreeAppendable appendable, boolean isReferenced) {
		if (obj instanceof JavammArrayConstructorCall) {
			_toJavaStatement((JavammArrayConstructorCall) obj, appendable, isReferenced);
		} else if (obj instanceof JavammArrayAccessExpression) {
			_toJavaStatement((JavammArrayAccessExpression) obj, appendable, isReferenced);
		} else {
			super.doInternalToJavaStatement(obj, appendable, isReferenced);
		}
	}
	
	public void _toJavaStatement(JavammArrayConstructorCall call, ITreeAppendable b,
			boolean isReferenced) {
		
	}

	public void _toJavaStatement(JavammArrayAccessExpression access, ITreeAppendable b,
			boolean isReferenced) {
		
	}

	@Override
	protected void internalToConvertedExpression(XExpression obj, ITreeAppendable appendable) {
		if (obj instanceof JavammArrayConstructorCall) {
			_toJavaExpression((JavammArrayConstructorCall) obj, appendable);
		} else if (obj instanceof JavammArrayAccessExpression) {
			_toJavaExpression((JavammArrayAccessExpression) obj, appendable);
		} else {
			super.internalToConvertedExpression(obj, appendable);
		}
	}

	public void _toJavaExpression(JavammArrayConstructorCall call, ITreeAppendable b) {
		b.append("new ");
		b.append(call.getType());
		compileArrayAccess(call, b);
	}

	public void _toJavaExpression(JavammArrayAccessExpression arrayAccess, ITreeAppendable b) {
		_toJavaExpression(arrayAccess.getFeatureCall(), b);
		compileArrayAccess(arrayAccess, b);
	}

	@Override
	protected void assignmentToJavaExpression(XAssignment expr, ITreeAppendable b, boolean isExpressionContext) {
		final JvmIdentifiableElement feature = expr.getFeature();
		if (feature instanceof JvmOperation) {
			boolean appendReceiver = appendReceiver(expr, b, isExpressionContext);
			if (appendReceiver)
				b.append(".");
			appendFeatureCall(expr, b);
		} else {
			boolean isArgument = expr.eContainer() instanceof XAbstractFeatureCall;
			if (isArgument) {
				EStructuralFeature containingFeature = expr.eContainingFeature();
				if (containingFeature == XbasePackage.Literals.XFEATURE_CALL__FEATURE_CALL_ARGUMENTS 
						|| containingFeature == XbasePackage.Literals.XMEMBER_FEATURE_CALL__MEMBER_CALL_ARGUMENTS) {
					isArgument = false;
				} else {
					b.append("(");
				}
			}
			if (feature instanceof JvmField) {
				boolean appendReceiver = appendReceiver(expr, b, isExpressionContext);
				if (appendReceiver)
					b.append(".");
				appendFeatureCall(expr, b);
			} else {
				String name = b.getName(expr.getFeature());
				b.append(name);
			}
			
			// custom implementation starts here
			compileArrayAccess(expr, b);
			// custom implementation ends here
			
			b.append(" = ");
			internalToJavaExpression(expr.getValue(), b);
			if (isArgument) {
				b.append(")");
			}
		}
	}

	private void compileArrayAccess(XExpression expr, ITreeAppendable b) {
		if (expr instanceof JavammArrayAccess) {
			JavammArrayAccess assignment = (JavammArrayAccess) expr;
			XExpression index = assignment.getIndex();
			if (index != null) {
				b.append("[");
				internalToJavaExpression(index, b);
				b.append("]");
			}
		}
	}

	@Override
	protected void doConversion(final LightweightTypeReference left,
			LightweightTypeReference right, ITreeAppendable appendable,
			XExpression context, Later expression) {
		// since we reassign the type of a feature call with array access
		// the actual type will be of the shape type[] & type
		// so we must not consider type[]
		if (right instanceof CompoundTypeReference) {
			CompoundTypeReference compoundTypeRef = (CompoundTypeReference) right;
			List<LightweightTypeReference> multiTypes = compoundTypeRef
					.getMultiTypeComponents();
			if (IterableExtensions.exists(multiTypes,
					new Function1<LightweightTypeReference, Boolean>() {
						@Override
						public Boolean apply(LightweightTypeReference input) {
							return left.isAssignableFrom(input);
						}
					})) {
				// no conversion needed
				expression.exec(appendable);
				return;
			}
		}
		super.doConversion(left, right, appendable, context, expression);
	}

	@Override
	protected LightweightTypeReference getTypeForVariableDeclaration(XExpression expr) {
		IResolvedTypes resolvedTypes = getResolvedTypes(expr);
		LightweightTypeReference actualType = resolvedTypes.getActualType(expr);
		// since we reassign the type of a feature call with array access
		// the actual type will be of the shape type[] & type
		// so we must not consider type[]
		if (actualType instanceof CompoundTypeReference) {
			CompoundTypeReference compoundTypeRef = (CompoundTypeReference) actualType;
			List<LightweightTypeReference> multiTypes = compoundTypeRef
					.getMultiTypeComponents();
			LightweightTypeReference nonArrayType = IterableExtensions.findFirst(multiTypes,
					new Function1<LightweightTypeReference, Boolean>() {
				@Override
				public Boolean apply(LightweightTypeReference input) {
					return !(input instanceof ArrayTypeReference);
				}
			});
			if (nonArrayType != null) {
				return nonArrayType;
			}
		}
		return super.getTypeForVariableDeclaration(expr);
	}
}
