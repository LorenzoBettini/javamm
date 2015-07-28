/**
 * 
 */
package javamm.typesystem;

import java.util.Iterator;

import javamm.javamm.JavammArrayAccess;
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
			if (featureType instanceof ArrayTypeReference) {
				return new AssignmentFeatureCallArguments(assignment.getValue(), 
						getComponentType(featureType, assignment));
			} else {
				return assignmentFeatureCallArguments;
			}
		}
		
		return super.createExpressionArguments(expression, candidate);
	}

	/**
	 * Computes the component type according to the number of array access expressions,
	 * for example
	 * 
	 * <pre>
	 * int[][] a;
	 * a[0] // type int[]
	 * a[0][0] // type int
	 * </pre>
	 * 
	 * @param arrayType
	 * @param arrayAccess
	 * @return
	 */
	private LightweightTypeReference getComponentType(LightweightTypeReference arrayType, JavammArrayAccess arrayAccess) {
		LightweightTypeReference resultType = arrayType;
		Iterator<XExpression> indexes = arrayAccess.getIndexes().iterator();
		while (indexes.hasNext()) {
			LightweightTypeReference componentType = resultType.getComponentType();
			if (componentType == null) {
				return resultType;
			}
			resultType = componentType;
			indexes.next();
		}
		return resultType;
	}
}
