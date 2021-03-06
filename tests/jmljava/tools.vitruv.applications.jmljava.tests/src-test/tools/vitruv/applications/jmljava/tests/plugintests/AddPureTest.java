package tools.vitruv.applications.jmljava.tests.plugintests;

import org.junit.Test;

import tools.vitruv.domains.jml.language.jML.JMLSpecMemberModifier;

public class AddPureTest extends JMLModifierTestBase {

	@Test
	public void testBasic() throws Exception {
		performTest("Applet.jml", "Applet", "select", false);
	}
	
	@Test
	public void testAddPureToNonPureMethod() throws Exception {
		performTest("Applet.jml", "Applet", "register", true);
	}

	private void performTest(final String fileName, final String typeName, final String methodName, boolean abortExpected) throws Exception {
		performTest(fileName, typeName, methodName, true, abortExpected);
	}
	
	@Override
	protected JMLSpecMemberModifier getJMLModifier() {
		return JMLSpecMemberModifier.PURE;
	}
}
