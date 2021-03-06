package mir.routines.umlToJavaClassifier;

import java.io.IOException;
import mir.routines.umlToJavaClassifier.RoutinesFacade;
import org.eclipse.uml2.uml.PrimitiveType;
import org.eclipse.xtext.xbase.lib.Extension;
import org.emftext.language.java.types.TypeReference;
import tools.vitruv.applications.umljava.uml2java.UmlToJavaHelper;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractRepairRoutineRealization;
import tools.vitruv.extensions.dslsruntime.reactions.ReactionExecutionState;
import tools.vitruv.extensions.dslsruntime.reactions.structure.CallHierarchyHaving;
import tools.vitruv.framework.userinteraction.UserInteractionOptions;

@SuppressWarnings("all")
public class CheckIfCorrespondingJavaPrimitiveTypeExistsRoutine extends AbstractRepairRoutineRealization {
  private CheckIfCorrespondingJavaPrimitiveTypeExistsRoutine.ActionUserExecution userExecution;
  
  private static class ActionUserExecution extends AbstractRepairRoutineRealization.UserExecution {
    public ActionUserExecution(final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy) {
      super(reactionExecutionState);
    }
    
    public void callRoutine1(final PrimitiveType uPrimType, @Extension final RoutinesFacade _routinesFacade) {
      TypeReference _mapToJavaPrimitiveType = UmlToJavaHelper.mapToJavaPrimitiveType(uPrimType);
      boolean _tripleEquals = (_mapToJavaPrimitiveType == null);
      if (_tripleEquals) {
        this.userInteractor.getNotificationDialogBuilder().message(
          (("There is no corresponding Java-PrimitiveType for " + uPrimType) + " (case sensitive)")).title("Warning").notificationType(UserInteractionOptions.NotificationType.WARNING).windowModality(UserInteractionOptions.WindowModality.MODAL);
      }
    }
  }
  
  public CheckIfCorrespondingJavaPrimitiveTypeExistsRoutine(final RoutinesFacade routinesFacade, final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy, final PrimitiveType uPrimType) {
    super(routinesFacade, reactionExecutionState, calledBy);
    this.userExecution = new mir.routines.umlToJavaClassifier.CheckIfCorrespondingJavaPrimitiveTypeExistsRoutine.ActionUserExecution(getExecutionState(), this);
    this.uPrimType = uPrimType;
  }
  
  private PrimitiveType uPrimType;
  
  protected boolean executeRoutine() throws IOException {
    getLogger().debug("Called routine CheckIfCorrespondingJavaPrimitiveTypeExistsRoutine with input:");
    getLogger().debug("   uPrimType: " + this.uPrimType);
    
    userExecution.callRoutine1(uPrimType, this.getRoutinesFacade());
    
    postprocessElements();
    
    return true;
  }
}
