package javamm.ui.wizard.selfassessment

class JavammSelfAssessmentProjectFiles {

	val public static SOLUTION_FILE_PATH = "src/javamm"

	val public static STUDENT_SOLUTION_FILE_NAME = "Max.javamm"

	val public static TEACHER_SOLUTION_FILE_NAME = "MaxSolution.javamm"

	val public static STUDENT_TEST_FILE_PATH = "tests/tests"

	val public static STUDENT_TEST_FILE_NAME = "MaxParameterizedRandomTest.java"
	
	def String studentSolution()
'''
// this is the student's implementation
int max(int i, int j) {
	if (i > j+1) { // ERROR
		return i;
	} else {
		return j;
	}
}
'''

	def String teacherSolution()
'''
// this is the teachers's implementation
int max(int i, int j) {
	if (i > j) {
		return i;
	} else {
		return j;
	}
}
'''

	def String studentTest()
'''
package tests;

import static org.junit.Assert.assertEquals;

import java.util.Arrays;
import java.util.Collection;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

import javamm.Max;
import javamm.MaxSolution;

@RunWith(Parameterized.class)
public class MaxParameterizedRandomTest {

	@Parameters(name = "i = {0}; j = {1})")
    public static Collection<Object[]> data() {
    	Object[][] m = new Object[1000][2];
    	for (int i = 0; i < 1000; ++i) {
			int x = 1 + (int) (Math.random() * 5);
			int y = 1 + (int) (Math.random() * 5);
			m[i][0] = x;
			m[i][1] = y;
		}
        return Arrays.asList(m);
    }

    private int x;
    private int y;

    public MaxParameterizedRandomTest(int x, int y) {
    	this.x = x;
    	this.y = y;
    }

	@Test
	public void testExcercise() {
		assertEquals(MaxSolution.max(x,  y), Max.max(x,  y));
	}

}
'''
}