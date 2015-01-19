package javamm.tests

import com.google.inject.Inject
import javamm.JavammInjectorProvider
import org.eclipse.xtext.formatting.INodeModelFormatter
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.resource.XtextResource
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammInjectorProvider))
class JavammFormatterTest extends JavammAbstractTest {
	
	@Inject extension INodeModelFormatter;

	@Test def void testVariableDeclaration() {
		'''
		int  i  = 1 ;
		'''.assertFormattedAs("int i = 1;")
	}

	@Test def void testMain() {
		'''
		int  i  = 1 ;int  k  = 1 ;
		'''.assertFormattedAs(
		'''
		int i = 1;
		int k = 1;'''
		)
	}

	@Test def void testBlock() {
		'''
		{ int i = 1; boolean b ; }
		'''.assertFormattedAs(
		'''
		{
			int i = 1;
			boolean b;
		}'''
		)
	}

	@Test def void testMethod() {
		'''
		void m(  String  s  ,  int  k   ){ int i = 1; boolean b ; }
		'''.assertFormattedAs(
		'''
		void m(String s, int k) {
			int i = 1;
			boolean b;
		}'''
		)
	}

	@Test def void testMethods() {
		'''
		void m(  String  s  ,  int  k   ){ int i = 1; boolean b ; }void n(  String  s  ,  int  k   ){ int i = 1; boolean b ; }
		'''.assertFormattedAs(
		'''
		void m(String s, int k) {
			int i = 1;
			boolean b;
		} void n(String s, int k) {
			int i = 1;
			boolean b;
		}'''
		)
	}

	@Test def void testIfThenElse() {
		'''
		String s = "";
		if (s != null){ int i = 1; int k = 0; }else{ boolean b; }
		'''.assertFormattedAs(
		'''
		String s = "";
		if (s != null) {
			int i = 1;
			int k = 0;
		} else {
			boolean b;
		}'''
		)
	}

	@Test def void testWhile() {
		'''
		String s = "";
		while  ( s == ""  ) {  s+=" ";}
		'''.assertFormattedAs(
		'''
		String s = "";
		while (s == "") {
			s += " ";
		}'''
		)
	}

	@Test def void testDoWhile() {
		'''
		String s = "";
		do  {  s+=" ";}  while  ( s == ""  ) ;
		'''.assertFormattedAs(
		'''
		String s = "";
		do {
			s += " ";
		} while (s == "");'''
		)
	}

	@Test def void testFor() {
		'''
		for  (  int i = 0  ; i  <  10; i++  ) {  int  k = i;  }
		'''.assertFormattedAs(
		'''
		for (int i = 0; i < 10; i++) {
			int k = i;
		}'''
		)
	}

	@Test def void testMemberFeatureCall() {
		'''
		String s = "";
		s.length();
		'''.assertFormattedAs(
		'''
		String s = "";
		s.length();'''
		)
	}

	@Test def void testMemberFeatureCall2() {
		'''
		String s = "";
		System.out.println( "s" + s  );
		'''.assertFormattedAs(
		'''
		String s = "";
		System.out.println("s" + s);'''
		)
	}

	@Test def void testFeatureCall() {
		'''
		int[] a;
		a [ 1 ] =  a [ 2 ];
		'''.assertFormattedAs(
		'''
		int [] a;
		a [ 1 ] = a[2];'''
		)
	}

	@Test def void testMultiArrayAccess() {
		'''
		int[][] a;
		a [ 1 ] =  a [ 2 ] [  1 ];
		'''.assertFormattedAs(
		'''
		int [] [] a;
		a [ 1 ] = a[2][ 1 ];'''
		)
	}

	@Test def void testPreAndPostfix() {
		'''
		i++;
		++i;
		'''.assertFormattedAs(
		'''
		i++;
		++i;'''
		)
	}

	def private void assertFormattedAs(CharSequence input, CharSequence expected) {
		expected.toString.assertEquals(
			(input.parse.eResource as XtextResource).parseResult.rootNode.format(0, input.length).formattedText)
	}
}