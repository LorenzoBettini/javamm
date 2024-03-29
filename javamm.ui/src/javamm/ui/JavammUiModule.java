/**
 * generated by Xtext
 */
package javamm.ui;

import org.eclipse.ui.plugin.AbstractUIPlugin;
import org.eclipse.xtext.ui.editor.syntaxcoloring.AbstractAntlrTokenToAttributeIdMapper;
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfiguration;
import org.eclipse.xtext.ui.util.PluginProjectFactory;
import org.eclipse.xtext.ui.wizard.IProjectCreator;

import javamm.ui.syntaxcoloring.JavammHighlightingConfiguration;
import javamm.ui.syntaxcoloring.JavammTokenToAttributeIdMapper;
import javamm.ui.wizard.JavammProjectCreatorCustom;
import javamm.ui.wizard.PluginProjectFactoryCustom;

/**
 * Use this class to register components to be used within the IDE.
 */
public class JavammUiModule extends AbstractJavammUiModule {
	public JavammUiModule(final AbstractUIPlugin plugin) {
		super(plugin);
	}

	@Override
	public Class<? extends IProjectCreator> bindIProjectCreator() {
		return JavammProjectCreatorCustom.class;
	}

	public Class<? extends PluginProjectFactory> bindPluginProjectFactory() {
		return PluginProjectFactoryCustom.class;
	}

	@Override
	public Class<? extends IHighlightingConfiguration> bindIHighlightingConfiguration() {
		return JavammHighlightingConfiguration.class;
	}

	@Override
	public Class<? extends AbstractAntlrTokenToAttributeIdMapper> bindAbstractAntlrTokenToAttributeIdMapper() {
		return JavammTokenToAttributeIdMapper.class;
	}
}
