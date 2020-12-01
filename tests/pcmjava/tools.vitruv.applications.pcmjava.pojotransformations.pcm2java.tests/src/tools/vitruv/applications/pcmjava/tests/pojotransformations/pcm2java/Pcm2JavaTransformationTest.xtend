package tools.vitruv.applications.pcmjava.tests.pojotransformations.pcm2java

import java.io.File
import java.io.IOException
import java.nio.file.Path
import java.util.ArrayList
import java.util.Collections
import java.util.List
import java.util.Set
import org.eclipse.emf.ecore.EObject
import org.emftext.language.java.JavaClasspath
import org.emftext.language.java.classifiers.Class
import org.emftext.language.java.classifiers.Classifier
import org.emftext.language.java.commons.NamedElement
import org.emftext.language.java.containers.CompilationUnit
import org.emftext.language.java.imports.ClassifierImport
import org.emftext.language.java.imports.Import
import org.emftext.language.java.instantiations.NewConstructorCall
import org.emftext.language.java.members.Constructor
import org.emftext.language.java.members.Field
import org.emftext.language.java.members.Member
import org.emftext.language.java.members.Method
import org.emftext.language.java.statements.Statement
import org.emftext.language.java.types.ClassifierReference
import org.emftext.language.java.types.NamespaceClassifierReference
import org.emftext.language.java.types.TypeReference
import org.junit.jupiter.api.BeforeEach
import org.palladiosimulator.pcm.core.composition.AssemblyContext
import org.palladiosimulator.pcm.core.composition.CompositionFactory
import org.palladiosimulator.pcm.core.entity.ComposedProvidingRequiringEntity
import org.palladiosimulator.pcm.core.entity.InterfaceProvidingEntity
import org.palladiosimulator.pcm.core.entity.InterfaceProvidingRequiringEntity
import org.palladiosimulator.pcm.repository.BasicComponent
import org.palladiosimulator.pcm.repository.CollectionDataType
import org.palladiosimulator.pcm.repository.CompositeComponent
import org.palladiosimulator.pcm.repository.CompositeDataType
import org.palladiosimulator.pcm.repository.DataType
import org.palladiosimulator.pcm.repository.InnerDeclaration
import org.palladiosimulator.pcm.repository.OperationInterface
import org.palladiosimulator.pcm.repository.OperationProvidedRole
import org.palladiosimulator.pcm.repository.OperationRequiredRole
import org.palladiosimulator.pcm.repository.OperationSignature
import org.palladiosimulator.pcm.repository.Parameter
import org.palladiosimulator.pcm.repository.ParameterModifier
import org.palladiosimulator.pcm.repository.PrimitiveDataType
import org.palladiosimulator.pcm.repository.PrimitiveTypeEnum
import org.palladiosimulator.pcm.repository.Repository
import org.palladiosimulator.pcm.repository.RepositoryFactory
import org.palladiosimulator.pcm.seff.ResourceDemandingSEFF
import org.palladiosimulator.pcm.seff.SeffFactory
import org.palladiosimulator.pcm.system.System
import tools.vitruv.applications.pcmjava.pojotransformations.pcm2java.Pcm2JavaChangePropagationSpecification
import tools.vitruv.applications.pcmjava.tests.util.Pcm2JavaTestUtils
import tools.vitruv.applications.pcmjava.util.pcm2java.DataTypeCorrespondenceHelper
import tools.vitruv.applications.util.temporary.pcm.PcmDataTypeUtil
import tools.vitruv.applications.util.temporary.pcm.PcmParameterUtil
import tools.vitruv.domains.java.JavaDomainProvider
import tools.vitruv.domains.pcm.PcmDomainProvider
import tools.vitruv.domains.pcm.PcmNamespace
import tools.vitruv.framework.change.processing.ChangePropagationSpecification
import tools.vitruv.framework.correspondence.CorrespondenceModelUtil
import tools.vitruv.framework.domains.VitruvDomain
import tools.vitruv.framework.util.bridges.EcoreResourceBridge
import tools.vitruv.testutils.VitruvApplicationTest

