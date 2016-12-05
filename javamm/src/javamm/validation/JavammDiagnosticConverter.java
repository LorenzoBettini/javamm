/**
 * 
 */
package javamm.validation;

import org.eclipse.emf.ecore.resource.Resource.Diagnostic;
import org.eclipse.xtext.diagnostics.Severity;
import org.eclipse.xtext.util.IAcceptor;
import org.eclipse.xtext.util.Wrapper;
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
	public void convertResourceDiagnostic(Diagnostic diagnostic, Severity severity, IAcceptor<Issue> acceptor) {
		final Wrapper<Issue> issueWrapper = Wrapper.forType(Issue.class);
		super.convertResourceDiagnostic(diagnostic, severity, new IAcceptor<Issue>() {
			@Override
			public void accept(Issue t) {
				// save the issue for message convertion
				issueWrapper.set(t);
			}
		});

		String message = diagnostic.getMessage();

		if (message.contains("Cannot use this in a static context")) {
			message = "Java-- does not support 'this'";
		} else if (message.contains("Cannot use super in a static context")) {
			message = "Java-- does not support 'super'";
		}

		IssueImpl issue = (IssueImpl) issueWrapper.get();
		issue.setMessage(message);

		// let the original acceptor accept the issue
		acceptor.accept(issue);
	}
}
