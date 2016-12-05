/**
 * 
 */
package javamm.scoping;

import javamm.javamm.JavammProgram;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.naming.QualifiedName;
import org.eclipse.xtext.xbase.scoping.XbaseQualifiedNameProvider;

/**
 * @author Lorenzo Bettini
 *
 */
public class JavammQualifiedNameProvider extends XbaseQualifiedNameProvider {
	
	@Override
	public QualifiedName getFullyQualifiedName(EObject obj) {
		if (obj instanceof JavammProgram) {
			JavammProgram program = (JavammProgram) obj;
			return getConverter().toQualifiedName("javamm." + 
					program.eResource().getURI().trimFileExtension().lastSegment());
		}
		return super.getFullyQualifiedName(obj);
	}
}
