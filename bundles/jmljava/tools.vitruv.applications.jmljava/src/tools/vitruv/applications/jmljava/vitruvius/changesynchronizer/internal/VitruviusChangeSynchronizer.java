package tools.vitruv.applications.jmljava.vitruvius.changesynchronizer.internal;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.apache.log4j.Logger;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IWorkspace;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.NullProgressMonitor;

import tools.vitruv.applications.jmljava.vitruvius.changesynchronizer.JavaJMLExtensionProvider;
import tools.vitruv.applications.jmljava.vitruvius.changesynchronizer.ModelProvidingDirtyMarker;
import tools.vitruv.applications.jmljava.vitruvius.changesynchronizer.extensions.Change2CommandTransformingProvider;
import tools.vitruv.applications.jmljava.vitruvius.changesynchronizer.extensions.CorrespondenceProvider;
import tools.vitruv.applications.jmljava.vitruvius.changesynchronizer.extensions.MappingProvider;
import tools.vitruv.applications.jmljava.vitruvius.changesynchronizer.extensions.MetaModelProvider;
import tools.vitruv.applications.jmljava.vitruvius.changesynchronizer.extensions.ModelURIProvider;
import tools.vitruv.framework.change.description.VitruviusChange;
import tools.vitruv.framework.correspondence.CorrespondenceModel;
import tools.vitruv.framework.metamodel.MetamodelPair;
import tools.vitruv.framework.metamodel.Metamodel;
import tools.vitruv.framework.util.datatypes.VURI;
import tools.vitruv.framework.change.processing.Change2CommandTransforming ;
import tools.vitruv.framework.change.processing.Change2CommandTransformingProviding;
import tools.vitruv.framework.modelsynchronization.ChangeSynchronizing;
import tools.vitruv.framework.modelsynchronization.SynchronisationListener;
import tools.vitruv.framework.correspondence.CorrespondenceProviding;
import tools.vitruv.framework.metamodel.MappingManaging;
import tools.vitruv.framework.metamodel.MetamodelRepository;
import tools.vitruv.framework.metamodel.ModelProviding;
import tools.vitruv.framework.metarepository.MetaRepositoryImpl;
import tools.vitruv.framework.modelsynchronization.ChangeSynchronizerImpl;
import tools.vitruv.framework.vsum.VSUMConstants;

/**
 * Wrapper for the Vitruvius synchronization framework. It initializes the framework by using the
 * tools.vitruv.applications.jmljava.vitruvius.changesynchronizer.extensions.* extension
 * points.
 */
public class VitruviusChangeSynchronizer implements ChangeSynchronizing {

    private static final Logger LOGGER = Logger.getLogger(VitruviusChangeSynchronizer.class);

    protected final MetaRepositoryImpl metaRepositoryImpl;
    protected final VSUMImplCustom vsumImpl;
    protected final Change2CommandTransformingProvidingImplCustom change2CommandTransformingProvidingImpl;
    protected final ChangeSynchronizerImpl syncManagerImpl;

    /**
     * Constructor.
     */
    public VitruviusChangeSynchronizer() {
        LOGGER.info("Initializing change synchronizer.");
        try {
            this.deleteExistingVSUM();
            this.metaRepositoryImpl = this.constructMetaRepositoryImpl();
            this.vsumImpl = this.constructVSUMImpl(this.metaRepositoryImpl, this.metaRepositoryImpl);
            this.change2CommandTransformingProvidingImpl = this.constructChange2CommandTransformingImpl();
            this.syncManagerImpl = this.constructSyncManagerImpl(this.vsumImpl,
                    this.change2CommandTransformingProvidingImpl, this.vsumImpl);
        } catch (final Exception e) {
            LOGGER.error("Exception thrown during initialization.", e);
            throw e;
        }
    }

    /**
     * Deletes the serialized information of the VSUM. This is necessary since it is build from
     * scratch on every construction in order to reflect the most recent state.
     */
    private void deleteExistingVSUM() {
        try {
            final IWorkspace workspace = ResourcesPlugin.getWorkspace();
            final IProject project = workspace.getRoot().getProject(VSUMConstants.VSUM_PROJECT_NAME);
            project.delete(true, true, new NullProgressMonitor());
            LOGGER.info("Deleted old VSUM project.");
        } catch (final NullPointerException e) {
            LOGGER.info("No old VSUM project found.");
        } catch (final CoreException e) {
            LOGGER.error("Could not delete old VSUM project.");
        }
    }

