package javamm.compiler;

import org.eclipse.xtext.xbase.XAssignment;
import org.eclipse.xtext.xbase.XExpression;
import org.eclipse.xtext.xbase.compiler.XbaseCompiler;
import org.eclipse.xtext.xbase.compiler.output.ITreeAppendable;

/**
 * Temporary fix for https://bugs.eclipse.org/bugs/show_bug.cgi?id=489037
 * 
 * @author Lorenzo Bettini
 *
 */
public class PatchedXbaseCompiler extends XbaseCompiler {

	@Override
	protected boolean isVariableDeclarationRequired(XExpression expr, ITreeAppendable b) {
		if (expr instanceof XAssignment) {
			XAssignment a = (XAssignment) expr;
			for (XExpression arg : getActualArguments(a)) {
				if (isVariableDeclarationRequired(arg, b)) {
					return true;
				}
			}
		}
		return super.isVariableDeclarationRequired(expr, b);
	}
}
