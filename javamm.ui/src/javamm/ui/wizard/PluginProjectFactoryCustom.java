/**
 * 
 */
package javamm.ui.wizard;

import java.util.Iterator;

import org.eclipse.core.resources.IProject;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.xtext.ui.util.PluginProjectFactory;

/**
 * Avoids putting plugin.xml in the build.properties, since we won't use
 * that in our projects.
 * 
 * @author Lorenzo Bettini
 *
 */
public class PluginProjectFactoryCustom extends PluginProjectFactory {

	@Override
	protected void createBuildProperties(IProject project, IProgressMonitor progressMonitor) {
		final StringBuilder content = new StringBuilder("source.. = ");
		for (final Iterator<String> iterator = folders.iterator(); iterator.hasNext();) {
			content.append(iterator.next()).append('/');
			if (iterator.hasNext()) {
				content.append(",\\\n");
				//              source.. =
				content.append("          ");
			}
		}
		content.append("\n");
		content.append("bin.includes = META-INF/,\\\n");
		content.append("               .");

		createFile("build.properties", project, content.toString(), progressMonitor);
	}
}
