/**
 * 
 */
package javamm.compiler;

import javamm.controlflow.JavammBranchingStatementDetector;
import javamm.javamm.JavammArrayAccess;
import javamm.javamm.JavammArrayAccessExpression;
import javamm.javamm.JavammArrayConstructorCall;
import javamm.javamm.JavammArrayLiteral;
import javamm.javamm.JavammBranchingStatement;
import javamm.javamm.JavammBreakStatement;
import javamm.javamm.JavammCharLiteral;
import javamm.javamm.JavammContinueStatement;
import javamm.javamm.JavammPrefixOperation;
import javamm.javamm.JavammXVariableDeclaration;
import javamm.util.JavammModelUtil;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.xtext.common.types.JvmField;
import org.eclipse.xtext.common.types.JvmIdentifiableElement;
import org.eclipse.xtext.common.types.JvmOperation;
import org.eclipse.xtext.generator.trace.ILocationData;
import org.eclipse.xtext.util.Strings;
import org.eclipse.xtext.xbase.XAbstractFeatureCall;
import org.eclipse.xtext.xbase.XAssignment;
import org.eclipse.xtext.xbase.XBasicForLoopExpression;
import org.eclipse.xtext.xbase.XCasePart;
import org.eclipse.xtext.xbase.XExpression;
import org.eclipse.xtext.xbase.XSwitchExpression;
import org.eclipse.xtext.xbase.XVariableDeclaration;
import org.eclipse.xtext.xbase.XbasePackage;
import org.eclipse.xtext.xbase.compiler.XbaseCompiler;
import org.eclipse.xtext.xbase.compiler.output.ITreeAppendable;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.typesystem.references.LightweightTypeReference;

import com.google.inject.Inject;

/**
 * @author Lorenzo Bettini
 *
 */
public class JavammXbaseCompiler extends XbaseCompiler {
	
