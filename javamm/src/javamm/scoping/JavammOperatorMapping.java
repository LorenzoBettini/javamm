/**
 * 
 */
package javamm.scoping;

import static org.eclipse.xtext.naming.QualifiedName.create;

import org.eclipse.xtext.xbase.scoping.featurecalls.OperatorMapping;

import com.google.inject.Singleton;

/**
 * To make '==' be translated exactly to '==' as in Java, not
 * into 'equals' like it happens by default in Xbase for objects.
 * 
 * @author Lorenzo Bettini
 *
 */
@Singleton
public class JavammOperatorMapping extends OperatorMapping {
	
	/**
	 * Special method on array that is called without parenthesis
	 */
	public static String ARRAY_LENGTH = "length";
	
	@Override
	protected void initializeMapping() {
		super.initializeMapping();
		
		map.remove(TRIPLE_EQUALS);
		map.put(EQUALS, create(OP_PREFIX+"tripleEquals"));
		
		map.remove(TRIPLE_NOT_EQUALS);
		map.put(NOT_EQUALS, create(OP_PREFIX+"tripleNotEquals"));
	}
}
