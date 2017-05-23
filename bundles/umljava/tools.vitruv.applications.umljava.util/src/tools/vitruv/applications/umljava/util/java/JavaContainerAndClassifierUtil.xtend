package tools.vitruv.applications.umljava.util.java

import java.io.ByteArrayInputStream
import java.util.Collections
import java.util.Iterator
import java.util.List
import org.apache.log4j.Logger
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.util.EcoreUtil
import org.emftext.language.java.classifiers.Class
import org.emftext.language.java.classifiers.ClassifiersFactory
import org.emftext.language.java.classifiers.ConcreteClassifier
import org.emftext.language.java.classifiers.Interface
import org.emftext.language.java.containers.CompilationUnit
import org.emftext.language.java.containers.ContainersFactory
import org.emftext.language.java.containers.JavaRoot
import org.emftext.language.java.containers.Package
import org.emftext.language.java.imports.ClassifierImport
import org.emftext.language.java.members.Constructor
import org.emftext.language.java.members.Field
import org.emftext.language.java.types.NamespaceClassifierReference
import org.emftext.language.java.types.TypeReference
import tools.vitruv.domains.java.util.jamoppparser.JamoppParser
import static tools.vitruv.applications.umljava.util.java.JavaModifierUtil.*
import static tools.vitruv.applications.umljava.util.java.JavaTypeUtil.*
import org.emftext.language.java.members.EnumConstant
import org.emftext.language.java.classifiers.Enumeration
import java.io.File
import java.io.PrintWriter
import org.emftext.language.java.commons.NamedElement
import org.emftext.language.java.members.Member
import org.emftext.language.java.parameters.Parameter
import java.util.ArrayList

/**
 * Class for java classifier, package and compilation unit util functions
 * 
 * @author Fei
 */
class JavaContainerAndClassifierUtil {
    private static val logger = Logger.getLogger(JavaContainerAndClassifierUtil.simpleName)
    private new() {
        
    }
    
    /**
     * Creates and return a  new java class with the given name, visibility and modifiers
     * The new class is not contained in a compilation unit.
     * 
     * @param name the name of the class
     * @param visibility the visibility of the class
     * @param abstr if the class should be abstract
     * @param fin if the class should be final
     * @return the new class with the given attributes
     */
    def static createJavaClass(String name, JavaVisibility visibility, boolean abstr, boolean fin) {
        val jClass = ClassifiersFactory.eINSTANCE.createClass;
        setName(jClass, name)
        setJavaVisibilityModifier(jClass, visibility)
        setAbstract(jClass, abstr)
        setFinal(jClass, fin)

        return jClass;
    }
    /**
     * Creates a new java package
     * 
     * @param name the name of the new package
     * @param containingPackage the super package of the new package or null if it is the default package
     * @return the new package
     */
    def static createJavaPackage(String name, Package containingPackage) {
        val jPackage = ContainersFactory.eINSTANCE.createPackage
        setName(jPackage, name)
        jPackage.namespaces += getJavaPackageAsStringList(containingPackage)
        return jPackage
    }
    
    /**
     * Creates a new java interface with the given name and list of super interfaces
     * The created interface is not contained in a compilation unit.
     * 
     * @param name the name of the interface
     * @param superInterfaces the superinterfaces of the interface
     * @return the new interface
     */
    def static createJavaInterface(String name, List<Interface> superInterfaces) {
        val jInterface = ClassifiersFactory.eINSTANCE.createInterface;
        setName(jInterface, name)
        jInterface.makePublic;
        if (!superInterfaces.nullOrEmpty) {
            jInterface.extends.addAll(createNamespaceReferenceFromList(superInterfaces));
        }
        return jInterface;
    }
    
    /**
     * Creats a new java enum with the given properties
     * The created Enum is not contained in a compilationunit.
     * 
     * @param name the name of the enum
     * @param visibility the visibility of the enum
     * @param constantsList list of enum constants for the enum
     * @return the new enum
     */
    def static createJavaEnum(String name, JavaVisibility visibility, List<EnumConstant> constantsList) {
        val jEnum = ClassifiersFactory.eINSTANCE.createEnumeration;
        setName(jEnum, name)
        setJavaVisibilityModifier(jEnum, visibility)
        addEnumConstantIfNotNull(jEnum, constantsList)
        return jEnum;
    }
    
    /**
     * Add constantList to the enum constants of the given jEnum if constantsList is not null or empty
     * 
     */
    def static addEnumConstantIfNotNull(Enumeration jEnum, List<EnumConstant> constantsList) {
        if (!constantsList.nullOrEmpty) {
            jEnum.constants.addAll(constantsList)
        }
    }
    
    /**
     * Creates a java compilation unit with the given naem
     * The method automatically sets the .java FileExtension for the compilation unit name
     * There are no classifiers in the compilation unit yet.
     * 
     * @param nameWithoutFileExtension the name without .java file extension
     * @return the new compilation unit
     */
    def static createEmptyCompilationUnit(String nameWithoutFileExtension) {
        val cu = ContainersFactory.eINSTANCE.createCompilationUnit
        cu.name = nameWithoutFileExtension + ".java"
        return cu
    }
    
