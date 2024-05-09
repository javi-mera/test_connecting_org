public with sharing class ProjectUtility {
    //geo extension subtypes
    public static final String GEO_EXTENSION_INNOVATION = 'Geo Extension Innovation';
    public static final String GEO_EXTENSION_OTHER = 'Geo Extension Other';

    private static final String NO_CHANGE_IN_FINANCIALS = 'No change';
    private static final String DELETE_FINANCIALS = 'Delete financials';
    private static final String DELETE_FINANCIALS_KEEP_DELIVERABLES = 'Delete financials and keep deliverables';
    private static final String CREATE_FINANCIALS = 'Create financials';
    private static final String CREATE_DELIVERABLES = 'Create deliverables';
    private static final String CREATE_FINANCIALS_CI_MANDATORY = 'Create financials CI or Mandatory';
    private static final String CREATE_FINANCIALS_AND_DELIVERABLES = 'Create financials and deliverables';
    private static final String DELETE_AND_CREATE_FINANCIALS = 'Delete and create financials';
    private static final String DELETE_AND_CREATE_DELIVERABLES = 'Delete and create deliverables';
    private static final String DELETE_AND_CREATE_FINANCIALS_CI_MANDATORY = 'Delete and create financials CI or Mandatory';
    private static final String DELETE_AND_CREATE_FINANCIALS_AND_DELIVERABLES = 'Delete and create financials and deliverables';

    private static final Map<String, Map<String, String>> PROJECT_CLASSIFICATION_TO_CLASSIFICATION_FINANCIAL_CHANGES = new Map<String, Map<String, String>> {
        InnovatorConstants.FEARLESS_BET => new Map<String, String> {
            InnovatorConstants.BRAND_ENERGIZER => NO_CHANGE_IN_FINANCIALS, // Works
            InnovatorConstants.BUSINESS_ENABLER => NO_CHANGE_IN_FINANCIALS, // Works, Financials reconstructs when going to the step
            InnovatorConstants.PROMOTIONAL_PACK => DELETE_FINANCIALS, // Works
            GEO_EXTENSION_INNOVATION => NO_CHANGE_IN_FINANCIALS, // Works
            GEO_EXTENSION_OTHER => DELETE_FINANCIALS, // Works
            InnovatorConstants.REPACK => DELETE_FINANCIALS_KEEP_DELIVERABLES, // Works
            InnovatorConstants.CONTINUOUS_IMPROVEMENT => DELETE_AND_CREATE_FINANCIALS_CI_MANDATORY, // Works
            InnovatorConstants.MANDATORY => DELETE_AND_CREATE_FINANCIALS_CI_MANDATORY // Works
        },
        InnovatorConstants.BRAND_ENERGIZER => new Map<String, String> {
            InnovatorConstants.FEARLESS_BET => NO_CHANGE_IN_FINANCIALS, // Works
            InnovatorConstants.BUSINESS_ENABLER => NO_CHANGE_IN_FINANCIALS, // Works
            InnovatorConstants.PROMOTIONAL_PACK => DELETE_FINANCIALS, // Works
            GEO_EXTENSION_INNOVATION => NO_CHANGE_IN_FINANCIALS, // Works
            GEO_EXTENSION_OTHER => DELETE_FINANCIALS, // Works
            InnovatorConstants.REPACK => DELETE_FINANCIALS_KEEP_DELIVERABLES, // Works
            InnovatorConstants.CONTINUOUS_IMPROVEMENT => DELETE_AND_CREATE_FINANCIALS_CI_MANDATORY, // Works
            InnovatorConstants.MANDATORY => DELETE_AND_CREATE_FINANCIALS_CI_MANDATORY // Works
        },
        InnovatorConstants.BUSINESS_ENABLER => new Map<String, String> {
            InnovatorConstants.FEARLESS_BET => NO_CHANGE_IN_FINANCIALS, // Works
            InnovatorConstants.BRAND_ENERGIZER => NO_CHANGE_IN_FINANCIALS, // Works
            InnovatorConstants.PROMOTIONAL_PACK => DELETE_FINANCIALS, // Works
            GEO_EXTENSION_INNOVATION => NO_CHANGE_IN_FINANCIALS, // Works
            GEO_EXTENSION_OTHER => DELETE_FINANCIALS, // Works
            InnovatorConstants.REPACK => DELETE_FINANCIALS_KEEP_DELIVERABLES, // Works
            InnovatorConstants.CONTINUOUS_IMPROVEMENT => DELETE_AND_CREATE_FINANCIALS_CI_MANDATORY, // Works
            InnovatorConstants.MANDATORY => DELETE_AND_CREATE_FINANCIALS_CI_MANDATORY // Works
        },
        GEO_EXTENSION_INNOVATION => new Map<String, String> {
            InnovatorConstants.FEARLESS_BET => NO_CHANGE_IN_FINANCIALS, // Works
            InnovatorConstants.BRAND_ENERGIZER => NO_CHANGE_IN_FINANCIALS, // Works
            InnovatorConstants.BUSINESS_ENABLER => NO_CHANGE_IN_FINANCIALS, // Works
            InnovatorConstants.PROMOTIONAL_PACK => DELETE_FINANCIALS, // Works
            GEO_EXTENSION_OTHER => DELETE_FINANCIALS, // Works
            InnovatorConstants.REPACK => DELETE_FINANCIALS_KEEP_DELIVERABLES, // Works
            InnovatorConstants.CONTINUOUS_IMPROVEMENT => DELETE_AND_CREATE_FINANCIALS_CI_MANDATORY, // Works
            InnovatorConstants.MANDATORY => DELETE_AND_CREATE_FINANCIALS_CI_MANDATORY // Works
        },
        InnovatorConstants.REPACK => new Map<String, String> {
            InnovatorConstants.FEARLESS_BET => CREATE_FINANCIALS, // Works
            InnovatorConstants.BRAND_ENERGIZER => CREATE_FINANCIALS, // Works
            InnovatorConstants.BUSINESS_ENABLER => CREATE_FINANCIALS, // Works
            InnovatorConstants.PROMOTIONAL_PACK => DELETE_FINANCIALS, // Works
            GEO_EXTENSION_INNOVATION => CREATE_FINANCIALS, // Works
            GEO_EXTENSION_OTHER => DELETE_FINANCIALS, // Works
            InnovatorConstants.CONTINUOUS_IMPROVEMENT => DELETE_AND_CREATE_FINANCIALS_CI_MANDATORY, // Works
            InnovatorConstants.MANDATORY => DELETE_AND_CREATE_FINANCIALS_CI_MANDATORY // Works
        },
        InnovatorConstants.PROMOTIONAL_PACK => new Map<String, String> {
            InnovatorConstants.FEARLESS_BET => CREATE_FINANCIALS_AND_DELIVERABLES, // Works
            InnovatorConstants.BRAND_ENERGIZER => CREATE_FINANCIALS_AND_DELIVERABLES,  // Works
            InnovatorConstants.BUSINESS_ENABLER => CREATE_FINANCIALS_AND_DELIVERABLES,  // Works
            GEO_EXTENSION_INNOVATION => CREATE_FINANCIALS_AND_DELIVERABLES, // Works
            GEO_EXTENSION_OTHER => NO_CHANGE_IN_FINANCIALS, // Works
            InnovatorConstants.REPACK => CREATE_DELIVERABLES, // Works
            InnovatorConstants.CONTINUOUS_IMPROVEMENT => CREATE_FINANCIALS_CI_MANDATORY, // Works
            InnovatorConstants.MANDATORY => CREATE_FINANCIALS_CI_MANDATORY // Works
        },
        InnovatorConstants.CONTINUOUS_IMPROVEMENT => new Map<String, String> {
            InnovatorConstants.FEARLESS_BET => DELETE_AND_CREATE_FINANCIALS_AND_DELIVERABLES, // Works 
            InnovatorConstants.BRAND_ENERGIZER => DELETE_AND_CREATE_FINANCIALS_AND_DELIVERABLES, // Works
            InnovatorConstants.BUSINESS_ENABLER => DELETE_AND_CREATE_FINANCIALS_AND_DELIVERABLES, // Works
            InnovatorConstants.PROMOTIONAL_PACK => DELETE_FINANCIALS, // Works
            GEO_EXTENSION_INNOVATION => DELETE_AND_CREATE_FINANCIALS_AND_DELIVERABLES, // Works
            GEO_EXTENSION_OTHER => DELETE_FINANCIALS, // Works
            InnovatorConstants.REPACK => DELETE_AND_CREATE_DELIVERABLES, // Works
            InnovatorConstants.MANDATORY => NO_CHANGE_IN_FINANCIALS // Works
        },
        InnovatorConstants.MANDATORY => new Map<String, String> {
            InnovatorConstants.FEARLESS_BET => DELETE_AND_CREATE_FINANCIALS_AND_DELIVERABLES, // Works
            InnovatorConstants.BRAND_ENERGIZER => DELETE_AND_CREATE_FINANCIALS_AND_DELIVERABLES, // Works
            InnovatorConstants.BUSINESS_ENABLER => DELETE_AND_CREATE_FINANCIALS_AND_DELIVERABLES, // Works
            InnovatorConstants.PROMOTIONAL_PACK => DELETE_FINANCIALS, // Works
            GEO_EXTENSION_INNOVATION => DELETE_AND_CREATE_FINANCIALS_AND_DELIVERABLES, // Works
            GEO_EXTENSION_OTHER => DELETE_FINANCIALS, // Works
            InnovatorConstants.REPACK => DELETE_AND_CREATE_DELIVERABLES, // Works
            InnovatorConstants.CONTINUOUS_IMPROVEMENT => NO_CHANGE_IN_FINANCIALS // Works
        },
        GEO_EXTENSION_OTHER => new Map<String, String> {
            InnovatorConstants.FEARLESS_BET => CREATE_FINANCIALS_AND_DELIVERABLES, // Works
            InnovatorConstants.BRAND_ENERGIZER => CREATE_FINANCIALS_AND_DELIVERABLES,  // Works
            InnovatorConstants.BUSINESS_ENABLER => CREATE_FINANCIALS_AND_DELIVERABLES,  // Works
            InnovatorConstants.PROMOTIONAL_PACK => NO_CHANGE_IN_FINANCIALS, // Works
            GEO_EXTENSION_INNOVATION => CREATE_FINANCIALS_AND_DELIVERABLES, // Works
            InnovatorConstants.REPACK => CREATE_DELIVERABLES, // Works
            InnovatorConstants.CONTINUOUS_IMPROVEMENT => CREATE_FINANCIALS_CI_MANDATORY, // Works
            InnovatorConstants.MANDATORY => CREATE_FINANCIALS_CI_MANDATORY // Works
        }
    };

    public static String projectClassificationToCombinedName(String classification, String geoExtensionSubType) {
        if (InnovatorConstants.GEO_EXTENSION.equals(classification) && geoExtensionSubType != null && geoExtensionSubType.contains('Innovation')) {
            return GEO_EXTENSION_INNOVATION;
        } else if (InnovatorConstants.GEO_EXTENSION.equals(classification)  && geoExtensionSubType != null && geoExtensionSubType.contains('Other')) {
            return GEO_EXTENSION_OTHER;
        }
        return classification;
    }

    public static void recalculateProjectFinancialsOnClassificationChange (Project__c newProject, String newProjectClassification, String oldProjectClassification) {
        List<Financial__c> finacialsToDelete = new List<Financial__c>();
        List<Financial__c> finacialsToCreate = new List<Financial__c>();
        Map<String, String> changeMap = PROJECT_CLASSIFICATION_TO_CLASSIFICATION_FINANCIAL_CHANGES.get(oldProjectClassification);
        String changeType = changeMap.get(newProjectClassification);

        if (DELETE_FINANCIALS.equals(changeType)) {
            finacialsToDelete = ProjectClassificationChangeRepository.getAllNonHistoricalFinancialsForProject(newProject.Id);
        } else if (DELETE_FINANCIALS_KEEP_DELIVERABLES.equals(changeType)) {
            finacialsToDelete = ProjectClassificationChangeRepository.getNonHistoricalFinancialsForProject(newProject.Id);
        } else if (CREATE_FINANCIALS.equals(changeType)) {
            finacialsToCreate = createFinancialData(newProject, false, false);
        } else if (CREATE_DELIVERABLES.equals(changeType)) {
            finacialsToCreate = createDeliverables(newProject);
        } else if (CREATE_FINANCIALS_CI_MANDATORY.equals(changeType)) {
            finacialsToCreate = createFinancialData(newProject, true, false);
        } else if (CREATE_FINANCIALS_AND_DELIVERABLES.equals(changeType)) {
            finacialsToCreate = createFinancialData(newProject, false, false);
            finacialsToCreate.addAll(createDeliverables(newProject));
        } else if (DELETE_AND_CREATE_FINANCIALS.equals(changeType)) {
            finacialsToDelete = ProjectClassificationChangeRepository.getAllNonHistoricalFinancialsForProject(newProject.Id);
            finacialsToCreate = createFinancialData(newProject, false, false);
        } else if (DELETE_AND_CREATE_DELIVERABLES.equals(changeType)) {
            finacialsToDelete = ProjectClassificationChangeRepository.getAllNonHistoricalFinancialsForProject(newProject.Id);
            finacialsToCreate.addAll(createDeliverables(newProject));
        } else if (DELETE_AND_CREATE_FINANCIALS_CI_MANDATORY.equals(changeType)) {
            finacialsToDelete = ProjectClassificationChangeRepository.getAllNonHistoricalFinancialsForProject(newProject.Id);
            finacialsToCreate = createFinancialData(newProject, true, false);
        } else if (DELETE_AND_CREATE_FINANCIALS_AND_DELIVERABLES.equals(changeType)) {
            finacialsToDelete = ProjectClassificationChangeRepository.getAllNonHistoricalFinancialsForProject(newProject.Id);
            finacialsToCreate = createFinancialData(newProject, false, false);
            finacialsToCreate.addAll(createDeliverables(newProject));
        }
        
        if (finacialsToDelete.size() > 0){
            delete finacialsToDelete;
        } 
        if (finacialsToCreate.size() > 0){
            insert finacialsToCreate;
        } 
    }

    public static void recalculateProjectFinancialsOnProjectPhaseChange (Project__c newProject, String newProjectPhase, String oldProjectPhase) {
        List<Financial__c> finacialsToDelete = new List<Financial__c>();
        List<Financial__c> finacialsToCreate = new List<Financial__c>();
        Boolean fromDiscoverPhaseToOtherPhase = InnovatorConstants.DISCOVER_PHASE.equals(oldProjectPhase) && !InnovatorConstants.DISCOVER_PHASE.equals(newProjectPhase);
        Boolean noNonHistoricalDeliverables = ProjectClassificationChangeRepository.getNonHistoricalDeliverablesForProject(newProject.Id).size() == 0;
        
        if (InnovatorConstants.FEARLESS_BET.equals(newProject.ProjectClassification__c) || InnovatorConstants.BRAND_ENERGIZER.equals(newProject.ProjectClassification__c)) {
            if (!InnovatorConstants.DISCOVER_PHASE.equals(oldProjectPhase) && InnovatorConstants.DISCOVER_PHASE.equals(newProjectPhase)) {
                finacialsToDelete = ProjectClassificationChangeRepository.getNonHistoricalSecondToFourthFinancialDataForProject(newProject.Id);
            } else if (fromDiscoverPhaseToOtherPhase) {
                finacialsToCreate = createFinancialData(newProject, false, true);
                if (noNonHistoricalDeliverables) {
                    finacialsToCreate.addAll(createDeliverables(newProject));
                }
            }
        } else if (InnovatorConstants.REPACK.equals(newProject.ProjectClassification__c) && fromDiscoverPhaseToOtherPhase && noNonHistoricalDeliverables) {
            finacialsToCreate = createDeliverables(newProject);
        }
        
        if (finacialsToDelete.size() > 0){
            delete finacialsToDelete;
        } 
        if (finacialsToCreate.size() > 0){
            insert finacialsToCreate;
        }
    }

    private static List<Financial__c> createFinancialData(Project__c project, Boolean isCIOrMandatory, Boolean isMissingFinancialYears) {
        if (isCIOrMandatory) { 
            return createFinancialData(project, new List<Integer>{1});
        } else if (isMissingFinancialYears) {
            return createFinancialData(project, new List<Integer>{2,3,4});
        } else if (InnovatorConstants.DISCOVER_PHASE.equals(project.ProjectPhase__c)) { 
            return createFinancialData(project, new List<Integer>{1,5});
        } else {
            return createFinancialData(project, new List<Integer>{1,2,3,4,5});
        }
    }
    
    private static List<Financial__c> createFinancialData(Project__c project, List<Integer> yearsToCreate) { 
        List<Financial__c> financialDataRecords = new List<Financial__c>();
        Id financialDataRecordTypeId = Schema.SObjectType.Financial__c.getRecordTypeInfosByDeveloperName().get(InnovatorConstants.FINANCIAL_DATA_RECORDTYPE).getRecordTypeId();
        for (Integer year : yearsToCreate) {
            Financial__c newYear = new Financial__c(ActualFY__c = year, Project__c = project.Id, RecordTypeId = financialDataRecordTypeId);
            financialDataRecords.add(newYear);
        }
        return financialDataRecords;
    }

    private static List<Financial__c> createDeliverables(Project__c project) { 
        List<Financial__c> deliverableRecords = new List<Financial__c>();
        List<String> labels = new List<String> {
            Label.Investment_Required_Deliverable,
            Label.Ongoing_Year_Two_Structural_Profitability_Deliverable,
            Label.Size_of_Prize_Deliverable,
            Label.Year_First_Gross_Profit_Deliverable,
            Label.Project_Average_GM
        };
        Id deliverableRecordTypeId = Schema.SObjectType.Financial__c.getRecordTypeInfosByDeveloperName().get(InnovatorConstants.DELIVERABLE_RECORDTYPE).getRecordTypeId();
        for (String label : labels) {
            Financial__c newDeliverable = new Financial__c(Label__c = label, Project__c = project.Id, RecordTypeId = deliverableRecordTypeId);
            deliverableRecords.add(newDeliverable);
        }
        return deliverableRecords;
    }

    public static String prepareRecordUrl(Id recordId) {
        return URL.getOrgDomainUrl().toExternalForm() + '/' + recordId;
    }

    private static final String PROJECT_CLASSIFICATION_GEOEXTENSION = 'Geographical Extension';
    private static final String PROJECT_CLASSIFICATION_REPACK = 'Repack';
    private static final String PROJECT_CLASSIFICATION_CI = 'Continuous Improvement';
    private static final String PROJECT_CLASSIFICATION_MANDATORY = 'Mandatory';
    private static final String PROJECT_CLASSIFICATION_FEARLESS_BET = 'Fearless Bet';
    private static final String PROJECT_CLASSIFICATION_BRAND_ENERGIZER = 'Brand Energizer';
    private static final String PROJECT_CLASSIFICATION_BUSINESS_ENABLER = 'Business Enabler';
    private static final String PROMOTIONAL_PACK = 'Promotional Pack';
    private static final String GEO_EXTENSION_IPC = 'IPC';
    private static final String DISCOVER_PHASE = 'Discover';
    private static final String DEFINE_PHASE = 'Define';
    private static final String DESIGN_PHASE = 'Design';
    private static final String DEVELOP_PHASE = 'Develop';
    private static final String DEPLOY_PHASE = 'Deploy';
    private static final String DIAGNOSE_PHASE = 'Diagnose';
    private static final String REPACK_ARTWORK_CHANGE_ONLY = 'Artwork change only';
    private static final String CI_MANDATORY_ARTWORK_CHANGE = 'Artwork Change';

    private static final List<String> PHASES_GEO_EXTENSION_PRODUCT_MODIFICATION = new List<String>{
        DEFINE_PHASE,
        DESIGN_PHASE,
        DEPLOY_PHASE,
        DIAGNOSE_PHASE
    };

    private static final List<String> PHASES_GEO_EXTENSION_PRODUCT_MODIFICATION_IPC_EXTENSION = new List<String>{
        DEFINE_PHASE,
        DIAGNOSE_PHASE
    };

    private static final List<String> PHASES_PROMOTIONAL_PACK_COMPLEX = new List<String>{
        DEFINE_PHASE,
        DESIGN_PHASE,
        DEPLOY_PHASE,
        DIAGNOSE_PHASE
    };

    private static final List<String> PHASES_PROMOTIONAL_PACK_SIMPLE = new List<String>{
        DEFINE_PHASE,
        DEPLOY_PHASE,
        DIAGNOSE_PHASE
    };

    private static final List<String> PHASES_REPACK_ARTWORK_CHANGE_ONLY = new List<String>{
        DISCOVER_PHASE,
        DEFINE_PHASE,
        DESIGN_PHASE,
        DEPLOY_PHASE,
        DIAGNOSE_PHASE
    };

    private static final List<String> PHASES_CI_MANDATORY_SIMPLE = new List<String>{
        DEFINE_PHASE,
        DIAGNOSE_PHASE
    };

    private static final List<String> PHASES_CI_MANDATORY_COMPLEX = new List<String>{
        DEFINE_PHASE,
        DESIGN_PHASE,
        DEPLOY_PHASE,
        DIAGNOSE_PHASE
    };

    private static final List<String> PHASES_ORDERED = new List<String>{
        DISCOVER_PHASE,
        DEFINE_PHASE,
        DESIGN_PHASE,
        DEVELOP_PHASE,
        DEPLOY_PHASE,
        DIAGNOSE_PHASE
    };

    public static String getNextPhaseName(Project__c project) {
        String nextPhase = '';
        final Boolean isSimplePromotionalPack = (project.ProjectClassificationSubtype__c == InnovatorConstants.NECK_TAG_SUBTYPE || (project.ProjectClassificationSubtype__c == InnovatorConstants.REPEATING_PROMOTIONAL_PACK_SUBTYPE && project.IsSameMarketPromotionalPack__c));
        final Boolean isGeoExtension = project.ProjectClassification__c == PROJECT_CLASSIFICATION_GEOEXTENSION;
        final Boolean isCIOrMandatory = PROJECT_CLASSIFICATION_CI.equals(project.ProjectClassification__c) || PROJECT_CLASSIFICATION_MANDATORY.equals(project.ProjectClassification__c);
        if (PROMOTIONAL_PACK.equals(project.ProjectClassification__c) && isSimplePromotionalPack) {
            nextPhase = PHASES_PROMOTIONAL_PACK_SIMPLE.get(PHASES_PROMOTIONAL_PACK_SIMPLE.indexOf(project.ProjectPhase__c) + 1);
        } else if (!isSimplePromotionalPack && PROMOTIONAL_PACK.equals(project.ProjectClassification__c)) {
            nextPhase = PHASES_PROMOTIONAL_PACK_COMPLEX.get(PHASES_PROMOTIONAL_PACK_COMPLEX.indexOf(project.ProjectPhase__c) + 1);
        } else if (isGeoExtension) {
            if (project.ProjectClassificationSubtype__c == GEO_EXTENSION_IPC) {
                nextPhase = PHASES_GEO_EXTENSION_PRODUCT_MODIFICATION_IPC_EXTENSION.get(PHASES_GEO_EXTENSION_PRODUCT_MODIFICATION_IPC_EXTENSION.indexOf(project.ProjectPhase__c) + 1);
            } else {
                nextPhase = PHASES_GEO_EXTENSION_PRODUCT_MODIFICATION.get(PHASES_GEO_EXTENSION_PRODUCT_MODIFICATION.indexOf(project.ProjectPhase__c) + 1);
            }
        } else if (project.ProjectClassification__c == PROJECT_CLASSIFICATION_REPACK && project.ProjectClassificationSubtype__c == REPACK_ARTWORK_CHANGE_ONLY) {
            nextPhase = PHASES_REPACK_ARTWORK_CHANGE_ONLY.get(PHASES_REPACK_ARTWORK_CHANGE_ONLY.indexOf(project.ProjectPhase__c) + 1);
        } else if (isCIOrMandatory) {
            if (project.ProjectClassificationSubtype__c == CI_MANDATORY_ARTWORK_CHANGE) {
                nextPhase = PHASES_CI_MANDATORY_SIMPLE.get(PHASES_CI_MANDATORY_SIMPLE.indexOf(project.ProjectPhase__c) + 1);
            } else {
                nextPhase = PHASES_CI_MANDATORY_COMPLEX.get(PHASES_CI_MANDATORY_COMPLEX.indexOf(project.ProjectPhase__c) + 1);
            }
        } else {
            nextPhase = PHASES_ORDERED.get(PHASES_ORDERED.indexOf(project.ProjectPhase__c) + 1);
        }
        return nextPhase;
    }
}