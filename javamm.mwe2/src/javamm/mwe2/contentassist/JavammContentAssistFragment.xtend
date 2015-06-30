package javamm.mwe2.contentassist

import com.google.inject.Inject
import org.eclipse.xpand2.XpandFacade
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.Grammar
import org.eclipse.xtext.generator.BindFactory
import org.eclipse.xtext.generator.Generator
import org.eclipse.xtext.generator.IInheriting
import org.eclipse.xtext.generator.IStubGenerating
import org.eclipse.xtext.generator.Naming
import org.eclipse.xtext.generator.Xtend2ExecutionContext
import org.eclipse.xtext.generator.Xtend2GeneratorFragment

import static java.util.Collections.*
import static org.eclipse.xtext.GrammarUtil.*

class JavammContentAssistFragment extends Xtend2GeneratorFragment implements IInheriting, IStubGenerating {

	@Inject extension ContentAssistFragmentExtensions

	@Inject extension Naming

	@Inject Grammar grammar

	@Accessors boolean inheritImplementation = true

	@Accessors boolean generateStub = true;
	
	def String getProposalProviderName(Grammar grammar) {
		return grammar.basePackageUi + ".contentassist." + getName(grammar) + "ProposalProvider"
	}
	
	def String getGenProposalProviderName() {
		return grammar.basePackageUi + ".contentassist.Abstract" + getName(grammar) + "ProposalProvider"
	}
	
	override getGuiceBindingsUi(Grammar grammar) {
		val bindFactory = new BindFactory()
		if(generateStub)
			bindFactory
				.addTypeToType('org.eclipse.xtext.ui.editor.contentassist.IContentProposalProvider',
						grammar.proposalProviderName)
		else 
			bindFactory
				.addTypeToType('org.eclipse.xtext.ui.editor.contentassist.IContentProposalProvider',
						genProposalProviderName)
		bindFactory.bindings
	}
	
	override getRequiredBundlesUi(Grammar grammar) {
		if(generateStub)
			newArrayList('org.eclipse.xtext.ui', 'org.eclipse.xtext.xbase.lib')
		else
			singletonList('org.eclipse.xtext.ui')
	}
	
	override getImportedPackagesUi(Grammar grammar) {
		singleton('org.apache.log4j')
	}
	
	override getExportedPackagesUi(Grammar grammar) {
		singletonList(grammar.proposalProviderName.packageName)
	}
	
	def getSuperClassName() {
		val superGrammar = getSuperGrammar()
		if(inheritImplementation && superGrammar != null)
			superGrammar.proposalProviderName
		else
			"org.eclipse.xtext.ui.editor.contentassist.AbstractJavaBasedContentProposalProvider"
				
	}
	
	override generate(Xtend2ExecutionContext ctx) {
		if(generateStub) {
			ctx.writeFile(Generator::SRC_UI, grammar.proposalProviderName.asPath + '.xtend', '''
				«fileHeader»
				package «grammar.proposalProviderName.packageName»
				
				import «genProposalProviderName»
				
				/**
				 * See https://www.eclipse.org/Xtext/documentation/304_ide_concepts.html#content-assist
				 * on how to customize the content assistant.
				 */
				class «grammar.proposalProviderName.toSimpleName» extends «genProposalProviderName.toSimpleName» {
				}
			''')
		}

		XpandFacade::create(ctx.xpandExecutionContext).evaluate2(
			"javamm::mwe2::contentassist::JavaBasedContentAssistFragment::GenProposalProvider", 
			grammar, 
			<Object>newArrayList(superClassName, getFqFeatureNamesToExclude)
		);
	}
	
}