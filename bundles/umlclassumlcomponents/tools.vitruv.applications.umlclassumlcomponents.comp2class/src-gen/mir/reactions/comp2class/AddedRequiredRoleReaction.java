package mir.reactions.comp2class;

import com.google.common.collect.Iterables;
import java.util.Collections;
import mir.routines.comp2class.RoutinesFacade;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.uml2.uml.Component;
import org.eclipse.uml2.uml.Interface;
import org.eclipse.uml2.uml.Usage;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import org.eclipse.xtext.xbase.lib.Conversions;
import org.eclipse.xtext.xbase.lib.Extension;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractReactionRealization;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractRepairRoutineRealization;
import tools.vitruv.extensions.dslsruntime.reactions.ReactionExecutionState;
import tools.vitruv.extensions.dslsruntime.reactions.structure.CallHierarchyHaving;
import tools.vitruv.framework.change.echange.EChange;
import tools.vitruv.framework.change.echange.feature.reference.InsertEReference;

@SuppressWarnings("all")
public class AddedRequiredRoleReaction extends AbstractReactionRealization {
  private InsertEReference<Usage, Interface> insertChange;
  
  private int currentlyMatchedChange;
  
  public AddedRequiredRoleReaction(final RoutinesFacade routinesFacade) {
    super(routinesFacade);
  }
  
  public void executeReaction(final EChange change) {
    if (!checkPrecondition(change)) {
    	return;
    }
    org.eclipse.uml2.uml.Usage affectedEObject = insertChange.getAffectedEObject();
    EReference affectedFeature = insertChange.getAffectedFeature();
    org.eclipse.uml2.uml.Interface newValue = insertChange.getNewValue();
    int index = insertChange.getIndex();
    				
    getLogger().trace("Passed complete precondition check of Reaction " + this.getClass().getName());
    				
    mir.reactions.comp2class.AddedRequiredRoleReaction.ActionUserExecution userExecution = new mir.reactions.comp2class.AddedRequiredRoleReaction.ActionUserExecution(this.executionState, this);
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
    	InsertEReference<org.eclipse.uml2.uml.Usage, org.eclipse.uml2.uml.Interface> _localTypedChange = (InsertEReference<org.eclipse.uml2.uml.Usage, org.eclipse.uml2.uml.Interface>) change;
    	if (!(_localTypedChange.getAffectedEObject() instanceof org.eclipse.uml2.uml.Usage)) {
    		return false;
    	}
    	if (!_localTypedChange.getAffectedFeature().getName().equals("supplier")) {
    		return false;
    	}
    	if (!(_localTypedChange.getNewValue() instanceof org.eclipse.uml2.uml.Interface)) {
    		return false;
    	}
    	this.insertChange = (InsertEReference<org.eclipse.uml2.uml.Usage, org.eclipse.uml2.uml.Interface>) change;
    	return true;
    }
    
    return false;
  }
  
  private static class ActionUserExecution extends AbstractRepairRoutineRealization.UserExecution {
    public ActionUserExecution(final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy) {
      super(reactionExecutionState);
    }
    
    public void callRoutine1(final InsertEReference insertChange, final Usage affectedEObject, final EReference affectedFeature, final Interface newValue, final int index, @Extension final RoutinesFacade _routinesFacade) {
      final Usage compUsage = affectedEObject;
      final Iterable<Component> clients = Iterables.<Component>filter(compUsage.getClients(), Component.class);
      boolean _isEmpty = IterableExtensions.isEmpty(clients);
      boolean _not = (!_isEmpty);
      if (_not) {
        final Component umlComp = ((Component[])Conversions.unwrapArray(clients, Component.class))[0];
        final Interface compInterface = newValue;
        final Iterable<Interface> iFs = Iterables.<Interface>filter(Iterables.<EObject>concat(this.correspondenceModel.getCorrespondingEObjects(Collections.<EObject>unmodifiableList(CollectionLiterals.<EObject>newArrayList(compInterface)))), Interface.class);
        Interface _xifexpression = null;
        boolean _isEmpty_1 = IterableExtensions.isEmpty(iFs);
        boolean _not_1 = (!_isEmpty_1);
        if (_not_1) {
          _xifexpression = ((Interface[])Conversions.unwrapArray(iFs, Interface.class))[0];
        } else {
          _xifexpression = null;
        }
        Interface matchedInterface = _xifexpression;
        if ((matchedInterface != null)) {
          _routinesFacade.createClassInterfaceRealization(compUsage, umlComp);
          _routinesFacade.addClassInterfaceRealizationToClass(compUsage, compInterface, umlComp);
        }
      }
    }
  }
}
