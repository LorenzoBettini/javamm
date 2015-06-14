/**
 * 
 */
package javamm.javamm.impl;

import javamm.javamm.JavammXVariableDeclaration;

/**
 * Custom implementation so that isWritable is always true.
 * 
 * @author Lorenzo Bettini
 *
 */
public class JavammXVariableDeclarationImplCustom extends JavammXVariableDeclarationImpl implements JavammXVariableDeclaration  {

	@Override
	public boolean isWriteable() {
		// in our language all variable declarations are considered writable
		// by default.
		return !isFinal();
	}

}
