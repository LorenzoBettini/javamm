package javamm.util

import org.eclipse.xtext.util.IAcceptor
import org.eclipse.xtext.xbase.XNumberLiteral
import org.eclipse.xtext.xbase.XUnaryOperation
import org.eclipse.xtext.xbase.lib.Functions.Function2

/**
 * Utility methods for expressions used both for typing and for code generation.
 * 
 * @author Lorenzo Bettini
 * 
 */
class JavammExpressionHelper {

	public static abstract class BaseCase implements Function2<XUnaryOperation, XNumberLiteral, Boolean> {
	}

	public static abstract class StepCase implements IAcceptor<XUnaryOperation> {
	}

	/**
	 * Whether this unary operation requires special handling
	 */
	def boolean specialHandling(XUnaryOperation unaryOperation) {
		specialHandling(unaryOperation, [true], [])
	}

	/**
	 * Whether this unary operation requires special handling; while checking
	 * it also executes the passed lambdas.
	 * 
	 * The base case is responsible for specifying whether in this particular execution the
	 * base case has performed custom operations.
	 * 
	 * The step case is executed after the base case executed and returned true, and
	 * after a successful recursive invocation.
	 * 
	 * For example, given this unary operation <pre>-(+1)</pre>
	 * and this (Xtend) code
	 * 
	 * <pre>
	 * val buffer = new StringBuilder
	 * helper.specialHandling(it as XUnaryOperation,
	 *   [ unaryOperation, numLiteral |
	 *     buffer.append(unaryOperation.getConcreteSyntaxFeatureName + numLiteral.value); return true
	 *   ],
	 *   [ unaryOperation | buffer.insert(0, unaryOperation.getConcreteSyntaxFeatureName)]
	 * )
	 * </pre>
	 * 
	 * Then the buffer will contain <pre>-+1</pre>
	 */
	def boolean specialHandling(XUnaryOperation unaryOperation, BaseCase baseCase, StepCase stepCase) {
		// don't get the feature since that would require linking resolution
		// get the original program text instead
		val unaryOp = unaryOperation.getConcreteSyntaxFeatureName();
		val operand = unaryOperation.getOperand();

		if ("!".equals(unaryOp)) {
			return false;
		}
		if (operand instanceof XNumberLiteral) {
			return baseCase.apply(unaryOperation, operand);
		} else if (operand instanceof XUnaryOperation) {
			// recursion
			if (specialHandling(operand, baseCase, stepCase)) {
				stepCase.accept(unaryOperation)
				return true
			}
		}
		return false
	}
}