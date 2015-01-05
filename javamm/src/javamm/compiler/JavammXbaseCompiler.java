/**
 * 
 */
package javamm.compiler;

import javamm.controlflow.JavammBranchingStatementDetector;
import javamm.javamm.JavammArrayAccess;
import javamm.javamm.JavammArrayAccessExpression;
import javamm.javamm.JavammArrayConstructorCall;
import javamm.javamm.JavammBranchingStatement;
import javamm.javamm.JavammContinueStatement;
import javamm.util.JavammModelUtil;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.xtext.common.types.JvmField;
import org.eclipse.xtext.common.types.JvmIdentifiableElement;
import org.eclipse.xtext.common.types.JvmOperation;
import org.eclipse.xtext.xbase.XAbstractFeatureCall;
import org.eclipse.xtext.xbase.XAssignment;
import org.eclipse.xtext.xbase.XBasicForLoopExpression;
import org.eclipse.xtext.xbase.XExpression;
import org.eclipse.xtext.xbase.XbasePackage;
import org.eclipse.xtext.xbase.compiler.XbaseCompiler;
import org.eclipse.xtext.xbase.compiler.output.ITreeAppendable;

import com.google.inject.Inject;

/**
 * @author Lorenzo Bettini
 *
 */
public class JavammXbaseCompiler extends XbaseCompiler {
	
	@Inject
	private JavammModelUtil modelUtil;
	
	@Inject
	private JavammBranchingStatementDetector branchingStatementDetector;
	
	@Override
	protected void doInternalToJavaStatement(XExpression obj,
			ITreeAppendable appendable, boolean isReferenced) {
		if (obj instanceof JavammArrayConstructorCall) {
			_toJavaStatement((JavammArrayConstructorCall) obj, appendable, isReferenced);
		} else if (obj instanceof JavammArrayAccessExpression) {
			_toJavaStatement((JavammArrayAccessExpression) obj, appendable, isReferenced);
		} else if (obj instanceof JavammContinueStatement) {
			_toJavaStatement((JavammContinueStatement) obj, appendable, isReferenced);
		} else {
			super.doInternalToJavaStatement(obj, appendable, isReferenced);
		}
	}
	
	public void _toJavaStatement(JavammArrayConstructorCall call, ITreeAppendable b,
			boolean isReferenced) {
		
	}

	public void _toJavaStatement(JavammArrayAccessExpression access, ITreeAppendable b,
			boolean isReferenced) {
		
	}

	public void _toJavaStatement(JavammContinueStatement st, ITreeAppendable b,
			boolean isReferenced) {
		XBasicForLoopExpression basicForLoop = modelUtil.getContainingForLoop(st);
		
		if (!canCompileToJavaBasicForStatement(basicForLoop, b)) {
			// the for loop is translated into a while statement, so, before
			// the continue; we must perform the update expressions and then
			// check the while condition.
			
			EList<XExpression> updateExpressions = basicForLoop.getUpdateExpressions();
			if (!updateExpressions.isEmpty()) {
				for (XExpression updateExpression : updateExpressions) {
					internalToJavaStatement(updateExpression, b, false);
				}
			}
			
			final String varName = b.getName(basicForLoop);
			
			XExpression expression = basicForLoop.getExpression();
			if (expression != null) {
				internalToJavaStatement(expression, b, true);
				b.newLine().append(varName).append(" = ");
				internalToJavaExpression(expression, b);
				b.append(";");
			} else {
				b.newLine().append("boolean ").append(varName).append(" = true;");
			}
		}
		compileBranchingStatement(st, b);
	}

	private void compileBranchingStatement(JavammBranchingStatement st,
			ITreeAppendable b) {
		b.newLine().append(st.getInstruction()).append(";");
	}

	@Override
	protected void internalToConvertedExpression(XExpression obj, ITreeAppendable appendable) {
		if (obj instanceof JavammArrayConstructorCall) {
			_toJavaExpression((JavammArrayConstructorCall) obj, appendable);
		} else if (obj instanceof JavammArrayAccessExpression) {
			_toJavaExpression((JavammArrayAccessExpression) obj, appendable);
		} else {
			super.internalToConvertedExpression(obj, appendable);
		}
	}

	public void _toJavaExpression(JavammArrayConstructorCall call, ITreeAppendable b) {
		b.append("new ");
		b.append(call.getType());
		compileArrayAccess(call, b);
	}

	public void _toJavaExpression(JavammArrayAccessExpression arrayAccess, ITreeAppendable b) {
		internalToConvertedExpression(arrayAccess.getArray(), b);
		compileArrayAccess(arrayAccess, b);
	}

