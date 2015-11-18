/**
 * 
 */
package javamm;

import com.google.inject.Guice;
import com.google.inject.Injector;

/**
 * This is required to run tests based on Java compiler in Tycho, otherwise
 * when compiling generated Java code, external libraries like javamm.util won't be found.
 * 
 * @author Lorenzo Bettini
 *
 */
public class JavammInjectorProviderCustom extends JavammInjectorProvider {

	@Override
	public Injector internalCreateInjector() {
		return new JavammStandaloneSetup() {
			@Override
			public Injector createInjector() {
				return Guice.createInjector(new JavammRuntimeModule() {
					@Override
					public ClassLoader bindClassLoaderToInstance() {
						return JavammInjectorProviderCustom.class.getClassLoader();
					}
				});
			}
		}.createInjectorAndDoEMFRegistration();
	}
}
