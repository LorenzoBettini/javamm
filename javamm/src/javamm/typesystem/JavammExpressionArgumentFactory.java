/**
 * 
 */
package javamm.typesystem;

import javamm.javamm.JavammXAssignment;

import org.eclipse.xtext.xbase.XExpression;
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
			// if it's an array access we must take the array component type
			if (featureType instanceof ArrayTypeReference && assignment.getIndex() != null) {
				return new AssignmentFeatureCallArguments(assignment.getValue(), ((ArrayTypeReference)featureType).getComponentType());
			} else {
				return assignmentFeatureCallArguments;
			}
		}
		
		return super.createExpressionArguments(expression, candidate);
	}

}