package mir.reactions.javaToUmlMethod;

import mir.routines.javaToUmlMethod.RoutinesFacade;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.xtext.xbase.lib.Extension;
import org.emftext.language.java.members.ClassMethod;
import org.emftext.language.java.modifiers.Abstract;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractReactionRealization;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractRepairRoutineRealization;
import tools.vitruv.extensions.dslsruntime.reactions.ReactionExecutionState;
import tools.vitruv.extensions.dslsruntime.reactions.structure.CallHierarchyHaving;
import tools.vitruv.framework.change.echange.EChange;
import tools.vitruv.framework.change.echange.eobject.CreateEObject;
import tools.vitruv.framework.change.echange.feature.reference.InsertEReference;

@SuppressWarnings("all")
public class JavaMethodMadeAbstractReaction extends AbstractReactionRealization {
  private CreateEObject<Abstract> createChange;
  
  private InsertEReference<ClassMethod, Abstract> insertChange;
  
  private int currentlyMatchedChange;
  
  public JavaMethodMadeAbstractReaction(final RoutinesFacade routinesFacade) {
    super(routinesFacade);
  }
  
  public void executeReaction(final EChange change) {
    if (!checkPrecondition(change)) {
    	return;
    }
    org.emftext.language.java.members.ClassMethod affectedEObject = insertChange.getAffectedEObject();
    EReference affectedFeature = insertChange.getAffectedFeature();
    org.emftext.language.java.modifiers.Abstract newValue = insertChange.getNewValue();
    int index = insertChange.getIndex();
    				
    getLogger().trace("Passed complete precondition check of Reaction " + this.getClass().getName());
    				
    mir.reactions.javaToUmlMethod.JavaMethodMadeAbstractReaction.ActionUserExecution userExecution = new mir.reactions.javaToUmlMethod.JavaMethodMadeAbstractReaction.ActionUserExecution(this.executionState, this);
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
    	CreateEObject<org.emftext.language.java.modifiers.Abstract> _localTypedChange = (CreateEObject<org.emftext.language.java.modifiers.Abstract>) change;
    	if (!(_localTypedChange.getAffectedEObject() instanceof org.emftext.language.java.modifiers.Abstract)) {
    		return false;
    	}
    	this.createChange = (CreateEObject<org.emftext.language.java.modifiers.Abstract>) change;
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
    	InsertEReference<org.emftext.language.java.members.ClassMethod, org.emftext.language.java.modifiers.Abstract> _localTypedChange = (InsertEReference<org.emftext.language.java.members.ClassMethod, org.emftext.language.java.modifiers.Abstract>) change;
    	if (!(_localTypedChange.getAffectedEObject() instanceof org.emftext.language.java.members.ClassMethod)) {
    		return false;
    	}
    	if (!_localTypedChange.getAffectedFeature().getName().equals("annotationsAndModifiers")) {
    		return false;
    	}
    	if (!(_localTypedChange.getNewValue() instanceof org.emftext.language.java.modifiers.Abstract)) {
    		return false;
    	}
    	this.insertChange = (InsertEReference<org.emftext.language.java.members.ClassMethod, org.emftext.language.java.modifiers.Abstract>) change;
    	return true;
    }
    
    return false;
  }
  
  private static class ActionUserExecution extends AbstractRepairRoutineRealization.UserExecution {
    public ActionUserExecution(final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy) {
      super(reactionExecutionState);
    }
    
    public void callRoutine1(final InsertEReference insertChange, final ClassMethod affectedEObject, final EReference affectedFeature, final Abstract newValue, final int index, @Extension final RoutinesFacade _routinesFacade) {
      _routinesFacade.setUmlMethodAbstract(affectedEObject, Boolean.valueOf(true));
    }
  }
}
