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
			toBeFormatted = '''
				int  i;
			'''
		]
	}
}