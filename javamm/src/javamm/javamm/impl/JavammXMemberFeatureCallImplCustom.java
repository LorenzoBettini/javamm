package javamm.javamm.impl;

import java.util.Collection;

import javamm.javamm.JavammArrayAccess;
import javamm.javamm.JavammArrayAccessExpression;
import javamm.javamm.JavammPackage;
import javamm.javamm.JavammXMemberFeatureCall;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;
import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.util.EObjectContainmentEList;
import org.eclipse.emf.ecore.util.InternalEList;
import org.eclipse.xtext.xbase.XExpression;
import org.eclipse.xtext.xbase.impl.XMemberFeatureCallImplCustom;

/**
 * @author Lorenzo Bettini
 *
 */
public class JavammXMemberFeatureCallImplCustom extends XMemberFeatureCallImplCustom implements JavammXMemberFeatureCall {

	/**
	 * The cached value of the '{@link #getArrayAccessExpression() <em>Array Access Expression</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getArrayAccessExpression()
	 * @generated
	 * @ordered
	 */
	protected JavammArrayAccessExpression arrayAccessExpression;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass()
	{
		return JavammPackage.Literals.JAVAMM_XMEMBER_FEATURE_CALL;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 */
	public EList<XExpression> getIndexes()
	{
		return getArrayAccessExpression().getIndexes();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public JavammArrayAccessExpression getArrayAccessExpression()
	{
		return arrayAccessExpression;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetArrayAccessExpression(JavammArrayAccessExpression newArrayAccessExpression, NotificationChain msgs)
	{
		JavammArrayAccessExpression oldArrayAccessExpression = arrayAccessExpression;
		arrayAccessExpression = newArrayAccessExpression;
		if (eNotificationRequired())
		{
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, JavammPackage.JAVAMM_XMEMBER_FEATURE_CALL__ARRAY_ACCESS_EXPRESSION, oldArrayAccessExpression, newArrayAccessExpression);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setArrayAccessExpression(JavammArrayAccessExpression newArrayAccessExpression)
	{
		if (newArrayAccessExpression != arrayAccessExpression)
		{
			NotificationChain msgs = null;
			if (arrayAccessExpression != null)
				msgs = ((InternalEObject)arrayAccessExpression).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - JavammPackage.JAVAMM_XMEMBER_FEATURE_CALL__ARRAY_ACCESS_EXPRESSION, null, msgs);
			if (newArrayAccessExpression != null)
				msgs = ((InternalEObject)newArrayAccessExpression).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - JavammPackage.JAVAMM_XMEMBER_FEATURE_CALL__ARRAY_ACCESS_EXPRESSION, null, msgs);
			msgs = basicSetArrayAccessExpression(newArrayAccessExpression, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, JavammPackage.JAVAMM_XMEMBER_FEATURE_CALL__ARRAY_ACCESS_EXPRESSION, newArrayAccessExpression, newArrayAccessExpression));
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
			case JavammPackage.JAVAMM_XMEMBER_FEATURE_CALL__INDEXES:
				return ((InternalEList<?>)getIndexes()).basicRemove(otherEnd, msgs);
			case JavammPackage.JAVAMM_XMEMBER_FEATURE_CALL__ARRAY_ACCESS_EXPRESSION:
				return basicSetArrayAccessExpression(null, msgs);
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
			case JavammPackage.JAVAMM_XMEMBER_FEATURE_CALL__INDEXES:
				return getIndexes();
			case JavammPackage.JAVAMM_XMEMBER_FEATURE_CALL__ARRAY_ACCESS_EXPRESSION:
				return getArrayAccessExpression();
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
			case JavammPackage.JAVAMM_XMEMBER_FEATURE_CALL__INDEXES:
				getIndexes().clear();
				getIndexes().addAll((Collection<? extends XExpression>)newValue);
				return;
			case JavammPackage.JAVAMM_XMEMBER_FEATURE_CALL__ARRAY_ACCESS_EXPRESSION:
				setArrayAccessExpression((JavammArrayAccessExpression)newValue);
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
			case JavammPackage.JAVAMM_XMEMBER_FEATURE_CALL__INDEXES:
				getIndexes().clear();
				return;
			case JavammPackage.JAVAMM_XMEMBER_FEATURE_CALL__ARRAY_ACCESS_EXPRESSION:
				setArrayAccessExpression((JavammArrayAccessExpression)null);
				return;
		}
		super.eUnset(featureID);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 */
	@Override
	public boolean eIsSet(int featureID)
	{
		switch (featureID)
		{
			case JavammPackage.JAVAMM_XMEMBER_FEATURE_CALL__INDEXES:
				return getArrayAccessExpression() != null && !getArrayAccessExpression().getIndexes().isEmpty();
			case JavammPackage.JAVAMM_XMEMBER_FEATURE_CALL__ARRAY_ACCESS_EXPRESSION:
				return arrayAccessExpression != null;
		}
		return super.eIsSet(featureID);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public int eBaseStructuralFeatureID(int derivedFeatureID, Class<?> baseClass)
	{
		if (baseClass == JavammArrayAccess.class)
		{
			switch (derivedFeatureID)
			{
				case JavammPackage.JAVAMM_XMEMBER_FEATURE_CALL__INDEXES: return JavammPackage.JAVAMM_ARRAY_ACCESS__INDEXES;
				default: return -1;
			}
		}
		return super.eBaseStructuralFeatureID(derivedFeatureID, baseClass);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public int eDerivedStructuralFeatureID(int baseFeatureID, Class<?> baseClass)
	{
		if (baseClass == JavammArrayAccess.class)
		{
			switch (baseFeatureID)
			{
				case JavammPackage.JAVAMM_ARRAY_ACCESS__INDEXES: return JavammPackage.JAVAMM_XMEMBER_FEATURE_CALL__INDEXES;
				default: return -1;
			}
		}
		return super.eDerivedStructuralFeatureID(baseFeatureID, baseClass);
	}
	
	@Override
	public void setMemberCallTarget(XExpression newMemberCallTarget) {
		JavammArrayAccessExpression arrayAccessExpression = new JavammArrayAccessExpressionImpl();
		
		setArrayAccessExpression(arrayAccessExpression);
		
		getArrayAccessExpression().setArray(newMemberCallTarget);
	}
	
	@Override
	public XExpression getMemberCallTarget() {
		return getArrayAccessExpression();
	}
}
