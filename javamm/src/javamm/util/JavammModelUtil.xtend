package javamm.util

import com.google.inject.Inject
import com.google.inject.Singleton
import javamm.javamm.JavammArrayConstructorCall
import javamm.javamm.JavammArrayDimension
import org.eclipse.xtext.xbase.XBasicForLoopExpression
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations

import static extension org.eclipse.xtext.EcoreUtil2.*
import org.eclipse.xtext.common.types.JvmFormalParameter
import javamm.javamm.JavammJvmFormalParameter

/**
 * Utility methods for accessing the Javamm model.
 * 
 * @author Lorenzo Bettini
 *
 */
@Singleton
class JavammModelUtil {
	
	@Inject extension JavammNodeModelUtil
	@Inject extension IJvmModelAssociations
	
	def getContainingForLoop(XExpression e) {
		e.getContainerOfType(XBasicForLoopExpression)		
	}

	/**
	 * The returned list contains XExpressions corresponding to
	 * dimension specification in a JavammArrayConstructorCall;
	 * if the n-th element in the list is null then it means that no
	 * dimension expression has been specified for that dimension.
	 * For example
	 * 
	 * <pre>new int[][0][][0]</pre>
	 * 
	 * will correspond to the list [null, XNumberLiteral, null, XNumberLiteral]
	 */
	def arrayDimensionIndexAssociations(JavammArrayConstructorCall c) {
		val sortedByOffset = (c.dimensions + c.indexes).sortBy[elementOffsetInProgram]
		
		// there's at least one dimension [ if we parsed a JavammArrayConstructorCall
		
		val associations = <XExpression>newArrayList()
		
		val last = sortedByOffset.reduce[p1, p2|
			if (p1 instanceof JavammArrayDimension) {
				if (p2 instanceof XExpression) {
					// case "[ exp"
					associations.add(p2)
				} else {
					// case "[ ["
					associations.add(null)
				}
			}
			// else "exp [ " skip and go to the next state
			p2
		]
		if (last instanceof JavammArrayDimension) {
			associations.add(null)
		}
		
		return associations
	}

	/**
	 * This also takes into consideration Jvm model methods inferred from Java--
	 * methods; in such case the parameter is not a JavammJvmFormalParameter, but
	 * its original source is, and we return the original one.
	 */
	def JavammJvmFormalParameter getOriginalParam(JvmFormalParameter p) {
		if (p instanceof JavammJvmFormalParameter) {
			return p
		}
		
		val orig = p.sourceElements.head
		if (orig instanceof JavammJvmFormalParameter) {
			return orig
		} else {
			return null
		}
	}
}