    def static createJavaCompilationUnitWithClassifierInPackage(ConcreteClassifier jClassifier, Package jPackage) {
        val compUnit = createEmptyCompilationUnit(jClassifier.name)
        compUnit.classifiers += jClassifier
        compUnit.namespaces.addAll(getJavaPackageAsStringList(jPackage))
        return compUnit
    }
    
    /**
     * Creates a Java-ClassifierImport from a qualified name
     */
    def static ClassifierImport createJavaClassImport(String qualifiedName) {
        val content = "package dummyPackage;\n " +
                "import " + qualifiedName + ";\n" +
                "public class DummyClass {}";
        val dummyCU = createJavaRoot("DummyClass", content) as CompilationUnit;
        val classifierImport = (dummyCU.getImports().get(0) as ClassifierImport)
        return classifierImport;
        
    }
    
    /**
     * Creates a JavaRoot Object with the given content
     * 
     */
    def static JavaRoot createJavaRoot(String name, String content) {
        val JamoppParser jaMoPPParser = new JamoppParser
        val inStream = new ByteArrayInputStream(content.bytes)
        val javaRoot = jaMoPPParser.parseCompilationUnitFromInputStream(URI.createFileURI(name + ".java"),
            inStream)
        javaRoot.name = name + ".java"
        EcoreUtil.remove(javaRoot)
        return javaRoot
    }
        
    /**
     * Removes all classifiers of the iterator which has the same name as the given classifier classif
     * 
     * @param iter iterator of typreferences
     * @param classif classifier that shoud be removed from the iterator
     */
    def static removeClassifierFromIterator(Iterator<TypeReference> iter, ConcreteClassifier classif) {
        while (iter.hasNext) {
            val type = (iter.next as NamespaceClassifierReference).classifierReferences.head.target
            if (classif.name.equals(type.name)) {
                iter.remove;
            }
        }
    }
    
    /**
     * For org.example.package it will return [org, example, package]
     * Returns empty list if jPackage is the default package.
     * 
     */
    def static getJavaPackageAsStringList(Package jPackage) {
       if (jPackage === null || jPackage.name.nullOrEmpty) { //Defaultpackage
           return Collections.<String>emptyList()
       }
       val packageStringList = new ArrayList<String>()
       packageStringList.addAll(jPackage.namespaces)
       packageStringList += jPackage.name
       return packageStringList
   }
   
   def static Field getJavaAttributeByName(Class jClass, String attributeName) {
       val candidates = jClass.members.filter(Field)
       for (member : candidates) {
           if (member.name == attributeName) {
               return member as Field
           }
       }
       return null
   }
   
   def static Constructor getFirstJavaConstructor(Class jClass) {
       val candidates = jClass.members.filter(Constructor)
       if (!candidates.nullOrEmpty) {
           return candidates.head
       } else {
           return null
       }
   }
   
   def static removeJavaClassifierFromPackage(Package jPackage, ConcreteClassifier jClassifier) {
        val iter = jPackage.compilationUnits.iterator
        while (iter.hasNext) {
            if (iter.next.name.equals(jClassifier.name)) {
                iter.remove;
            }
        }
    }
    
    def static File createPackageInfo(String directory, String packageName) {
        val file = new File(directory +  "/package-info.java")
        file.createNewFile
        val writer = new PrintWriter(file)
        writer.println("package " + packageName + ";")
        writer.close
        return file
    }
    
    /**
     * Returns the namespace of the compilation unit where the given object is directly or indirectly contained
     * 
     */
    def static dispatch List<String> getJavaNamespace(CompilationUnit compUnit) {
        return compUnit.namespaces
    }
    
    def static dispatch List<String> getJavaNamespace(ConcreteClassifier classifier) {
        return getJavaNamespace(classifier.eContainer as CompilationUnit)
    }
    
    def static dispatch List<String> getJavaNamespace(NamedElement element) {
        throw new IllegalArgumentException("Unsupported type for retrieving namespace: " + element)
    }
    def static dispatch List<String> getJavaNamespace(Void element) {
        throw new IllegalArgumentException("Can not retrieve namespace for " + element)
    }
    
    def static dispatch CompilationUnit getContainingCompilationUnit(ConcreteClassifier classifier) {
        return classifier.eContainer as CompilationUnit
    }
    def static dispatch CompilationUnit getContainingCompilationUnit(Member mem) {
        return getContainingCompilationUnit(mem.eContainer as ConcreteClassifier)
    }
    def static dispatch CompilationUnit getContainingCompilationUnit(Parameter param) {
        return getContainingCompilationUnit(param.eContainer as Member)
    }
    
    def static dispatch CompilationUnit getContainingCompilationUnit(NamedElement element) {
        throw new IllegalArgumentException("Unsupported type for retrieving compilation unit: " + element)
    }
    def static dispatch CompilationUnit getContainingCompilationUnit(Void element) {
        throw new IllegalArgumentException("Can not retrieve compilation unit for " + element)
    }
}