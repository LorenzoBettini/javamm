package javamm.ui.tests

import com.google.inject.Inject
import javamm.JavammUiInjectorProvider
import javamm.tests.utils.ui.PDETargetPlatformUtils
import javamm.tests.utils.ui.PluginProjectHelper
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IProject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.ui.AbstractWorkbenchTest
import org.junit.Before
import org.junit.BeforeClass
import org.junit.Test
import org.junit.runner.RunWith

import static org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil.*
import javamm.selfassessment.builder.builder.JavammSelfAssessmentNature

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammUiInjectorProvider))
class JavammSelfAssessmentBuilderTest extends AbstractWorkbenchTest {

	@Inject PluginProjectHelper projectHelper
	
	val TEST_PROJECT = "mytestproject"

	val TEST_TEACHER_PROJECT = TEST_PROJECT + JavammSelfAssessmentNature.TEACHER_PROJECT_SUFFIX

	val TEST_STUDENT_PROJECT = TEST_PROJECT + JavammSelfAssessmentNature.STUDENT_PROJECT_SUFFIX

	val SOLUTION = JavammSelfAssessmentNature.STUDENT_PROJECT_SOLUTION_PATH

	var IProject studentProject

	var IProject teacherProject
	
	@BeforeClass
	def static void beforeClass() {
		PDETargetPlatformUtils.setTargetPlatform();
	}

	@Before
	override void setUp() {
		super.setUp
		studentProject = projectHelper.createJavammStudentProject(TEST_PROJECT).project
		teacherProject = projectHelper.createJavammTeacherProject(TEST_PROJECT).project
	}

	@Test
	def void testFullBuild() {
		createSimpleJavaFile(TEST_TEACHER_PROJECT, "example.sub", "ExampleSub", "")
		createSimpleJavaFile(TEST_TEACHER_PROJECT, "example", "Example", "")
		createSimpleJavaFile(TEST_TEACHER_PROJECT, "", "AnotherExample", "")
		fullBuild
		getFileFromSolutionPath("example/sub/ExampleSub.class").assertFileExists
		getFileFromSolutionPath("example/Example.class").assertFileExists
		getFileFromSolutionPath("AnotherExample.class").assertFileExists
	}

	@Test
	def void testIncrementalBuild() {
		createSimpleJavaFile(TEST_TEACHER_PROJECT, "example.sub", "ExampleSub", "")
		waitForBuild
		getFileFromSolutionPath("example/sub/ExampleSub.class").assertFileExists
		createSimpleJavaFile(TEST_TEACHER_PROJECT, "", "AnotherExample", "")
		waitForBuild
		getFileFromSolutionPath("AnotherExample.class").assertFileExists
		createSimpleJavaFile(TEST_TEACHER_PROJECT, "example", "Example", "")
		waitForBuild
		getFileFromSolutionPath("example/Example.class").assertFileExists
	}

	@Test
	def void testSolutionFolderContentsRemovedBeforeCopyingClassFiles() {
		val solutionFolder = studentProject.getFolder(SOLUTION)
		val file = solutionFolder.getFile("foo")
		createFile(file.fullPath, "")
		solutionFolder.getFile("foo").exists.assertTrue
		
		createSimpleJavaFile(TEST_TEACHER_PROJECT, "example.sub", "ExampleSub", "")
		waitForBuild
		// the solution folder should have been emptied before copying the .class files
		solutionFolder.getFile("foo").exists.assertFalse
	}

	@Test
	def void testRemoval() {
		createSimpleJavaFile(TEST_TEACHER_PROJECT, "example.sub", "ExampleSub", "")
		waitForBuild
		getFileFromSolutionPath("example/sub/ExampleSub.class").assertFileExists
		getFileFromTeacherSourcePath("example/sub/ExampleSub.java").delete(true, monitor)
		waitForBuild
		getFileFromSolutionPath("example/sub/ExampleSub.class").assertFileDoesNotExist
	}

	@Test
	def void testRemovalOfAnAlreadyRemovedFile() {
		createSimpleJavaFile(TEST_TEACHER_PROJECT, "example.sub", "ExampleSub", "")
		waitForBuild
		// we manually remove it
		getFileFromSolutionPath("example/sub/ExampleSub.class") => [
			assertFileExists
			delete(true, monitor)
			assertFileDoesNotExist
		]
		getFileFromTeacherSourcePath("example/sub/ExampleSub.java").delete(true, monitor)
		// to test that we check for file existance before removal in our builder
		waitForBuild
		getFileFromSolutionPath("example/sub/ExampleSub.class").assertFileDoesNotExist
	}