	private static final String ASSIGNED_TRUE = " = true;";

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
		} else if (obj instanceof JavammBreakStatement) {
			_toJavaStatement((JavammBreakStatement) obj, appendable, isReferenced);
		} else {
			super.doInternalToJavaStatement(obj, appendable, isReferenced);
		}
	}
	
	public void _toJavaStatement(JavammArrayConstructorCall call, ITreeAppendable b,
			boolean isReferenced) {
		// compile it only as expression
	}

	public void _toJavaStatement(JavammArrayAccessExpression access, ITreeAppendable b,
			boolean isReferenced) {
		// compile it only as expression
	}

	public void _toJavaStatement(JavammContinueStatement st, ITreeAppendable b,
			boolean isReferenced) {
		XBasicForLoopExpression basicForLoop = modelUtil.getContainingForLoop(st);
		
		if (basicForLoop != null && !canCompileToJavaBasicForStatement(basicForLoop, b)) {
			// the for loop is translated into a while statement, so, before
			// the continue; we must perform the update expressions and then
			// check the while condition.
			
			EList<XExpression> updateExpressions = basicForLoop.getUpdateExpressions();
			for (XExpression updateExpression : updateExpressions) {
				internalToJavaStatement(updateExpression, b, false);
			}
			
			final String varName = b.getName(basicForLoop);
			
			XExpression expression = basicForLoop.getExpression();
			if (expression != null) {
				internalToJavaStatement(expression, b, true);
				b.newLine().append(varName).append(" = ");
				internalToJavaExpression(expression, b);
				b.append(";");
			} else {
				b.newLine().append(varName).append(ASSIGNED_TRUE);
			}
		}
		compileBranchingStatement(st, b);
	}

	public void _toJavaStatement(JavammBreakStatement st, ITreeAppendable b,
			boolean isReferenced) {
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
		} else if (obj instanceof JavammCharLiteral) {
			_toJavaExpression((JavammCharLiteral) obj, appendable);
		} else {
			super.internalToConvertedExpression(obj, appendable);
		}
	}

	public void _toJavaExpression(JavammArrayConstructorCall call, ITreeAppendable b) {
		if (call.getArrayLiteral() == null) {
			// otherwise we simply compile the array literal
			// assuming that no dimension expression has been specified
			// (checked by the validator)
			b.append("new ");
			b.append(call.getType());
		}
		compileArrayAccess(call, b);
	}

	public void _toJavaExpression(JavammArrayAccessExpression arrayAccess, ITreeAppendable b) {
		internalToConvertedExpression(arrayAccess.getArray(), b);
		compileArrayAccess(arrayAccess, b);
	}

	/**
	 * Always compile into a char literal (we've already type checked that, and we
	 * can assign it also to numeric variables as in Java).
	 * 
	 * @param literal
	 * @param appendable
	 */
	public void _toJavaExpression(JavammCharLiteral literal, ITreeAppendable appendable) {
		String javaString = Strings.convertToJavaString(literal.getValue(), true);
		appendable.append("'").append(javaString).append("'");
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

	/**
	 * Overridden to deal with several variable declarations.
	 * 
	 * @see org.eclipse.xtext.xbase.compiler.XbaseCompiler#toJavaBasicForStatement(org.eclipse.xtext.xbase.XBasicForLoopExpression, org.eclipse.xtext.xbase.compiler.output.ITreeAppendable, boolean)
	 */
	@Override
	protected void toJavaBasicForStatement(XBasicForLoopExpression expr,
			ITreeAppendable b, boolean isReferenced) {
		ITreeAppendable loopAppendable = b.trace(expr);
		loopAppendable.openPseudoScope();
		loopAppendable.newLine().append("for (");
		
		EList<XExpression> initExpressions = expr.getInitExpressions();
		XExpression firstInitExpression = IterableExtensions.head(initExpressions);
		if (firstInitExpression instanceof JavammXVariableDeclaration) {
			JavammXVariableDeclaration variableDeclaration = (JavammXVariableDeclaration) firstInitExpression;
			LightweightTypeReference type = appendVariableTypeAndName(variableDeclaration, loopAppendable);
			loopAppendable.append(" = ");
			if (variableDeclaration.getRight() != null) {
				compileAsJavaExpression(variableDeclaration.getRight(), loopAppendable, type);
			} else {
				appendDefaultLiteral(loopAppendable, type);
			}
			
			// custom implementation since possible additional declarations are contained (i.e., parsed)
			// in JavamXVariableDeclaration
			EList<XVariableDeclaration> additionalVariables = variableDeclaration.getAdditionalVariables();
			for (int i = 0; i < additionalVariables.size(); i++) {
				loopAppendable.append(", ");
				XVariableDeclaration initExpression = additionalVariables.get(i);
				loopAppendable.append(loopAppendable.declareVariable(initExpression, makeJavaIdentifier(initExpression.getName())));
				loopAppendable.append(" = ");
				if (initExpression.getRight() != null) {
					compileAsJavaExpression(initExpression.getRight(), loopAppendable, type);
				} else {
					appendDefaultLiteral(loopAppendable, type);
				}
			}
		} else {
			for (int i = 0; i < initExpressions.size(); i++) {
				if (i != 0) {
					loopAppendable.append(", ");
				}
				XExpression initExpression = initExpressions.get(i);
				compileAsJavaExpression(initExpression, loopAppendable, getLightweightType(initExpression));
			}
		}
		
		loopAppendable.append(";");
		
		XExpression expression = expr.getExpression();
		if (expression != null) {
			loopAppendable.append(" ");
			internalToJavaExpression(expression, loopAppendable);
		}
		loopAppendable.append(";");
		
		EList<XExpression> updateExpressions = expr.getUpdateExpressions();
		for (int i = 0; i < updateExpressions.size(); i++) {
			if (i != 0) {
				loopAppendable.append(",");
			}
			loopAppendable.append(" ");
			XExpression updateExpression = updateExpressions.get(i);
			internalToJavaExpression(updateExpression, loopAppendable);
		}
		loopAppendable.append(") {").increaseIndentation();
		
		XExpression eachExpression = expr.getEachExpression();
		internalToJavaStatement(eachExpression, loopAppendable, false);
		
		loopAppendable.decreaseIndentation().newLine().append("}");
		loopAppendable.closeScope();
	}

	/**
	 * Overridden to deal with branching instructions.
	 * 
	 * @see org.eclipse.xtext.xbase.compiler.XbaseCompiler#toJavaWhileStatement(org.eclipse.xtext.xbase.XBasicForLoopExpression, org.eclipse.xtext.xbase.compiler.output.ITreeAppendable, boolean)
	 */
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
			loopAppendable.newLine().append("boolean ").append(varName).append(ASSIGNED_TRUE);
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
				loopAppendable.newLine().append(varName).append(ASSIGNED_TRUE);
			}
		}
		
		loopAppendable.closeScope();
		loopAppendable.decreaseIndentation().newLine().append("}");
		
		if (needBraces) {
			loopAppendable.closeScope();
			loopAppendable.decreaseIndentation().newLine().append("}");
		}
	}

	/**
	 * In our Javamm switch statement we can always compile into Java switch.
	 * 
	 * @see org.eclipse.xtext.xbase.compiler.XbaseCompiler#_toJavaStatement(org.eclipse.xtext.xbase.XSwitchExpression, org.eclipse.xtext.xbase.compiler.output.ITreeAppendable, boolean)
	 */
	@Override
	protected void _toJavaStatement(XSwitchExpression expr, ITreeAppendable b, boolean isReferenced) {
		_toJavaSwitchStatement(expr, b, isReferenced);
	}

	/**
	 * Since we want Java switch statement, the compilation is simpler and does
	 * not append break automatically.
	 * 
	 * @see org.eclipse.xtext.xbase.compiler.XbaseCompiler#_toJavaSwitchStatement(org.eclipse.xtext.xbase.XSwitchExpression, org.eclipse.xtext.xbase.compiler.output.ITreeAppendable, boolean)
	 */
	@Override
	protected void _toJavaSwitchStatement(XSwitchExpression expr, ITreeAppendable b, boolean isReferenced) {
		final String switchResultName = declareSwitchResultVariable(expr, b, isReferenced);
		internalToJavaStatement(expr.getSwitch(), b, true);
		final String variableName = declareLocalVariable(expr, b);
		
		b.newLine().append("switch (").append(variableName).append(") {").increaseIndentation();
		for (XCasePart casePart : expr.getCases()) {
			ITreeAppendable caseAppendable = b.trace(casePart, true);
			caseAppendable.newLine().increaseIndentation().append("case ");
			
			ITreeAppendable conditionAppendable = caseAppendable.trace(casePart.getCase(), true);
			internalToJavaExpression(casePart.getCase(), conditionAppendable);
			
			caseAppendable.append(":");
			XExpression then = casePart.getThen();
			if (then != null) {
				executeThenPart(expr, switchResultName, then, caseAppendable, isReferenced);
			}
			caseAppendable.decreaseIndentation();
		}
		if (expr.getDefault() != null) {
			ILocationData location = getLocationOfDefault(expr);
			ITreeAppendable defaultAppendable = location != null ? b.trace(location) : b;
			
			defaultAppendable.newLine().increaseIndentation().append("default:");

			if (expr.getDefault() != null) {
				defaultAppendable.openPseudoScope();
				executeThenPart(expr, switchResultName, expr.getDefault(), defaultAppendable, isReferenced);
				defaultAppendable.closeScope();
			}

			defaultAppendable.decreaseIndentation();
		}
		b.decreaseIndentation().newLine().append("}");
	}

	@Override
	protected void _toJavaStatement(XVariableDeclaration varDeclaration,
			ITreeAppendable b, boolean isReferenced) {
		super._toJavaStatement(varDeclaration, b, isReferenced);
		
		if (varDeclaration instanceof JavammXVariableDeclaration) {
			JavammXVariableDeclaration customVar = (JavammXVariableDeclaration) varDeclaration;
			for (XVariableDeclaration additional : customVar.getAdditionalVariables()) {
				_toJavaStatement(additional, b, isReferenced);
			}
		}
	}

	/**
	 * Specialized for prefix operator
	 * 
	 * @see org.eclipse.xtext.xbase.compiler.FeatureCallCompiler#featureCalltoJavaExpression(org.eclipse.xtext.xbase.XAbstractFeatureCall, org.eclipse.xtext.xbase.compiler.output.ITreeAppendable, boolean)
	 */
	@Override
	protected void featureCalltoJavaExpression(XAbstractFeatureCall call,
			ITreeAppendable b, boolean isExpressionContext) {
		if (call instanceof JavammPrefixOperation) {
			// we can't simply retrieve the inline annotations as it is done
			// for postfix operations, since postfix operations are already mapped to
			// postfix methods operator_plusPlus and operator_minusMinus
			JvmIdentifiableElement feature = call.getFeature();
			if (feature.getSimpleName().endsWith("plusPlus")) {
				b.append("++");
			} else {
				// the only other possibility is minus minus
				b.append("--");
			}
			
			appendArgument(((JavammPrefixOperation) call).getOperand(), b);
			
			return;
		}
		
		super.featureCalltoJavaExpression(call, b, isExpressionContext);
	}

	private void compileArrayAccess(XExpression expr, ITreeAppendable b) {
		if (expr instanceof JavammArrayAccess) {
			JavammArrayAccess access = (JavammArrayAccess) expr;
			for (XExpression index : access.getIndexes()) {
				if (index != null) {
					b.append("[");
					internalToJavaExpression(index, b);
					b.append("]");
				}
			}
		}
	}

	/**
	 * Specialization for {@link JavammArrayConstructorCall} since it can
	 * have dimensions without dimension expression (index).
	 * 
	 * @param cons
	 * @param b
	 */
	private void compileArrayAccess(JavammArrayConstructorCall cons, ITreeAppendable b) {
		JavammArrayLiteral arrayLiteral = cons.getArrayLiteral();

		if (arrayLiteral != null) {
			internalToJavaExpression(arrayLiteral, b);
		} else {
			Iterable<XExpression> dimensionsAndIndexes = modelUtil.arrayDimensionIndexAssociations(cons);
			
			for (XExpression e : dimensionsAndIndexes) {
				b.append("[");
				if (e != null) {
					internalToJavaExpression(e, b);
				}
				b.append("]");
			}
		}
	}

}
