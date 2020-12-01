package tools.vitruv.applications.cbs.testutils

import tools.vitruv.testutils.activeannotations.ModelCreators
import org.palladiosimulator.pcm.PcmFactory
import org.palladiosimulator.pcm.repository.RepositoryFactory

@ModelCreators(factory=PcmFactory)
class PcmModelCreators {
	public static val pcm = new PcmModelCreators
	public val repository = new PcmRepositoryCreators

	private new() {
	}

	@ModelCreators(factory=RepositoryFactory)
	static class PcmRepositoryCreators {
		private new() {}
	}
}
