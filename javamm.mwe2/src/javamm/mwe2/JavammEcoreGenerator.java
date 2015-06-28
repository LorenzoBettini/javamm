/**
 * 
 */
package javamm.mwe2;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.URIConverter;
import org.eclipse.emf.mwe2.ecore.EcoreGenerator;

import com.google.common.base.Function;

/**
 * @author Lorenzo Bettini
 *
 */
public class JavammEcoreGenerator extends EcoreGenerator {

	private boolean generateCustomClasses = false;
	
	@Override
	protected Function<String, String> getTypeMapper() {
		return new mapper();
	}

	@Override
	public void setGenerateCustomClasses(boolean generateCustomClasses) {
		super.setGenerateCustomClasses(generateCustomClasses);
		this.generateCustomClasses = generateCustomClasses;
	}
	
	protected final class mapper implements Function<String, String> {
		public String apply(String from) {
			if (from.startsWith("org.eclipse.emf.ecore"))
				return null;
			String customClassName = from+"Custom";
			String fromPath = from.replace('.', '/');
			for(String srcPath: srcPaths) {
				URI createURI = URI.createURI(srcPath+"/"+fromPath+"Custom.java");
				if (URIConverter.INSTANCE.exists(createURI, null)) {
					return customClassName;
				}
				if (from.endsWith("Impl") && generateCustomClasses) {
					generate(from,customClassName,createURI);
					return customClassName;
				}
			}
			if (getClass().getClassLoader().getResourceAsStream(fromPath + "Custom.class") != null) {
				return customClassName;
			}
			return null;
		}
	}

}
