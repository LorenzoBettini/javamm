package javamm.controlflow

import java.util.Collection
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.XSwitchExpression

/**
 * Checks whether there is a sure return statement.
 * 
 * @author Lorenzo Bettini
 */
class JavammSureReturnComputer extends JavammSemicolonStatementAwareEarlyExitComputer {

	def boolean isSureReturn(XExpression expression) {
		return isEarlyExit(expression)
	}

	/**
	 * For switch, a sure return must be in the default case.
	 */
	dispatch override protected Collection<ExitPoint> exitPoints(XSwitchExpression expression) {
		return getExitPoints(expression.getDefault())
	}
}