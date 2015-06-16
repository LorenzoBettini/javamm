package javamm.tests

import com.google.inject.Inject
import javamm.JavammInjectorProvider
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.formatter.FormatterTester
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammInjectorProvider))
class JavammFormatterTest extends JavammAbstractTest {
	
	@Inject extension FormatterTester

	@Test def void testProgramSpaces() {
		assertFormatted[
			expectation = '''
				import java.util.List;
				import static java.util.Arrays.*;
				
				int m() {
					return 0;
				}
				
				int n() {
					return 0;
				}
				
				System.out.println(m());
				
			'''
			toBeFormatted = '''
				
				
				import  java.util.List ;
				import static  java.util.Arrays.* ;
				
				
				int m() { return 0; }
				int n() { return 0; }
				
				
				System.out.println(m());
				
				
			'''
		]
	}

	@Test def void testProgramSpacesWithOnlyMain() {
		assertFormatted[
			expectation = '''
				import java.util.List;
				import static java.util.Arrays.*;
				
				System.out.println(m());
				
			'''
			toBeFormatted = '''
				
				
				import  java.util.List ;
				import static  java.util.Arrays.* ;
				
				
				
				
				System.out.println(m());
				
				
			'''
		]
	}

	@Test def void testProgramSpacesWithOnlyImports() {
		assertFormatted[
			expectation = '''
				import java.util.List;
				import static java.util.Arrays.*;
				
			'''
			toBeFormatted = '''
				
				
				import  java.util.List ;
				import static  java.util.Arrays.* ;
				
			'''
		]
	}

	@Test def void testFormatImportSection() {
		assertFormatted[
			expectation = '''
				import java.util.List;
				import static java.util.Arrays.*;
				
			'''
			toBeFormatted = '''
				import  java.util.List ;
				import static  java.util.Arrays.* ;
			'''
		]
	}

	@Test def void testFormatBlock() {
		assertFormatted[
			expectation = '''
			{
				System.out.println("1");
				System.out.println("2");
			}
			'''
			toBeFormatted = '''
				{ System.out.println("1");  System.out.println("2") ;  }
			'''
		]
	}

	@Test def void testMain() {
		assertFormatted[
			expectation = '''
				System.out.println("1");
				System.out.println("2");
			'''
			toBeFormatted = '''
				System.out.println("1");  System.out.println("2") ;  
			'''
		]
	}

	@Test def void testMainAsBlock() {
		assertFormatted[
			expectation = '''
			{
				System.out.println("1");
				System.out.println("2");
			}
			'''
			toBeFormatted = '''
				{   System.out.println("1");  System.out.println("2") ;   }
			'''
		]
	}

	@Test def void testFormatSystemOut() {
		assertFormatted[
			toBeFormatted = '''
				System.out.println("Hello");
			'''
		]
	}

	@Test def void testFormatSystemOut2() {
		assertFormatted[
			expectation = '''
				System.out.println("Hello");
			'''
			toBeFormatted = '''
				System.out.println( "Hello" ) ;
			'''
		]
	}

	@Test def void testVariableDeclaration() {
		assertFormatted[
			expectation = '''
				int i;
			'''
			toBeFormatted = '''
				int  i ;
			'''
		]
	}

	@Test def void testVariableDeclarationWithInitialization() {
		assertFormatted[
			expectation = '''
				int i = 0;
			'''
			toBeFormatted = '''
				int  i  =   0;
			'''
		]
	}

	@Test def void testVariableDeclarations() {
		assertFormatted[
			expectation = '''
				int i, j, k;
			'''
			toBeFormatted = '''
				int  i , j , k ;
			'''
		]
	}

	@Test def void testVariableDeclarationsWithInitialization() {
		assertFormatted[
			expectation = '''
				int i = 0, j = 1, k = 2;
			'''
			toBeFormatted = '''
				int  i  =  0  , j  =  1 , k  =  2 ;
			'''
		]
	}

	@Test def void testAssignment() {
		assertFormatted[
			expectation = '''
				i = 0;
			'''
			toBeFormatted = '''
				i  =  0   ;
			'''
		]
	}

	@Test def void testAssignmentWithArrayAccess() {
		assertFormatted[
			expectation = '''
				i[0] = 0;
			'''
			toBeFormatted = '''
				i [ 0 ]  =  0   ;
			'''
		]
	}

	@Test def void testAssignmentWithArrayAccesses() {
		assertFormatted[
			expectation = '''
				i[0][1] = 0;
			'''
			toBeFormatted = '''
				i [ 0 ] [ 1 ] =  0   ;
			'''
		]
	}

	@Test def void testMethod() {
		assertFormatted[
			expectation = '''
				int m(int i, final String s) {
					return 0;
				}
			'''
			toBeFormatted = '''
				int  m ( int  i ,  final  String  s )  {					return 0; 			}
			'''
		]
	}

	@Test def void testBinaryOperator() {
		assertFormatted[
			expectation = '''
				int j = i + 0 * 1;
			'''
			toBeFormatted = '''
				int j  =   i  +0  *  1 ;
			'''
		]
	}

	@Test def void testFeatureCall() {
		assertFormatted[
			expectation = '''
				m(1 + 3, 2);
			'''
			toBeFormatted = '''
				m (  1+3  ,   2  )  ;
			'''
		]
	}

	@Test def void testPrefixOperator() {
		assertFormatted[
			expectation = '''
				++i;
			'''
			toBeFormatted = '''
				++  i  ;
			'''
		]
	}

	@Test def void testConstructorCall() {
		assertFormatted[
			expectation = '''
				new List<Integer, String>(1 + 3, 2);
			'''
			toBeFormatted = '''
				new  List  < Integer  ,  String  >  (  1+3  ,   2  )  ;
			'''
		]
	}
}