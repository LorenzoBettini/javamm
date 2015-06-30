package javamm.mwe2.contentassist

import com.google.common.collect.Sets
import java.util.Set
import org.eclipse.xtext.AbstractRule
import org.eclipse.xtext.Assignment
import org.eclipse.xtext.Grammar

import static extension org.eclipse.xtext.GrammarUtil.*

/**
 * Created for https://bugs.eclipse.org/bugs/show_bug.cgi?id=471434
 * 
 * @author Lorenzo Bettini - Initial contribution and API
 */
class ContentAssistFragmentExtensions {

	def static String getFqFeatureName(Assignment it) {
		containingParserRule().name.toFirstUpper() + "_" + feature.toFirstUpper();
	}

	def static String getFqFeatureName(AbstractRule it) {
		"_" + name;
	}

	def static Grammar getSuperGrammar(Grammar grammar) {
		grammar.usedGrammars.head
	}

	def static Set<String> getFqFeatureNamesToExclude(Grammar grammar) {
		var Set<String> toExclude = <String>newHashSet()

		val superGrammar = getSuperGrammar(grammar)
		if (superGrammar != null) {
			val superGrammarsFqFeatureNames = computeFqFeatureNamesFromSuperGrammars(grammar)
			val thisGrammarFqFeatureNames = computeFqFeatureNames(grammar).toSet

			// all elements that are not already defined in some inherited grammars
			toExclude = Sets.intersection(thisGrammarFqFeatureNames, superGrammarsFqFeatureNames)
		}

		return toExclude
	}

	def static private Set<String> computeFqFeatureNamesFromSuperGrammars(Grammar grammar) {
		val superGrammars = newHashSet()
		computeAllSuperGrammars(grammar, superGrammars)
		superGrammars.map[computeFqFeatureNames].flatten.toSet
	}

	def static private Iterable<String> computeFqFeatureNames(Grammar grammar) {
		grammar.containedAssignments.map[fqFeatureName] + grammar.rules.map[fqFeatureName]
	}

	def static private void computeAllSuperGrammars(Grammar current, Set<Grammar> visitedGrammars) {
		for (s : current.usedGrammars) {
			if (!visitedGrammars.contains(s)) {
				visitedGrammars.add(s)
				computeAllSuperGrammars(s, visitedGrammars)
			}
		}
	}

}