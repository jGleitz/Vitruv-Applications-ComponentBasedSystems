package tools.vitruv.applications.pcmjava.ejbtransformations.java2pcm

import org.emftext.language.java.classifiers.Class
import org.emftext.language.java.classifiers.Classifier
import org.emftext.language.java.classifiers.Interface
import org.emftext.language.java.members.ClassMethod
import org.emftext.language.java.types.TypeReference
import org.palladiosimulator.pcm.repository.Repository
import tools.vitruv.framework.correspondence.CorrespondenceModel
import tools.vitruv.applications.pcmjava.util.java2pcm.Java2PcmUtils

class EjbJava2PcmHelper {
	private new(){}
	
	public static def Classifier getClassifier(TypeReference typeReference){
		var classifier = Java2PcmUtils.getTargetClassifierFromImplementsReferenceAndNormalizeURI(typeReference)
		return classifier
	}
	
	public static def boolean  overridesInterfaceMethod(ClassMethod classMethod, Class jaMoPPClass){
		return null !== getOoverridenInterfaceMethod(classMethod, jaMoPPClass) 
	}
	
	public static def getOoverridenInterfaceMethod(ClassMethod classMethod, Class jaMoPPClass){
		val implementedEjbInterfaces = jaMoPPClass.implements.map[it.classifier].filter(typeof(Interface)).filter[EjbAnnotationHelper.isEjbBuisnessInterface(it)]
		for(ejbInterface : implementedEjbInterfaces){
			val method = ejbInterface.methods.findFirst[Java2PcmUtils.hasSameSignature(it, classMethod)]
			if(null !== method){
				return method
			}
		}
		return null
	} 
	
	public static def Repository findRepository(CorrespondenceModel correspondenceModel){ 
		return Java2PcmUtils.getRepository(correspondenceModel)
	}
	
}