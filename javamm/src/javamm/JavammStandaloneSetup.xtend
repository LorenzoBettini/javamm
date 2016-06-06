/*
 * generated by Xtext
 */
package javamm

import org.eclipse.emf.ecore.EPackage
import com.google.inject.Injector

/** 
 * Initialization support for running Xtext languages 
 * without equinox extension registry
 */
class JavammStandaloneSetup extends JavammStandaloneSetupGenerated {
	def static void doSetup() {
		new JavammStandaloneSetup().createInjectorAndDoEMFRegistration()
	}

	override void register(Injector injector) {
		if (!EPackage.Registry.INSTANCE.containsKey("http://www.Javamm.javamm")) {
			EPackage.Registry.INSTANCE.put("http://www.Javamm.javamm", javamm.javamm.JavammPackage.eINSTANCE)
		}
		super.register(injector)
	}
}
