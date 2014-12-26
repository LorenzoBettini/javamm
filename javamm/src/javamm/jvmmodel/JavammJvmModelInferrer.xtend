package javamm.jvmmodel

import com.google.inject.Inject
import org.eclipse.xtext.xbase.jvmmodel.AbstractModelInferrer
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import javamm.javamm.JavammProgram

/**
 * <p>Infers a JVM model from the source model.</p> 
 *
 * <p>The JVM model should contain all elements that would appear in the Java code 
 * which is generated from the source model. Other models link against the JVM model rather than the source model.</p>     
 */
class JavammJvmModelInferrer extends AbstractModelInferrer {

    /**
     * convenience API to build and initialize JVM types and their members.
     */
	@Inject extension JvmTypesBuilder

	/**
	 * The dispatch method {@code infer} is called for each instance of the
	 * given element's type that is contained in a resource.
	 * 
	 * @param element
	 *            the model to create one or more
	 *            {@link org.eclipse.xtext.common.types.JvmDeclaredType declared
	 *            types} from.
	 * @param acceptor
	 *            each created
	 *            {@link org.eclipse.xtext.common.types.JvmDeclaredType type}
	 *            without a container should be passed to the acceptor in order
	 *            get attached to the current resource. The acceptor's
	 *            {@link IJvmDeclaredTypeAcceptor#accept(org.eclipse.xtext.common.types.JvmDeclaredType)
	 *            accept(..)} method takes the constructed empty type for the
	 *            pre-indexing phase. This one is further initialized in the
	 *            indexing phase using the closure you pass to the returned
	 *            {@link org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor.IPostIndexingInitializing#initializeLater(org.eclipse.xtext.xbase.lib.Procedures.Procedure1)
	 *            initializeLater(..)}.
	 * @param isPreIndexingPhase
	 *            whether the method is called in a pre-indexing phase, i.e.
	 *            when the global index is not yet fully updated. You must not
	 *            rely on linking using the index if isPreIndexingPhase is
	 *            <code>true</code>.
	 */
   	def dispatch void infer(JavammProgram program, IJvmDeclaredTypeAcceptor acceptor, boolean isPreIndexingPhase) {
   		val main = program.main
   		val className = program.eResource.URI.trimFileExtension.lastSegment
   		
   		acceptor.accept(program.toClass(className)) [
   			for (m : program.javammMethods) {
   				members += m.toMethod(m.name, m.type) [
   					documentation = m.documentation
   					
   					static = true
   					
   					for (p : m.params) {
   						parameters += p.toParameter(p.name, p.parameterType)
   					}
   					
   					body = m.body
   				]
   			}
   			
   			// the class gets one main method
   			members += program.toMethod('main', typeRef(Void.TYPE)) [
   				parameters += program.toParameter("args", typeRef(String).addArrayTypeDimension)
   				static = true
   				// Associate the script as the body of the main method
   				body = main
   			]	
   		]
   	}
}

