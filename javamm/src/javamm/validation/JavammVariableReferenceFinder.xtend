package javamm.validation

import com.google.inject.Singleton
import javamm.javamm.JavammXVariableDeclaration
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.XFeatureCall
import org.eclipse.xtext.xbase.XVariableDeclaration

/**
 * Finds references to variables.
 * 
 * @author Lorenzo Bettini
 * 
 */
@Singleton
class JavammVariableReferenceFinder {

	def Iterable<XFeatureCall> getAllRighthandVariableReferences(XExpression e) {
		if (e == null) {
			return emptyList
		}
		if (e instanceof JavammXVariableDeclaration) {
			return getAllRighthandVariableReferences(e.right) + e.additionalVariables.map [
				right.getAllRighthandVariableReferences
			].flatten
		}
		return EcoreUtil2.eAllOfType(e, XFeatureCall).filter[ref|ref.feature instanceof XVariableDeclaration]
	}

}