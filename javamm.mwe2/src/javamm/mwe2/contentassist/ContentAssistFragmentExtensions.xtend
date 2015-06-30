package javamm.mwe2.contentassist

import com.google.common.collect.Sets
import com.google.inject.Inject
import java.util.Set
import org.eclipse.xtext.AbstractRule
import org.eclipse.xtext.Assignment
import org.eclipse.xtext.Grammar

import static extension org.eclipse.xtext.GrammarUtil.*

/**
 * @author Lorenzo Bettini - Initial contribution and API
 */
class ContentAssistFragmentExtensions {

	@Inject Grammar grammar

	def String getFqFeatureName(Assignment it) {
		containingParserRule().name.toFirstUpper() + "_" + feature.toFirstUpper();
	}

	def String getFqFeatureName(AbstractRule it) {
		"_" + name;
	}

	def getSuperGrammar() {
		grammar.usedGrammars.head
	}

	def Set<String> getFqFeatureNamesToExclude() {
		var Set<String> toExclude = <String>newHashSet()

		val superGrammar = getSuperGrammar()
		if (superGrammar != null) {
			val superGrammarsFqFeatureNames = computeFqFeatureNamesFromSuperGrammars
			val thisGrammarFqFeatureNames = computeFqFeatureNames(grammar).toSet

			// all elements that are not already defined in some inherited grammars
			toExclude = Sets.intersection(thisGrammarFqFeatureNames, superGrammarsFqFeatureNames)
		}

		return toExclude
	}

	def private computeFqFeatureNamesFromSuperGrammars() {
		val superGrammars = newHashSet()
		computeAllSuperGrammars(grammar, superGrammars)
		superGrammars.map[computeFqFeatureNames].flatten.toSet
	}

	def private computeFqFeatureNames(Grammar grammar) {
		grammar.containedAssignments.map[fqFeatureName] + grammar.rules.map[fqFeatureName]
	}

	def private void computeAllSuperGrammars(Grammar current, Set<Grammar> visitedGrammars) {
		for (s : current.usedGrammars) {
			if (!visitedGrammars.contains(s)) {
				visitedGrammars.add(s)
				computeAllSuperGrammars(s, visitedGrammars)
			}
		}
	}

}