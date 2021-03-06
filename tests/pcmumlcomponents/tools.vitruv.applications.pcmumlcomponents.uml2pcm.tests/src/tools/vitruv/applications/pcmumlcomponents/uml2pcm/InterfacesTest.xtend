package tools.vitruv.applications.pcmumlcomponents.uml2pcm

import org.eclipse.emf.common.util.BasicEList
import org.eclipse.uml2.uml.Interface
import org.eclipse.uml2.uml.Type
import org.eclipse.uml2.uml.UMLFactory
import org.junit.Test
import org.palladiosimulator.pcm.repository.OperationInterface
import org.palladiosimulator.pcm.repository.OperationSignature

import static org.junit.Assert.*
import org.eclipse.uml2.uml.Operation
import tools.vitruv.applications.pcmumlcomponents.uml2pcm.UmlToPcmUtil
import org.palladiosimulator.pcm.repository.PrimitiveDataType
import org.eclipse.uml2.uml.Parameter
import org.eclipse.uml2.uml.ParameterDirectionKind

class InterfacesTest extends AbstractUmlPcmTest {
	
	protected def Interface createUmlInterface(String name) {
		val umlInterface = UMLFactory.eINSTANCE.createInterface();
		umlInterface.name = name
		rootElement.packagedElements += umlInterface
		saveAndSynchronizeChanges(rootElement);
		return umlInterface
	}
	
