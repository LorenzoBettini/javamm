/**
 * 
 */
package javamm.typesystem;

import javamm.javamm.JavammXAssignment;

import org.eclipse.xtext.common.types.JvmField;
import org.eclipse.xtext.common.types.JvmFormalParameter;
import org.eclipse.xtext.common.types.JvmIdentifiableElement;
import org.eclipse.xtext.common.types.JvmOperation;
import org.eclipse.xtext.common.types.JvmTypeReference;
import org.eclipse.xtext.xbase.XExpression;
import org.eclipse.xtext.xbase.XVariableDeclaration;
import org.eclipse.xtext.xbase.typesystem.arguments.AssignmentFeatureCallArguments;
import org.eclipse.xtext.xbase.typesystem.arguments.IFeatureCallArguments;
import org.eclipse.xtext.xbase.typesystem.internal.AbstractLinkingCandidate;
import org.eclipse.xtext.xbase.typesystem.internal.ExpressionArgumentFactory;
import org.eclipse.xtext.xbase.typesystem.references.ArrayTypeReference;
import org.eclipse.xtext.xbase.typesystem.references.LightweightTypeReference;

/**
 * @author Lorenzo Bettini
 *
 */
public class JavammExpressionArgumentFactory extends ExpressionArgumentFactory {
	
	@Override
	public IFeatureCallArguments createExpressionArguments(
			XExpression expression, AbstractLinkingCandidate<?> candidate) {
		
		if (expression instanceof JavammXAssignment) {
			AssignmentFeatureCallArguments assignmentFeatureCallArguments = (AssignmentFeatureCallArguments) super.createExpressionArguments(expression, candidate);
			JavammXAssignment assignment = (JavammXAssignment) expression;
			LightweightTypeReference featureType = assignmentFeatureCallArguments.getDeclaredType();
			if (featureType instanceof ArrayTypeReference) {
				return new AssignmentFeatureCallArguments(assignment.getValue(), ((ArrayTypeReference)featureType).getComponentType());
			} else {
				return assignmentFeatureCallArguments;
			}
		}
		
		return super.createExpressionArguments(expression, candidate);
	}
	
	protected JvmTypeReference getDeclaredType(JvmIdentifiableElement identifiable) {
		if (identifiable instanceof XVariableDeclaration) {
			return ((XVariableDeclaration)identifiable).getType();
		}
		if (identifiable instanceof JvmOperation) {
			return ((JvmOperation) identifiable).getReturnType();
		}
		if (identifiable instanceof JvmField) {
			return ((JvmField) identifiable).getType();
		}
		if (identifiable instanceof JvmFormalParameter) {
			JvmTypeReference parameterType = ((JvmFormalParameter) identifiable).getParameterType();
			return parameterType;
		}
		return null;
	}
}
