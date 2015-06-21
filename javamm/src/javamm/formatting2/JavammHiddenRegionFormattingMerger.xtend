package javamm.formatting2

import java.util.List
import org.eclipse.xtext.formatting2.AbstractFormatter2
import org.eclipse.xtext.formatting2.IHiddenRegionFormatter
import org.eclipse.xtext.formatting2.IHiddenRegionFormatting
import org.eclipse.xtext.formatting2.internal.HiddenRegionFormattingMerger

/**
 * This is required to avoid the formatter to break a member feature call with an
 * array access before the array access (that is, the opening square brackets).
 * 
 * This probably happens because our custom member feature call embeds a JavammArrayAccessExpression
 * which is created on the fly.
 * 
 * @author Lorenzo Bettini
 */
class JavammHiddenRegionFormattingMerger extends HiddenRegionFormattingMerger {
	
	new(AbstractFormatter2 formatter) {
		super(formatter)
	}

	override merge(List<? extends IHiddenRegionFormatting> conflicting) {
		if (conflicting.size == 2) {
			if (conflicting.get(0).isNoSpaceWithHighPriority)
				return conflicting.get(0)
			if (conflicting.get(1).isNoSpaceWithHighPriority)
				return conflicting.get(1)
		}
		
		super.merge(conflicting)
	}

	def private isNoSpaceWithHighPriority(IHiddenRegionFormatting f) {
		val space = f.space
		return space != null && space.empty && f.priority == IHiddenRegionFormatter.HIGH_PRIORITY
	}
}