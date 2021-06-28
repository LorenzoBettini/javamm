package javamm.ui.launch;

import java.util.Objects;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.debug.core.DebugPlugin;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.ILaunchConfigurationType;
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy;
import org.eclipse.debug.core.ILaunchManager;
import org.eclipse.debug.ui.RefreshTab;
import org.eclipse.jdt.launching.IJavaLaunchConfigurationConstants;
import org.eclipse.xtext.util.Strings;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.StringExtensions;

public class LaunchConfigurationInfo {
	public static final String LAUNCH_TYPE = "javamm.ui.JavammLaunchConfigurationType";

	private final String project;

	private final String clazz;

	public LaunchConfigurationInfo(final String project, final String clazz) {
		this.project = project;
		this.clazz = clazz;
	}

	public String getProject() {
		return this.project;
	}

	public String getClazz() {
		return this.clazz;
	}

	public String getName() {
		return Strings.lastToken(this.clazz, ".");
	}

	public ILaunchConfiguration createConfiguration() {
		try {
			final ILaunchManager launchManager = DebugPlugin.getDefault().getLaunchManager();
			final ILaunchConfigurationType configType = launchManager
					.getLaunchConfigurationType(LaunchConfigurationInfo.LAUNCH_TYPE);
			ILaunchConfigurationWorkingCopy wc;
				wc = configType.newInstance(null,
						launchManager.generateLaunchConfigurationName(this.getName()));
			wc.setAttribute(IJavaLaunchConfigurationConstants.ATTR_PROJECT_NAME, this.project);
			wc.setAttribute(IJavaLaunchConfigurationConstants.ATTR_MAIN_TYPE_NAME, this.clazz);
			wc.setAttribute(IJavaLaunchConfigurationConstants.ATTR_STOP_IN_MAIN, false);
			wc.setAttribute(RefreshTab.ATTR_REFRESH_SCOPE, "${workspace}");
			wc.setAttribute(RefreshTab.ATTR_REFRESH_RECURSIVE, true);
			return wc.doSave();
		} catch (CoreException e) {
			throw Exceptions.sneakyThrow(e);
		}
	}

	public boolean configEquals(final ILaunchConfiguration a) {
		try {
			return (Objects.equals(a.getAttribute(IJavaLaunchConfigurationConstants.ATTR_MAIN_TYPE_NAME, "X"),
					this.clazz)
					&& Objects.equals(a.getAttribute(IJavaLaunchConfigurationConstants.ATTR_PROJECT_NAME, "X"),
							this.project)
					&& Objects.equals(a.getType().getIdentifier(), LaunchConfigurationInfo.LAUNCH_TYPE));
		} catch (CoreException e) {
			return false;
		}
	}

	public boolean isValid() {
		return !StringExtensions.isNullOrEmpty(this.clazz) && !StringExtensions.isNullOrEmpty(this.project);
	}
}
