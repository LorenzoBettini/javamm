package javamm.ui.launch

import org.eclipse.core.resources.IFile
import org.eclipse.core.runtime.CoreException
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.ui.DebugUITools
import org.eclipse.debug.ui.ILaunchShortcut
import org.eclipse.debug.ui.RefreshTab
import org.eclipse.jface.viewers.ISelection
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.ui.IEditorPart
import org.eclipse.ui.IFileEditorInput
import org.eclipse.xtend.lib.annotations.Data
import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.util.Strings
import org.eclipse.xtext.xbase.ui.editor.XbaseEditor

import static org.eclipse.jdt.launching.IJavaLaunchConfigurationConstants.*
import static org.eclipse.jface.dialogs.MessageDialog.*

class JavammLaunchShortcut implements ILaunchShortcut {

	override launch(ISelection selection, String mode) {
		val file = (selection as IStructuredSelection).firstElement as IFile
		val name = file.name
		val clazz = "javamm." + name.substring(0, name.lastIndexOf('.'))
		launch(mode, new LaunchConfigurationInfo(file.project.name, clazz))
	}
	
	override launch(IEditorPart editor, String mode) {
		if (editor instanceof XbaseEditor) {
			val editorInput = editor.editorInput
			if (editorInput instanceof IFileEditorInput) {
				val project = editorInput.file.project.name
				val info = editor.document.readOnly [
					val file = contents.filter(JvmDeclaredType).head
					new LaunchConfigurationInfo(project, file?.identifier)
				]
				launch(mode, info)
				return
			}
		} 
		openError(null, "Wrong editor kind.", "")
	}

	def launch(String mode, LaunchConfigurationInfo info) {
		if (info.clazz.nullOrEmpty)    
			openError(null, "Launch Error", "Could not determine the class that should be executed.")
		else if (info.project.nullOrEmpty)  
			openError(null, "Launch Error", "Could not determine the project that should be executed.")
		else try {
			val configs = DebugPlugin.getDefault.launchManager.launchConfigurations
			val config = configs.findFirst[info.configEquals(it)] ?: info.createConfiguration 
			DebugUITools.launch(config, mode)
		} catch (CoreException e) {
			openError(null, "Problem running workflow.", e.message)
		}
	}
}

@Data class LaunchConfigurationInfo {
	public static val String LAUNCH_TYPE = "javamm.ui.JavammLaunchConfigurationType"

	val String project
	val String clazz
	
	def getName() {
		Strings.lastToken(clazz, ".")
	}
	
	def createConfiguration()  {
		val launchManager = DebugPlugin.getDefault.launchManager
		val configType = launchManager.getLaunchConfigurationType(LAUNCH_TYPE)
		val wc = configType.newInstance(null, launchManager.generateLaunchConfigurationName(name))
		wc.setAttribute(ATTR_PROJECT_NAME, project)
		wc.setAttribute(ATTR_MAIN_TYPE_NAME, clazz)
		wc.setAttribute(ATTR_STOP_IN_MAIN, false)
		wc.setAttribute(RefreshTab.ATTR_REFRESH_SCOPE, "${workspace}")
		wc.setAttribute(RefreshTab.ATTR_REFRESH_RECURSIVE, true)
		wc.doSave
	}

	def configEquals(ILaunchConfiguration a) {
		a.getAttribute(ATTR_MAIN_TYPE_NAME, "X") == clazz && 
		a.getAttribute(ATTR_MAIN_TYPE_NAME, "X") == project &&
		a.type.identifier == LAUNCH_TYPE
	}
	
	def isValid() {
		!clazz.nullOrEmpty && !project.nullOrEmpty
	}
}
