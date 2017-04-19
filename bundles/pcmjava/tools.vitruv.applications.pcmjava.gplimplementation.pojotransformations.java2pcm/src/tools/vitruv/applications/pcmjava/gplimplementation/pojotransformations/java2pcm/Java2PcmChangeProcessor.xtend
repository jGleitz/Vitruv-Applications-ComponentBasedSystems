package tools.vitruv.applications.pcmjava.gplimplementation.pojotransformations.java2pcm

import tools.vitruv.applications.pcmjava.gplimplementation.pojotransformations.util.transformationexecutor.TransformationExecutorChangeProcessor
import tools.vitruv.framework.userinteraction.UserInteracting
import tools.vitruv.applications.pcmjava.gplimplementation.pojotransformations.java2pcm.transformations.PackageMappingTransformation
import tools.vitruv.applications.pcmjava.gplimplementation.pojotransformations.java2pcm.transformations.CompilationUnitMappingTransformation
import tools.vitruv.applications.pcmjava.gplimplementation.pojotransformations.java2pcm.transformations.ClassMappingTransformation
import tools.vitruv.applications.pcmjava.gplimplementation.pojotransformations.java2pcm.transformations.InterfaceMappingTransformation
import tools.vitruv.applications.pcmjava.gplimplementation.pojotransformations.java2pcm.transformations.MethodMappingTransformation
import tools.vitruv.applications.pcmjava.gplimplementation.pojotransformations.java2pcm.transformations.ParameterMappingTransformation
import tools.vitruv.applications.pcmjava.gplimplementation.pojotransformations.java2pcm.transformations.ModifierMappingTransformation
import tools.vitruv.applications.pcmjava.gplimplementation.pojotransformations.java2pcm.transformations.FieldMappingTransformation
import tools.vitruv.applications.pcmjava.gplimplementation.pojotransformations.java2pcm.transformations.ClassMethodMappingTransformation
import tools.vitruv.applications.pcmjava.gplimplementation.pojotransformations.java2pcm.transformations.TypeReferenceMappingTransformation
import tools.vitruv.applications.pcmjava.gplimplementation.pojotransformations.util.transformationexecutor.DefaultEObjectMappingTransformation
import tools.vitruv.domains.java.JavaDomainProvider
import tools.vitruv.domains.pcm.PcmDomainProvider

class Java2PcmChangeProcessor extends TransformationExecutorChangeProcessor {
	
	new(UserInteracting userInteracting) {
		super(userInteracting, new JavaDomainProvider().domain, new PcmDomainProvider().domain)

		addMapping(new PackageMappingTransformation())
		addMapping(new CompilationUnitMappingTransformation())
		addMapping(new ClassMappingTransformation())
		addMapping(new InterfaceMappingTransformation())
		addMapping(new MethodMappingTransformation())
		addMapping(new ParameterMappingTransformation())
		addMapping(new ModifierMappingTransformation())
		addMapping(new FieldMappingTransformation())
		addMapping(new ClassMethodMappingTransformation())
		addMapping(new TypeReferenceMappingTransformation())
		// Mapping for EObjects in order to avoid runtime exceptions
		addMapping(new DefaultEObjectMappingTransformation());
	}
	
}