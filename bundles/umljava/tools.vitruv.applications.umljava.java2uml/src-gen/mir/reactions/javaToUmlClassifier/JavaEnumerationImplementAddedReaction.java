package mir.reactions.javaToUmlClassifier;

import mir.routines.javaToUmlClassifier.RoutinesFacade;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.xtext.xbase.lib.Extension;
import org.emftext.language.java.classifiers.Enumeration;
import org.emftext.language.java.types.TypeReference;
import tools.vitruv.applications.umljava.java2uml.JavaToUmlHelper;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractReactionRealization;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractRepairRoutineRealization;
import tools.vitruv.extensions.dslsruntime.reactions.ReactionExecutionState;
import tools.vitruv.extensions.dslsruntime.reactions.structure.CallHierarchyHaving;
import tools.vitruv.framework.change.echange.EChange;
import tools.vitruv.framework.change.echange.eobject.CreateEObject;
import tools.vitruv.framework.change.echange.feature.reference.InsertEReference;

@SuppressWarnings("all")
public class JavaEnumerationImplementAddedReaction extends AbstractReactionRealization {
  private CreateEObject<TypeReference> createChange;
  
  private InsertEReference<Enumeration, TypeReference> insertChange;
  
  private int currentlyMatchedChange;
  
  public JavaEnumerationImplementAddedReaction(final RoutinesFacade routinesFacade) {
    super(routinesFacade);
  }
  
  public void executeReaction(final EChange change) {
    if (!checkPrecondition(change)) {
    	return;
    }
    org.emftext.language.java.classifiers.Enumeration affectedEObject = insertChange.getAffectedEObject();
    EReference affectedFeature = insertChange.getAffectedFeature();
    org.emftext.language.java.types.TypeReference newValue = insertChange.getNewValue();
    int index = insertChange.getIndex();
    				
    getLogger().trace("Passed complete precondition check of Reaction " + this.getClass().getName());
    				
    mir.reactions.javaToUmlClassifier.JavaEnumerationImplementAddedReaction.ActionUserExecution userExecution = new mir.reactions.javaToUmlClassifier.JavaEnumerationImplementAddedReaction.ActionUserExecution(this.executionState, this);
    userExecution.callRoutine1(insertChange, affectedEObject, affectedFeature, newValue, index, this.getRoutinesFacade());
    
    resetChanges();
  }
  
  private void resetChanges() {
    createChange = null;
    insertChange = null;
    currentlyMatchedChange = 0;
  }
  
  private boolean matchCreateChange(final EChange change) {
    if (change instanceof CreateEObject<?>) {
    	CreateEObject<org.emftext.language.java.types.TypeReference> _localTypedChange = (CreateEObject<org.emftext.language.java.types.TypeReference>) change;
    	if (!(_localTypedChange.getAffectedEObject() instanceof org.emftext.language.java.types.TypeReference)) {
    		return false;
    	}
    	this.createChange = (CreateEObject<org.emftext.language.java.types.TypeReference>) change;
    	return true;
    }
    
    return false;
  }
  
  public boolean checkPrecondition(final EChange change) {
    if (currentlyMatchedChange == 0) {
    	if (!matchCreateChange(change)) {
    		resetChanges();
    		return false;
    	} else {
    		currentlyMatchedChange++;
    	}
    	return false; // Only proceed on the last of the expected changes
    }
    if (currentlyMatchedChange == 1) {
    	if (!matchInsertChange(change)) {
    		resetChanges();
    		checkPrecondition(change); // Reexecute to potentially register this as first change
    		return false;
    	} else {
    		currentlyMatchedChange++;
    	}
    }
    
    return true;
  }
  
  private boolean matchInsertChange(final EChange change) {
    if (change instanceof InsertEReference<?, ?>) {
    	InsertEReference<org.emftext.language.java.classifiers.Enumeration, org.emftext.language.java.types.TypeReference> _localTypedChange = (InsertEReference<org.emftext.language.java.classifiers.Enumeration, org.emftext.language.java.types.TypeReference>) change;
    	if (!(_localTypedChange.getAffectedEObject() instanceof org.emftext.language.java.classifiers.Enumeration)) {
    		return false;
    	}
    	if (!_localTypedChange.getAffectedFeature().getName().equals("implements")) {
    		return false;
    	}
    	if (!(_localTypedChange.getNewValue() instanceof org.emftext.language.java.types.TypeReference)) {
    		return false;
    	}
    	this.insertChange = (InsertEReference<org.emftext.language.java.classifiers.Enumeration, org.emftext.language.java.types.TypeReference>) change;
    	return true;
    }
    
    return false;
  }
  
  private static class ActionUserExecution extends AbstractRepairRoutineRealization.UserExecution {
    public ActionUserExecution(final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy) {
      super(reactionExecutionState);
    }
    
    public void callRoutine1(final InsertEReference insertChange, final Enumeration affectedEObject, final EReference affectedFeature, final TypeReference newValue, final int index, @Extension final RoutinesFacade _routinesFacade) {
      JavaToUmlHelper.showMessage(this.userInteractor, ("Implement relations from enums are not supported. Please remove it from " + affectedEObject));
    }
  }
}
