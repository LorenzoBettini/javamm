/**
 * 
 */
package javamm.imports;

import org.eclipse.xtext.conversion.IValueConverter;
import org.eclipse.xtext.formatting.IWhitespaceInformationProvider;
import org.eclipse.xtext.resource.XtextResource;
import org.eclipse.xtext.xbase.conversion.XbaseQualifiedNameValueConverter;
import org.eclipse.xtext.xbase.imports.IImportsConfiguration;
import org.eclipse.xtext.xbase.imports.ImportSectionRegionUtil;
import org.eclipse.xtext.xbase.imports.RewritableImportSection;
import org.eclipse.xtext.xtype.XImportDeclaration;
import org.eclipse.xtext.xtype.XImportSection;

import com.google.inject.Inject;

/**
 * We must make sure to add a terminating ';' otherwise the added import would not be
 * valid Java-- code.
 * 
 * @author Lorenzo Bettini
 *
 */
public class JavammRewritableImportSection extends RewritableImportSection {

	/**
	 * @author Lorenzo Bettini
	 *
	 */
	public static class JavammRewritableImportSectionFactory extends Factory {

		@Inject
		private IImportsConfiguration importsConfiguration;

		@Inject
		private IWhitespaceInformationProvider whitespaceInformationProvider;

		@Inject
		private ImportSectionRegionUtil regionUtil;

		@Inject
		private XbaseQualifiedNameValueConverter nameValueConverter;

		@Override
		public RewritableImportSection parse(XtextResource resource) {
			RewritableImportSection rewritableImportSection = new JavammRewritableImportSection(resource, importsConfiguration,
					importsConfiguration.getImportSection(resource), whitespaceInformationProvider.getLineSeparatorInformation(resource.getURI())
							.getLineSeparator(), regionUtil, nameValueConverter);
			return rewritableImportSection;
		}

		@Override
		public RewritableImportSection createNewEmpty(XtextResource resource) {
			RewritableImportSection rewritableImportSection = new JavammRewritableImportSection(resource, importsConfiguration, null, whitespaceInformationProvider
					.getLineSeparatorInformation(resource.getURI()).getLineSeparator(), regionUtil, nameValueConverter);
			rewritableImportSection.setSort(true);
			return rewritableImportSection;
		}

	}

	/**
	 * @param resource
	 * @param importsConfiguration
	 * @param originalImportSection
	 * @param lineSeparator
	 * @param regionUtil
	 * @param nameConverter
	 */
	public JavammRewritableImportSection(XtextResource resource,
			IImportsConfiguration importsConfiguration,
			XImportSection originalImportSection, String lineSeparator,
			ImportSectionRegionUtil regionUtil,
			IValueConverter<String> nameConverter) {
		super(resource, importsConfiguration, originalImportSection,
				lineSeparator, regionUtil, nameConverter);
	}
	
	@Override
	protected void appendImport(StringBuilder builder,
			XImportDeclaration newImportDeclaration) {
		super.appendImport(builder, newImportDeclaration);
		builder.insert(builder.length()-1, ';');
	}

}