import static edu.kit.ipd.sdq.commons.util.org.eclipse.core.resources.IProjectUtil.JAVA_SOURCE_FOLDER
import static org.hamcrest.MatcherAssert.assertThat
import static org.junit.jupiter.api.Assertions.assertEquals
import static org.junit.jupiter.api.Assertions.assertNotNull
import static org.junit.jupiter.api.Assertions.assertTrue
import static org.junit.jupiter.api.Assertions.fail
import static tools.vitruv.applications.cbs.testutils.JamoppMatchers.hasName
import static tools.vitruv.applications.cbs.testutils.PcmModelCreators.pcm
import static tools.vitruv.domains.java.util.JavaQueryUtil.getNameFromJaMoPPType
import static tools.vitruv.testutils.matchers.CorrespondenceMatchers.ofType

import static extension tools.vitruv.testutils.matchers.CorrespondenceMatchers.hasOneCorrespondence
import static extension tools.vitruv.testutils.Capture.operator_doubleGreaterThan
import tools.vitruv.testutils.Capture

/** 
 * super class for all repository and system tests. Contains helper methods
 * @author Langhamm
 */
class Pcm2JavaTransformationTest extends VitruvApplicationTest {
	@BeforeEach
	def protected void resetJavaClasspath() {
		// This is necessary because otherwise Maven tests will fail as resources from previous
		// tests are still in the classpath and accidentally resolved
		JavaClasspath.reset()
	}

	override protected List<ChangePropagationSpecification> getChangePropagationSpecifications() {
		return Collections.singletonList(new Pcm2JavaChangePropagationSpecification())
	}

	def protected void assertDataTypeCorrespondence(DataType dataType) throws Throwable {
		switch (dataType) {
			CollectionDataType,
			CompositeDataType: {
				assertThat(dataType,
					hasOneCorrespondence(ofType(CompilationUnit), hasName('''«dataType.entityName».java''')))
				assertThat(dataType, hasOneCorrespondence(ofType(Classifier), hasName(dataType.entityName)))
				if (dataType instanceof CollectionDataType) {
					assertThat(dataType, hasOneCorrespondence(ofType(TypeReference)))
				}
			}
			PrimitiveDataType:
				assertNotNull(DataTypeCorrespondenceHelper.
					claimJaMoPPTypeForPrimitiveDataType(
						dataType), '''No correspondence exists for DataType «dataType»''')
		}
	}

	def protected void assertEqualsTypeReference(TypeReference expected, TypeReference actual) {
		assertEquals(expected.getClass(), actual.getClass(), "type reference are not from the same type")
		// Note: not necessary to check Primitive type: if the classes are from
		// the same type (e.g.
		// Int) the TypeReferences are equal
		if (expected instanceof ClassifierReference) {
			val ClassifierReference expectedClassifierRef = (expected as ClassifierReference)
			val ClassifierReference actualClassifierRef = (actual as ClassifierReference)
			assertEquals(expectedClassifierRef.getTarget().getName(), actualClassifierRef.getTarget().getName(),
				"Target of type reference does not have the same name")
		}
		if (expected instanceof NamespaceClassifierReference) {
			val NamespaceClassifierReference expectedNamespaceClassifierRef = (expected as NamespaceClassifierReference)
			val NamespaceClassifierReference actualNamespaceClassifierRef = (actual as NamespaceClassifierReference)
			this.assertEqualsTypeReference(expectedNamespaceClassifierRef.getPureClassifierReference(),
				actualNamespaceClassifierRef.getPureClassifierReference())
		}
	}

	def protected OperationSignature createAndSyncOperationSignature(Repository repo,
		OperationInterface opInterface) throws IOException {
		val String operationSignatureName = Pcm2JavaTestUtils.OPERATION_SIGNATURE_1_NAME
		return this.createAndSyncOperationSignature(repo, opInterface, operationSignatureName)
	}

