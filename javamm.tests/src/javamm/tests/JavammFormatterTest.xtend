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

	@Test def void testSemicolonInSingleStatements() {
		assertFormatted[
			expectation = '''
				if (s)
					continue;
				if (s)
					System.out.println(s);
				if (s)
					a[0].println();
				if (s)
					a[0];
				if (s)
					int j = 0;
				if (s)
					do {
						int j = 0;
					} while (true);
			'''
			toBeFormatted = '''
				if (s)
					continue ;
				if (s)
					System.out.println(s) ;
				if (s)
					a[0].println() ;
				if (s)
					a [ 0 ] ;
				if (s)
					int  j  =  0  ;
				if (s)
					do { int j = 0; } while  (true);
			'''
		]
	}

	@Test def void testSemicolonInSingleStatements2() {
		assertFormatted[
			expectation = '''
				if (s)
					a[0].println();
				
				for (String s : strings)
					a[0].println();
			'''
			toBeFormatted = '''
				if (s)
					a   [    0 ].println() ;
				
				for (String s : strings)
					a   [    0 ].println() ;
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

	@Test def void testArrayAccesses() {
		assertFormatted[
			expectation = '''
				j = i[0][1];
			'''
			toBeFormatted = '''
				j = i [ 0 ] [ 1 ]   ;
			'''
		]
	}

	@Test def void testMemberFeatureCallArrayAccesses() {
		assertFormatted[
			expectation = '''
				args[0].length;
				args[0][1].length;
			'''
			toBeFormatted = '''
				args  [ 0 ]   . length   ;
				args  [ 0 ] [ 1 ]  . length   ;
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

	@Test def void testMethodWithComment() {
		assertFormatted[
			expectation = '''
				/**
				 * This is a comment
				 */
				int m(int i, final String s) {
					return 0;
				}
			'''
			toBeFormatted = '''
				/**
				 * This is a comment
				 */
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

	@Test def void testPostfixOperator() {
		assertFormatted[
			expectation = '''
				i++;
			'''
			toBeFormatted = '''
				i  ++  ;
			'''
		]
	}

	@Test def void testCasted() {
		assertFormatted[
			expectation = '''
				(String) s;
			'''
			toBeFormatted = '''
				(  String  )   s ;
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

	@Test def void testArrayConstructorCall() {
		assertFormatted[
			expectation = '''
				new List<Integer, String>[0][1];
			'''
			toBeFormatted = '''
				new  List  < Integer  ,  String  >  [ 0 ] [  1  ]  ;
			'''
		]
	}

	@Test def void testArrayConstructorCallWithArrayLiteral() {
		assertFormatted[
			expectation = '''
				new List[1][] {0, 1, 1 + 2};
				new List[1][2] {0, 1, 1 + 2};
				new List[][2] {0, 1, 1 + 2};
				new List[][] {0, 1, 1 + 2};
				new List[][];
			'''
			toBeFormatted = '''
				new  List    [  1  ] [    ]  {0 ,  1  ,  1+2 };
				new  List    [  1  ] [  2  ]  {0 ,  1  ,  1+2 };
				new  List    [    ] [  2  ]  {0 ,  1  ,  1+2 };
				new  List    [    ] [    ]  {0 ,  1  ,  1+2 };
				new  List    [    ] [    ]  ;
			'''
		]
	}

	@Test def void testArrayLiteral() {
		assertFormatted[
			expectation = '''
				int[] a = {0, 1, 1 + 2};
				int[][] b = {{0, 1}, 1 + 2};
			'''
			toBeFormatted = '''
				int[] a = { 0 , 1 ,  1  +  2 } ;
				int[][] b = { { 0 ,  1 } , 1 + 2};
			'''
		]
	}

	@Test def void testBasicForLoop() {
		assertFormatted[
			expectation = '''
				for (int i = 0; i < argsNum; i += 1) {
					System.out.println("args[" + i + "] = " + args[i]);
				}
			'''
			toBeFormatted = '''
				for  (int  i  =  0  ; i  <  argsNum ;  i  +=  1 )  {
					System.out.println ( "args[" + i + "] = " + args[i] );
				}
			'''
		]
	}

	@Test def void testForEachLoop() {
		assertFormatted[
			expectation = '''
				for (String s : strings)
					continue;
				for (String s : strings)
					System.out.println(s);
				for (String s : strings) {
					System.out.println(s);
				}
				for (final String s : strings) {
					System.out.println(s);
				}
			'''
			toBeFormatted = '''
				for ( String  s  :  strings )
					continue ;
				for ( String  s  :  strings )
					System.out.println(s) ;
				for  ( String  s  :  strings )  {
					System.out.println ( s ) ;
				}
				for  (  final  String  s  :  strings )  {
					System.out.println ( s ) ;
				}
			'''
		]
	}

	@Test def void testBranchingStatements() {
		assertFormatted[
			expectation = '''
				continue;
				break;
			'''
			toBeFormatted = '''
				continue ;  break   ;
			'''
		]
	}

	@Test def void testIfStatements() {
		assertFormatted[
			expectation = '''
				if (args.length() == 0)
					System.out.println("No args");
				else
					System.out.println("Args");
				if (args.length() == 0)
					System.out.println("No args");
				else
					System.out.println("Args");
				if (args.length() == 0) {
					System.out.println("No args");
				} else {
					System.out.println("Args");
				}
				if (args.length() == 0) {
					System.out.println("No args");
				} else if (args.length() == 0) {
					System.out.println("Args");
				}
				if (args.length() == 0) {
					System.out.println("No args");
				}
			'''
			toBeFormatted = '''
				if  ( args.length( )  ==  0 )
					System.out.println ("No args") ; 
				else 	System.out.println( "Args");
				if  ( args.length( )  ==  0 )
					System.out.println ("No args") ; 	else 	System.out.println( "Args");
				if  ( args.length( )  ==  0 )   {
					System.out.println ("No args");  }
				else 	{System.out.println( "Args"); }
				if  ( args.length( )  ==  0 )   {
					System.out.println ("No args");  }
				else  if  ( args.length( )  ==  0 ) 	{System.out.println( "Args"); }
				if  ( args.length( )  ==  0 )   {
					System.out.println ("No args");  }
			'''
		]
	}

	@Test def void testWhileStatements() {
		assertFormatted[
			expectation = '''
				while (args.length() == 0)
					System.out.println("No args");
				while (args.length() == 0) {
					System.out.println("No args");
				}
			'''
			toBeFormatted = '''
				while  ( args.length( )  ==  0 )
					System.out.println ("No args") ; 
				while ( args.length( )  ==  0 )   {
					System.out.println ("No args");  }
			'''
		]
	}

	@Test def void testDoWhileStatements() {
		assertFormatted[
			expectation = '''
				do  
					System.out.println("No args");
				while (args.length() == 0) ;
				do {
					System.out.println("No args");
				} while (args.length() == 0) ;
			'''
			toBeFormatted = '''
				do  
					System.out.println ("No args") ; 
				while  ( args.length( )  ==  0 ) ;
				do  {
					System.out.println ("No args") ; 
				}   while  ( args.length( )  ==  0 ) ;
			'''
		]
	}

	@Test def void testConditionalExpression() {
		assertFormatted[
			expectation = '''
				int i = j > 0 ? 1 : '2';
				int j = ( j > 0 ? 1 : '2' );
			'''
			toBeFormatted = '''
				int i =  j  >  0  ?  1  :  '2' ;
				int j =  ( j  >  0  ?  1  :  '2' ) ;
			'''
		]
	}

	@Test def void testSwitch() {
		assertFormatted[
			expectation = '''
				switch (argsNum) {
					case 0: System.out.println("0");
					default: System.out.println("default");
				}
			'''
			toBeFormatted = '''
				switch  ( argsNum )  {
					case 0  :  System.out.println("0");
					default  :  System.out.println("default");
				}
			'''
		]
	}
}