	@Override
	protected void assignmentToJavaExpression(XAssignment expr, ITreeAppendable b, boolean isExpressionContext) {
		final JvmIdentifiableElement feature = expr.getFeature();
		if (feature instanceof JvmOperation) {
			boolean appendReceiver = appendReceiver(expr, b, isExpressionContext);
			if (appendReceiver)
				b.append(".");
			appendFeatureCall(expr, b);
		} else {
			boolean isArgument = expr.eContainer() instanceof XAbstractFeatureCall;
			if (isArgument) {
				EStructuralFeature containingFeature = expr.eContainingFeature();
				if (containingFeature == XbasePackage.Literals.XFEATURE_CALL__FEATURE_CALL_ARGUMENTS 
						|| containingFeature == XbasePackage.Literals.XMEMBER_FEATURE_CALL__MEMBER_CALL_ARGUMENTS) {
					isArgument = false;
				} else {
					b.append("(");
				}
			}
			if (feature instanceof JvmField) {
				boolean appendReceiver = appendReceiver(expr, b, isExpressionContext);
				if (appendReceiver)
					b.append(".");
				appendFeatureCall(expr, b);
			} else {
				String name = b.getName(expr.getFeature());
				b.append(name);
			}
			
			// custom implementation starts here
			compileArrayAccess(expr, b);
			// custom implementation ends here
			
			b.append(" = ");
			internalToJavaExpression(expr.getValue(), b);
			if (isArgument) {
				b.append(")");
			}
		}
	}

	@Override
	protected void toJavaWhileStatement(XBasicForLoopExpression expr,
			ITreeAppendable b, boolean isReferenced) {
		ITreeAppendable loopAppendable = b.trace(expr);
		
		boolean needBraces = !bracesAreAddedByOuterStructure(expr);
		if (needBraces) {
			loopAppendable.newLine().increaseIndentation().append("{");
			loopAppendable.openPseudoScope();
		}
		
		EList<XExpression> initExpressions = expr.getInitExpressions();
		for (int i = 0; i < initExpressions.size(); i++) {
			XExpression initExpression = initExpressions.get(i);
			
			// custom implementation
			// since a for statement cannot be used as expression we don't need
			// any special treatment for the last expression
			
			internalToJavaStatement(initExpression, loopAppendable, false);
			
		}

		final String varName = loopAppendable.declareSyntheticVariable(expr, "_while");
		
		XExpression expression = expr.getExpression();
		if (expression != null) {
			internalToJavaStatement(expression, loopAppendable, true);
			loopAppendable.newLine().append("boolean ").append(varName).append(" = ");
			internalToJavaExpression(expression, loopAppendable);
			loopAppendable.append(";");
		} else {
			loopAppendable.newLine().append("boolean ").append(varName).append(" = true;");
		}
		loopAppendable.newLine();
		loopAppendable.append("while (");
		loopAppendable.append(varName);
		loopAppendable.append(") {").increaseIndentation();
		loopAppendable.openPseudoScope();
		
		XExpression eachExpression = expr.getEachExpression();
		internalToJavaStatement(eachExpression, loopAppendable, false);
		
		// custom implementation:
		// if the each expression contains sure branching statements then
		// we must not generate the update expression and the check expression
		if (!branchingStatementDetector.isSureBranchStatement(eachExpression) && !isEarlyExit(eachExpression)) {
			EList<XExpression> updateExpressions = expr.getUpdateExpressions();
			
			for (XExpression updateExpression : updateExpressions) {
				internalToJavaStatement(updateExpression, loopAppendable, false);
			}

			if (expression != null) {
				internalToJavaStatement(expression, loopAppendable, true);
				loopAppendable.newLine().append(varName).append(" = ");
				internalToJavaExpression(expression, loopAppendable);
				loopAppendable.append(";");
			} else {
				loopAppendable.newLine().append(varName).append(" = true;");
			}
		}
		
		loopAppendable.closeScope();
		loopAppendable.decreaseIndentation().newLine().append("}");
		
		if (needBraces) {
			loopAppendable.closeScope();
			loopAppendable.decreaseIndentation().newLine().append("}");
		}
	}

	private void compileArrayAccess(XExpression expr, ITreeAppendable b) {
		if (expr instanceof JavammArrayAccess) {
			JavammArrayAccess assignment = (JavammArrayAccess) expr;
			for (XExpression index : assignment.getIndexes()) {
				if (index != null) {
					b.append("[");
					internalToJavaExpression(index, b);
					b.append("]");
				}
			}
		}
	}

}
