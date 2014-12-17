package javamm.typesystem

import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.xbase.typesystem.references.StandardTypeReferenceOwner
import org.eclipse.xtext.xbase.typesystem.util.CommonTypeComputationServices
import com.google.inject.Singleton

/**
 * @author Lorenzo Bettini
 */
@Singleton
class JavammTypingUtil {
	
	@Inject CommonTypeComputationServices services;

	def toLightweightTypeReference(JvmTypeReference typeRef, EObject context) {
		return newTypeReferenceOwner(context).toLightweightTypeReference(typeRef)
	}

	def newTypeReferenceOwner(EObject context) {
		return new StandardTypeReferenceOwner(services, context);
	}

}