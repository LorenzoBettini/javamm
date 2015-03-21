/**
 * 
 */
package javamm.ui.wizard.file;

import java.io.ByteArrayInputStream;
import java.lang.reflect.InvocationTargetException;

import org.apache.log4j.Logger;
import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IFolder;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IAdaptable;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.core.runtime.OperationCanceledException;
import org.eclipse.jdt.core.IJavaElement;
import org.eclipse.jdt.core.IJavaProject;
import org.eclipse.jdt.core.JavaCore;
import org.eclipse.jdt.core.JavaModelException;
import org.eclipse.jdt.ui.wizards.NewTypeWizardPage;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.operation.IRunnableWithProgress;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.swt.SWT;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Display;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.IWorkbenchPart;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.actions.WorkspaceModifyOperation;
import org.eclipse.ui.views.contentoutline.ContentOutline;
import org.eclipse.xtext.ui.editor.XtextEditor;
import org.eclipse.xtext.ui.editor.model.IXtextDocument;

/**
 * @author Lorenzo Bettini
 *
 */
public class NewJavammFileWizardPage extends NewTypeWizardPage {
	
	private static final Logger LOGGER = Logger.getLogger(NewJavammFileWizardPage.class);
	
	public static final String JAVAMM_FILE = "Java-- File";

	protected static final int COLS = 4;
	
	private IResource resource;

	public NewJavammFileWizardPage() {
		super(true, JAVAMM_FILE);
		this.setTitle(JAVAMM_FILE);
		this.setDescription("Creates a new Java-- file in the current project");
	}
	
	public IResource getResource() {
		return resource;
	}

	protected void setResource(IResource resource) {
		this.resource = resource;
	}

	@Override
	public void createControl(Composite parent) {
		initializeDialogUnits(parent);
		Composite composite = new Composite(parent, SWT.NONE);
		composite.setFont(parent.getFont());
		GridLayout layout = new GridLayout();
		layout.numColumns = COLS;
		composite.setLayout(layout);
		createContainerControls(composite, COLS);
//		createPackageControls(composite, COLS);
		createSeparator(composite, COLS);
		createTypeNameControls(composite, COLS);
//		createSuperClassControls(composite, COLS);
//		createSuperInterfacesControls(composite, COLS);
		setControl(composite);
	}
	
	protected void init(IStructuredSelection selection) {
		IJavaElement elem = getSelectedResource(selection);
		initContainerPage(elem);
		initTypePage(elem);
	}
	
	public IJavaElement getSelectedResource(IStructuredSelection selection) {
		IJavaElement elem = null;
		if(selection != null && !selection.isEmpty()){
			Object o = selection.getFirstElement();
			if(o instanceof IAdaptable) {
				IAdaptable adaptable = (IAdaptable)o;
				elem = (IJavaElement)adaptable.getAdapter(IJavaElement.class);
				if(elem == null){
					elem = getPackage(adaptable);
				}
			}
		}
		if (elem == null) {
			IWorkbenchPage activePage = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage();
			IWorkbenchPart part = activePage.getActivePart();
			if (part instanceof ContentOutline) {
				part= activePage.getActiveEditor();
			}
			if (part instanceof XtextEditor) {
				IXtextDocument doc = ((XtextEditor)part).getDocument();
				IFile file = doc.getAdapter(IFile.class);
				elem = getPackage(file);
			}
		}
		if (elem == null || elem.getElementType() == IJavaElement.JAVA_MODEL) {
			try {
				IJavaProject[] projects= JavaCore.create(ResourcesPlugin.getWorkspace().getRoot()).getJavaProjects();
				if (projects.length == 1) {
					elem= projects[0];
				}
			} catch (JavaModelException e) {
				throw new RuntimeException(e);
			}
		}
		return elem;
	}

	private IJavaElement getPackage(IAdaptable adaptable) {
		IJavaElement elem = null;
		IResource resource = (IResource) adaptable.getAdapter(IResource.class);
		if (resource != null && resource.getType() != IResource.ROOT) {
			while(elem == null && resource.getType() != IResource.PROJECT){
				resource = resource.getParent();
				elem = (IJavaElement) resource.getAdapter(IJavaElement.class);
			}
		}
		if (elem == null) {
			elem = JavaCore.create(resource);
		}
		return elem;
	}

	protected int createType() {
		final int[] size = { 0 };
		IRunnableWithProgress op = new WorkspaceModifyOperation() {
			@Override
			protected void execute(IProgressMonitor monitor) throws CoreException, InvocationTargetException,
					InterruptedException {
				if (monitor == null) {
					monitor = new NullProgressMonitor();
				}
				try {
					if (!getPackageFragment().exists()) {
						try {
							getPackageFragmentRoot().createPackageFragment(getPackageFragment().getElementName(), true,
									monitor);
						} catch (JavaModelException e) {
							LOGGER.error(e);
							displayError("Error creating package", e.getMessage());
						}
					}
					IResource res = getPackageFragment().getResource();
					IFile myFile = ((IFolder) res).getFile(getTypeName() + ".javamm"); //$NON-NLS-1$
					size[0] = createJavammElement(monitor, myFile);
				} catch (OperationCanceledException e) {
					LOGGER.error(e);
					throw new InterruptedException();
				} catch (Exception e) {
					throw new InvocationTargetException(e);
				} finally {
					monitor.done();
				}
			}
		};
		try {
			getContainer().run(true, false, op);
		} catch (InterruptedException e) {
			// cancelled by user
			return 0;
		} catch (InvocationTargetException e) {
			LOGGER.error(e);
			Throwable realException = e.getTargetException();
			MessageDialog.openError(getShell(), getElementCreationErrorMessage(), realException.getMessage());
		}
		return size[0];
	}
	
	protected int createJavammElement(IProgressMonitor monitor, IFile xtendFile) {
		int size = 0;
		try {
			String content = "";
			size = content.length();
			xtendFile.create(new ByteArrayInputStream(content.getBytes()), true, monitor);
			setResource(xtendFile);
		} catch (CoreException e) {
			LOGGER.error(e);
			displayError(getElementCreationErrorMessage(), e.getMessage());
		}
		return size;
	}

	protected void displayError(final String title, final String message) {
		Display.getDefault().syncExec(new Runnable() {
			public void run() {
				MessageDialog.openError(getShell(), title, message);
			}
		});
	}
	
	protected String getElementCreationErrorMessage() {
		return "Error creating Java-- element";
	}
}
