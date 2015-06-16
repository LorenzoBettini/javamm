/*
 * generated by Xtext
 */
package javamm.formatting2;

import java.util.List
import javamm.javamm.JavammArrayAccessExpression
import javamm.javamm.JavammArrayConstructorCall
import javamm.javamm.JavammArrayDimension
import javamm.javamm.JavammArrayLiteral
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
import org.eclipse.xtext.formatting2.IFormattableDocument
import org.eclipse.xtext.xbase.XBasicForLoopExpression
import org.eclipse.xtext.xbase.XCasePart
import org.eclipse.xtext.xbase.XCastedExpression
import org.eclipse.xtext.xbase.XDoWhileExpression
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.XIfExpression
import org.eclipse.xtext.xbase.XPostfixOperation
import org.eclipse.xtext.xbase.XSwitchExpression
import org.eclipse.xtext.xbase.XVariableDeclaration
import org.eclipse.xtext.xbase.XWhileExpression
import org.eclipse.xtext.xbase.formatting2.XbaseFormatter

import static org.eclipse.xtext.xbase.XbasePackage.Literals.*
import static org.eclipse.xtext.xbase.formatting2.XbaseFormatterPreferenceKeys.*

class JavammFormatter extends XbaseFormatter {
	
//	@Inject extension JavammGrammarAccess

	def dispatch void format(JavammProgram javammprogram, extension IFormattableDocument document) {
		javammprogram.prepend[setNewLines(0, 0, 0); noSpace]
		format(javammprogram.getImportSection(), document);
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
	}

	def dispatch void format(JavammXAssignment javammxassignment, extension IFormattableDocument document) {
		super._format(javammxassignment, document) 
		formatArrayIndexes(javammxassignment.getIndexes(), document)
	}

	def dispatch void format(JavammConditionalExpression javammconditionalexpression, extension IFormattableDocument document) {
		format(javammconditionalexpression.getThen(), document);
		format(javammconditionalexpression.getElse(), document);
		format(javammconditionalexpression.getIf(), document);
		
		javammconditionalexpression.regionForKeyword("?").surround[oneSpace]
		javammconditionalexpression.regionForKeyword(":").surround[oneSpace]
	}

	def dispatch void format(JavammArrayConstructorCall javammarrayconstructorcall, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
		for (JavammArrayDimension dimensions : javammarrayconstructorcall.getDimensions()) {
			format(dimensions, document);
		}
		for (XExpression indexes : javammarrayconstructorcall.getIndexes()) {
			format(indexes, document);
		}
		format(javammarrayconstructorcall.getArrayLiteral(), document);
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

	def dispatch void format(JavammArrayAccessExpression javammarrayaccessexpression, extension IFormattableDocument document) {
		format(javammarrayaccessexpression.getArray(), document);
		formatArrayIndexes(javammarrayaccessexpression.indexes, document)
	}

	def dispatch void format(JavammXMemberFeatureCall javammxmemberfeaturecall, extension IFormattableDocument document) {
		super._format(javammxmemberfeaturecall, document) 
		formatArrayIndexes(javammxmemberfeaturecall.getIndexes(), document)
	}

//	override dispatch void format(XMemberFeatureCall xmemberfeaturecall, extension IFormattableDocument document) {
//		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
//		for (XExpression memberCallArguments : xmemberfeaturecall.getMemberCallArguments()) {
//			format(memberCallArguments, document);
//		}
//		format(xmemberfeaturecall.getMemberCallTarget(), document);
//	}

	override dispatch void format(XBasicForLoopExpression xbasicforloopexpression, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
		for (XExpression initExpressions : xbasicforloopexpression.getInitExpressions()) {
			format(initExpressions, document);
		}
		format(xbasicforloopexpression.getExpression(), document);
		for (XExpression updateExpressions : xbasicforloopexpression.getUpdateExpressions()) {
			format(updateExpressions, document);
		}
		format(xbasicforloopexpression.getEachExpression(), document);
	}

	override dispatch void format(XIfExpression xifexpression, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
		format(xifexpression.getIf(), document);
		format(xifexpression.getThen(), document);
		format(xifexpression.getElse(), document);
	}

	override dispatch void format(XWhileExpression xwhileexpression, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
		format(xwhileexpression.getPredicate(), document);
		format(xwhileexpression.getBody(), document);
	}

	override dispatch void format(XDoWhileExpression xdowhileexpression, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
		format(xdowhileexpression.getBody(), document);
		format(xdowhileexpression.getPredicate(), document);
	}

	override dispatch void format(XSwitchExpression xswitchexpression, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
		format(xswitchexpression.getSwitch(), document);
		for (XCasePart cases : xswitchexpression.getCases()) {
			format(cases, document);
		}
		format(xswitchexpression.getDefault(), document);
	}

//	override dispatch void format(XCasePart xcasepart, extension IFormattableDocument document) {
//		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
//		format(xcasepart.getCase(), document);
//		format(xcasepart.getThen(), document);
//	}

	def dispatch void format(JavammArrayLiteral javammarrayliteral, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
		for (XExpression elements : javammarrayliteral.getElements()) {
			format(elements, document);
		}
	}

	def private void formatArrayIndexes(List<XExpression> indexes, extension IFormattableDocument document) {
		for (XExpression index : indexes) {
			index.immediatelyPrecedingKeyword("[").prepend[noSpace].append[noSpace]
			format(index, document);
			index.immediatelyFollowingKeyword("]").prepend[noSpace]
		}
	}
}
