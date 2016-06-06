/**
 * 
 */
package javamm.ui.wizard;

import java.util.List;

import com.google.common.collect.Lists;

/**
 * @author Lorenzo Bettini
 *
 */
public class JavammProjectCreatorCustom extends JavammProjectCreator {

	@Override
	protected List<String> getRequiredBundles() {
		return Lists.newArrayList("javamm.runtime");
	}

}
