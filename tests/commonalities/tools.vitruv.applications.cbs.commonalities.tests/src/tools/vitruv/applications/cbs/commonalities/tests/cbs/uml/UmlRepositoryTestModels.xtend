package tools.vitruv.applications.cbs.commonalities.tests.cbs.uml

import tools.vitruv.applications.cbs.commonalities.tests.cbs.RepositoryTest
import tools.vitruv.applications.cbs.commonalities.tests.uml.UmlTestModelsBase
import tools.vitruv.applications.cbs.commonalities.tests.util.VitruvApplicationTestAdapter

class UmlRepositoryTestModels extends UmlTestModelsBase implements RepositoryTest.DomainModels {

	new(VitruvApplicationTestAdapter vitruvApplicationTestAdapter) {
		super(vitruvApplicationTestAdapter)
	}

	override emptyRepositoryCreation() {
		return newModel [
			val umlRepositoryModel = new UmlRepositoryModel()
			return #[
				umlRepositoryModel.model
			]
		]
	}
}
