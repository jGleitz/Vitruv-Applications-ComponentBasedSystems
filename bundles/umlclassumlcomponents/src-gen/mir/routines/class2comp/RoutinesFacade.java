package mir.routines.class2comp;

import org.eclipse.uml2.uml.DataType;
import org.eclipse.uml2.uml.Model;
import org.eclipse.uml2.uml.NamedElement;
import org.eclipse.uml2.uml.PrimitiveType;
import org.eclipse.uml2.uml.Property;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractRepairRoutinesFacade;
import tools.vitruv.extensions.dslsruntime.reactions.ReactionExecutionState;
import tools.vitruv.extensions.dslsruntime.reactions.structure.CallHierarchyHaving;

@SuppressWarnings("all")
public class RoutinesFacade extends AbstractRepairRoutinesFacade {
  public RoutinesFacade(final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy) {
    super(reactionExecutionState, calledBy);
  }
  
  public void createUmlComponent(final org.eclipse.uml2.uml.Class umlClass) {
    mir.routines.class2comp.CreateUmlComponentRoutine effect = new mir.routines.class2comp.CreateUmlComponentRoutine(this.executionState, calledBy,
    	umlClass);
    effect.applyRoutine();
  }
  
  public void renameComponent(final org.eclipse.uml2.uml.Class umlClass) {
    mir.routines.class2comp.RenameComponentRoutine effect = new mir.routines.class2comp.RenameComponentRoutine(this.executionState, calledBy,
    	umlClass);
    effect.applyRoutine();
  }
  
  public void deleteComponent(final org.eclipse.uml2.uml.Class umlClass, final String packageName, final String expectedTag) {
    mir.routines.class2comp.DeleteComponentRoutine effect = new mir.routines.class2comp.DeleteComponentRoutine(this.executionState, calledBy,
    	umlClass, packageName, expectedTag);
    effect.applyRoutine();
  }
  
  public void renameElement(final NamedElement classElement) {
    mir.routines.class2comp.RenameElementRoutine effect = new mir.routines.class2comp.RenameElementRoutine(this.executionState, calledBy,
    	classElement);
    effect.applyRoutine();
  }
  
  public void createComponentModel(final Model umlClassModel) {
    mir.routines.class2comp.CreateComponentModelRoutine effect = new mir.routines.class2comp.CreateComponentModelRoutine(this.executionState, calledBy,
    	umlClassModel);
    effect.applyRoutine();
  }
  
  public void renameComponentModelForClassModel(final Model umlClassModel) {
    mir.routines.class2comp.RenameComponentModelForClassModelRoutine effect = new mir.routines.class2comp.RenameComponentModelForClassModelRoutine(this.executionState, calledBy,
    	umlClassModel);
    effect.applyRoutine();
  }
  
  public void createPrimitiveDataType(final PrimitiveType classType) {
    mir.routines.class2comp.CreatePrimitiveDataTypeRoutine effect = new mir.routines.class2comp.CreatePrimitiveDataTypeRoutine(this.executionState, calledBy,
    	classType);
    effect.applyRoutine();
  }
  
  public void createDataType(final DataType classType) {
    mir.routines.class2comp.CreateDataTypeRoutine effect = new mir.routines.class2comp.CreateDataTypeRoutine(this.executionState, calledBy,
    	classType);
    effect.applyRoutine();
  }
  
  public void changePropertyType(final Property classProperty, final DataType classType) {
    mir.routines.class2comp.ChangePropertyTypeRoutine effect = new mir.routines.class2comp.ChangePropertyTypeRoutine(this.executionState, calledBy,
    	classProperty, classType);
    effect.applyRoutine();
  }
  
  public void createCompAttribute(final org.eclipse.uml2.uml.Class umlClass, final Property classAttribute) {
    mir.routines.class2comp.CreateCompAttributeRoutine effect = new mir.routines.class2comp.CreateCompAttributeRoutine(this.executionState, calledBy,
    	umlClass, classAttribute);
    effect.applyRoutine();
  }
  
  public void renameComponentAttribute(final Property classAttribute) {
    mir.routines.class2comp.RenameComponentAttributeRoutine effect = new mir.routines.class2comp.RenameComponentAttributeRoutine(this.executionState, calledBy,
    	classAttribute);
    effect.applyRoutine();
  }
  
  public void deleteComponentAttribute(final Property classAttribute) {
    mir.routines.class2comp.DeleteComponentAttributeRoutine effect = new mir.routines.class2comp.DeleteComponentAttributeRoutine(this.executionState, calledBy,
    	classAttribute);
    effect.applyRoutine();
  }
}
