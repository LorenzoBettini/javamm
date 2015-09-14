package javamm.tests.utils.ui

import com.google.inject.Inject
import com.google.inject.Provider
import java.util.List
import org.eclipse.core.resources.IMarker
import org.eclipse.core.resources.IResource
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.jdt.core.IJavaProject
import org.eclipse.jdt.core.JavaCore
import org.eclipse.xtext.junit4.ui.util.JavaProjectSetupUtil
import org.eclipse.xtext.ui.XtextProjectHelper
import org.eclipse.xtext.ui.util.PluginProjectFactory

import static org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil.*
import static org.junit.Assert.*
import javamm.selfassessment.builder.builder.JavammSelfAssessmentBuilder
import javamm.selfassessment.builder.builder.JavammSelfAssessmentNature

class PluginProjectHelper {

	@Inject Provider<PluginProjectFactory> projectFactoryProvider

	val defaultBuilderIds = newArrayList(JavaCore.BUILDER_ID, 
				"org.eclipse.pde.ManifestBuilder",
				"org.eclipse.pde.SchemaBuilder",
				XtextProjectHelper.BUILDER_ID)
	val defaultNatureIds = newArrayList(JavaCore.NATURE_ID, 
				"org.eclipse.pde.PluginNature", 
				XtextProjectHelper.NATURE_ID)
	val defaultRequiredBundles = newArrayList("javamm.runtime")

	def IJavaProject createJavammPluginProject(String projectName) {
		createJavaPluginProject(projectName, defaultRequiredBundles)
	}

	def IJavaProject createJavammStudentProject(String projectPrefix) {
		val required = defaultRequiredBundles + newArrayList("org.junit")
		createJavaPluginProject(
			projectPrefix + JavammSelfAssessmentNature.STUDENT_PROJECT_SUFFIX,
			required.toList
		) => [
			val solutionFolder = createFolder(path.append(JavammSelfAssessmentNature.STUDENT_PROJECT_SOLUTION_PATH))
			val classpath = newArrayList(rawClasspath)
			val solutionFolderFullPath = solutionFolder.fullPath
			val libEntry = JavaCore.newLibraryEntry(solutionFolderFullPath, null, null)
			classpath += libEntry
			setRawClasspath(classpath, monitor)
		]
	}

	def IJavaProject createJavammTeacherProject(String projectPrefix) {
		createJavaPluginProject(
			projectPrefix + JavammSelfAssessmentNature.TEACHER_PROJECT_SUFFIX,
			defaultRequiredBundles,
			#[],
			(defaultBuilderIds + newArrayList(JavammSelfAssessmentBuilder.BUILDER_ID)).toList,
			(defaultNatureIds + newArrayList(JavammSelfAssessmentNature.NATURE_ID)).toList
		)
	}

	def IJavaProject createJavaPluginProject(String projectName, List<String> requiredBundles) {
		createJavaPluginProject(projectName, requiredBundles, #[])
	}

	def IJavaProject createJavaPluginProject(String projectName, List<String> requiredBundles, List<String> exportedPackages) {
		createJavaPluginProject(projectName, requiredBundles, exportedPackages, 
			defaultBuilderIds, defaultNatureIds)
	}

	def IJavaProject createJavaPluginProject(String projectName, 
		List<String> requiredBundles, List<String> exportedPackages,
		List<String> builderIds, List<String> natureIds) {
		val projectFactory = projectFactoryProvider.get
		
		projectFactory.setProjectName(projectName);
		projectFactory.addFolders(newArrayList("src"));
		projectFactory.addFolders(newArrayList("src-gen"));
		projectFactory.addBuilderIds(builderIds);
		projectFactory.addProjectNatures(natureIds);
		projectFactory.addRequiredBundles(requiredBundles);
		projectFactory.addExportedPackages(exportedPackages)
		val result = projectFactory.createProject(new NullProgressMonitor(), null);
		JavaCore.create(result);
		return JavaProjectSetupUtil.findJavaProject(projectName);
	}

	def assertNoErrors() {
		val markers = getErrorMarkers()
		assertEquals(
			"unexpected errors:\n" +
			markers.map[getAttribute(IMarker.MESSAGE)].join("\n"),
			0, 
			markers.size
		)
	}

	def assertErrors(CharSequence expected) {
		val markers = getErrorMarkers()
		assertEqualsStrings(
			expected,
			markers.map[getAttribute(IMarker.MESSAGE)].join("\n")
		)
	}
	
	def getErrorMarkers() {
		root.findMarkers(IMarker.PROBLEM, true, IResource.DEPTH_INFINITE).
			filter[
				getAttribute(IMarker.SEVERITY, IMarker.SEVERITY_INFO) == IMarker.SEVERITY_ERROR
			]
	}

	def protected assertEqualsStrings(CharSequence expected, CharSequence actual) {
		assertEquals(expected.toString().replaceAll("\r", ""), actual.toString());
	}

}