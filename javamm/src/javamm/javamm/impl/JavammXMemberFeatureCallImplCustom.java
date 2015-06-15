package javamm.javamm.impl;

import javamm.javamm.JavammArrayAccessExpression;
import javamm.javamm.JavammXMemberFeatureCall;

import org.eclipse.emf.common.util.EList;
import org.eclipse.xtext.xbase.XExpression;

/**
 * A manual implementation that embeds the original member call target XExpression into
 * a {@link JavammArrayAccessExpression}; "indexes" are also delegated to the embedded
 * {@link JavammArrayAccessExpression} instance.
 * 
 * @author Lorenzo Bettini
 *
 */
public class JavammXMemberFeatureCallImplCustom extends JavammXMemberFeatureCallImpl implements JavammXMemberFeatureCall {

	/**
	 * Delegated to the embedded {@link JavammArrayAccessExpression}; when indexes
	 * are requested or updated we can safely assume that the {@link JavammArrayAccessExpression}
	 * has already been created (see the grammar rule).
	 */
	@Override
	public EList<XExpression> getIndexes()
	{
		return getArrayAccessExpression().getIndexes();
	}

	/**
	 * Custom implementation that intercepts the set of the {@link XExpression} from the parser,
	 * creates a new {@link JavammArrayAccessExpression} and embeds the original {@link XExpression}.
	 * 
	 * @see org.eclipse.xtext.xbase.impl.XMemberFeatureCallImpl#setMemberCallTarget(org.eclipse.xtext.xbase.XExpression)
	 */
	@Override
	public void setMemberCallTarget(XExpression newMemberCallTarget) {
		JavammArrayAccessExpression arrayAccessExpression = new JavammArrayAccessExpressionImpl();
		
		setArrayAccessExpression(arrayAccessExpression);
		
		getArrayAccessExpression().setArray(newMemberCallTarget);
	}
	
	/**
	 * Customized in order to return the embedded {@link JavammArrayAccessExpression}
	 * 
	 * @see org.eclipse.xtext.xbase.impl.XMemberFeatureCallImpl#getMemberCallTarget()
	 */
	@Override
	public XExpression getMemberCallTarget() {
		return getArrayAccessExpression();
	}
}
