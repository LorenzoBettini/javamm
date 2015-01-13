/**
 * 
 */
package javamm.javamm.impl;

import java.util.Collection;

import javamm.javamm.JavammPackage;
import javamm.javamm.JavammXVariableDeclaration;

import org.eclipse.emf.common.notify.NotificationChain;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;
import org.eclipse.emf.ecore.util.EObjectContainmentEList;
import org.eclipse.emf.ecore.util.InternalEList;
import org.eclipse.xtext.xbase.XVariableDeclaration;
import org.eclipse.xtext.xbase.impl.XVariableDeclarationImplCustom;

/**
 * Custom implementation so that isWritable is always true.
 * 
 * @author Lorenzo Bettini
 *
 */
public class JavammXVariableDeclarationImplCustom extends XVariableDeclarationImplCustom implements JavammXVariableDeclaration  {

	@Override
	public boolean isWriteable() {
		// in our language all variable declarations are considered NOT final
		return true;
	}
	
	/**
	 * The cached value of the '{@link #getAdditionalVariables() <em>Additional Variables</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getAdditionalVariables()
	 * @generated
	 * @ordered
	 */
	protected EList<XVariableDeclaration> additionalVariables;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass()
	{
		return JavammPackage.Literals.JAVAMM_XVARIABLE_DECLARATION;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<XVariableDeclaration> getAdditionalVariables()
	{
		if (additionalVariables == null)
		{
			additionalVariables = new EObjectContainmentEList<XVariableDeclaration>(XVariableDeclaration.class, this, JavammPackage.JAVAMM_XVARIABLE_DECLARATION__ADDITIONAL_VARIABLES);
		}
		return additionalVariables;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs)
	{
		switch (featureID)
		{
			case JavammPackage.JAVAMM_XVARIABLE_DECLARATION__ADDITIONAL_VARIABLES:
				return ((InternalEList<?>)getAdditionalVariables()).basicRemove(otherEnd, msgs);
		}
		return super.eInverseRemove(otherEnd, featureID, msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType)
	{
		switch (featureID)
		{
			case JavammPackage.JAVAMM_XVARIABLE_DECLARATION__ADDITIONAL_VARIABLES:
				return getAdditionalVariables();
		}
		return super.eGet(featureID, resolve, coreType);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void eSet(int featureID, Object newValue)
	{
		switch (featureID)
		{
			case JavammPackage.JAVAMM_XVARIABLE_DECLARATION__ADDITIONAL_VARIABLES:
				getAdditionalVariables().clear();
				getAdditionalVariables().addAll((Collection<? extends XVariableDeclaration>)newValue);
				return;
		}
		super.eSet(featureID, newValue);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void eUnset(int featureID)
	{
		switch (featureID)
		{
			case JavammPackage.JAVAMM_XVARIABLE_DECLARATION__ADDITIONAL_VARIABLES:
				getAdditionalVariables().clear();
				return;
		}
		super.eUnset(featureID);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public boolean eIsSet(int featureID)
	{
		switch (featureID)
		{
			case JavammPackage.JAVAMM_XVARIABLE_DECLARATION__ADDITIONAL_VARIABLES:
				return additionalVariables != null && !additionalVariables.isEmpty();
		}
		return super.eIsSet(featureID);
	}
}
