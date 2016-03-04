package javamm.controlflow

import javamm.javamm.JavammContinueStatement

/**
 * Whether in the passed expression a break is surely executed.
 * 
 * @author Lorenzo Bettini
 */
class JavammBreakStatementDetector extends JavammBranchingStatementDetector {

	def protected dispatch sureBranch(JavammContinueStatement e) {
		return false
	}

}
