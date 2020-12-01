package tools.vitruv.applications.cbs.testutils

import tools.vitruv.testutils.activeannotations.ModelCreators
import org.emftext.language.java.JavaFactory
import org.emftext.language.java.types.TypesFactory

@ModelCreators(factory=JavaFactory)
class JavaModelCreators {
	public static val java = new JavaModelCreators
	public val types = new TypeModelCreators

	private new() {
	}

	@ModelCreators(factory=TypesFactory)
	static class TypeModelCreators {
		private new() {
		}
	}
}
