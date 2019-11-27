package mir.routines.umlXpcmRoles_L2R;

import java.io.IOException;
import mir.routines.umlXpcmRoles_L2R.RoutinesFacade;
import org.eclipse.uml2.uml.Property;
import org.eclipse.xtext.xbase.lib.Extension;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractRepairRoutineRealization;
import tools.vitruv.extensions.dslsruntime.reactions.ReactionExecutionState;
import tools.vitruv.extensions.dslsruntime.reactions.structure.CallHierarchyHaving;

@SuppressWarnings("all")
public class OnRequiredRoleNameReplacedAtProperty_nameBidirectionalRepairRoutine extends AbstractRepairRoutineRealization {
  private OnRequiredRoleNameReplacedAtProperty_nameBidirectionalRepairRoutine.ActionUserExecution userExecution;
  
  private static class ActionUserExecution extends AbstractRepairRoutineRealization.UserExecution {
    public ActionUserExecution(final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy) {
      super(reactionExecutionState);
    }
    
    public void callRoutine1(final Property affectedEObject, @Extension final RoutinesFacade _routinesFacade) {
      _routinesFacade.requiredRole_BidirectionalCheck(affectedEObject, "updateRequiredRoleName");
    }
  }
  
  public OnRequiredRoleNameReplacedAtProperty_nameBidirectionalRepairRoutine(final RoutinesFacade routinesFacade, final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy, final Property affectedEObject) {
    super(routinesFacade, reactionExecutionState, calledBy);
    this.userExecution = new mir.routines.umlXpcmRoles_L2R.OnRequiredRoleNameReplacedAtProperty_nameBidirectionalRepairRoutine.ActionUserExecution(getExecutionState(), this);
    this.affectedEObject = affectedEObject;
  }
  
  private Property affectedEObject;
  
  protected boolean executeRoutine() throws IOException {
    getLogger().debug("Called routine OnRequiredRoleNameReplacedAtProperty_nameBidirectionalRepairRoutine with input:");
    getLogger().debug("   affectedEObject: " + this.affectedEObject);
    
    userExecution.callRoutine1(affectedEObject, this.getRoutinesFacade());
    
    postprocessElements();
    
    return true;
  }
}