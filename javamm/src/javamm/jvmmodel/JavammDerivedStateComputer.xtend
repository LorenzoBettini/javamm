package javamm.jvmmodel

import org.eclipse.xtext.xbase.jvmmodel.JvmModelAssociator
import org.eclipse.xtext.resource.DerivedStateAwareResource
import org.eclipse.xtext.xbase.XVariableDeclaration

/**
 * We set some values in some classes as defaults (for example, all variable
 * declarations are NOT final in our language)
 * 
 * @author Lorenzo Bettini
 */
class JavammDerivedStateComputer extends JvmModelAssociator {
	
	override installDerivedState(DerivedStateAwareResource resource, boolean preIndexingPhase) {
		if (!preIndexingPhase) {
			// in our language all variable declarations are considered NOT final
			resource.allContents.filter(XVariableDeclaration).forEach [
		    	writeable = true
		    ]
		}
		super.installDerivedState(resource, preIndexingPhase)
	}
	
}