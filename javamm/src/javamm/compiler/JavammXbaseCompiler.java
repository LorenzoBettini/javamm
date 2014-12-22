/**
 * 
 */
package javamm.compiler;

import java.util.List;

import javamm.javamm.JavammArrayAccess;

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
import org.eclipse.xtext.xbase.typesystem.references.CompoundTypeReference;
import org.eclipse.xtext.xbase.typesystem.references.LightweightTypeReference;

/**
 * @author Lorenzo Bettini
 *
 */
public class JavammXbaseCompiler extends XbaseCompiler {

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
			
			compileArrayAccess(expr.getValue(), b);
		}
	}

	@Override
	protected void appendFeatureCall(XAbstractFeatureCall call,
			ITreeAppendable b) {
		super.appendFeatureCall(call, b);
		compileArrayAccess(call, b);
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
}
