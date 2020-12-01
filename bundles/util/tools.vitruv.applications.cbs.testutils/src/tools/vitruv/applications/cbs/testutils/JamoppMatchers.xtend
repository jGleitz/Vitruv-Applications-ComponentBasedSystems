package tools.vitruv.applications.cbs.testutils

import edu.kit.ipd.sdq.activextendannotations.Utility
import org.hamcrest.TypeSafeMatcher
import org.emftext.language.java.commons.NamedElement
import org.hamcrest.Description
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.hamcrest.Matcher
import org.eclipse.emf.ecore.EObject

@Utility
class JamoppMatchers {
	def static Matcher<? super EObject> hasName(String expectedName) {
		new JamoppNamedElementNameMatcher(expectedName) as Matcher<?> as Matcher<? super EObject>
	}
}

@FinalFieldsConstructor
package class JamoppNamedElementNameMatcher extends TypeSafeMatcher<NamedElement> {
	val String expectedName

	override protected matchesSafely(NamedElement item) {
		item.name == expectedName
	}

	override describeTo(Description description) {
		description.appendText("a NamedElement called").appendValue(expectedName)
	}
}
