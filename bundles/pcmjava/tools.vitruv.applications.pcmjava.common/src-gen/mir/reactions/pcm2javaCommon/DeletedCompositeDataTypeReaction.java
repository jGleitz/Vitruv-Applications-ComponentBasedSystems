package mir.reactions.pcm2javaCommon;

import mir.routines.pcm2javaCommon.RoutinesFacade;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.xtext.xbase.lib.Extension;
import org.palladiosimulator.pcm.repository.CompositeDataType;
import org.palladiosimulator.pcm.repository.Repository;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractReactionRealization;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractRepairRoutineRealization;
import tools.vitruv.extensions.dslsruntime.reactions.ReactionExecutionState;
import tools.vitruv.extensions.dslsruntime.reactions.structure.CallHierarchyHaving;
import tools.vitruv.framework.change.echange.EChange;
import tools.vitruv.framework.change.echange.eobject.DeleteEObject;
import tools.vitruv.framework.change.echange.feature.reference.RemoveEReference;

@SuppressWarnings("all")
public class DeletedCompositeDataTypeReaction extends AbstractReactionRealization {
  private RemoveEReference<Repository, CompositeDataType> removeChange;
  
  private DeleteEObject<CompositeDataType> deleteChange;
  
  private int currentlyMatchedChange;
  
  public DeletedCompositeDataTypeReaction(final RoutinesFacade routinesFacade) {
    super(routinesFacade);
  }
  
  public void executeReaction(final EChange change) {
    if (!checkPrecondition(change)) {
    	return;
    }
    org.palladiosimulator.pcm.repository.Repository affectedEObject = removeChange.getAffectedEObject();
    EReference affectedFeature = removeChange.getAffectedFeature();
    org.palladiosimulator.pcm.repository.CompositeDataType oldValue = removeChange.getOldValue();
    int index = removeChange.getIndex();
    				
    getLogger().trace("Passed complete precondition check of Reaction " + this.getClass().getName());
    				
    mir.reactions.pcm2javaCommon.DeletedCompositeDataTypeReaction.ActionUserExecution userExecution = new mir.reactions.pcm2javaCommon.DeletedCompositeDataTypeReaction.ActionUserExecution(this.executionState, this);
    userExecution.callRoutine1(removeChange, affectedEObject, affectedFeature, oldValue, index, this.getRoutinesFacade());
    
    resetChanges();
  }
  
  private boolean matchDeleteChange(final EChange change) {
    if (change instanceof DeleteEObject<?>) {
    	DeleteEObject<org.palladiosimulator.pcm.repository.CompositeDataType> _localTypedChange = (DeleteEObject<org.palladiosimulator.pcm.repository.CompositeDataType>) change;
    	if (!(_localTypedChange.getAffectedEObject() instanceof org.palladiosimulator.pcm.repository.CompositeDataType)) {
    		return false;
    	}
    	this.deleteChange = (DeleteEObject<org.palladiosimulator.pcm.repository.CompositeDataType>) change;
    	return true;
    }
    
    return false;
  }
  
  private void resetChanges() {
    removeChange = null;
    deleteChange = null;
    currentlyMatchedChange = 0;
  }
  
  private boolean matchRemoveChange(final EChange change) {
    if (change instanceof RemoveEReference<?, ?>) {
    	RemoveEReference<org.palladiosimulator.pcm.repository.Repository, org.palladiosimulator.pcm.repository.CompositeDataType> _localTypedChange = (RemoveEReference<org.palladiosimulator.pcm.repository.Repository, org.palladiosimulator.pcm.repository.CompositeDataType>) change;
    	if (!(_localTypedChange.getAffectedEObject() instanceof org.palladiosimulator.pcm.repository.Repository)) {
    		return false;
    	}
    	if (!_localTypedChange.getAffectedFeature().getName().equals("dataTypes__Repository")) {
    		return false;
    	}
    	if (!(_localTypedChange.getOldValue() instanceof org.palladiosimulator.pcm.repository.CompositeDataType)) {
    		return false;
    	}
    	this.removeChange = (RemoveEReference<org.palladiosimulator.pcm.repository.Repository, org.palladiosimulator.pcm.repository.CompositeDataType>) change;
    	return true;
    }
    
    return false;
  }
  
  public boolean checkPrecondition(final EChange change) {
    if (currentlyMatchedChange == 0) {
    	if (!matchRemoveChange(change)) {
    		resetChanges();
    		return false;
    	} else {
    		currentlyMatchedChange++;
    	}
    	return false; // Only proceed on the last of the expected changes
    }
    if (currentlyMatchedChange == 1) {
    	if (!matchDeleteChange(change)) {
    		resetChanges();
    		checkPrecondition(change); // Reexecute to potentially register this as first change
    		return false;
    	} else {
    		currentlyMatchedChange++;
    	}
    }
    
    return true;
  }
  
  private static class ActionUserExecution extends AbstractRepairRoutineRealization.UserExecution {
    public ActionUserExecution(final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy) {
      super(reactionExecutionState);
    }
    
    public void callRoutine1(final RemoveEReference removeChange, final Repository affectedEObject, final EReference affectedFeature, final CompositeDataType oldValue, final int index, @Extension final RoutinesFacade _routinesFacade) {
      _routinesFacade.deleteJavaClassifier(oldValue);
    }
  }
}
