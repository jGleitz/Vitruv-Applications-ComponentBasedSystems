package tools.vitruv.applications.cbs.testutils

import tools.vitruv.testutils.activeannotations.ModelCreators
import org.eclipse.uml2.uml.UMLFactory

@ModelCreators(factory=UMLFactory)
class UmlModelCreators {
	public static val uml = new UmlModelCreators()

	private new() {
	}
}
