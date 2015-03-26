/**
 * 
 */
package javamm.typesystem;

import java.util.List;

import org.eclipse.xtext.common.types.JvmPrimitiveType;
import org.eclipse.xtext.common.types.util.Primitives;
import org.eclipse.xtext.common.types.util.Primitives.Primitive;
import org.eclipse.xtext.xbase.XNumberLiteral;
import org.eclipse.xtext.xbase.typesystem.computation.ITypeComputationState;
import org.eclipse.xtext.xbase.typesystem.computation.ITypeExpectation;
import org.eclipse.xtext.xbase.typesystem.computation.XbaseTypeComputer;
import org.eclipse.xtext.xbase.typesystem.references.LightweightTypeReference;

import com.google.inject.Inject;

/**
 * Type computation for number literals takes expectations into account.
 * 
 * @author Lorenzo Bettini
 *
 */
public class PatchedTypeComputer extends XbaseTypeComputer {
	
	@Inject
	private Primitives primitives;
	
	/**
	 * The original implementation in Xbase does not consider possible type expectations,
	 * failing to correctly type these cases, which are valid in Java:
	 * 
	 * <pre>
	 * byte b = 100;
	 * short s = 1000;
	 * char c = 1000;
	 * </pre>
	 */
	@Override
	protected void _computeTypes(XNumberLiteral object, ITypeComputationState state) {
		List<? extends ITypeExpectation> expectations = state.getExpectations();
		for (ITypeExpectation typeExpectation : expectations) {
			LightweightTypeReference expectedType = typeExpectation.getExpectedType();
			if (expectedType != null && expectedType.getType() instanceof JvmPrimitiveType) {
				Primitive kind = primitives.primitiveKind((JvmPrimitiveType)expectedType.getType());
				if (checkConversionToPrimitive(object, kind)) {
					state.acceptActualType(expectedType);
					return;
				}
			}
		}
		
		super._computeTypes(object, state);
	}

	private boolean checkConversionToPrimitive(XNumberLiteral object,
			Primitive kind) {
		boolean success = true;
		String value = object.getValue();
		try {
			switch(kind) {
			case Byte:
				Byte.parseByte(value);
				break;
			case Short:
				Short.parseShort(value);
				break;
			case Char:
				int parsed = Integer.parseInt(value);
				success = parsed <= Character.MAX_VALUE;
				break;
			default:
				success = false;
				break;
			}
			
		} catch (NumberFormatException e) {
			success = false;
		}
		return success;
	}
}
