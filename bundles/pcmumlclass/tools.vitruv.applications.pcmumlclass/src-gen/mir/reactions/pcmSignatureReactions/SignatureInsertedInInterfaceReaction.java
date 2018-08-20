package mir.reactions.pcmSignatureReactions;

import mir.routines.pcmSignatureReactions.RoutinesFacade;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.xtext.xbase.lib.Extension;
import org.palladiosimulator.pcm.repository.OperationInterface;
import org.palladiosimulator.pcm.repository.OperationSignature;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractReactionRealization;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractRepairRoutineRealization;
import tools.vitruv.extensions.dslsruntime.reactions.ReactionExecutionState;
import tools.vitruv.extensions.dslsruntime.reactions.structure.CallHierarchyHaving;
import tools.vitruv.framework.change.echange.EChange;
import tools.vitruv.framework.change.echange.feature.reference.InsertEReference;

@SuppressWarnings("all")
public class SignatureInsertedInInterfaceReaction extends AbstractReactionRealization {
  private InsertEReference<OperationInterface, OperationSignature> insertChange;
  
  private int currentlyMatchedChange;
  
  public SignatureInsertedInInterfaceReaction(final RoutinesFacade routinesFacade) {
    super(routinesFacade);
  }
  
  public void executeReaction(final EChange change) {
    if (!checkPrecondition(change)) {
    	return;
    }
    org.palladiosimulator.pcm.repository.OperationInterface affectedEObject = insertChange.getAffectedEObject();
    EReference affectedFeature = insertChange.getAffectedFeature();
    org.palladiosimulator.pcm.repository.OperationSignature newValue = insertChange.getNewValue();
    int index = insertChange.getIndex();
    				
    getLogger().trace("Passed change matching of Reaction " + this.getClass().getName());
    if (!checkUserDefinedPrecondition(insertChange, affectedEObject, affectedFeature, newValue, index)) {
    	resetChanges();
    	return;
    }
    getLogger().trace("Passed complete precondition check of Reaction " + this.getClass().getName());
    				
    mir.reactions.pcmSignatureReactions.SignatureInsertedInInterfaceReaction.ActionUserExecution userExecution = new mir.reactions.pcmSignatureReactions.SignatureInsertedInInterfaceReaction.ActionUserExecution(this.executionState, this);
    userExecution.callRoutine1(insertChange, affectedEObject, affectedFeature, newValue, index, this.getRoutinesFacade());
    
    resetChanges();
  }
  
  private void resetChanges() {
    insertChange = null;
    currentlyMatchedChange = 0;
  }
  
  public boolean checkPrecondition(final EChange change) {
    if (currentlyMatchedChange == 0) {
    	if (!matchInsertChange(change)) {
    		resetChanges();
    		return false;
    	} else {
    		currentlyMatchedChange++;
    	}
    }
    
    return true;
  }
  
  private boolean matchInsertChange(final EChange change) {
    if (change instanceof InsertEReference<?, ?>) {
    	InsertEReference<org.palladiosimulator.pcm.repository.OperationInterface, org.palladiosimulator.pcm.repository.OperationSignature> _localTypedChange = (InsertEReference<org.palladiosimulator.pcm.repository.OperationInterface, org.palladiosimulator.pcm.repository.OperationSignature>) change;
    	if (!(_localTypedChange.getAffectedEObject() instanceof org.palladiosimulator.pcm.repository.OperationInterface)) {
    		return false;
    	}
    	if (!_localTypedChange.getAffectedFeature().getName().equals("signatures__OperationInterface")) {
    		return false;
    	}
    	if (!(_localTypedChange.getNewValue() instanceof org.palladiosimulator.pcm.repository.OperationSignature)) {
    		return false;
    	}
    	this.insertChange = (InsertEReference<org.palladiosimulator.pcm.repository.OperationInterface, org.palladiosimulator.pcm.repository.OperationSignature>) change;
    	return true;
    }
    
    return false;
  }
  
  private boolean checkUserDefinedPrecondition(final InsertEReference insertChange, final OperationInterface affectedEObject, final EReference affectedFeature, final OperationSignature newValue, final int index) {
    return affectedEObject.getSignatures__OperationInterface().contains(newValue);
  }
  
  private static class ActionUserExecution extends AbstractRepairRoutineRealization.UserExecution {
    public ActionUserExecution(final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy) {
      super(reactionExecutionState);
    }
    
    public void callRoutine1(final InsertEReference insertChange, final OperationInterface affectedEObject, final EReference affectedFeature, final OperationSignature newValue, final int index, @Extension final RoutinesFacade _routinesFacade) {
      _routinesFacade.insertCorrespondingOperation(newValue, affectedEObject);
    }
  }
}