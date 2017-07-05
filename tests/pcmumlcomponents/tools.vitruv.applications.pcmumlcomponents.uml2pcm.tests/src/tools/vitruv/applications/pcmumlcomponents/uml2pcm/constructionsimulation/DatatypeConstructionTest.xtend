package tools.vitruv.applications.pcmumlcomponents.uml2pcm.constructionsimulation

import org.apache.log4j.Level
import org.eclipse.emf.ecore.resource.Resource
import org.junit.Test

class DatatypeConstructionTest extends ModelConstructionTest {
		
	@Test
	def void dataTypeTest() {
		logger.level = Level.ALL
		val Resource resource = loadModel("model/datatype.uml")
		userInteractor.addNextSelections(1)
		createAndSynchronizeModel(TARGET_MODEL_NAME, resource.rootElement)
	}
	
}