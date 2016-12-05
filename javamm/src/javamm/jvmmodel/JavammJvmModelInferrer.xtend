package javamm.jvmmodel

import com.google.inject.Inject
import javamm.javamm.JavammProgram
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.xbase.jvmmodel.AbstractModelInferrer
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder

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

	@Inject extension IQualifiedNameProvider

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
		val className = program.fullyQualifiedName

		acceptor.accept(program.toClass(className)) [
			for (m : program.javammMethods) {
				members += m.toMethod(m.name, m.type) [
					documentation = m.documentation
					static = true
					for (p : m.params) {
						var parameterType = p.parameterType
						if (p.varArgs) {
							// varArgs is a property of JvmExecutable
							varArgs = p.varArgs
							parameterType = parameterType.addArrayTypeDimension
						}
						parameters += p.toParameter(p.name, parameterType)
					}
					body = m.body
				]
			}

			// to make org.eclipse.xtext.xbase.imports.TypeUsageCollector.collectAllReferences(EObject) find
			// all used type references and thus to make OrganizeImports work, we must associate the Java main
			// method to the Main model element.
			// the class gets one main method
			members += main.toMethod('main', typeRef(Void.TYPE)) [
				parameters += main.toParameter("args", typeRef(String).addArrayTypeDimension)
				static = true
				// Associate the script as the body of the main method
				body = main
			]
		]
	}
}