    /**
     * Constructs the meta repository by using the meta-model and mapping providers.
     *
     * @return The initialized meta-repository.
     */
    protected MetaRepositoryImpl constructMetaRepositoryImpl() {
        LOGGER.info("Constructing meta repository.");

        final MetaRepositoryImpl result = new MetaRepositoryImpl();

        for (final MetaModelProvider mmProvider : JavaJMLExtensionProvider.getMetaModelProvider()) {
            final Metamodel mm = mmProvider.getMetaModel();
            result.addMetamodel(mm);
            LOGGER.debug("Meta model registered: " + mm.getURI());
        }

        for (final MappingProvider mappingProvider : JavaJMLExtensionProvider.getMappingProviders()) {
            for (final MetamodelPair mapping : mappingProvider.getMappings(result)) {
                result.addMapping(mapping);
                LOGGER.debug("Mapping registered: " + mapping);
            }
        }

        return result;
    }

    /**
     * Constructs the VSUM and initializes it with models and correspondences.
     *
     * @param metamodelManaging
     *            An initialized implementation of a meta-model managing.
     * @param mappingManaging
     *            An initialized implementation of a mapping managing.
     * @return The initialized VSUM.
     */
    protected VSUMImplCustom constructVSUMImpl(final MetamodelRepository metamodelManaging,
            final MappingManaging mappingManaging) {
        LOGGER.info("Constructing VSUM.");
        final VSUMImplCustom result = new VSUMImplCustom(metamodelManaging, mappingManaging);

        final List<VURI> relevantURIs = new ArrayList<VURI>();
        for (final ModelURIProvider modelURIProvider : JavaJMLExtensionProvider.getModelURIProviders()) {
            final List<VURI> providedRelevantURIs = modelURIProvider.getAllRelevantURIs();
            relevantURIs.addAll(providedRelevantURIs);
            for (final VURI uri : providedRelevantURIs) {
                result.getAndLoadModelInstanceOriginal(uri);
            }
        }
        LOGGER.debug("Found " + relevantURIs.size() + " relevant model URIs.");

        for (final CorrespondenceProvider correspondenceProvider : JavaJMLExtensionProvider
                .getCorrespondenceProviders()) {
            final CorrespondenceModel ci = result.getCorrespondenceModel(
                    correspondenceProvider.getFirstMetaModelUri(), correspondenceProvider.getSecondMetaModelUri());

            LOGGER.debug("Setting correspondences for " + correspondenceProvider.getFirstMetaModelUri() + " and "
                    + correspondenceProvider.getSecondMetaModelUri());

            correspondenceProvider.setAllCorrespondences(ci, relevantURIs, result, metamodelManaging);
        }

        return result;
    }

    /**
     * Constructs a transformation executing provider and initializes it by using an extension
     * point.
     *
     * @return The initialized transformation executing provider.
     */
    protected Change2CommandTransformingProvidingImplCustom constructChange2CommandTransformingImpl() {
        LOGGER.info("Constructing transformation executing providing.");

        final Change2CommandTransformingProvidingImplCustom result = new Change2CommandTransformingProvidingImplCustom();

        for (final Change2CommandTransformingProvider transProvider : JavaJMLExtensionProvider
                .getEMFModelTransformationExecutingProviders()) {
            for (final Change2CommandTransforming trans : transProvider.getEMFModelTransformationExecutings()) {
                result.addChange2CommandTransforming(trans);
                LOGGER.debug("EMFModelTransformationExecuting registered: " + trans.getClass().getSimpleName());
            }
        }

        return result;
    }

    /**
     * Constructs and initializes a sync manager.
     *
     * @param modelProviding
     *            An initialized implementation of a model providing.
     * @param changePropagating
     *            An initialized implementation of a change propagating.
     * @param correspondenceProviding
     *            An initialized implementation of a change providing.
     * @param validating
     *            An initialized implementation of a validating.
     * @return An initialized sync manager.
     */
    protected ChangeSynchronizerImpl constructSyncManagerImpl(final ModelProviding modelProviding,
            final Change2CommandTransformingProviding change2CommandTransformingProviding,
            final CorrespondenceProviding correspondenceProviding) {
        LOGGER.info("Constructing sync manager.");

        final ChangeSynchronizerImpl result = new ChangeSynchronizerImpl(modelProviding,
                change2CommandTransformingProviding, correspondenceProviding);

        return result;
    }

    @Override
    public List<List<VitruviusChange>> synchronizeChange(final VitruviusChange change) {
        if (change == null) {
            LOGGER.warn("Ignoring null changes.");
        }
        try {
            return this.syncManagerImpl.synchronizeChange(change);
        } catch (final Exception e) {
            LOGGER.error("Exception thrown during synchronisation.", e);
        }
        return Collections.emptyList();
    }

    public ModelProvidingDirtyMarker getModelProvidingDirtyMarker() {
        return this.vsumImpl;
    }

	@Override
	public void addSynchronizationListener(SynchronisationListener synchronizationListener) {
		syncManagerImpl.addSynchronizationListener(synchronizationListener);
	}

	@Override
	public void removeSynchronizationListener(SynchronisationListener synchronizationListener) {
		syncManagerImpl.removeSynchronizationListener(synchronizationListener);
	}

}
