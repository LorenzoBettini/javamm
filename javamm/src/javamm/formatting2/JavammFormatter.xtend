/*
 * generated by Xtext
 */
package javamm.formatting2;

import com.google.inject.Inject
import java.util.List
import javamm.javamm.JavammArrayAccessExpression
import javamm.javamm.JavammArrayConstructorCall
import javamm.javamm.JavammBranchingStatement
import javamm.javamm.JavammConditionalExpression
import javamm.javamm.JavammJvmFormalParameter
import javamm.javamm.JavammMethod
import javamm.javamm.JavammPackage
import javamm.javamm.JavammPrefixOperation
import javamm.javamm.JavammProgram
import javamm.javamm.JavammSwitchStatements
import javamm.javamm.JavammXAssignment
import javamm.javamm.JavammXVariableDeclaration
import javamm.javamm.Main
import javamm.util.JavammModelUtil
import org.eclipse.emf.common.util.EList
import org.eclipse.xtext.formatting2.IFormattableDocument
import org.eclipse.xtext.xbase.XCastedExpression
import org.eclipse.xtext.xbase.XClosure
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.XForLoopExpression
import org.eclipse.xtext.xbase.XMemberFeatureCall
import org.eclipse.xtext.xbase.XSwitchExpression
import org.eclipse.xtext.xbase.XSynchronizedExpression
import org.eclipse.xtext.xbase.XThrowExpression
import org.eclipse.xtext.xbase.XTryCatchFinallyExpression
import org.eclipse.xtext.xbase.XTypeLiteral
import org.eclipse.xtext.xbase.XVariableDeclaration
import org.eclipse.xtext.xbase.formatting2.XbaseFormatter

import static org.eclipse.xtext.xbase.XbasePackage.Literals.*
import static org.eclipse.xtext.xbase.formatting2.XbaseFormatterPreferenceKeys.*

class JavammFormatter extends XbaseFormatter {
	
	@Inject extension JavammModelUtil

	def dispatch void format(JavammProgram javammprogram, extension IFormattableDocument document) {
		val importSection = javammprogram.getImportSection()
		if (importSection != null) {
			// to avoid a useless newline at the beginning of the program
			javammprogram.prepend[setNewLines(0, 0, 0); noSpace]
			format(importSection, document);
		} else {
			javammprogram.prepend[setNewLines(0, 0, 1); noSpace]
		}
		for (JavammMethod javammMethod : javammprogram.javammMethods) {
			format(javammMethod, document);
			
			if (javammMethod != javammprogram.javammMethods.last)
				javammMethod.append[setNewLines(2, 2, 2)]
			else
				javammMethod.append[setNewLines(1, 1, 2)]
		}
		format(javammprogram.getMain(), document);
	}

	def dispatch void format(JavammMethod javammmethod, extension IFormattableDocument document) {
		javammmethod.type.prepend[noSpace].append[oneSpace]
		format(javammmethod.type, document);

		javammmethod.regionFor.keyword("(").surround[noSpace]
		if (!javammmethod.params.isEmpty) {
			for (comma : javammmethod.regionFor.keywords(","))
				comma.prepend[noSpace].append[oneSpace]
			for (params : javammmethod.params)
				format(params, document);
			javammmethod.regionFor.keyword(")").prepend[noSpace]
		}
		javammmethod.regionFor.keyword(")").append[oneSpace]

		format(javammmethod.body, document);
	}

	def dispatch void format(JavammJvmFormalParameter javammjvmformalparameter, extension IFormattableDocument document) {
		super._format(javammjvmformalparameter, document);
		javammjvmformalparameter.
			regionFor.feature(JavammPackage.eINSTANCE.javammJvmFormalParameter_Final).
			append[oneSpace]
	}

	def dispatch void format(Main main, extension IFormattableDocument document) {
		formatExpressions(main.expressions, document, false)
	}
	
