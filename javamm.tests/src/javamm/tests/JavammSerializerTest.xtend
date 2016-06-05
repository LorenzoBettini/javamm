package javamm.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.serializer.impl.Serializer
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammInjectorProvider))
class JavammSerializerTest extends JavammAbstractTest {

	@Inject Serializer serializer

	@Test def void testAssignmentLeft() {
		assertSerialize('''
		i = 1;
		''')
	}

	@Test def void testVariableDeclarations() {
		'''
		int  i , j , k ;
		'''.assertSerialize
	}

	@Test def void testMemberFeatureCall() {
		'''
		System.out.println("a");
		'''.assertSerialize
	}

	@Test def void testMemberFeatureCallArrayAccesses() {
		'''
		args  [ 0 ]   . length;
		'''.assertSerialize
	}

	@Test def void testMemberFeatureCallArrayAccesses2() {
		'''
		args  [ 0 ] [ 1 ]   . length;
		'''.assertSerialize
	}

	@Test def void testMemberFeatureCallArrayAccessesWithParenthesis() {
		'''
		args  [ 0 ]   . length();
		'''.assertSerialize
	}

	@Test def void testMemberFeatureCallArrayAccessesWithArguments() {
		'''
		args  [ 0 ]   . length(0);
		'''.assertSerialize
	}

	@Test def void testMemberFeatureCallArrayAccessesWithArguments2() {
		'''
		args  [ 0 ]   . length(0,1);
		'''.assertSerialize
	}

	@Test def void testBinaryOperator() {
		'''
		for  (int  i  =  0  ; i  <  argsNum ;  i  +=  1 )  {
			
		}
		'''.assertSerialize
	}

	@Test def void testBinaryOperator2() {
		'''
		int j = 1 + 0;
		'''.assertSerialize
	}

	@Test def void testBreak() {
		'''
		while (true) {
			break ;
		}
		'''.assertSerialize
	}

	@Test def void testBreak2() {
		'''
		while (true)
			break ;
		'''.assertSerialize
	}

	@Test def void testCast() {
		'''
		(Object) o;
		'''.assertSerialize
	}

	@Test def void testConditional() {
		'''
		1 > 0 ? true : false;
		'''.assertSerialize
	}

	@Test def void testArrayDimensions() {
		'''
		new List[1][] {0, 1, 1 + 2};
		new List[1][2] {0, 1, 1 + 2};
		'''.assertSerialize
	}

	@Test def void testArrayDimensions2() {
		'''
		new List[][2] {0, 1, 1 + 2};
		new List[][] {0, 1, 1 + 2};
		new List[][];
		'''.assertSerialize
	}

	@Test def void testArrayDimensions3() {
		'''
		new List[][2][][1] {0, 1, 1 + 2};
		'''.assertSerialize
	}

	def private assertSerialize(CharSequence input) {
		val o = input.parse
		input.toString.assertEquals(serializer.serialize(o))
	}
}