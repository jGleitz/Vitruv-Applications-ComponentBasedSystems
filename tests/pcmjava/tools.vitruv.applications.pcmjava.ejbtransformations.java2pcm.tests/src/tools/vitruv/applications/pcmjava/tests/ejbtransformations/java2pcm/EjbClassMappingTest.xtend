package tools.vitruv.applications.pcmjava.tests.ejbtransformations.java2pcm

import org.junit.jupiter.api.Test

class EjbClassMappingTest extends EjbJava2PcmTransformationTest { 
	@Test
	def testCreateClassAndAddStatelessAnnotation(){ 
		super.addRepoContractsAndDatatypesPackage()
		
		val correspondingBasicComponent = createEjbClass(TEST_CLASS_NAME)
		
		assertThat("Created component has different name as added class", correspondingBasicComponent.entityName, is(TEST_CLASS_NAME))
	}
	
	@Test
	def testCreateMethodThatOverridesInterfaceMethod(){
		super.createPackageEjbClassAndInterface()
		super.addImplementsCorrespondingToOperationProvidedRoleToClass(TEST_CLASS_NAME, TEST_INTERFACE_NAME)
		val correspondingOpSignature = super.addMethodToInterfaceWithCorrespondence(TEST_INTERFACE_NAME)
		
		val rdSEFF = super.addClassMethodToClassThatOverridesInterfaceMethod(TEST_CLASS_NAME, correspondingOpSignature.entityName)
		
		assertEquals("RDSEFF describes wrong service", rdSEFF.describedService__SEFF.id, correspondingOpSignature.id)
	}
	
}