	def dispatch void format(JavammXVariableDeclaration expr, extension IFormattableDocument document) {
		expr.type.append[oneSpace]
		expr.regionFor.keyword("=").surround[oneSpace]
		expr.type.format(document)
		expr.right.format(document)
		
		for (XVariableDeclaration additionalVariable : expr.getAdditionalVariables()) {
			format(additionalVariable, document);
			additionalVariable.immediatelyPreceding.keyword(",").prepend[noSpace].append[oneSpace]
			additionalVariable.regionFor.keyword("=").surround[oneSpace]
		}

		formatMandatorySemicolon(expr, document)
	}

	def dispatch void format(JavammXAssignment javammxassignment, extension IFormattableDocument document) {
		super._format(javammxassignment, document) 
		formatArrayIndexes(javammxassignment.getIndexes(), document)
	}

	def dispatch void format(JavammConditionalExpression expr, extension IFormattableDocument document) {
		format(expr.getThen(), document);
		format(expr.getElse(), document);
		format(expr.getIf(), document);

		expr.regionFor.keyword("?").surround[oneSpace]
		expr.regionFor.keyword(":").surround[oneSpace]
	}

	def dispatch void format(JavammArrayConstructorCall javammarrayconstructorcall, extension IFormattableDocument document) {
		javammarrayconstructorcall.
			regionFor.feature(JavammPackage.eINSTANCE.javammArrayConstructorCall_Type).
			prepend[oneSpace]
		
		// we must consider the case of a dimension with index expression
		// and without index expression
		for (XExpression index : javammarrayconstructorcall.arrayDimensionIndexAssociations) {
			if (index != null) {
				formatArrayIndex(index, document);
			}
		}
		for (d : javammarrayconstructorcall.dimensions) {
			d.regionFor.feature(JavammPackage.eINSTANCE.javammArrayDimension_OpenBracket).
				prepend[noSpace].append[noSpace]
			d.immediatelyFollowing.keyword("]").prepend[noSpace]
		}
		
		val arrayLiteral = javammarrayconstructorcall.getArrayLiteral()
		if (arrayLiteral != null) {
			format(arrayLiteral, document);
			arrayLiteral.regionFor.keyword("{").prepend[oneSpace]
		}
	}

	override dispatch void format(XCastedExpression xcastedexpression, extension IFormattableDocument document) {
		format(xcastedexpression.getType(), document);
		format(xcastedexpression.getTarget(), document);
		xcastedexpression.regionFor.keyword("(").surround[noSpace]
		xcastedexpression.regionFor.keyword(")").prepend[noSpace].append[oneSpace]
	}

	def dispatch void format(JavammPrefixOperation javammprefixoperation, extension IFormattableDocument document) {
		format(javammprefixoperation.getOperand(), document);
		javammprefixoperation.regionFor.feature(XABSTRACT_FEATURE_CALL__FEATURE).append[noSpace]
	}

	def dispatch void format(JavammArrayAccessExpression expr, extension IFormattableDocument document) {
		format(expr.getArray(), document);
		formatArrayIndexes(expr.indexes, document)
		formatMandatorySemicolon(expr, document)
	}

	def dispatch void format(JavammBranchingStatement expr, extension IFormattableDocument document) {
		expr.regionFor.feature(JavammPackage.eINSTANCE.javammBranchingStatement_Instruction).surround[noSpace]
		formatMandatorySemicolon(expr, document)
	}

	override dispatch void format(XMemberFeatureCall expr, extension IFormattableDocument document) {
		super._format(expr, document)
		formatMandatorySemicolon(expr, document)
	}

