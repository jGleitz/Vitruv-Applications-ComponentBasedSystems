package tools.vitruv.applications.pcmjava.tests.pojotransformations.pcm2java.repository

import org.emftext.language.java.classifiers.Class
import org.emftext.language.java.containers.CompilationUnit
import org.emftext.language.java.containers.Package
import org.junit.jupiter.api.Test
import org.palladiosimulator.pcm.repository.BasicComponent
import org.palladiosimulator.pcm.repository.Repository
import tools.vitruv.applications.pcmjava.tests.pojotransformations.pcm2java.Pcm2JavaTransformationTest
import tools.vitruv.applications.pcmjava.tests.util.Pcm2JavaTestUtils
import tools.vitruv.testutils.Capture

import static extension org.eclipse.emf.ecore.util.EcoreUtil.delete
import static org.hamcrest.MatcherAssert.assertThat
import static tools.vitruv.applications.cbs.testutils.JamoppMatchers.hasName
import static tools.vitruv.applications.cbs.testutils.PcmModelCreators.pcm
import static tools.vitruv.testutils.matchers.CorrespondenceMatchers.ofType

import static extension tools.vitruv.testutils.Capture.operator_doubleGreaterThan
import static extension tools.vitruv.testutils.matchers.CorrespondenceMatchers.*
import static tools.vitruv.testutils.matchers.ModelMatchers.*

class BasicComponentMappingTransformationTest extends Pcm2JavaTransformationTest {
	@Test
	def void testAddBasicComponent() throws Throwable {
		val basicComponent = new Capture<BasicComponent>
		initRepository('TestRepository').propagate [
			components__Repository += pcm.repository.BasicComponent => [
				entityName = "TestBasicComponent"
			] >> basicComponent
		]

		assertThat(+basicComponent, hasOneCorrespondence(ofType(CompilationUnit), hasName("TestBasicComponentImpl")))
		assertThat(+basicComponent, hasOneCorrespondence(ofType(Package), hasName("TestBasicComponent")))
		assertThat(+basicComponent, hasOneCorrespondence(ofType(Class), hasName("TestBasicComponentImpl")))
		assertThat(resourceAt(javaModelFor("TestBasicComponent", "TestBasicComponentImpl")), exists())
	}

	@Test
	def void testRenameBasicComponent() throws Throwable {
		val basicComponent = new Capture<BasicComponent>

		initRepository('TestRepository').propagate [
			components__Repository += pcm.repository.BasicComponent => [
				entityName = "TestBasicComponent"
			] >> basicComponent
		]
		basicComponent.get.propagate [
			entityName = "RenamedComponent"
		]
		assertThat(+basicComponent, hasOneCorrespondence(ofType(CompilationUnit), hasName("RenamedComponentImpl")))
		assertThat(+basicComponent, hasOneCorrespondence(ofType(Package), hasName("RenamedComponent")))
		assertThat(+basicComponent, hasOneCorrespondence(ofType(Class), hasName("RenamedComponentImpl")))
	}

	@Test
	def void testDeleteBasicComponent() throws Throwable {
		val basicComponent = new Capture<BasicComponent>

		initRepository('TestRepository').propagate [
			components__Repository += pcm.repository.BasicComponent => [
				entityName = "TestBasicComponent"
			] >> basicComponent
		]
		basicComponent.get.propagate [delete()]
		assertThat(+basicComponent, hasNoCorrespondences())
		this.assertCompilationUnitForBasicComponentDeleted(basicComponent)
	}

	@Test
	def void testAddTwoBasicComponentAndDeleteOne() throws Throwable {
		resourceAt(rep)
		val Repository repo = this.initRepository(Pcm2JavaTestUtils.REPOSITORY_NAME)
		val BasicComponent basicComponent = this.addBasicComponentAndSync(repo)
		val BasicComponent basicComponent2 = this.addBasicComponentAndSync(repo, "SecondBasicComponent")
		delete(basicComponent)
		super.saveAndSynchronizeChanges(repo)
		assertThat(basicComponent, hasNoCorrespondences())
		assertThat(basicComponent2,
			hasOneCorrespondence(ofType(CompilationUnit), hasName('''«basicComponent.entityName»Impl''')))
		assertThat(basicComponent2, hasOneCorrespondence(ofType(Package), hasName(basicComponent.entityName)))
		assertThat(basicComponent2, hasOneCorrespondence(ofType(Class), hasName('''«basicComponent.entityName»Impl''')))
	}

	@SuppressWarnings("unchecked")
	def private void assertBasicComponentCorrespondences(BasicComponent basicComponent) throws Throwable {
		this.assertCorrespondnecesAndCompareNames(basicComponent, 3,
			(#[typeof(CompilationUnit), typeof(Package), typeof(Class)] as java.lang.Class[]),
			(#[.toString, basicComponent.getEntityName(),
				'''«basicComponent.getEntityName()»Impl'''.toString] as String[]))
}
}
