package javamm.ui.wizard.selfassessment;

import static javamm.ui.wizard.selfassessment.JavammSelfAssessmentProjectFiles.*;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.core.resources.IFolder;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.jdt.core.IClasspathEntry;
import org.eclipse.jdt.core.IJavaProject;
import org.eclipse.jdt.core.JavaCore;
import org.eclipse.xtext.xbase.lib.Conversions;

import com.google.common.collect.Lists;
import com.google.inject.Inject;
import com.google.inject.Provider;

import javamm.selfassessment.builder.builder.JavammSelfAssessmentBuilder;
import javamm.selfassessment.builder.builder.JavammSelfAssessmentNature;
import javamm.ui.wizard.JavammProjectCreatorCustom;
import javamm.ui.wizard.PluginProjectFactoryCustom;

/**
 * This creates both the student's project and the teacher's project, adding
 * example contents, including a Junit test, and setting our builder in the
 * teacher's project.
 * 
 * @author Lorenzo Bettini
 *
 */
public class JavammSelfAssessmentProjectCreator extends JavammProjectCreatorCustom {

	protected static final String SRC_GEN_ROOT = "src-gen";

	protected static final String SRC_ROOT = "src";

	protected static final String TESTS_ROOT = "tests";

	private JavammSelfAssessmentProjectFiles projectFiles = new JavammSelfAssessmentProjectFiles();

	@Inject
	private Provider<PluginProjectFactoryCustom> projectFactoryProvider;

	@Override
	protected List<String> getRequiredBundles() {
		List<String> requiredBundles = super.getRequiredBundles();
		requiredBundles.add("org.junit");
		return requiredBundles;
	}

	@Override
	protected List<String> getAllFolders() {
		List<String> allFolders = new ArrayList<>();
		allFolders.add(SRC_ROOT);
		allFolders.add(TESTS_ROOT);
		allFolders.add(SRC_GEN_ROOT);
		return allFolders;
	}

	@Override
	protected PluginProjectFactoryCustom createProjectFactory() {
		return projectFactoryProvider.get();
	}

	@Override
	protected void enhanceProject(IProject project, IProgressMonitor monitor) throws CoreException {
		PluginProjectFactoryCustom projectFactory = (PluginProjectFactoryCustom) configureProjectFactory(
				createProjectFactory());

		projectFactory.createFileInContainer(STUDENT_SOLUTION_FILE_NAME, project.getFolder(SOLUTION_FILE_PATH),
				projectFiles.studentSolution(), monitor);
		projectFactory.createFileInContainer(STUDENT_TEST_FILE_NAME, project.getFolder(STUDENT_TEST_FILE_PATH),
				projectFiles.studentTest(), monitor);

		IFolder solutionFolder = project.getFolder(JavammSelfAssessmentNature.STUDENT_PROJECT_SOLUTION_PATH);

		IJavaProject javaProject = JavaCore.create(project);

		projectFactory.createFolder(solutionFolder);

		List<IClasspathEntry> classpath = Lists.newArrayList(javaProject.getRawClasspath());
		classpath.add(JavaCore.newLibraryEntry(solutionFolder.getFullPath(), null, null));
		javaProject.setRawClasspath((IClasspathEntry[]) Conversions.unwrapArray(classpath, IClasspathEntry.class),
				monitor);

		StringBuilder contentsForBuildProperties = projectFactory.getContentsForBuildProperties();
		contentsForBuildProperties.append("\n");
		contentsForBuildProperties.append("output.. = solution/");
		projectFactory.createBuildProperties(project, contentsForBuildProperties.toString(), monitor);

		// now create the project for the teacher
		projectFactory = (PluginProjectFactoryCustom) configureProjectFactory(
				createProjectFactory());

		String studentProjectName = project.getName();
		String teacherProjectName = studentProjectName.replace(JavammSelfAssessmentNature.STUDENT_PROJECT_SUFFIX,
				JavammSelfAssessmentNature.TEACHER_PROJECT_SUFFIX);
		projectFactory.setProjectName(teacherProjectName);
		projectFactory.getFolders().clear();
		projectFactory.addFolders(Lists.newArrayList(SRC_ROOT, SRC_GEN_ROOT));
		projectFactory.addProjectNatures(JavammSelfAssessmentNature.NATURE_ID);
		projectFactory.addBuilderIds(JavammSelfAssessmentBuilder.BUILDER_ID);
		IProject teacherProject = projectFactory.createProject(monitor, null);
		
		projectFactory.createFileInContainer(TEACHER_SOLUTION_FILE_NAME, teacherProject.getFolder(SOLUTION_FILE_PATH),
				projectFiles.teacherSolution(), monitor);
	}
}