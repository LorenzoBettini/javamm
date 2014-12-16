/**
 * 
 */
package javamm.javamm.impl;

import javamm.javamm.JavammXVariableDeclaration;

import org.eclipse.xtext.xbase.impl.XVariableDeclarationImplCustom;

/**
 * @author Lorenzo Bettini
 *
 */
public class JavammXVariableDeclarationImplCustom extends XVariableDeclarationImplCustom implements JavammXVariableDeclaration  {

	@Override
	public boolean isWriteable() {
		// in our language all variable declarations are considered NOT final
		return true;
	}
}
