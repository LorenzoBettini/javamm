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
import javamm.javamm.JavammXAssignment
import javamm.javamm.JavammXMemberFeatureCall
import javamm.javamm.JavammXVariableDeclaration
import javamm.javamm.Main
import javamm.util.JavammModelUtil
import org.eclipse.xtext.formatting2.IFormattableDocument
import org.eclipse.xtext.xbase.XBlockExpression
import org.eclipse.xtext.xbase.XCastedExpression
import org.eclipse.xtext.xbase.XDoWhileExpression
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.XForLoopExpression
import org.eclipse.xtext.xbase.XIfExpression
import org.eclipse.xtext.xbase.XMemberFeatureCall
import org.eclipse.xtext.xbase.XPostfixOperation
import org.eclipse.xtext.xbase.XSwitchExpression
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

		javammmethod.regionForKeyword("(").surround[noSpace]
		if (!javammmethod.params.isEmpty) {
			for (comma : javammmethod.regionsForKeywords(","))
				comma.prepend[noSpace].append[oneSpace]
			for (params : javammmethod.params)
				format(params, document);
			javammmethod.regionForKeyword(")").prepend[noSpace]
		}
		javammmethod.regionForKeyword(")").append[oneSpace]

		format(javammmethod.body, document);
	}

	def dispatch void format(JavammJvmFormalParameter javammjvmformalparameter, extension IFormattableDocument document) {
		super._format(javammjvmformalparameter, document);
		javammjvmformalparameter.
			regionForFeature(JavammPackage.eINSTANCE.javammJvmFormalParameter_Final).
			append[oneSpace]
	}

	def dispatch void format(Main main, extension IFormattableDocument document) {
		for (child : main.expressions) {
			child.format(document)
			val sem = child.immediatelyFollowingKeyword(";")
			if (sem != null)
				sem.prepend[noSpace].append(blankLinesAroundExpression)
			else
				child.append(blankLinesAroundExpression)
		}
	}

	def dispatch void format(JavammXVariableDeclaration expr, extension IFormattableDocument document) {
		expr.type.append[oneSpace]
		expr.regionForKeyword("=").surround[oneSpace]
		expr.type.format(document)
		expr.right.format(document)
		
		for (XVariableDeclaration additionalVariable : expr.getAdditionalVariables()) {
			format(additionalVariable, document);
			additionalVariable.immediatelyPrecedingKeyword(",").prepend[noSpace].append[oneSpace]
			additionalVariable.regionForKeyword("=").surround[oneSpace]
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

		expr.regionForKeyword("?").surround[oneSpace]
		expr.regionForKeyword(":").surround[oneSpace]
	}

	def dispatch void format(JavammArrayConstructorCall javammarrayconstructorcall, extension IFormattableDocument document) {
		javammarrayconstructorcall.
			regionForFeature(JavammPackage.eINSTANCE.javammArrayConstructorCall_Type).
			prepend[oneSpace]
		
		// we must consider the case of a dimension with index expression
		// and without index expression
		for (XExpression index : javammarrayconstructorcall.arrayDimensionIndexAssociations) {
			if (index != null) {
				formatArrayIndex(index, document);
			}
		}
		for (d : javammarrayconstructorcall.dimensions) {
			d.regionForFeature(JavammPackage.eINSTANCE.javammArrayDimension_OpenBracket).
				prepend[noSpace].append[noSpace]
			d.immediatelyFollowingKeyword("]").prepend[noSpace]
		}
		
		val arrayLiteral = javammarrayconstructorcall.getArrayLiteral()
		if (arrayLiteral != null) {
			format(arrayLiteral, document);
			arrayLiteral.regionForKeyword("{").prepend[oneSpace]
		}
	}

	def dispatch void format(XCastedExpression xcastedexpression, extension IFormattableDocument document) {
		format(xcastedexpression.getType(), document);
		format(xcastedexpression.getTarget(), document);
		xcastedexpression.regionForKeyword("(").surround[noSpace]
		xcastedexpression.regionForKeyword(")").prepend[noSpace].append[oneSpace]
	}

	def dispatch void format(JavammPrefixOperation javammprefixoperation, extension IFormattableDocument document) {
		format(javammprefixoperation.getOperand(), document);
		javammprefixoperation.regionForFeature(XABSTRACT_FEATURE_CALL__FEATURE).append[noSpace]
	}

	def dispatch void format(XPostfixOperation xpostfixoperation, extension IFormattableDocument document) {
		format(xpostfixoperation.getOperand(), document);
		xpostfixoperation.regionForFeature(XABSTRACT_FEATURE_CALL__FEATURE).prepend[noSpace]
	}

	def dispatch void format(JavammArrayAccessExpression expr, extension IFormattableDocument document) {
		format(expr.getArray(), document);
		formatArrayIndexes(expr.indexes, document)
		formatMandatorySemicolon(expr, document)
	}

	def dispatch void format(JavammXMemberFeatureCall expr, extension IFormattableDocument document) {
		super._format(expr, document)
		formatMandatorySemicolon(expr, document)
	}

	def dispatch void format(JavammBranchingStatement expr, extension IFormattableDocument document) {
		expr.regionForFeature(JavammPackage.eINSTANCE.javammBranchingStatement_Instruction).surround[noSpace]
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

	override dispatch void format(XIfExpression expr, extension IFormattableDocument format) {
		expr.^if.surround[noSpace]
		expr.regionForKeyword("if").append[oneSpace]
		if (expr.then instanceof XBlockExpression) {
			expr.then.prepend(bracesInNewLine)
			if (expr.^else != null)
				expr.then.append(bracesInNewLine)
		} else {
			expr.then.prepend[newLine increaseIndentation]
			if (expr.^else != null) {
				expr.then.immediatelyFollowingKeyword(";").append[newLine; decreaseIndentation]
			} else
				expr.then.append[decreaseIndentation]
		}
		if (expr.^else instanceof XBlockExpression) {
			expr.^else.prepend(bracesInNewLine)
		} else if (expr.^else instanceof XIfExpression) {
			expr.^else.prepend[oneSpace]
		} else {
			expr.^else.prepend[newLine increaseIndentation]
			expr.^else.append[decreaseIndentation]
		}
		expr.^if.format(format)
		expr.then.format(format)
		if (expr.^else != null)
			expr.^else.format(format)

//		super._format(expr, format)
		// this is required otherwise there's no space after the if
		// again, probably due to the way we implement JavammXMemberFeatureCall
		// (see also JavammHiddenRegionFormattingMerger)
		expr.regionForKeyword("if").append[oneSpace; highPriority]
	}

	override dispatch void format(XDoWhileExpression expr, extension IFormattableDocument format) {
		expr.regionForKeyword("while").append(whitespaceBetweenKeywordAndParenthesisML)
		expr.predicate.prepend[noSpace].append[noSpace]
		if (expr.body instanceof XBlockExpression) {
			expr.body.prepend(bracesInNewLine).append(bracesInNewLine)
		} else {
			expr.body.immediatelyFollowingKeyword(";").append[newLine; decreaseIndentation]
		}
		expr.predicate.format(format)
		expr.body.format(format)
		// the following does not seem to work...
		formatMandatorySemicolon(expr, format)
	}

	override dispatch void format(XSwitchExpression xswitchexpression, extension IFormattableDocument document) {
		super._format(xswitchexpression, document)
		xswitchexpression.regionForKeyword("(").append[noSpace]
		xswitchexpression.regionForKeyword(")").prepend[noSpace]
	}

	override createHiddenRegionFormattingMerger() {
		new JavammHiddenRegionFormattingMerger(this)
	}

	def private void formatArrayIndexes(List<XExpression> indexes, extension IFormattableDocument document) {
		for (XExpression index : indexes) {
			formatArrayIndex(index, document)
		}
	}
	
	private def formatArrayIndex(XExpression index, extension IFormattableDocument document) {
		index.immediatelyPrecedingKeyword("[").prepend[noSpace; highPriority].append[noSpace]
		format(index, document);
		index.immediatelyFollowingKeyword("]").prepend[noSpace]
	}

	private def formatMandatorySemicolon(XExpression expr, extension IFormattableDocument document) {
		expr.immediatelyFollowingKeyword(";").prepend[noSpace]
	}
}
