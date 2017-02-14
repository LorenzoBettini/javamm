package javamm.tests

import com.google.inject.Inject
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.util.ReplaceRegion
import org.eclipse.xtext.xbase.imports.ImportOrganizer
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammInjectorProvider))
class JavammOrganizeImportsTest extends JavammAbstractTest {
	@Inject ImportOrganizer importOrganizer

	def protected assertIsOrganizedTo(CharSequence model, CharSequence expected) {
		val program = parse(model)
		val changes = importOrganizer.getOrganizedImportChanges(program.eResource as XtextResource)
		val builder = new StringBuilder(model)
		val sortedChanges= changes.sortBy[offset]
		var ReplaceRegion lastChange = null
		// in our DSL the following would fail for inputs such as
		// "java.io.Serializable s = null;"
		// so we must make sure to have enough leading whitespaces in the input
		for(it: sortedChanges) {
			if(lastChange !== null && lastChange.endOffset > offset)
				fail("Overlapping text edits: " + lastChange + ' and ' +it)
			lastChange = it
		}
		for(it: sortedChanges.reverse)
			builder.replace(offset, offset + length, text)
		assertEquals(expected.toString, builder.toString)
	}

	@Test def testDefaultPackage() {
		'''
			«»
			   	
			java.io.Serializable s = null;
		'''.assertIsOrganizedTo('''
			import java.io.Serializable;

			Serializable s = null;
		''')
	}

	@Test def testDefaultPackages() {
		'''
			«»
			   	
			java.io.Serializable s = null;
			java.util.List l = null;
		'''.assertIsOrganizedTo('''
			import java.io.Serializable;
			import java.util.List;
			
			Serializable s = null;
			List l = null;
		''')
	}

	@Test def testDefaultPackagesSorted() {
		'''
			import java.util.List;
			import java.io.Serializable;

			Serializable s = null;
			List l = null;
		'''.assertIsOrganizedTo('''
			import java.io.Serializable;
			import java.util.List;
			
			Serializable s = null;
			List l = null;
		''')
	}
}