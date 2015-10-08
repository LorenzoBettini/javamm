/**
 * 
 */
package javamm.scoping;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.xtext.naming.QualifiedName;
import org.eclipse.xtext.scoping.impl.ImportNormalizer;
import org.eclipse.xtext.xbase.scoping.XImportSectionNamespaceScopeProvider;

/**
 * Implicitly imported packages for our runtime library
 * 
 * @author Lorenzo Bettini
 *
 */
public class JavammImportedNamespaceScopeProvider extends XImportSectionNamespaceScopeProvider {

	@Override
	protected List<ImportNormalizer> getImplicitImports(boolean ignoreCase) {
		List<ImportNormalizer> implicitImports = new ArrayList<ImportNormalizer>(super.getImplicitImports(ignoreCase));
		implicitImports.add(new ImportNormalizer(QualifiedName.create("javamm","util"), true, ignoreCase));
		return implicitImports;
	}

}
