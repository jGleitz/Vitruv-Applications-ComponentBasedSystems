package mir.reactions.umlToJavaMethod;

import com.google.common.base.Objects;
import mir.routines.umlToJavaMethod.RoutinesFacade;
import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.uml2.uml.Interface;
import org.eclipse.uml2.uml.Operation;
import org.eclipse.uml2.uml.VisibilityKind;
import org.eclipse.xtext.xbase.lib.Extension;
import tools.vitruv.applications.umljava.uml2java.UmlToJavaHelper;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractReactionRealization;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractRepairRoutineRealization;
import tools.vitruv.extensions.dslsruntime.reactions.ReactionExecutionState;
import tools.vitruv.extensions.dslsruntime.reactions.structure.CallHierarchyHaving;
import tools.vitruv.framework.change.echange.EChange;
import tools.vitruv.framework.change.echange.feature.attribute.ReplaceSingleValuedEAttribute;

@SuppressWarnings("all")
public class UmlInterfaceMethodVisibilityChangedReaction extends AbstractReactionRealization {
  private ReplaceSingleValuedEAttribute<Operation, VisibilityKind> replaceChange;
  
  private int currentlyMatchedChange;
  
  public UmlInterfaceMethodVisibilityChangedReaction(final RoutinesFacade routinesFacade) {
    super(routinesFacade);
  }
  
  public void executeReaction(final EChange change) {
    if (!checkPrecondition(change)) {
    	return;
    }
    org.eclipse.uml2.uml.Operation affectedEObject = replaceChange.getAffectedEObject();
    EAttribute affectedFeature = replaceChange.getAffectedFeature();
    org.eclipse.uml2.uml.VisibilityKind oldValue = replaceChange.getOldValue();
    org.eclipse.uml2.uml.VisibilityKind newValue = replaceChange.getNewValue();
    				
    getLogger().trace("Passed change matching of Reaction " + this.getClass().getName());
    if (!checkUserDefinedPrecondition(replaceChange, affectedEObject, affectedFeature, oldValue, newValue)) {
    	resetChanges();
    	return;
    }
    getLogger().trace("Passed complete precondition check of Reaction " + this.getClass().getName());
    				
    mir.reactions.umlToJavaMethod.UmlInterfaceMethodVisibilityChangedReaction.ActionUserExecution userExecution = new mir.reactions.umlToJavaMethod.UmlInterfaceMethodVisibilityChangedReaction.ActionUserExecution(this.executionState, this);
    userExecution.callRoutine1(replaceChange, affectedEObject, affectedFeature, oldValue, newValue, this.getRoutinesFacade());
    
    resetChanges();
  }
  
  private void resetChanges() {
    replaceChange = null;
    currentlyMatchedChange = 0;
  }
  
  public boolean checkPrecondition(final EChange change) {
    if (currentlyMatchedChange == 0) {
    	if (!matchReplaceChange(change)) {
    		resetChanges();
    		return false;
    	} else {
    		currentlyMatchedChange++;
    	}
    }
    
    return true;
  }
  
  private boolean matchReplaceChange(final EChange change) {
    if (change instanceof ReplaceSingleValuedEAttribute<?, ?>) {
    	ReplaceSingleValuedEAttribute<org.eclipse.uml2.uml.Operation, org.eclipse.uml2.uml.VisibilityKind> _localTypedChange = (ReplaceSingleValuedEAttribute<org.eclipse.uml2.uml.Operation, org.eclipse.uml2.uml.VisibilityKind>) change;
    	if (!(_localTypedChange.getAffectedEObject() instanceof org.eclipse.uml2.uml.Operation)) {
    		return false;
    	}
    	if (!_localTypedChange.getAffectedFeature().getName().equals("visibility")) {
    		return false;
    	}
    	if (_localTypedChange.isFromNonDefaultValue() && !(_localTypedChange.getOldValue() instanceof org.eclipse.uml2.uml.VisibilityKind)) {
    		return false;
    	}
    	if (_localTypedChange.isToNonDefaultValue() && !(_localTypedChange.getNewValue() instanceof org.eclipse.uml2.uml.VisibilityKind)) {
    		return false;
    	}
    	this.replaceChange = (ReplaceSingleValuedEAttribute<org.eclipse.uml2.uml.Operation, org.eclipse.uml2.uml.VisibilityKind>) change;
    	return true;
    }
    
    return false;
  }
  
  private boolean checkUserDefinedPrecondition(final ReplaceSingleValuedEAttribute replaceChange, final Operation affectedEObject, final EAttribute affectedFeature, final VisibilityKind oldValue, final VisibilityKind newValue) {
    return ((affectedEObject.eContainer() instanceof Interface) && (!Objects.equal(newValue, VisibilityKind.PUBLIC_LITERAL)));
  }
  
  private static class ActionUserExecution extends AbstractRepairRoutineRealization.UserExecution {
    public ActionUserExecution(final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy) {
      super(reactionExecutionState);
    }
    
    public void callRoutine1(final ReplaceSingleValuedEAttribute replaceChange, final Operation affectedEObject, final EAttribute affectedFeature, final VisibilityKind oldValue, final VisibilityKind newValue, @Extension final RoutinesFacade _routinesFacade) {
      UmlToJavaHelper.showMessage(this.userInteractor, (("Non-public operations in interface are not valid. Please set " + affectedEObject) + " to public"));
    }
  }
}
