package javamm.tests

import com.google.inject.Inject
import javamm.JavammInjectorProvider
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

	@Test def void testMemberFeatureCallArrayAccesses() {
		'''
		args  [ 0 ]   . length;
		'''.assertSerialize
	}

	def private assertSerialize(CharSequence input) {
		val o = input.parse
		input.toString.assertEquals(serializer.serialize(o))
	}
}