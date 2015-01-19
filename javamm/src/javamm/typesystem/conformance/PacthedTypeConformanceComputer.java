/**
 * 
 */
package javamm.typesystem.conformance;

import org.eclipse.xtext.xbase.typesystem.conformance.TypeConformanceComputer;
import org.eclipse.xtext.xbase.typesystem.references.LightweightTypeReference;

/**
 * https://bugs.eclipse.org/bugs/show_bug.cgi?id=457779
 * 
 * @author Lorenzo Bettini
 *
 */
public class PacthedTypeConformanceComputer extends TypeConformanceComputer {

	@Override
	public int isConformant(LightweightTypeReference left, LightweightTypeReference right, int flags) {
		if ((flags & (ALLOW_BOXING_UNBOXING | ALLOW_PRIMITIVE_WIDENING)) != 0) {
			final String booleanName = Boolean.TYPE.getName();
			if (left.isPrimitive() && right.isPrimitive()
					&& left.getSimpleName().equals(booleanName)
					&& !right.getSimpleName().equals(booleanName)) {
				return flags | INCOMPATIBLE;
			}
		}
		return super.isConformant(left, right, flags);
	}
}
