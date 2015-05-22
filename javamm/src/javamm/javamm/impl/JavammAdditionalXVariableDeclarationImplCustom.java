/**
 * 
 */
package javamm.javamm.impl;

import javamm.javamm.JavammAdditionalXVariableDeclaration;
import javamm.javamm.JavammXVariableDeclaration;

import org.eclipse.xtext.common.types.JvmTypeReference;
import org.eclipse.xtext.xbase.impl.XVariableDeclarationImplCustom;

/**
 * Custom implementation so that isWritable is always true, so that
 * the declared type is implicitly the one of the containing variable declaration.
 * 
 * @author Lorenzo Bettini
 *
 */
public class JavammAdditionalXVariableDeclarationImplCustom extends XVariableDeclarationImplCustom implements JavammAdditionalXVariableDeclaration  {

	@Override
	public boolean isWriteable() {
		// in our language all variable declarations are considered NOT final by default
		return getContainingVariableDeclaration().isWriteable();
	}

	/**
	 * Custom implementation that returns the type of the containing variable declaration.
	 * 
	 * @see org.eclipse.xtext.xbase.impl.XVariableDeclarationImpl#getType()
	 */
	@Override
	public JvmTypeReference getType() {
		return getContainingVariableDeclaration().getType() ;
	}

	protected JavammXVariableDeclaration getContainingVariableDeclaration() {
		return (JavammXVariableDeclaration)eContainer();
	}
}
