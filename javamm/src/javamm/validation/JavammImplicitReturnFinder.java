/**
 * 
 */
package javamm.validation;

import org.eclipse.xtext.xbase.XExpression;
import org.eclipse.xtext.xbase.XSwitchExpression;
import org.eclipse.xtext.xbase.validation.XbaseImplicitReturnFinder;

/**
 * Customized for our switch statements, where we only need to check the default case.
 * 
 * @author Lorenzo Bettini
 *
 */
public class JavammImplicitReturnFinder extends XbaseImplicitReturnFinder {

	@Override
	public void findImplicitReturns(XExpression expression, Acceptor acceptor) {
		if (expression instanceof XSwitchExpression) {
			XSwitchExpression s = (XSwitchExpression) expression;
			findImplicitReturns(s.getDefault(), acceptor);
			return;
		}
		super.findImplicitReturns(expression, acceptor);
	}
}
