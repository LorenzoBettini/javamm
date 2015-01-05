package javamm.util

import org.eclipse.xtext.xbase.XExpression

import static extension org.eclipse.xtext.EcoreUtil2.*
import org.eclipse.xtext.xbase.XBasicForLoopExpression
import com.google.inject.Singleton

/**
 * Utility methods for accessing the Javamm model.
 * 
 * @author Lorenzo Bettini
 *
 */
@Singleton
class JavammModelUtil {
	
	def getContainingForLoop(XExpression e) {
		e.getContainerOfType(XBasicForLoopExpression)		
	}
}