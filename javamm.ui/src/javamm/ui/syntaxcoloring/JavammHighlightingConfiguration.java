/**
 * 
 */
package javamm.ui.syntaxcoloring;

import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfigurationAcceptor;
import org.eclipse.xtext.xbase.ui.highlighting.XbaseHighlightingConfiguration;

/**
 * Highlighting configuration for char literals.
 * 
 * @author Lorenzo Bettini
 *
 */
public class JavammHighlightingConfiguration extends
		XbaseHighlightingConfiguration {

	public static final String CHAR_ID = "char";
	
	@Override
	public void configure(IHighlightingConfigurationAcceptor acceptor) {
		acceptor.acceptDefaultHighlighting(CHAR_ID, "Character", stringTextStyle());

		super.configure(acceptor);
	}
}
