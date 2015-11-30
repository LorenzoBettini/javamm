package javamm.controlflow

import java.util.Collection
import javamm.javamm.JavammSemicolonStatement
import org.eclipse.xtext.xbase.controlflow.DefaultEarlyExitComputer

/**
 * Handles semicolon statement containers.
 * 
 * @author Lorenzo Bettini
 */
class JavammSemicolonStatementAwareEarlyExitComputer extends DefaultEarlyExitComputer {

	/**
	 * A semicolon statement wraps an expression, so we delegate to the contained expression.
	 */
	def dispatch protected Collection<ExitPoint> exitPoints(JavammSemicolonStatement st) {
		return getExitPoints(st.expression)
	}
}