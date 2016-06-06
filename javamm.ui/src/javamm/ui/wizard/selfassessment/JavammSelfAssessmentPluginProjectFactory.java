/**
 * 
 */
package javamm.ui.wizard.selfassessment;

import java.util.List;

import javamm.ui.wizard.PluginProjectFactoryCustom;

/**
 * Custom factory for Self-assessment projects creation.
 * 
 * @author Lorenzo Bettini
 *
 */
public class JavammSelfAssessmentPluginProjectFactory extends PluginProjectFactoryCustom {

	public List<String> getFolders() {
		return folders;
	}

}
