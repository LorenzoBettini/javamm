package javamm.mwe2.contentassist

import com.google.inject.Inject
import org.eclipse.xpand2.XpandFacade
import org.eclipse.xtext.Grammar
import org.eclipse.xtext.generator.Generator
import org.eclipse.xtext.generator.Naming
import org.eclipse.xtext.generator.Xtend2ExecutionContext
import org.eclipse.xtext.ui.generator.contentAssist.ContentAssistFragment

/**
 * Modified for https://bugs.eclipse.org/bugs/show_bug.cgi?id=471434
 * 
 * @author Lorenzo Bettini
 */
class JavammContentAssistFragment extends ContentAssistFragment {

	@Inject extension Naming

	@Inject Grammar grammar

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
			"javamm::mwe2::contentassist::JavammJavaBasedContentAssistFragment::GenProposalProvider", 
			grammar, 
			<Object>newArrayList(superClassName)
		);
	}
	
}