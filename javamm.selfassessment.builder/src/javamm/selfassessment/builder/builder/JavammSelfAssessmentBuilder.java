package javamm.selfassessment.builder.builder;

import java.util.Map;

import org.eclipse.core.resources.IContainer;
import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IFolder;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.resources.IResourceDelta;
import org.eclipse.core.resources.IResourceDeltaVisitor;
import org.eclipse.core.resources.IResourceVisitor;
import org.eclipse.core.resources.IWorkspaceRoot;
import org.eclipse.core.resources.IncrementalProjectBuilder;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.NullProgressMonitor;

/**
 * A project builder for self-assessment project sets: it copies the class files
 * from the bin directory of the teacher's project into the library folder of
 * the student's project.
 * 
 * @author Lorenzo Bettini
 *
 */
public class JavammSelfAssessmentBuilder extends IncrementalProjectBuilder {

	public static final String BIN = "bin";

	public static final String BUILDER_ID = "javamm.selfassessment.builder.javammSelfAssessmentBuilder";

	class SelfAssessmentBuilderDeltaVisitor implements IResourceDeltaVisitor {
		private IProgressMonitor monitor;

		public SelfAssessmentBuilderDeltaVisitor(IProgressMonitor monitor) {
			this.monitor = monitor;
		}

		@Override
		public boolean visit(IResourceDelta delta) throws CoreException {
			IResource resource = delta.getResource();
			if (isClassFile(resource)) {
				if (delta.getKind() == IResourceDelta.REMOVED) {
					removeFromStudentProject(resource, monitor);
				} else {
					copyToStudentProject(resource, monitor);
				}
			}
			// return true to continue visiting children.
			return true;
		}
	}

	class SelfAssessmentBuilderResourceVisitor implements IResourceVisitor {
		private IProgressMonitor monitor;

		public SelfAssessmentBuilderResourceVisitor(IProgressMonitor monitor) {
			this.monitor = monitor;
		}

		@Override
		public boolean visit(IResource resource) throws CoreException {
			fullCopy(monitor);
			// we already manage the full build for the whole project
			return false;
		}

		private void fullCopy(IProgressMonitor monitor) throws CoreException {
			clearStudentProjectDestination(monitor);
			for (IResource member : getProject().getFolder(BIN).members()) {
				copyClassFiles(member, monitor);
			}
		}

		private void clearStudentProjectDestination(IProgressMonitor monitor) throws CoreException {
			IFolder folder = getStudentProjectDestinationFolder();
			// don't delete the whole folder, but only its contents.
			// deleting the folder would make PDE complain about missing library
			// folder
			for (IResource resource : folder.members()) {
				resource.delete(true, monitor);
			}
		}
	}

	@Override
	protected IProject[] build(int kind, Map<String, String> args, IProgressMonitor monitor) throws CoreException {
		IResourceDelta delta = getDelta(getProject());
		if (delta == null) {
			fullBuild(monitor);
		} else {
			incrementalBuild(delta, monitor);
			// refresh the student project
			workspaceRoot().getProject(fromTeacherProjectNameToStudentProjectName())
					.refreshLocal(IResource.DEPTH_INFINITE, monitor);
		}
		return null; // NOSONAR null is part of the contract
	}

	private boolean isClassFile(IResource resource) {
		return resource instanceof IFile && resource.getName().endsWith(".class");
	}

	private void copyClassFiles(IResource resource, IProgressMonitor monitor) throws CoreException {
		if (resource instanceof IFolder) {
			IFolder folder = (IFolder) resource;
			for (IResource member : folder.members()) {
				copyClassFiles(member, monitor);
			}
		} else if (isClassFile(resource)) {
			copyToStudentProject(resource, monitor);
		}
	}

	private IFolder getStudentProjectDestinationFolder() {
		return workspaceRoot().getFolder(getStudentProjectDestination());
	}

	private IWorkspaceRoot workspaceRoot() {
		return ResourcesPlugin.getWorkspace().getRoot();
	}

	private void copyToStudentProject(IResource resource, IProgressMonitor monitor) throws CoreException {
		// before copying we must remove possible already existing file
		IFile file = removeFromStudentProject(resource, monitor);
		createRecursive(file.getParent());
		IPath finalDestinationPath = file.getFullPath();
		resource.copy(finalDestinationPath, true, monitor);
	}

	private IFolder getStudentProjectDestinationFolder(IResource resource) {
		IPath projectRelative = resource.getProjectRelativePath();
		// remove project and bin folder
		IPath classFileRelativePath = projectRelative.removeFirstSegments(1).removeLastSegments(1);
		return getStudentProjectDestinationFolder().getFolder(classFileRelativePath);
	}

	private IFile removeFromStudentProject(IResource resource, IProgressMonitor monitor) throws CoreException {
		IFolder destinationFolder = getStudentProjectDestinationFolder(resource);
		IFile file = destinationFolder.getFile(resource.getName());
		if (file.exists()) {
			file.delete(true, monitor);
		}
		return file;
	}

	private void createRecursive(final IContainer resource) throws CoreException {
		if (!resource.exists()) {
			if (!resource.getParent().exists()) {
				createRecursive(resource.getParent());
			}
			((IFolder) resource).create(false, true, new NullProgressMonitor());
		}
	}

	protected void fullBuild(final IProgressMonitor monitor) throws CoreException {
		getProject().accept(new SelfAssessmentBuilderResourceVisitor(monitor));
	}

	protected void incrementalBuild(IResourceDelta delta, IProgressMonitor monitor) throws CoreException {
		// the visitor does the work.
		delta.accept(new SelfAssessmentBuilderDeltaVisitor(monitor));
	}

	private IPath getStudentProjectDestination() {
		return fromTeacherProjectToStudentProject().append(JavammSelfAssessmentNature.STUDENT_PROJECT_SOLUTION_PATH);
	}

	private IPath fromTeacherProjectToStudentProject() {
		IPath projectPath = getProject().getFullPath();
		return projectPath.removeFileExtension()
				.addFileExtension(JavammSelfAssessmentNature.STUDENT_PROJECT_SUFFIX_NAME);
	}

	private String fromTeacherProjectNameToStudentProjectName() {
		String teacherProjectName = getProject().getName();
		return teacherProjectName.replace(JavammSelfAssessmentNature.TEACHER_PROJECT_SUFFIX,
				JavammSelfAssessmentNature.STUDENT_PROJECT_SUFFIX);
	}
}
