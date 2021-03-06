package tools.vitruv.applications.pcmumlcomponents.uml2pcm

import org.junit.Test
import org.palladiosimulator.pcm.repository.PrimitiveDataType
import org.palladiosimulator.pcm.repository.PrimitiveTypeEnum

import static org.junit.Assert.*
import org.eclipse.uml2.uml.UMLFactory
import org.eclipse.uml2.uml.PrimitiveType
import org.eclipse.emf.common.util.BasicEList
import org.eclipse.uml2.uml.Type
import org.palladiosimulator.pcm.repository.OperationInterface
import org.eclipse.uml2.uml.DataType
import org.palladiosimulator.pcm.repository.Repository
import org.palladiosimulator.pcm.repository.CompositeDataType

class ImportedDataTypesTest extends AbstractUmlPcmTest {
	
	protected val UMLTYPE_BOOL = "Boolean"
	
	/**
	 * Cannot modify resource set without a write transaction
	 */
	//@Test
	public def void importedTypesExistTest() {
		val umlTypes = importPrimitiveTypes()
		assertNotNull(umlTypes.getOwnedMember(UMLTYPE_BOOL))
		val umlType = umlTypes.getOwnedMember(UMLTYPE_BOOL) as DataType
		val pcmRepository = rootElement.correspondingElements.head as Repository
		saveAndSynchronizeChanges(rootElement)
		val pcmType = UmlToPcmTypesUtil.retrieveCorrespondingPcmType(umlType, pcmRepository, false, null, correspondenceModel)
		assertNotNull(pcmType)
		assertTrue(pcmType instanceof PrimitiveDataType)
		assertEquals(PrimitiveTypeEnum.BOOL, (pcmType as PrimitiveDataType).type)
	}
	
	@Test
	public def void unmappedPrimitiveTypeTest() {
		importPrimitiveTypes()
		val umlTypeName = "MyPrimitive"
		val umlType = UMLFactory.eINSTANCE.createPrimitiveType()
		umlType.name = umlTypeName
		userInteractor.addNextSingleSelection(PrimitiveTypeEnum.BYTE_VALUE)
		rootElement.packagedElements += umlType
		saveAndSynchronizeChanges(rootElement)
		val pcmRepository = rootElement.correspondingElements.head as Repository
		val pcmType = UmlToPcmTypesUtil.retrieveCorrespondingPcmType(umlType, pcmRepository, false, null, correspondenceModel) as PrimitiveDataType
		assertEquals(PrimitiveTypeEnum.BYTE, pcmType.type)
	}
	
	@Test
	public def void mapToCompositeTypeTest() {
		importPrimitiveTypes()
		val umlTypeName = "MyPrimitive"
		val umlType = UMLFactory.eINSTANCE.createPrimitiveType()
		umlType.name = umlTypeName
		userInteractor.addNextSingleSelection(PrimitiveTypeEnum.values.length)
		rootElement.packagedElements += umlType
		saveAndSynchronizeChanges(rootElement)
		val pcmType = umlType.correspondingElements.head
		assertTrue(pcmType instanceof CompositeDataType)
		assertEquals(umlTypeName, (pcmType as CompositeDataType).entityName)
	}
	
	@Test
	public def void useImportedTypeTest() {
		val umlTypes = importPrimitiveTypes()
		val umlType = umlTypes.getOwnedMember(UMLTYPE_BOOL) as PrimitiveType
		val umlInterface = UMLFactory.eINSTANCE.createInterface()
		umlInterface.createOwnedOperation(OPERATION_NAME, new BasicEList<String>(), new BasicEList<Type>(), umlType)
		rootElement.packagedElements += umlInterface
		saveAndSynchronizeChanges(rootElement)
		val pcmInterface = correspondenceModel.getCorrespondingEObjects(#[umlInterface]).flatten.head as OperationInterface
		assertEquals(UmlToPcmUtil.getPcmPrimitiveType(UMLTYPE_BOOL),
					 (pcmInterface.signatures__OperationInterface.head.returnType__OperationSignature as PrimitiveDataType).type)
	}
	
}