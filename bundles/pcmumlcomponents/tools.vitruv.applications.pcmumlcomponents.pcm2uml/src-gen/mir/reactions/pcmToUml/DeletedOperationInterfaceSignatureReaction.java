package mir.reactions.pcmToUml;

import mir.routines.pcmToUml.RoutinesFacade;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.xtext.xbase.lib.Extension;
import org.palladiosimulator.pcm.repository.OperationInterface;
import org.palladiosimulator.pcm.repository.OperationSignature;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractReactionRealization;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractRepairRoutineRealization;
import tools.vitruv.extensions.dslsruntime.reactions.ReactionExecutionState;
import tools.vitruv.extensions.dslsruntime.reactions.structure.CallHierarchyHaving;
import tools.vitruv.framework.change.echange.EChange;
import tools.vitruv.framework.change.echange.feature.reference.RemoveEReference;

@SuppressWarnings("all")
public class DeletedOperationInterfaceSignatureReaction extends AbstractReactionRealization {
  private RemoveEReference<OperationInterface, OperationSignature> removeChange;
  
  private int currentlyMatchedChange;
  
  public DeletedOperationInterfaceSignatureReaction(final RoutinesFacade routinesFacade) {
    super(routinesFacade);
  }
  
  public void executeReaction(final EChange change) {
    if (!checkPrecondition(change)) {
    	return;
    }
    org.palladiosimulator.pcm.repository.OperationInterface affectedEObject = removeChange.getAffectedEObject();
    EReference affectedFeature = removeChange.getAffectedFeature();
    org.palladiosimulator.pcm.repository.OperationSignature oldValue = removeChange.getOldValue();
    int index = removeChange.getIndex();
    				
    getLogger().trace("Passed complete precondition check of Reaction " + this.getClass().getName());
    				
    mir.reactions.pcmToUml.DeletedOperationInterfaceSignatureReaction.ActionUserExecution userExecution = new mir.reactions.pcmToUml.DeletedOperationInterfaceSignatureReaction.ActionUserExecution(this.executionState, this);
    userExecution.callRoutine1(removeChange, affectedEObject, affectedFeature, oldValue, index, this.getRoutinesFacade());
    
    resetChanges();
  }
  
  private void resetChanges() {
    removeChange = null;
    currentlyMatchedChange = 0;
  }
  
  private boolean matchRemoveChange(final EChange change) {
    if (change instanceof RemoveEReference<?, ?>) {
    	RemoveEReference<org.palladiosimulator.pcm.repository.OperationInterface, org.palladiosimulator.pcm.repository.OperationSignature> _localTypedChange = (RemoveEReference<org.palladiosimulator.pcm.repository.OperationInterface, org.palladiosimulator.pcm.repository.OperationSignature>) change;
    	if (!(_localTypedChange.getAffectedEObject() instanceof org.palladiosimulator.pcm.repository.OperationInterface)) {
    		return false;
    	}
    	if (!_localTypedChange.getAffectedFeature().getName().equals("signatures__OperationInterface")) {
    		return false;
    	}
    	if (!(_localTypedChange.getOldValue() instanceof org.palladiosimulator.pcm.repository.OperationSignature)) {
    		return false;
    	}
    	this.removeChange = (RemoveEReference<org.palladiosimulator.pcm.repository.OperationInterface, org.palladiosimulator.pcm.repository.OperationSignature>) change;
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
    }
    
    return true;
  }
  
  private static class ActionUserExecution extends AbstractRepairRoutineRealization.UserExecution {
    public ActionUserExecution(final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy) {
      super(reactionExecutionState);
    }
    
    public void callRoutine1(final RemoveEReference removeChange, final OperationInterface affectedEObject, final EReference affectedFeature, final OperationSignature oldValue, final int index, @Extension final RoutinesFacade _routinesFacade) {
      _routinesFacade.deleteElement(oldValue);
    }
  }
}
