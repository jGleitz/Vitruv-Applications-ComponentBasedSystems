package tools.vitruv.applications.umljava.uml2java

import org.apache.log4j.Logger
import org.eclipse.uml2.uml.Model
import org.eclipse.uml2.uml.Property
import org.eclipse.uml2.uml.UMLFactory

import static tools.vitruv.domains.java.util.JavaPersistenceHelper.*
import org.eclipse.uml2.uml.Operation
import tools.vitruv.testutils.VitruvApplicationTest
import org.junit.jupiter.api.BeforeEach
import tools.vitruv.testutils.domains.DomainUtil
import tools.vitruv.domains.uml.UmlDomainProvider
import java.nio.file.Path

/**
 * Abstract super class for uml to java test cases.
 * Initializes a uml rootmodel.
 * 
 * @author Fei
 */
abstract class Uml2JavaTransformationTest extends VitruvApplicationTest {
    protected static val final Logger logger = Logger.getLogger(typeof(Uml2JavaTransformationTest).simpleName);
    
	static val UML_MODEL = DomainUtil.getModelFileName(Path.of("model", "model"), new UmlDomainProvider)

	override protected getChangePropagationSpecifications() {
		return #[new UmlToJavaChangePropagationSpecification()]; 
	}

	@BeforeEach
    def createUmlModel() {
    	resourceAt(UML_MODEL).propagate [
    		contents += 
    	]
        val umlModel = UMLFactory.eINSTANCE.createModel();
        umlModel.name = tools.vitruv.applications.umljava.uml2java.Uml2JavaTransformationTest.UML_MODEL;
        createAndSynchronizeModel(tools.vitruv.applications.umljava.uml2java.Uml2JavaTransformationTest.UML_MODEL.projectModelPath, umlModel);
    }

	def protected assertJavaFileExists(String fileName, String[] namespaces) {
	    assertModelExists(buildJavaFilePath(fileName + ".java", namespaces));
	}
    def protected assertJavaFileNotExists(String fileName, String[] namespaces) {
        assertModelNotExists(buildJavaFilePath(fileName + ".java", namespaces));
    }
    
    /**
     * Retrieves the first corresponding java field for a given uml property
     */
    def protected getCorrespondingAttribute(Property uAttribute) {
    	return getFirstCorrespondingObjectWithClass(uAttribute, org.emftext.language.java.members.Field)
    }
    
    /**
     * Retrieves the first corresponding java class method for a given uml operation
     */
    def protected getCorrespondingClassMethod(Operation uOperation) {
    	return getFirstCorrespondingObjectWithClass(uOperation, org.emftext.language.java.members.ClassMethod)
    }
    
    /**
     * Retrieves the first corresponding java interface method for a given uml operation
     */
    def protected getCorrespondingInterfaceMethod(Operation uOperation) {
    	return getFirstCorrespondingObjectWithClass(uOperation, org.emftext.language.java.members.InterfaceMethod)
    }
    
    /**
     * Retrieves the first corresponding java class for a given uml class
     */
    def protected getCorrespondingClass(org.eclipse.uml2.uml.Classifier uClass) {
    	return getFirstCorrespondingObjectWithClass(uClass, org.emftext.language.java.classifiers.Class)
    }
    
    /**
     * Retrieves the first corresponding java compilationunit for a given uml class
     */
    def protected getCorrespondingCompilationUnit(org.eclipse.uml2.uml.Class uClass) {
        return getFirstCorrespondingObjectWithClass(uClass, org.emftext.language.java.containers.CompilationUnit)
    }
    
    /**
     * Retrieves the first corresponding java interface for a given uml interface
     */
    def protected getCorrespondingInterface(org.eclipse.uml2.uml.Interface uInterface) {
    	return getFirstCorrespondingObjectWithClass(uInterface, org.emftext.language.java.classifiers.Interface)
    }
    
    /**
     * Retrieves the first corresponding java enumeration for a given uml enumeration
     */
    def protected getCorrespondingEnum(org.eclipse.uml2.uml.Enumeration uEnumeration) {
    	return getFirstCorrespondingObjectWithClass(uEnumeration, org.emftext.language.java.classifiers.Enumeration)
    }
    
    /**
     * Retrieves the first corresponding java ordinary parameter for a given uml parameter
     */
    def protected getCorrespondingParameter(org.eclipse.uml2.uml.Parameter uParam) {
    	return getFirstCorrespondingObjectWithClass(uParam, org.emftext.language.java.parameters.OrdinaryParameter)
    }
    
    /**
     * Retrieves the first corresponding java package for a given uml package
     */
    def protected getCorrespondingPackage(org.eclipse.uml2.uml.Package uPackage) {
        return getFirstCorrespondingObjectWithClass(uPackage, org.emftext.language.java.containers.Package)
    }
    
    /**
     * Retrieves the first corresponding java constructor for a given uml operation
     */
    def protected getCorrespondingConstructor(org.eclipse.uml2.uml.Operation uOperation) {
        return getFirstCorrespondingObjectWithClass(uOperation, org.emftext.language.java.members.Constructor)
    }
    
    
    
}
