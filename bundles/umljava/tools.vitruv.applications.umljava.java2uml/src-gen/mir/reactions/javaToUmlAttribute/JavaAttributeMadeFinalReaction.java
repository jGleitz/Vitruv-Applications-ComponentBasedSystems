package mir.reactions.javaToUmlAttribute;

import mir.routines.javaToUmlAttribute.RoutinesFacade;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.xtext.xbase.lib.Extension;
import org.emftext.language.java.members.Field;
import org.emftext.language.java.modifiers.Final;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractReactionRealization;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractRepairRoutineRealization;
import tools.vitruv.extensions.dslsruntime.reactions.ReactionExecutionState;
import tools.vitruv.extensions.dslsruntime.reactions.structure.CallHierarchyHaving;
import tools.vitruv.framework.change.echange.EChange;
import tools.vitruv.framework.change.echange.eobject.CreateEObject;
import tools.vitruv.framework.change.echange.feature.reference.InsertEReference;

@SuppressWarnings("all")
public class JavaAttributeMadeFinalReaction extends AbstractReactionRealization {
  private CreateEObject<Final> createChange;
  
  private InsertEReference<Field, Final> insertChange;
  
  private int currentlyMatchedChange;
  
  public JavaAttributeMadeFinalReaction(final RoutinesFacade routinesFacade) {
    super(routinesFacade);
  }
  
  public void executeReaction(final EChange change) {
    if (!checkPrecondition(change)) {
    	return;
    }
    org.emftext.language.java.members.Field affectedEObject = insertChange.getAffectedEObject();
    EReference affectedFeature = insertChange.getAffectedFeature();
    org.emftext.language.java.modifiers.Final newValue = insertChange.getNewValue();
    int index = insertChange.getIndex();
    				
    getLogger().trace("Passed complete precondition check of Reaction " + this.getClass().getName());
    				
    mir.reactions.javaToUmlAttribute.JavaAttributeMadeFinalReaction.ActionUserExecution userExecution = new mir.reactions.javaToUmlAttribute.JavaAttributeMadeFinalReaction.ActionUserExecution(this.executionState, this);
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
    	CreateEObject<org.emftext.language.java.modifiers.Final> _localTypedChange = (CreateEObject<org.emftext.language.java.modifiers.Final>) change;
    	if (!(_localTypedChange.getAffectedEObject() instanceof org.emftext.language.java.modifiers.Final)) {
    		return false;
    	}
    	this.createChange = (CreateEObject<org.emftext.language.java.modifiers.Final>) change;
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
    	InsertEReference<org.emftext.language.java.members.Field, org.emftext.language.java.modifiers.Final> _localTypedChange = (InsertEReference<org.emftext.language.java.members.Field, org.emftext.language.java.modifiers.Final>) change;
    	if (!(_localTypedChange.getAffectedEObject() instanceof org.emftext.language.java.members.Field)) {
    		return false;
    	}
    	if (!_localTypedChange.getAffectedFeature().getName().equals("annotationsAndModifiers")) {
    		return false;
    	}
    	if (!(_localTypedChange.getNewValue() instanceof org.emftext.language.java.modifiers.Final)) {
    		return false;
    	}
    	this.insertChange = (InsertEReference<org.emftext.language.java.members.Field, org.emftext.language.java.modifiers.Final>) change;
    	return true;
    }
    
    return false;
  }
  
  private static class ActionUserExecution extends AbstractRepairRoutineRealization.UserExecution {
    public ActionUserExecution(final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy) {
      super(reactionExecutionState);
    }
    
    public void callRoutine1(final InsertEReference insertChange, final Field affectedEObject, final EReference affectedFeature, final Final newValue, final int index, @Extension final RoutinesFacade _routinesFacade) {
      _routinesFacade.setUmlAttributeFinal(affectedEObject, Boolean.valueOf(true));
    }
  }
}
