/**
 * 
 */
package javamm.ui.syntaxcoloring;

import org.eclipse.xtext.ui.editor.syntaxcoloring.DefaultAntlrTokenToAttributeIdMapper;

/**
 * Highlighting for char literals.
 * 
 * @author Lorenzo Bettini
 *
 */
public class JavammTokenToAttributeIdMapper extends
		DefaultAntlrTokenToAttributeIdMapper {

	@Override
	protected String calculateId(String tokenName, int tokenType) {
		if("RULE_CHARACTER".equals(tokenName)) {
			return JavammHighlightingConfiguration.CHAR_ID;
		}
		return super.calculateId(tokenName, tokenType);
	}
}
