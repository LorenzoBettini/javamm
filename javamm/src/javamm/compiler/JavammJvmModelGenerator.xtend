package javamm.compiler

import com.google.inject.Inject
import javamm.util.JavammModelUtil
import org.eclipse.xtext.common.types.JvmFormalParameter
import org.eclipse.xtext.common.types.JvmGenericArrayTypeReference
import org.eclipse.xtext.xbase.compiler.GeneratorConfig
import org.eclipse.xtext.xbase.compiler.JvmModelGenerator
import org.eclipse.xtext.xbase.compiler.output.ITreeAppendable

/**
 * All parameters are NOT final.
 * 
 * @author Lorenzo Bettini
 */
class JavammJvmModelGenerator extends JvmModelGenerator {
	
	@Inject extension JavammModelUtil
	
	/**
	 * Copied from JvmModelGenerator but avoid generating "final"
	 */
	override void generateParameter(JvmFormalParameter it, ITreeAppendable appendable, boolean vararg, GeneratorConfig config) {
		val tracedAppendable = appendable.trace(it)
		annotations.generateAnnotations(tracedAppendable, false, config)
		
		// all parameters are NOT final by default
		val originalParam = it.originalParam
		if (originalParam != null && originalParam.isFinal()) {
			tracedAppendable.append("final ")	
		}

		if (vararg) {
			if (! (parameterType instanceof JvmGenericArrayTypeReference)) {
				tracedAppendable.append("/* Internal Error: Parameter was vararg but not an array type. */");
			} else {
				(parameterType as JvmGenericArrayTypeReference).componentType.serializeSafely("Object", tracedAppendable)
			}
			tracedAppendable.append("...")
		} else {
			parameterType.serializeSafely("Object", tracedAppendable)
		}
		tracedAppendable.append(" ")
		val name = tracedAppendable.declareVariable(it, makeJavaIdentifier(simpleName))
		tracedAppendable.traceSignificant(it).append(name)
	}
}