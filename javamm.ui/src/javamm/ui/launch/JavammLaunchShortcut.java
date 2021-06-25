package javamm.ui.launch;

import static com.google.common.collect.Iterables.filter;
import static org.eclipse.xtext.xbase.lib.IterableExtensions.head;

import java.util.stream.Stream;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.debug.core.DebugPlugin;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.ui.DebugUITools;
import org.eclipse.debug.ui.ILaunchShortcut;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.ui.IEditorInput;
import org.eclipse.ui.IEditorPart;
import org.eclipse.ui.IFileEditorInput;
import org.eclipse.xtext.common.types.JvmDeclaredType;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.ui.editor.XbaseEditor;

public class JavammLaunchShortcut implements ILaunchShortcut {
	@Override
	public void launch(final ISelection selection, final String mode) {
		final IFile file = (IFile) ((IStructuredSelection) selection).getFirstElement();
		final String name = file.getName();
		final String clazz = "javamm." + name.substring(0, name.lastIndexOf("."));
		this.launch(mode, new LaunchConfigurationInfo(file.getProject().getName(), clazz));
	}

	@Override
	public void launch(final IEditorPart editor, final String mode) {
		if (editor instanceof XbaseEditor) {
			final IEditorInput editorInput = ((XbaseEditor) editor).getEditorInput();
			if (editorInput instanceof IFileEditorInput) {
				final String project = ((IFileEditorInput) editorInput).getFile().getProject().getName();
				final LaunchConfigurationInfo info = ((XbaseEditor) editor).getDocument()
						.readOnly(it -> {
							final JvmDeclaredType file = head(
									filter(it.getContents(), JvmDeclaredType.class));
							String identifier = null;
							if (file != null) {
								identifier = file.getIdentifier();
							}
							return new LaunchConfigurationInfo(project, identifier);
						});
				this.launch(mode, info);
				return;
			}
		}
		MessageDialog.openError(null, "Wrong editor kind.", "");
	}

	public void launch(final String mode, final LaunchConfigurationInfo info) {
		try {
			ILaunchConfiguration[] configs = DebugPlugin.getDefault().getLaunchManager()
					.getLaunchConfigurations();
			ILaunchConfiguration launchConfiguration = Stream.of(configs)
					.filter(info::configEquals)
					.findFirst()
					.orElseGet(info::createConfiguration);
			DebugUITools.launch(launchConfiguration, mode);
		} catch (CoreException e) {
			throw Exceptions.sneakyThrow(e);
		}
	}
}
