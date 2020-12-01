package tools.vitruv.applications.pcmjava.tests.pojotransformations.pcm2java

import org.emftext.language.java.classifiers.Classifier
import org.emftext.language.java.types.Int
import org.emftext.language.java.types.NamespaceClassifierReference
import org.emftext.language.java.types.TypeReference
import org.junit.jupiter.api.Test
import org.palladiosimulator.pcm.repository.PrimitiveDataType
import org.palladiosimulator.pcm.repository.PrimitiveTypeEnum
import org.palladiosimulator.pcm.repository.RepositoryFactory
import tools.vitruv.applications.pcmjava.tests.util.Pcm2JavaTestUtils

import static org.hamcrest.CoreMatchers.instanceOf
import static org.hamcrest.CoreMatchers.is
import static org.hamcrest.MatcherAssert.assertThat
import static tools.vitruv.applications.cbs.testutils.PcmMatchers.hasEntityName
import static extension tools.vitruv.applications.pcmjava.util.pcm2java.DataTypeCorrespondenceHelper.claimUniqueCorrespondingJaMoPPDataTypeReference
import static tools.vitruv.applications.cbs.testutils.PcmModelCreators.pcm
import tools.vitruv.testutils.Capture
import static extension tools.vitruv.testutils.Capture.operator_doubleGreaterThan
import org.palladiosimulator.pcm.repository.CompositeDataType
import static tools.vitruv.applications.cbs.testutils.JamoppMatchers.hasName

class DataTypeCorrespondenceHelperTest extends Pcm2JavaTransformationTest {
	@Test
	def void testCorrespondenceForCompositeDataType() throws Throwable {
		val dataType = new Capture<CompositeDataType>
		initRepository('TestRepository').propagate [
			dataTypes__Repository += pcm.repository.CompositeDataType => [
				entityName = 'TestDataType'
			] >> dataType
		]
		val type = correspondenceModel.claimUniqueCorrespondingJaMoPPDataTypeReference(+dataType)
		val classifier = (type as NamespaceClassifierReference).target as Classifier
		assertThat("Name of composite data type does not equal name of classifier", classifier, hasName("TestDataType"))
	}

	@Test
	def void testCorrespondenceForPrimitiveDataType() throws Throwable {
		val PrimitiveDataType pdtInt = RepositoryFactory.eINSTANCE.createPrimitiveDataType()
		pdtInt.setType(PrimitiveTypeEnum.INT)
		val type = correspondenceModel.claimUniqueCorrespondingJaMoPPDataTypeReference(pdtInt)
		assertThat(type, is(instanceOf(Int)))
	}

	@Test
	def void testCorrespondenceForCollectionDataType() throws Throwable {
		val repo = this.initRepository(Pcm2JavaTestUtils.REPOSITORY_NAME)
		// Create and sync CollectionDataType
		userInteractor.addNextSingleSelection(0)
		val collectionDataType = addCollectionDatatypeAndSync(repo, Pcm2JavaTestUtils.COLLECTION_DATA_TYPE_NAME, null)
		val TypeReference type = correspondenceModel.claimUniqueCorrespondingJaMoPPDataTypeReference(collectionDataType)
		val classifier = (type as NamespaceClassifierReference).target as Classifier
		assertThat("Name of composite data type does not equals name of classifier", collectionDataType,
			hasEntityName(classifier.name))
	}
}
