/**
 * 
 */
package javamm.validation;

import static org.eclipse.xtext.validation.IssueCodes.COPY_JAVA_PROBLEMS;

import org.eclipse.xtext.preferences.PreferenceKey;
import org.eclipse.xtext.util.IAcceptor;
import org.eclipse.xtext.validation.SeverityConverter;
import org.eclipse.xtext.xbase.validation.XbaseConfigurableIssueCodes;

/**
 * Retrieve possible errors in the generated Java code.
 * 
 * @author Lorenzo Bettini
 *
 */
public class JavammConfigurableIssueCodes extends XbaseConfigurableIssueCodes {

	@Override
	protected void initialize(IAcceptor<PreferenceKey> iAcceptor) {
		super.initialize(iAcceptor);
		// overwrite xbase default
		iAcceptor.accept(create(COPY_JAVA_PROBLEMS,
				SeverityConverter.SEVERITY_ERROR));
	}
}
