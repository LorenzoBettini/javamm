/**
 * 
 */
package javamm.util;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.nodemodel.ICompositeNode;
import org.eclipse.xtext.nodemodel.util.NodeModelUtils;

/**
 * Retrieves the original program text, to check for the terminating semicolon.
 * 
 * @author Lorenzo Bettini
 *
 */
public class JavammNodeModelUtil {

	public String getProgramText(EObject object) {
		return NodeModelUtils.getTokenText(findActualNode(object));
	}

	public int getElementOffsetInProgram(EObject object) {
		return findActualNode(object).getOffset();
	}

	public boolean hasSemicolon(EObject object) {
		return getProgramText(object).endsWith(";");
	}

	private ICompositeNode findActualNode(EObject object) {
		final ICompositeNode node = NodeModelUtils.findActualNodeFor(object);
		return node;
	}

}
