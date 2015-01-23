/**
 * 
 */
package javamm.ui.wizard.file;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.jdt.core.IJavaElement;
import org.eclipse.jdt.internal.ui.JavaPlugin;
import org.eclipse.jdt.internal.ui.wizards.NewElementWizard;
import org.eclipse.jface.resource.ImageDescriptor;
import org.eclipse.jface.text.TextSelection;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.ISelectionProvider;
import org.eclipse.swt.widgets.Display;
import org.eclipse.ui.IEditorPart;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.ide.IDE;
import org.eclipse.ui.texteditor.ITextEditor;
import org.eclipse.xtext.ui.IImageHelper.IImageDescriptorHelper;

import com.google.inject.Inject;

/**
 * @author Lorenzo Bettini
 *
 */
public class NewJavammFileWizard extends NewElementWizard {

	private NewJavammFileWizardPage page;

	@Inject
	public NewJavammFileWizard(IImageDescriptorHelper imgHelper, NewJavammFileWizardPage page) {
		this.page= page;
		ImageDescriptor image = imgHelper.getImageDescriptor("newjavammfile_wiz.png");
		setDefaultPageImageDescriptor(image);
		setDialogSettings(JavaPlugin.getDefault().getDialogSettings());
		setWindowTitle("Java-- File");
	}

	/**
	 * This can be used in derived classes for testing purposes
	 * 
	 * @return
	 */
	protected NewJavammFileWizardPage getPage() {
		return page;
	}

	@Override
	public void addPages() {
		super.addPages();
		page.init(getSelection());
		super.addPage(page);
	}

	@Override
	protected void finishPage(IProgressMonitor monitor) throws InterruptedException, CoreException {
	}

	@Override
	public IJavaElement getCreatedElement() {
		return null;
	}

	@Override
	public boolean performFinish() {
		final int size = this.page.createType();
		final IResource resource = page.getResource();
		if(resource != null) {
			selectAndReveal(resource);
			final Display display= getShell().getDisplay();
			display.asyncExec(new Runnable() {
				public void run() {
					IEditorPart editor;
					try {
						editor = IDE.openEditor(JavaPlugin.getActivePage(), (IFile) resource);
						if (editor instanceof ITextEditor) {
							final ITextEditor textEditor = (ITextEditor) editor;
							ISelectionProvider selectionProvider = textEditor.getSelectionProvider();
							ISelection selection = new TextSelection(size - 2, 0);
							selectionProvider.setSelection(selection);
						}
					} catch (PartInitException e) {
						throw new RuntimeException(e);
					}
				}
			});
			return true;
		} else {
			return false;
		}
	}

}