	override dispatch void format(XForLoopExpression expr, extension IFormattableDocument format) {
		super._format(expr, format)
		format(expr.declaredParam, format)
	}

//	override dispatch void format(XIfExpression expr, extension IFormattableDocument format) {
//		expr.^if.surround[noSpace]
//		expr.regionFor.keyword("if").append[oneSpace]
//		if (expr.then instanceof XBlockExpression) {
//			expr.then.prepend(bracesInNewLine)
//			if (expr.^else != null)
//				expr.then.append(bracesInNewLine)
//		} else {
//			expr.then.prepend[newLine increaseIndentation]
//			if (expr.^else != null) {
//				expr.then.immediatelyFollowing.keyword(";").append[newLine; decreaseIndentation]
//			} else
//				expr.then.append[decreaseIndentation]
//		}
//		if (expr.^else instanceof XBlockExpression) {
//			expr.^else.prepend(bracesInNewLine)
//		} else if (expr.^else instanceof XIfExpression) {
//			expr.^else.prepend[oneSpace]
//		} else {
//			expr.^else.prepend[newLine increaseIndentation]
//			expr.^else.append[decreaseIndentation]
//		}
//		expr.^if.format(format)
//		expr.then.format(format)
//		if (expr.^else != null)
//			expr.^else.format(format)
//
////		super._format(expr, format)
//		// this is required otherwise there's no space after the if
//		// again, probably due to the way we implement JavammXMemberFeatureCall
//		// (see also JavammHiddenRegionFormattingMerger)
//		expr.regionFor.keyword("if").append[oneSpace; highPriority]
//	}
//
//	override dispatch void format(XDoWhileExpression expr, extension IFormattableDocument format) {
//		expr.regionFor.keyword("while").append(whitespaceBetweenKeywordAndParenthesisML)
//		expr.predicate.prepend[noSpace].append[noSpace]
//		if (expr.body instanceof XBlockExpression) {
//			expr.body.prepend(bracesInNewLine).append(bracesInNewLine)
//		} else {
//			expr.body.immediatelyFollowing.keyword(";").append[newLine; decreaseIndentation]
//		}
//		expr.predicate.format(format)
//		expr.body.format(format)
//		// the following does not seem to work...
//		formatMandatorySemicolon(expr, format)
//	}

	override dispatch void format(XSwitchExpression xswitchexpression, extension IFormattableDocument document) {
		super._format(xswitchexpression, document)
		xswitchexpression.regionFor.keyword("(").append[noSpace]
		xswitchexpression.regionFor.keyword(")").prepend[noSpace]
	}

	def dispatch void format(JavammSwitchStatements expr, extension IFormattableDocument document) {
		formatExpressions(expr.expressions, document, true)
	}

	override createHiddenRegionFormattingMerger() {
		new JavammHiddenRegionFormattingMerger(this)
	}

	override dispatch void format(XClosure expr, extension IFormattableDocument format) {
		
	}

	override dispatch void format(XThrowExpression expr, extension IFormattableDocument format) {
		
	}

	override dispatch void format(XSynchronizedExpression expr, extension IFormattableDocument format) {
		
	}

	override dispatch void format(XTryCatchFinallyExpression expr, extension IFormattableDocument format) {
		
	}

	override dispatch void format(XTypeLiteral expr, extension IFormattableDocument format) {
		
	}

	private def formatExpressions(EList<XExpression> expressions, extension IFormattableDocument document,
			boolean noLineAfterLastExpression
	) {
		val last = expressions.last
		for (child : expressions) {
			child.format(document)
			val sem = child.immediatelyFollowing.keyword(";")

			if (noLineAfterLastExpression && child == last) {
				sem.prepend[noSpace]
			} else {
				if (sem != null)
					sem.prepend[noSpace].append(blankLinesAroundExpression)
				else
					child.append(blankLinesAroundExpression)
			}
		}
	}

	def private void formatArrayIndexes(List<XExpression> indexes, extension IFormattableDocument document) {
		for (XExpression index : indexes) {
			formatArrayIndex(index, document)
		}
	}
	
	private def formatArrayIndex(XExpression index, extension IFormattableDocument document) {
		index.immediatelyPreceding.keyword("[").prepend[noSpace; highPriority].append[noSpace]
		format(index, document);
		index.immediatelyFollowing.keyword("]").prepend[noSpace]
	}

	private def formatMandatorySemicolon(XExpression expr, extension IFormattableDocument document) {
		expr.immediatelyFollowing.keyword(";").prepend[noSpace]
	}
}
