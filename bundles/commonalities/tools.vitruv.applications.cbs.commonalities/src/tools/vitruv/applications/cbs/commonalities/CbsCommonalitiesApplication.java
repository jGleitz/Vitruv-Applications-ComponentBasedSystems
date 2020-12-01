package tools.vitruv.applications.cbs.commonalities;

import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import edu.kit.ipd.sdq.commons.util.java.Pair;
import tools.vitruv.framework.applications.AbstractVitruvApplication;
import tools.vitruv.framework.change.processing.ChangePropagationSpecification;
import tools.vitruv.framework.domains.VitruvDomain;
import tools.vitruv.framework.change.processing.impl.CompositeDecomposingChangePropagationSpecification;

public class CbsCommonalitiesApplication extends AbstractVitruvApplication {
    @Override
    public Set<ChangePropagationSpecification> getChangePropagationSpecifications () {
        // TODO The Commonalities language should // generate a combined
        // change propagation specification for all the partial change propagation specifications it
        // generates via the Reactions language.
        Stream .of( // generate with:
                // find src-gen -type f -name '*ChangePropagationSpecification.java' -printf "%P\n"
                // | sed -E 's|/|.|g;s|(.*)\.java|new \1()|g' | paste -sd "," -
                new mir.reactions.operationFromPCM.OperationFromPCMChangePropagationSpecification(),
                new mir.reactions.classMethodToJava.ClassMethodToJavaChangePropagationSpecification(),
                new mir.reactions.propertyFromJava.PropertyFromJavaChangePropagationSpecification(),
                new mir.reactions.interfaceFromUML.InterfaceFromUMLChangePropagationSpecification(),
                new mir.reactions.interfaceToUML.InterfaceToUMLChangePropagationSpecification(),
                new mir.reactions.operationParameterFromObjectOrientedDesign.OperationParameterFromObjectOrientedDesignChangePropagationSpecification(),
                new mir.reactions.componentInterfaceToPCM.ComponentInterfaceToPCMChangePropagationSpecification(),
                new mir.reactions.compositeDataTypeElementToPCM.CompositeDataTypeElementToPCMChangePropagationSpecification(),
                new mir.reactions.repositoryToPCM.RepositoryToPCMChangePropagationSpecification(),
                new mir.reactions.constructorToJava.ConstructorToJavaChangePropagationSpecification(),
                new mir.reactions.classMethodToUML.ClassMethodToUMLChangePropagationSpecification(),
                new mir.reactions.interfaceToJava.InterfaceToJavaChangePropagationSpecification(),
                new mir.reactions.propertyToUML.PropertyToUMLChangePropagationSpecification(),
                new mir.reactions.repositoryFromObjectOrientedDesign.RepositoryFromObjectOrientedDesignChangePropagationSpecification(),
                new mir.reactions.componentFromObjectOrientedDesign.ComponentFromObjectOrientedDesignChangePropagationSpecification(),
                new mir.reactions.operationToObjectOrientedDesign.OperationToObjectOrientedDesignChangePropagationSpecification(),
                new mir.reactions.operationParameterFromPCM.OperationParameterFromPCMChangePropagationSpecification(),
                new mir.reactions.compositeDataTypeToObjectOrientedDesign.CompositeDataTypeToObjectOrientedDesignChangePropagationSpecification(),
                new mir.reactions.compositeDataTypeElementFromPCM.CompositeDataTypeElementFromPCMChangePropagationSpecification(),
                new mir.reactions.classMethodFromJava.ClassMethodFromJavaChangePropagationSpecification(),
                new mir.reactions.classMethodFromUML.ClassMethodFromUMLChangePropagationSpecification(),
                new mir.reactions.propertyToJava.PropertyToJavaChangePropagationSpecification(),
                new mir.reactions.classToUML.ClassToUMLChangePropagationSpecification(),
                new mir.reactions.compositeDataTypeFromPCM.CompositeDataTypeFromPCMChangePropagationSpecification(),
                new mir.reactions.constructorFromJava.ConstructorFromJavaChangePropagationSpecification(),
                new mir.reactions.packageFromJava.PackageFromJavaChangePropagationSpecification(),
                new mir.reactions.operationFromObjectOrientedDesign.OperationFromObjectOrientedDesignChangePropagationSpecification(),
                new mir.reactions.methodParameterFromJava.MethodParameterFromJavaChangePropagationSpecification(),
                new mir.reactions.repositoryFromPCM.RepositoryFromPCMChangePropagationSpecification(),
                new mir.reactions.componentFromPCM.ComponentFromPCMChangePropagationSpecification(),
                new mir.reactions.operationToPCM.OperationToPCMChangePropagationSpecification(),
                new mir.reactions.constructorFromUML.ConstructorFromUMLChangePropagationSpecification(),
                new mir.reactions.packageFromUML.PackageFromUMLChangePropagationSpecification(),
                new mir.reactions.operationParameterToObjectOrientedDesign.OperationParameterToObjectOrientedDesignChangePropagationSpecification(),
                new mir.reactions.compositeDataTypeElementToObjectOrientedDesign.CompositeDataTypeElementToObjectOrientedDesignChangePropagationSpecification(),
                new mir.reactions.interfaceMethodToJava.InterfaceMethodToJavaChangePropagationSpecification(),
                new mir.reactions.operationParameterToPCM.OperationParameterToPCMChangePropagationSpecification(),
                new mir.reactions.componentToPCM.ComponentToPCMChangePropagationSpecification(),
                new mir.reactions.methodParameterToUML.MethodParameterToUMLChangePropagationSpecification(),
                new mir.reactions.classToJava.ClassToJavaChangePropagationSpecification(),
                new mir.reactions.interfaceFromJava.InterfaceFromJavaChangePropagationSpecification(),
                new mir.reactions.compositeDataTypeElementFromObjectOrientedDesign.CompositeDataTypeElementFromObjectOrientedDesignChangePropagationSpecification(),
                new mir.reactions.compositeDataTypeFromObjectOrientedDesign.CompositeDataTypeFromObjectOrientedDesignChangePropagationSpecification(),
                new mir.reactions.methodParameterToJava.MethodParameterToJavaChangePropagationSpecification(),
                new mir.reactions.methodParameterFromUML.MethodParameterFromUMLChangePropagationSpecification(),
                new mir.reactions.interfaceMethodToUML.InterfaceMethodToUMLChangePropagationSpecification(),
                new mir.reactions.interfaceMethodFromJava.InterfaceMethodFromJavaChangePropagationSpecification(),
                new mir.reactions.componentToObjectOrientedDesign.ComponentToObjectOrientedDesignChangePropagationSpecification(),
                new mir.reactions.repositoryToObjectOrientedDesign.RepositoryToObjectOrientedDesignChangePropagationSpecification(),
                new mir.reactions.componentInterfaceToObjectOrientedDesign.ComponentInterfaceToObjectOrientedDesignChangePropagationSpecification(),
                new mir.reactions.compositeDataTypeToPCM.CompositeDataTypeToPCMChangePropagationSpecification(),
                new mir.reactions.classFromUML.ClassFromUMLChangePropagationSpecification(),
                new mir.reactions.interfaceMethodFromUML.InterfaceMethodFromUMLChangePropagationSpecification(),
                new mir.reactions.componentInterfaceFromPCM.ComponentInterfaceFromPCMChangePropagationSpecification(),
                new mir.reactions.propertyFromUML.PropertyFromUMLChangePropagationSpecification(),
                new mir.reactions.packageToJava.PackageToJavaChangePropagationSpecification(),
                new mir.reactions.packageToUML.PackageToUMLChangePropagationSpecification(),
                new mir.reactions.constructorToUML.ConstructorToUMLChangePropagationSpecification(),
                new mir.reactions.componentInterfaceFromObjectOrientedDesign.ComponentInterfaceFromObjectOrientedDesignChangePropagationSpecification(),
                new mir.reactions.classFromJava.ClassFromJavaChangePropagationSpecification()).collect(Collectors.groupingBy(spec -> new Pair(spec.getSourceDomain(), spec.getTargetDomain()))).entrySet().stream().map(entry -> new CombinedChangePropagationSpecification(entry.getKey(), entry.getValue()))
    }

    @Override
    public String getName() {
        return "CBS Commonalities";
    }

    private static class CombinedChangePropagationSpecification
    extends CompositeDecomposingChangePropagationSpecification {
        CombinedChangePropagationSpecification(Pair<VitruvDomain, VitruvDomain> domains,
                Iterable<? extends ChangePropagationSpecification> specifications) {
            super(domains.getFirst(), domains.getSecond());
            specifications.forEach(this::addChangeMainprocessor);
        }
    }
}
