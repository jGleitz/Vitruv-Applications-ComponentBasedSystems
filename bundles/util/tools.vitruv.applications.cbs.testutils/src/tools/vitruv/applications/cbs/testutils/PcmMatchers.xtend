package tools.vitruv.applications.cbs.testutils

import edu.kit.ipd.sdq.activextendannotations.Utility
import org.hamcrest.Matcher
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.hamcrest.TypeSafeMatcher
import org.palladiosimulator.pcm.core.entity.NamedElement
import org.hamcrest.Description

@Utility
class PcmMatchers {
	def static Matcher<? super EObject> hasEntityName(String expectedName) {
		new PcmNamedElementEntityNameMatcher(expectedName) as Matcher<?> as Matcher<? super EObject>
	}
}

@FinalFieldsConstructor
package class PcmNamedElementEntityNameMatcher extends TypeSafeMatcher<NamedElement> {
	val String expectedName

	override protected matchesSafely(NamedElement item) {
		item.entityName == expectedName
	}

	override describeTo(Description description) {
		description.appendText("a NamedElement called").appendValue(expectedName)
	}
}
