/**
 * 
 */
package javamm.validation;

import org.eclipse.emf.ecore.resource.Resource.Diagnostic;
import org.eclipse.xtext.diagnostics.AbstractDiagnostic;
import org.eclipse.xtext.diagnostics.Severity;
import org.eclipse.xtext.resource.XtextSyntaxDiagnostic;
import org.eclipse.xtext.util.IAcceptor;
import org.eclipse.xtext.validation.CheckType;
import org.eclipse.xtext.validation.DiagnosticConverterImpl;
import org.eclipse.xtext.validation.Issue;
import org.eclipse.xtext.validation.Issue.IssueImpl;

/**
 * Customization of errors concerning 'this' and 'super', as suggested here:
 * https://www.eclipse.org/forums/index.php?t=msg&th=1065796&goto=1692742&#msg_1692742
 * 
 * @author Lorenzo Bettini
 *
 */
public class JavammDiagnosticConverter extends DiagnosticConverterImpl {

	@Override
	public void convertResourceDiagnostic(Diagnostic diagnostic,
			Severity severity, IAcceptor<Issue> acceptor) {
		
		String message = diagnostic.getMessage();
		
		if (message.contains("Cannot use this in a static context")) {
			message = "Java-- does not support 'this'";
		} else if (message.contains("Cannot use super in a static context")) {
			message = "Java-- does not support 'super'";
		} else {
			super.convertResourceDiagnostic(diagnostic, severity, acceptor);
			return;
		}

		// this is copied from the base class
		IssueImpl issue = new Issue.IssueImpl();
		issue.setSyntaxError(diagnostic instanceof XtextSyntaxDiagnostic);
		issue.setSeverity(severity);
		issue.setLineNumber(diagnostic.getLine());
		issue.setMessage(message);

		if (diagnostic instanceof org.eclipse.xtext.diagnostics.Diagnostic) {
			org.eclipse.xtext.diagnostics.Diagnostic xtextDiagnostic = (org.eclipse.xtext.diagnostics.Diagnostic) diagnostic;
			issue.setOffset(xtextDiagnostic.getOffset());
			issue.setLength(xtextDiagnostic.getLength());
		}
		if (diagnostic instanceof AbstractDiagnostic) {
			AbstractDiagnostic castedDiagnostic = (AbstractDiagnostic)diagnostic;
			issue.setUriToProblem(castedDiagnostic.getUriToProblem());
			issue.setCode(castedDiagnostic.getCode());
			issue.setData(castedDiagnostic.getData());
		}
		issue.setType(CheckType.FAST);
		acceptor.accept(issue);
	}
}