	@Test
	def void testOriginalJavammFileIsNotCopied() {
		createSimpleJavammFile(TEST_TEACHER_PROJECT, "javamm", "Example", 
			'''
			int m() {
				return 0;
			}
			'''
		)
		waitForBuild
		getFileFromSolutionPath("javamm/Example.class").assertFileExists
		getFolderFromSolutionPath("javamm") => [
			1.assertEquals(members.length)
		]
	}

	@Test
	def void testChangeOfJavammFile() {
		createSimpleJavammFile(TEST_TEACHER_PROJECT, "javamm", "Example", 
			'''
			int m() {
				return 0;
			}
			'''
		)
		waitForBuild
		getFileFromSolutionPath("javamm/Example.class").assertFileExists
		createSimpleJavammFile(TEST_TEACHER_PROJECT, "javamm", "Example", 
			'''
			int m2() {
				return 0;
			}
			'''
		)
		waitForBuild
		getFileFromSolutionPath("javamm/Example.class").assertFileExists
	}

	@Test
	def void testCreatingFileInTeacherProjectFixesProblemsInStudentProject() {
		createSimpleJavaFile(TEST_STUDENT_PROJECT, "excercise", "ExampleExcercise",
			'''
			// this must be defined in the teacher's project
			example.ExampleSolution solution = null;
			'''
		)
		
		waitForBuild
		// ExampleSolution is not yet defined
		assertErrors("example cannot be resolved to a type")
		
		// create the solution in the teacher's project
		createSimpleJavaFile(TEST_TEACHER_PROJECT, "example", "ExampleSolution", "")

		// we wait for the .class file to be copied in the student's project
		waitForBuild
		// we wait for the student's project to be recompiled
		waitForBuild
		// now the solution .class should have been copied in the student's project
		assertNoErrors
	}

	@Test
	def void testCreatingJavammFileInTeacherProjectFixesProblemsInStudentProject() {
		createSimpleJavaFile(TEST_STUDENT_PROJECT, "excercise", "ExampleExcercise",
			'''
			// this must be defined in the teacher's project
			javamm.ExampleSolution solution = null;
			'''
		)
		
		waitForBuild
		// ExampleSolution is not yet defined
		assertErrors("javamm.ExampleSolution cannot be resolved to a type")
		
		// create the solution in the teacher's project
		createSimpleJavammFile(TEST_TEACHER_PROJECT, "javamm", "ExampleSolution", "")

		// we wait for the .class file to be copied in the student's project
		waitForBuild
		// we wait for the student's project to be recompiled
		waitForBuild
		// now the solution .class should have been copied in the student's project
		assertNoErrors
	}

	def private createSimpleJavaFile(String projectName, String packageName, String className, CharSequence contents) {
		createFile(
			projectName + "/src/" + packageName.replace('.', '/') + "/" + className + ".java",
			'''
			«IF !packageName.empty»package «packageName»;«ENDIF»
			
			public class «className» {
				«contents»
			}
			'''
		)
	}

	def private createSimpleJavammFile(String projectName, String packageName, String className, String contents) {
		createFile(
			projectName + "/src/" + packageName.replace('.', '/') + "/" + className + ".javamm",
			contents
		)
	}

	def private getFileFromSolutionPath(String path) {
		studentProject.getFile(SOLUTION + "/" + path)
	}

	def private getFolderFromSolutionPath(String path) {
		studentProject.getFolder(SOLUTION + "/" + path)
	}

	def private getFileFromTeacherSourcePath(String path) {
		teacherProject.getFile("src/" + path)
	}

	def private assertFileExists(IFile file) {
		assertTrue("file does not exist: " + file.fullPath, file.exists)	
	}

	def private assertFileDoesNotExist(IFile file) {
		assertFalse("file does exist: " + file.fullPath, file.exists)	
	}

	def private assertErrors(CharSequence expected) {
		projectHelper.assertErrors(expected)
	}

	def private assertNoErrors() {
		projectHelper.assertNoErrors
	}
}