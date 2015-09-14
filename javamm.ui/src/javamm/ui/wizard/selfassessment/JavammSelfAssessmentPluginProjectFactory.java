/**
 * 
 */
package javamm.ui.wizard.selfassessment;

import java.util.Iterator;
import java.util.List;

import org.eclipse.core.resources.IProject;
import org.eclipse.core.runtime.IProgressMonitor;

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

	@Override
	protected void createBuildProperties(IProject project, IProgressMonitor progressMonitor) {
		createBuildProperties(project, getContentsForBuildProperties().toString(), progressMonitor);
	}

	public void createBuildProperties(IProject project, String contents, IProgressMonitor progressMonitor) {
		createFile("build.properties", project, contents, progressMonitor);
	}

	public StringBuilder getContentsForBuildProperties() {
		final StringBuilder content = new StringBuilder("source.. = ");
		for (final Iterator<String> iterator = folders.iterator(); iterator.hasNext();) {
			content.append(iterator.next()).append('/');
			if (iterator.hasNext()) {
				content.append(",\\\n");
				// source.. =
				content.append("          ");
			}
		}
		content.append("\n");
		content.append("bin.includes = META-INF/,\\\n");
		content.append("               .");
		return content;
	}

}
