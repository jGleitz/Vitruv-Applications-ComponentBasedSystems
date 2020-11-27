package tools.vitruv.applications.cbs.testutils

import tools.vitruv.testutils.activeannotations.ModelCreators
import org.palladiosimulator.pcm.PcmFactory

@ModelCreators(factory=PcmFactory)
class PcmModelCreators {
	public static val pcm = new PcmModelCreators

	private new() {
	}
}