	def private OperationSignature createAndSyncOperationSignature(Repository repo, OperationInterface opInterface,
		String operationSignatureName) throws IOException {
		var OperationSignature result
		repo.record [
			result = pcm.repository.OperationSignature => [
				entityName = operationSignatureName
				interface__OperationSignature = opInterface
			]
		]
		return result;
	}

	@SuppressWarnings("unchecked")
	def protected NamedElement assertSingleCorrespondence(
		org.palladiosimulator.pcm.core.entity.NamedElement pcmNamedElement,
		java.lang.Class<? extends EObject> expectedClass, String expectedName) throws Throwable {
		val Set<NamedElement> namedElements = this.assertCorrespondnecesAndCompareNames(pcmNamedElement, 1,
			(#[expectedClass] as java.lang.Class[]), (#[expectedName] as String[]))
		return namedElements.iterator().next()
	}

	def protected OperationInterface renameInterfaceAndSync(OperationInterface opInterface) throws Throwable {
		val String newValue = opInterface.getEntityName() + Pcm2JavaTestUtils.RENAME
		opInterface.setEntityName(newValue)
		this.saveAndSynchronizeChanges(opInterface)
		return opInterface
	}

	def protected BasicComponent addBasicComponentAndSync(Repository repo, String name) throws Throwable {
		val BasicComponent basicComponent = Pcm2JavaTestUtils.createBasicComponent(repo, name)
		this.saveAndSynchronizeChanges(repo)
		return basicComponent
	}

	def protected BasicComponent addBasicComponentAndSync(Repository repo) throws Throwable {
		return this.addBasicComponentAndSync(repo, Pcm2JavaTestUtils.BASIC_COMPONENT_NAME)
	}

	def protected OperationInterface addInterfaceToReposiotryAndSync(Repository repo,
		String interfaceName) throws Throwable {
		val OperationInterface opInterface = RepositoryFactory.eINSTANCE.createOperationInterface()
		opInterface.setRepository__Interface(repo)
		opInterface.setEntityName(interfaceName)
		this.saveAndSynchronizeChanges(repo)
		return opInterface
	}

	def protected repositoryModelFor(String repositoryName) {
		Path.of('model', '''«repositoryName».«PcmNamespace.REPOSITORY_FILE_EXTENSION»''')
	}

	def protected javaModelFor(String... javaTypePath) {
		var packagePath = JAVA_SOURCE_FOLDER
		for (var i = 0; i < javaTypePath.length - 1; i += 1) {
			packagePath = packagePath.resolve(javaTypePath.get(i))
		}
		return packagePath.resolve(javaTypePath.get(javaTypePath.length - 1) + ".java")
	}

	def protected Repository initRepository(String repositoryName) throws IOException {
		val repository = new Capture<Repository>
		resourceAt(repositoryModelFor(repositoryName)).propagate [
			contents += pcm.repository.Repository => [
				entityName = repositoryName
			] >> repository
		]
		return +repository
	}

	def protected OperationSignature createAndSyncRepoInterfaceAndOperationSignature() throws IOException, Throwable {
		val Repository repo = this.initRepository(Pcm2JavaTestUtils.REPOSITORY_NAME)
		val OperationInterface opInterface = this.addInterfaceToReposiotryAndSync(repo,
			Pcm2JavaTestUtils.INTERFACE_NAME)
		val OperationSignature opSig = this.createAndSyncOperationSignature(repo, opInterface)
		return opSig
	}

	def protected PrimitiveDataType createPrimitiveDataType(PrimitiveTypeEnum type, Repository repository) {
		val PrimitiveDataType dataType = RepositoryFactory.eINSTANCE.createPrimitiveDataType()
		dataType.setType(PrimitiveTypeEnum.INT)
		repository.getDataTypes__Repository().add(dataType)
		return dataType
	}

	def protected Parameter addAndSyncParameterWithPrimitiveTypeToSignature(
		OperationSignature opSig) throws IOException {
		val Repository repo = opSig.getInterface__OperationSignature().getRepository__Interface()
		val PrimitiveDataType dataType = createPrimitiveDataType(PrimitiveTypeEnum.INT, repo)
		return this.addAndSyncParameterToSignature(opSig, dataType, Pcm2JavaTestUtils.PARAMETER_NAME)
	}

	def protected Parameter addAndSyncParameterToSignature(OperationSignature opSig, DataType dataType,
		String parameterName) throws IOException {
		val Parameter param = RepositoryFactory.eINSTANCE.createParameter()
		PcmParameterUtil.setParameterName(param, parameterName)
		param.setDataType__Parameter(dataType)
		param.setModifier__Parameter(ParameterModifier.IN)
		param.setOperationSignature__Parameter(opSig)
		opSig.getParameters__OperationSignature().add(param)
		this.saveAndSynchronizeChanges(opSig)
		return param
	}

	def protected CompositeDataType createAndSyncCompositeDataType(Repository repo, String name) throws Throwable {
		val CompositeDataType cdt = this.createCompositeDataType(repo, name)
		this.saveAndSynchronizeChanges(repo)
		return cdt
	}

	def protected CompositeDataType createCompositeDataType(Repository repo, String name) {
		val CompositeDataType cdt = RepositoryFactory.eINSTANCE.createCompositeDataType()
		cdt.setEntityName(name)
		cdt.setRepository__DataType(repo)
		return cdt
	}

	def protected CompositeDataType createAndSyncCompositeDataType(Repository repo) throws Throwable {
		return this.createAndSyncCompositeDataType(repo, Pcm2JavaTestUtils.COMPOSITE_DATA_TYPE_NAME)
	}

	def protected Parameter createAndSyncRepoOpSigAndParameter() throws IOException, Throwable {
		val OperationSignature opSig = this.createAndSyncRepoInterfaceAndOperationSignature()
		val Parameter param = this.addAndSyncParameterWithPrimitiveTypeToSignature(opSig)
		return param
	}

	def protected Parameter createAndSyncRepoOpSigAndParameterWithDataTypeName(String compositeDataTypeName,
		String parameterName) throws Throwable {
		val OperationSignature opSig = this.createAndSyncRepoInterfaceAndOperationSignature()
		val CompositeDataType cdt = this.createAndSyncCompositeDataType(
			opSig.getInterface__OperationSignature().getRepository__Interface(), compositeDataTypeName)
		val Parameter param = this.addAndSyncParameterToSignature(opSig, cdt, parameterName)
		return param
	}

	def protected InnerDeclaration createAndSyncRepositoryCompositeDataTypeAndInnerDeclaration() throws Throwable {
		val Repository repo = this.initRepository(Pcm2JavaTestUtils.REPOSITORY_NAME)
		val CompositeDataType cdt = this.createAndSyncCompositeDataType(repo)
		val InnerDeclaration innerDec = this.addInnerDeclaration(cdt, repo)
		this.saveAndSynchronizeChanges(repo)
		return innerDec
	}

	def protected InnerDeclaration addInnerDeclaration(CompositeDataType cdt, Repository repo) throws Throwable {
		val InnerDeclaration innerDec = RepositoryFactory.eINSTANCE.createInnerDeclaration()
		val PrimitiveDataType pdt = createPrimitiveDataType(PrimitiveTypeEnum.INT, repo)
		innerDec.setDatatype_InnerDeclaration(pdt)
		// innerDec.setCompositeDataType_InnerDeclaration(cdt);
		innerDec.setEntityName(Pcm2JavaTestUtils.INNER_DEC_NAME)
		cdt.getInnerDeclaration_CompositeDataType().add(innerDec)
		EcoreResourceBridge.saveResource(cdt.eResource())
		return innerDec
	}

	def protected OperationProvidedRole createAndSyncRepoOpIntfOpSigBasicCompAndOperationProvRole() throws IOException, Throwable {
		val OperationSignature opSig = this.createAndSyncRepoInterfaceAndOperationSignature()
		val OperationInterface opInterface = opSig.getInterface__OperationSignature()
		val BasicComponent basicComponent = this.addBasicComponentAndSync(opInterface.getRepository__Interface())
		return this.createAndSyncOperationProvidedRole(opInterface, basicComponent)
	}

	def protected OperationProvidedRole createAndSyncOperationProvidedRole(OperationInterface opInterface,
		InterfaceProvidingEntity interfaceProvidingEntity) throws IOException {
		val OperationProvidedRole operationProvidedRole = RepositoryFactory.eINSTANCE.createOperationProvidedRole()
		operationProvidedRole.setEntityName(
			'''«interfaceProvidingEntity.getEntityName()»_provides_«opInterface.getEntityName()»''')
		operationProvidedRole.setProvidedInterface__OperationProvidedRole(opInterface)
		operationProvidedRole.setProvidingEntity_ProvidedRole(interfaceProvidingEntity)
		this.saveAndSynchronizeChanges(opInterface)
		return operationProvidedRole
	}

	def protected OperationRequiredRole createAndSyncRepoBasicCompInterfaceAndOperationReqiredRole() throws IOException, Throwable {
		val OperationSignature opSig = this.createAndSyncRepoInterfaceAndOperationSignature()
		val OperationInterface opInterface = opSig.getInterface__OperationSignature()
		val BasicComponent basicComponent = this.addBasicComponentAndSync(opInterface.getRepository__Interface())
		val OperationRequiredRole operationRequiredRole = this.
			createAndSyncOperationRequiredRole(opInterface, basicComponent)
		return operationRequiredRole
	}

	def protected OperationRequiredRole createAndSyncOperationRequiredRole(OperationInterface opInterface,
		InterfaceProvidingRequiringEntity iprovidingRequiringEntity) throws Throwable {
		val OperationRequiredRole operationRequiredRole = RepositoryFactory.eINSTANCE.createOperationRequiredRole()
		operationRequiredRole.setEntityName(opInterface.getEntityName().toLowerCase())
		operationRequiredRole.setRequiredInterface__OperationRequiredRole(opInterface)
		operationRequiredRole.setRequiringEntity_RequiredRole(iprovidingRequiringEntity)
		this.saveAndSynchronizeChanges(iprovidingRequiringEntity)
		return operationRequiredRole
	}

	def protected String createSystemPathInProject(String systemName) {
		return '''model/«systemName».«PcmNamespace.SYSTEM_FILE_EXTENSION»'''
	}

	def protected System createAndSyncSystem(String systemName) throws Throwable {
		val System system = Pcm2JavaTestUtils.createSystem(systemName)
		createAndSynchronizeModel(createSystemPathInProject(systemName), system)
		return system
	}

	def protected AssemblyContext createAndSyncAssemblyContext(
		ComposedProvidingRequiringEntity composedProvidingRequiringEntity,
		BasicComponent basicComponent) throws IOException {
		val AssemblyContext assemblyContext = CompositionFactory.eINSTANCE.createAssemblyContext()
		assemblyContext.setEntityName(Pcm2JavaTestUtils.ASSEMBLY_CONTEXT_NAME)
		assemblyContext.setEncapsulatedComponent__AssemblyContext(basicComponent)
		assemblyContext.setParentStructure__AssemblyContext(composedProvidingRequiringEntity)
		this.saveAndSynchronizeChanges(composedProvidingRequiringEntity)
		return assemblyContext
	}

	def protected CompositeComponent createAndSyncCompositeComponent(Repository repo, String name) throws Throwable {
		val CompositeComponent compositeComponent = Pcm2JavaTestUtils.createCompositeComponent(repo, name)
		this.saveAndSynchronizeChanges(repo)
		return compositeComponent
	}

	/** 
	 * a operation provided is represented by the main class implementing the interface and an
	 * import
	 * @param operationProvidedRole
	 * @throws Throwable
	 */
	def protected void assertOperationProvidedRole(OperationProvidedRole operationProvidedRole) throws Throwable {
		val Set<EObject> correspondingEObjects = CorrespondenceModelUtil.getCorrespondingEObjects(correspondenceModel,
			operationProvidedRole)
		var int namespaceClassifierReferenceFound = 0
		var int importFound = 0
		for (EObject eObject : correspondingEObjects) {
			if (eObject instanceof NamespaceClassifierReference) {
				namespaceClassifierReferenceFound++
			} else if (eObject instanceof ClassifierImport) {
				importFound++
			} else {
				fail('''operation provided role corresponds to unexpected object: «eObject»''')
			}
		}
		assertEquals("unexpected size of corresponding imports", 1, importFound)
		assertEquals("unexpected size of corresponding namespace classifier references", 1,
			namespaceClassifierReferenceFound)
	}

	/** 
	 * ap operation required role is represented by one constructor parameter (per constructor), one
	 * assignment in the constructor (per constructor) and a field with the type of the interface as
	 * well as the import of the required interface in the components main class
	 * @param operationRequiredRole
	 * @throws Throwable
	 */
	def protected void assertOperationRequiredRole(OperationRequiredRole operationRequiredRole) throws Throwable {
		val Set<EObject> correspondingEObjects = CorrespondenceModelUtil.getCorrespondingEObjects(correspondenceModel,
			operationRequiredRole)
		var int importFounds = 0
		var int constructorParameterFound = 0
		var int fieldsFound = 0
		/*FIXME Cannot add Annotation to Variable declaration. Java code: @SuppressWarnings("unused")*/
		var int assignmentOperatorsFound = 0
		var int expectedConstrucotrParameters = 0
		for (EObject correspondingEObj : correspondingEObjects) {
			if (correspondingEObj instanceof Import) {
				importFounds++
			} else if (correspondingEObj instanceof org.emftext.language.java.parameters.Parameter) {
				constructorParameterFound++
				val org.emftext.language.java.parameters.Parameter param = (correspondingEObj as org.emftext.language.java.parameters.Parameter)
				assertTrue("Corresponding parameter has wrong name",
					param.getName().equalsIgnoreCase(operationRequiredRole.getEntityName()))
			} else if (correspondingEObj instanceof Statement) {
				assignmentOperatorsFound++
			} else if (correspondingEObj instanceof Field) {
				fieldsFound++
				val Field field = (correspondingEObj as Field)
				val Class jaMoPPClass = (field.getContainingConcreteClassifier() as Class)
				for (Member member : jaMoPPClass.getMembers()) {
					if (member instanceof Constructor) {
						expectedConstrucotrParameters++
					}
				}
				assertTrue("Corresponding field has wrong name",
					field.getName().equalsIgnoreCase(operationRequiredRole.getEntityName()))
			} else {
				fail('''operation required role corresponds to unexpected object: «correspondingEObj»''')
			}
		}
		assertEquals("Unexpected number of imports found", 1, importFounds)
		assertEquals("Unexpected number of constructorParameters found", expectedConstrucotrParameters,
			constructorParameterFound)
		assertEquals("Unexpected number of fields found", 1, fieldsFound) // we currently do not synchronize the assignment statements
		// assertEquals("Unexpected number of imports found", assignmentOperatorsFound,
		// constructorParameterFound);
	}

	/** 
	 * AssemblyContext should correspond to a field, a constructor, an import and to a new
	 * constructor call
	 * @param assemblyContext
	 * @throws Throwable
	 */
	def protected void assertAssemblyContext(AssemblyContext assemblyContext) throws Throwable {
		val Set<EObject> correspondingEObjects = CorrespondenceModelUtil.getCorrespondingEObjects(correspondenceModel,
			assemblyContext)
		var boolean fieldFound = false
		var boolean importFound = false
		var boolean newConstructorCallFound = false
		var boolean constructorFound = false
		for (EObject correspondingEObject : correspondingEObjects) {
			if (correspondingEObject instanceof Field) {
				val Field field = (correspondingEObject as Field)
				assertEquals("The name of the field has to be the same as the name of the assembly context",
					assemblyContext.getEntityName(), field.getName())
				fieldFound = true
			}
			if (correspondingEObject instanceof Import) {
				importFound = true
			}
			if (correspondingEObject instanceof NewConstructorCall) {
				newConstructorCallFound = true
			}
			if (correspondingEObject instanceof Constructor) {
				constructorFound = true
			}
		}
		assertTrue("Could not find corresponding constructor", constructorFound)
		assertTrue("Could not find corresponding import", importFound)
		assertTrue("Could not find corresponding new constructor call", newConstructorCallFound)
		assertTrue("Could not find corresponding field", fieldFound)
	}

	@SuppressWarnings("unused")
	def Repository createMediaStore(String mediaStoreName, String webGUIName, String downloadMethodName,
		String uploadMethodName) throws Throwable {
		this.beforeTest()
		// create repo
		val Repository repo = this.initRepository("mediastorerepo")
		// create component
		val BasicComponent mediaStoreBC = this.addBasicComponentAndSync(repo, mediaStoreName)
		val BasicComponent webGUIBC = this.addBasicComponentAndSync(repo, webGUIName)
		// create interfaces
		val OperationInterface iMediaStoreIf = this.addInterfaceToReposiotryAndSync(repo, '''I«mediaStoreName»''')
		val OperationInterface iwebGUIIf = this.addInterfaceToReposiotryAndSync(repo, '''I«webGUIName»''')
		// create signatures
		val OperationSignature downloadMediaStore = this.createAndSyncOperationSignature(repo, iMediaStoreIf,
			downloadMethodName)
		val OperationSignature uploadMediaStore = this.createAndSyncOperationSignature(repo, iMediaStoreIf,
			uploadMethodName)
		val OperationSignature downloadWebGUI = this.
			createAndSyncOperationSignature(repo, iwebGUIIf, '''http«downloadMethodName»''')
		val OperationSignature uploadWebGUI = this.
			createAndSyncOperationSignature(repo, iwebGUIIf, '''http«uploadMethodName»''')
		// create provided roles
		val OperationProvidedRole mediaStore2IMediaStore = this.
			createAndSyncOperationProvidedRole(iMediaStoreIf, mediaStoreBC)
		val OperationProvidedRole webGUI2IWebGUI = this.createAndSyncOperationProvidedRole(iwebGUIIf, webGUIBC)
		// create required role
		val OperationRequiredRole webGui2MediaStore = this.createAndSyncOperationRequiredRole(iMediaStoreIf, webGUIBC)
		// Create seff for provided roles
		this.createAndSyncSeff(mediaStoreBC, downloadMediaStore)
		this.createAndSyncSeff(mediaStoreBC, uploadMediaStore)
		this.createAndSyncSeff(webGUIBC, downloadWebGUI)
		this.createAndSyncSeff(webGUIBC, uploadWebGUI)
		return repo
	}

	def protected ResourceDemandingSEFF createAndSyncSeff(BasicComponent basicComponent,
		OperationSignature describedSignature) throws Throwable {
		val ResourceDemandingSEFF rdSEFF = SeffFactory.eINSTANCE.createResourceDemandingSEFF()
		rdSEFF.setBasicComponent_ServiceEffectSpecification(basicComponent)
		rdSEFF.setDescribedService__SEFF(describedSignature)
		this.saveAndSynchronizeChanges(basicComponent)
		return rdSEFF
	}

	override protected List<VitruvDomain> getVitruvDomains() {
		var List<VitruvDomain> result = new ArrayList()
		result.add(new PcmDomainProvider().getDomain())
		result.add(new JavaDomainProvider().getDomain())
		return result
	}

	/** 
	 * innerDeclaration must have 3 correspondences: one field, one getter and one setter
	 * @param innerDec
	 * @throws Throwable
	 */
	def protected void assertInnerDeclaration(InnerDeclaration innerDec) throws Throwable {
		val Set<EObject> correspondingObjects = CorrespondenceModelUtil.getCorrespondingEObjects(correspondenceModel,
			innerDec)
		var int fieldsFound = 0
		var int methodsFound = 0
		var String fieldName = null
		var String fieldTypeName = null
		for (EObject eObject : correspondingObjects) {
			if (eObject instanceof Field) {
				fieldsFound++
				val Field field = (eObject as Field)
				fieldName = field.getName()
				fieldTypeName = getNameFromJaMoPPType(field.getTypeReference())
				assertTrue("field name unexpected",
					field.getName().toLowerCase().contains(innerDec.getEntityName().toLowerCase()))
			} else if (eObject instanceof Method) {
				methodsFound++
			} else {
				fail('''unexpected corresponding object for inner declartion found: «eObject»''')
			}
		}
		assertEquals("unexpected number of corresponding fields found", 1, fieldsFound)
		assertEquals("unexpected number of corresponding methods found", 2, methodsFound)
		val String expectedName = innerDec.getEntityName()
		assertEquals("name of field does not mathc name of inner declaration", expectedName, fieldName)
		val String expectedTypeName = PcmDataTypeUtil.getNameFromPCMDataType(innerDec.getDatatype_InnerDeclaration())
		assertEquals("name of JaMoPP type is not expected name of PCM datatype", expectedTypeName.toLowerCase(),
			fieldTypeName.toLowerCase())
	}

	def protected void assertCompilationUnitForBasicComponentDeleted(BasicComponent basicComponent) throws Throwable {
		val String expectedClassName = '''«basicComponent.getEntityName()»Impl'''
		if (existsClass(expectedClassName)) {
			fail(
				'''CompilationUnit with name «expectedClassName» for component «basicComponent.getEntityName()» still exists.'''.
					toString)
		}
	}

	def protected void assertCompilationUnitForSystemDeleted(System system) throws Throwable {
		val String expectedClassName = '''«system.getEntityName()»Impl'''
		if (existsClass(expectedClassName)) {
			fail(
				'''CompilationUnit with name «expectedClassName» for component «system.getEntityName()» still exists.'''.
					toString)
		}
	}

	def protected boolean existsClass(String expectedClassName) throws Throwable {
		return containsClass(this.getCurrentTestProjectFolder(), expectedClassName) // final IProject testProject =
		// TestUtil.getProjectByName(this.getCurrentTestProject().getName());
		//
		// final IJavaProject javaProject = JavaCore.create(testProject);
		// for (final IPackageFragment pkg : javaProject.getPackageFragments()) {
		// for (final ICompilationUnit unit : pkg.getCompilationUnits()) {
		// if (unit.getElementName().contains(expectedClassName)) {
		// return true;
		// }
		// }
		// }
		// return false;
	}

	def private boolean containsClass(File packageFolder, String expectedClassName) {
		for (File file : packageFolder.listFiles()) {
			if (file.isDirectory()) {
				if (containsClass(file, expectedClassName)) {
					return true
				}
			} else if (file.isFile()) {
				if (file.getName().equals('''«expectedClassName».java''')) {
					return true
				}
			}
		}
		return false
	}

	def protected CollectionDataType addCollectionDatatypeAndSync(Repository repo, String name,
		DataType innerType) throws IOException {
		val CollectionDataType cdt = RepositoryFactory.eINSTANCE.createCollectionDataType()
		cdt.setEntityName(name)
		cdt.setRepository__DataType(repo)
		if (null !== innerType) {
			cdt.setInnerType_CollectionDataType(innerType)
		}
		super.saveAndSynchronizeChanges(repo)
		return cdt
	}
}