	@Test
	public def void createInterfaceTest() {
		val interfaceName = INTERFACE_NAME
		val umlInterface = createUmlInterface(interfaceName)
		val correspondingElements = correspondenceModel.getCorrespondingEObjects(#[umlInterface]).flatten;
		assertEquals(1, correspondingElements.length);
		assertTrue(correspondingElements.get(0) instanceof OperationInterface)
		val pcmInterface = (correspondingElements.get(0) as OperationInterface)
		assertEquals(interfaceName, pcmInterface.entityName)
	}
	
	@Test
	public def void createIntefaceOperationTest() {
		val umlInterface = createUmlInterface(INTERFACE_NAME)
		userInteractor.addNextSingleSelection(10)
		val p1Type = UMLFactory.eINSTANCE.createPrimitiveType()
		p1Type.name = "dataType1";
		rootElement.packagedElements += p1Type
		
		userInteractor.addNextSingleSelection(2)
		val returnType = UMLFactory.eINSTANCE.createPrimitiveType()
		returnType.name = UML_TYPE_BOOL
		rootElement.packagedElements += returnType
		
		val parameterNames = new BasicEList<String>()
		parameterNames += PARAMETER_NAME
		val parameterTypes = new BasicEList<Type>()
		parameterTypes += p1Type
		val umlOperation = umlInterface.createOwnedOperation(OPERATION_NAME, parameterNames, parameterTypes, returnType)
		saveAndSynchronizeChanges(rootElement);

		val correspondingElements = correspondenceModel.getCorrespondingEObjects(#[umlOperation]).flatten;
		assertEquals(1, correspondingElements.length);
		assertTrue(correspondingElements.get(0) instanceof OperationSignature)
		val pcmOperation = (correspondingElements.get(0) as OperationSignature)
		assertEquals(umlOperation.name, pcmOperation.entityName)
		assertEquals(UmlToPcmUtil.getPcmPrimitiveType(umlOperation.type.name),
			(pcmOperation.returnType__OperationSignature as PrimitiveDataType).type)
			
		assertEquals(1, pcmOperation.parameters__OperationSignature.length)
		assertEquals(parameterNames.get(0), pcmOperation.parameters__OperationSignature.get(0).parameterName)
	}
	
	protected def Operation createInterfaceOperation(Interface umlInterface, String operationName, String operationType) {
		userInteractor.addNextSingleSelection(getDataTypeUserSelection(operationType))
		val returnType = UMLFactory.eINSTANCE.createPrimitiveType()
		returnType.name = operationType
		rootElement.packagedElements += returnType
		val umlOperation = UMLFactory.eINSTANCE.createOperation()
		umlOperation.name = operationName
		umlOperation.type = returnType
		umlInterface.ownedOperations += umlOperation
		saveAndSynchronizeChanges(rootElement)
		return umlOperation
	}
	
	@Test
	public def void changeInterfaceOperationTest() {
		val umlInterface = createUmlInterface(INTERFACE_NAME)
		val umlOperation = createInterfaceOperation(umlInterface, OPERATION_NAME, UML_TYPE_BOOL)
		var correspondingSignatures = correspondenceModel.getCorrespondingEObjects(#[umlOperation]).flatten
		var pcmSignature = (correspondingSignatures.get(0) as OperationSignature)
		umlOperation.name = OPERATION_NAME + "2"
		saveAndSynchronizeChanges(umlOperation)
		assertEquals(umlOperation.name, pcmSignature.entityName)
		val newType = UMLFactory.eINSTANCE.createPrimitiveType()
		newType.name = UML_TYPE_INT
		rootElement.packagedElements += newType
		umlOperation.type = newType
		saveAndSynchronizeChanges(umlOperation)
		
		correspondingSignatures = correspondenceModel.getCorrespondingEObjects(#[umlOperation]).flatten
		pcmSignature = (correspondingSignatures.get(0) as OperationSignature)
		assertEquals(UmlToPcmUtil.getPcmPrimitiveType(newType.name),
			(pcmSignature.returnType__OperationSignature as PrimitiveDataType).type)
			
		umlOperation.type = null
		saveAndSynchronizeChanges(umlOperation)
		correspondingSignatures = correspondenceModel.getCorrespondingEObjects(#[umlOperation]).flatten
		pcmSignature = (correspondingSignatures.get(0) as OperationSignature)
		assertNull(pcmSignature.returnType__OperationSignature)
	}
	
	protected def Parameter createParameter(Operation umlOperation, String name, String type) {
		val parameterType = UMLFactory.eINSTANCE.createPrimitiveType()
		parameterType.name = type
		rootElement.packagedElements += parameterType 
		val umlParameter = UMLFactory.eINSTANCE.createParameter()
		umlParameter.name = name
		umlParameter.type = parameterType
		umlOperation.ownedParameters += umlParameter
		saveAndSynchronizeChanges(rootElement)
		return umlParameter
	}
	
	@Test
	public def void addOperationParameterTest() {
		val umlInterface = createUmlInterface(INTERFACE_NAME)
		val umlOperation = createInterfaceOperation(umlInterface, OPERATION_NAME, UML_TYPE_BOOL)
		val umlParameter = createParameter(umlOperation, PARAMETER_NAME, UML_TYPE_INT)
		
		val pcmSignature = getCorrespondingSignature(umlOperation)
		assertEquals(1, pcmSignature.parameters__OperationSignature.length)
		
		val correspondingElements = correspondenceModel.getCorrespondingEObjects(#[umlParameter]).flatten
		assertEquals(1, correspondingElements.length)
		assertTrue(correspondingElements.get(0) instanceof org.palladiosimulator.pcm.repository.Parameter)
		val pcmParameter = (correspondingElements.get(0) as org.palladiosimulator.pcm.repository.Parameter)
		assertEquals(umlParameter.name, pcmParameter.parameterName)
		// TODO: pcm modifier is not set or explicitly changed per default, uml sets IN as default
		// assertEquals(UmlToPcmUtil.getPcmParameterModifier(umlParameter.direction), pcmParameter.modifier__Parameter)
		assertEquals(UmlToPcmUtil.getPcmPrimitiveType(umlParameter.type.name), (pcmParameter.dataType__Parameter as PrimitiveDataType).type)
	}
	
	protected def OperationSignature getCorrespondingSignature(Operation operation) {
		val correspondingElements = correspondenceModel.getCorrespondingEObjects(#[operation]).flatten
		return (correspondingElements.get(0) as OperationSignature)
	}
	
	protected def org.palladiosimulator.pcm.repository.Parameter getCorrespondingParameter(Parameter umlParameter) {
		val correspondingElements = correspondenceModel.getCorrespondingEObjects(#[umlParameter]).flatten
		return (correspondingElements.get(0) as org.palladiosimulator.pcm.repository.Parameter)
	}
	
	@Test
	public def void changeOperationParameterTest() {
		val umlInterface = createUmlInterface(INTERFACE_NAME)
		val umlOperation = createInterfaceOperation(umlInterface, OPERATION_NAME, UML_TYPE_BOOL)
		val umlParameter = createParameter(umlOperation, PARAMETER_NAME, UML_TYPE_INT)
		
		val correspondingElements = correspondenceModel.getCorrespondingEObjects(#[umlParameter]).flatten
		assertEquals(1, correspondingElements.length)
		assertTrue(correspondingElements.get(0) instanceof org.palladiosimulator.pcm.repository.Parameter)
		var pcmParameter = (correspondingElements.get(0) as org.palladiosimulator.pcm.repository.Parameter)
		
		val newName = PARAMETER_NAME_2
		umlParameter.name = newName
		saveAndSynchronizeChanges(umlParameter)
		pcmParameter = getCorrespondingParameter(umlParameter)
		assertEquals(newName, pcmParameter.parameterName)
		
		val newType = umlOperation.type
		umlParameter.type = newType
		saveAndSynchronizeChanges(umlParameter)
		pcmParameter = getCorrespondingParameter(umlParameter)
		assertEquals(UmlToPcmUtil.getPcmPrimitiveType(newType.name), (pcmParameter.dataType__Parameter as PrimitiveDataType).type)
		
		umlParameter.direction = ParameterDirectionKind.INOUT_LITERAL
		saveAndSynchronizeChanges(umlParameter)
		pcmParameter = getCorrespondingParameter(umlParameter)
		assertEquals(UmlToPcmUtil.getPcmParameterModifier(umlParameter.direction), pcmParameter.modifier__Parameter)
	}
	
	@Test
	public def void deleteOperationParameterTest() {
		val umlInterface = createUmlInterface(INTERFACE_NAME)
		val umlOperation = createInterfaceOperation(umlInterface, OPERATION_NAME, UML_TYPE_BOOL)
		val parameter1 = createParameter(umlOperation, PARAMETER_NAME, UML_TYPE_INT)
		val remainingParameterName = PARAMETER_NAME_2
		createParameter(umlOperation, remainingParameterName, UML_TYPE_STRING)
		
		var pcmSignature = getCorrespondingSignature(umlOperation)
		
		assertEquals(2, pcmSignature.parameters__OperationSignature.length)
		
		umlOperation.ownedParameters -= parameter1
		saveAndSynchronizeChanges(umlOperation)
		
		pcmSignature = getCorrespondingSignature(umlOperation)
		assertEquals(1, pcmSignature.parameters__OperationSignature.length)
		assertEquals(remainingParameterName, pcmSignature.parameters__OperationSignature.get(0).parameterName)
		
		umlOperation.ownedParameters.remove(0)
		saveAndSynchronizeChanges(umlOperation)
		
		pcmSignature = getCorrespondingSignature(umlOperation)
		assertEquals(1, pcmSignature.parameters__OperationSignature.length)
		assertNull(pcmSignature.returnType__OperationSignature)
	}
	
}