package tools.vitruv.applications.cbs.testutils

import tools.vitruv.testutils.activeannotations.ModelCreators
import org.emftext.language.java.JavaFactory

@ModelCreators(factory=JavaFactory)
class JavaModelCreators {
	public static val java = new JavaModelCreators

	private new() {
	}
}
