/**
 */
package javamm.javamm.impl;

import javamm.javamm.JavammPackage;
import javamm.javamm.JavammPrefixOperation;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.xtext.xbase.impl.XPostfixOperationImplCustom;

/**
 * @author Lorenzo Bettini
 *
 */
public class JavammPrefixOperationImplCustom extends XPostfixOperationImplCustom implements JavammPrefixOperation
{
	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass()
	{
		return JavammPackage.Literals.JAVAMM_PREFIX_OPERATION;
	}

} //JavammPrefixOperationImpl
