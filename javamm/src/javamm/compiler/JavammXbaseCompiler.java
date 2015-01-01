/**
 * 
 */
package javamm.compiler;

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
import org.eclipse.xtext.xbase.compiler.XbaseCompiler;
import org.eclipse.xtext.xbase.compiler.output.ITreeAppendable;

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
		internalToConvertedExpression(arrayAccess.getArray(), b);
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
			for (XExpression index : assignment.getIndexes()) {
				if (index != null) {
					b.append("[");
					internalToJavaExpression(index, b);
					b.append("]");
				}
			}
		}
	}

}
