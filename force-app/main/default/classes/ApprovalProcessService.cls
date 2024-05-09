public with sharing class ApprovalProcessService {
    private static final String CANCELLED_PROJECT = 'Cancelled';
    private static final String APPROVED_STATUS = 'Approved';
    private static final String FIRST_SUBMISSION_APPROVED_STATUS = 'First Submission Approved';
    private static final String FIRST_SUBMISSION_ADDITIONAL_APPROVERS_APPROVED_STATUS = 'First Submission Additional Approvers Approved';
    private static final String GEO_EXTENSION_COMPLEX_APPROVED_STATUS = 'Geo Extension Complex Approved';
    private static final String GEO_EXTENSION_COMPLEX_ADDITIONAL_APPROVERS_APPROVED_STATUS = 'Geo Extension Complex Additional Approvers Approved';
    private static final String SECOND_SUBMISSION = 'Second Submission';
    private static final String MULTI_REGION_SUBMISSION = 'Multi Region Submission';
    private static final String MULTI_REGION_APPROVED = 'Multi Region Approved';
    private static final String FIRST_SUBMISSION = 'Submitted';
    private static final String DISCOVER_PHASE = 'Discover';
    private static final String DEFINE_PHASE = 'Define';
    private static final String DESIGN_PHASE = 'Design';
    private static final String DEVELOP_PHASE = 'Develop';
    private static final String DEPLOY_PHASE = 'Deploy';
    private static final String DIAGNOSE_PHASE = 'Diagnose';
    private static final String DECISION_STEP_OPPORTUNITY = 'Opportunity Milestone';
    private static final String DECISION_STEP_BCA = 'Business Case Ambition';
    private static final String DECISION_STEP_BCV = 'Business Case Validation';
    private static final String DECISION_STEP_COMMERCIAL = 'Commercial Milestone';
    private static final String DECISION_STEP_PRODUCTION = 'Production Milestone';
    private static final String DECISION_STEP_PLR = 'Post-Launch Review';
    private static final String FEARLESS_BET = 'Fearless Bet';
    private static final String BRAND_ENERGIZER = 'Brand Energizer';
    private static final String BUSINESS_ENABLER = 'Business Enabler';
    private static final String PROMOTIONAL_PACK = 'Promotional Pack';
    private static final String GEO_EXTENSION = 'Geographical Extension';
    private static final String REPACK = 'Repack';
    private static final String CONTINUOUS_IMPROVEMENT = 'Continuous Improvement';
    private static final String MANDATORY = 'Mandatory';
    private static final String SUBMISSION_STATUS_OPPORTUNITY_APPROVED = 'Opportunity Milestone Approved';
    private static final String SUBMISSION_STATUS_BCA_APPROVED = 'Business Case Ambition Approved';
    private static final String SUBMISSION_STATUS_BCV_APPROVED = 'Business Case Validation Approved';
    private static final String SUBMISSION_STATUS_DEPLOY = 'Commercial Milestone Approved';
    private static final String SUBMISSION_STATUS_DIAGNOSE = 'Production Milestone Approved';
    private static final String SUBMISSION_STATUS_PLR_APPROVED = 'Post Launch Review Approved';
    private static final String GEO_EXTENSION_IPC = 'IPC';
    private static final String GEO_EXTENSION_CHANGE = 'Liq/Sourcing/Pack Change';
    private static final String REPACK_PRIMARY_PACK_CHANGE = 'Primary pack change';
    private static final String REPACK_ARTWORK_CHANGE_ONLY = 'Artwork change only';
    private static final String CI_MANDATORY_LIQ_PACK_CHANGE = 'Pack/Liquid Change';
    private static final String CI_MANDATORY_ARTWORK_CHANGE = 'Artwork Change';
    private static final String SHORT_DIAGNOSE_DECISION_STEP = 'Production Milestone';
    private static final String TEMPLATE_NAME_NO_BCA_BCV = 'Project submitted to approvers without BCA and BCV';
    private static final String TEMPLATE_NAME_BCA = 'Project submitted to approvers with BCA';
    private static final String TEMPLATE_NAME_BCV = 'Project submitted to approvers with BCV';
    private static final String SUBMISSION_STATUS_BCA_REJECTED = 'Business Case Ambition Rejected';
    private static final String SUBMISSION_STATUS_BCV_REJECTED = 'Business Case Validation Rejected';
    private static final String PROJECT_NUMBER_FIELD = '{!Project__c.ProjectNumberFormula__c}';
    private static final String PROJECT_NAME_FIELD = '{!Project__c.Name}';
    private static final String PROJECT_SUBMITTER_TEXT = 'This comment has been added by the project team while submitting the decision step';
    private static final String PROJECT_REASSIGN_TEXT = 'This comment has been added by the approver while reassigning the approval';
    private static final String PENDING_APPROVAL_PROJECTS_TAB = 'PendingApprovalProjects';

    private static final List<String> PHASES_ORDERED = new List<String>{
        DISCOVER_PHASE,
        DEFINE_PHASE,
        DESIGN_PHASE,
        DEVELOP_PHASE,
        DEPLOY_PHASE,
        DIAGNOSE_PHASE
    };

    private static final List<String> PHASES_GEO_EXTENSION_PRODUCT_MODIFICATION = new List<String>{
        DEFINE_PHASE,
        DEVELOP_PHASE,
        DEPLOY_PHASE,
        DIAGNOSE_PHASE
    };

    private static final List<String> PHASES_GEO_EXTENSION_PRODUCT_MODIFICATION_IPC_EXTENSION = new List<String>{
        DEFINE_PHASE,
        DEVELOP_PHASE,
        DIAGNOSE_PHASE
    };

    private static final List<String> PHASES_GEO_EXTENSION_SIMPLE_PACK_NEW_CHANGE = new List<String>{
        DEFINE_PHASE,
        DEVELOP_PHASE,
        DEPLOY_PHASE,
        DIAGNOSE_PHASE
    };

    private static final List<String> PHASES_SIMPLE_PACK_NEW_CHANGE = new List<String>{
        DEFINE_PHASE,
        DESIGN_PHASE,
        DEPLOY_PHASE,
        DIAGNOSE_PHASE
    };

    private static final List<String> PHASES_PROMOTIONAL_PACK_SIMPLE = new List<String> {
        DEFINE_PHASE,
        DEPLOY_PHASE,
        DIAGNOSE_PHASE
    };

    private static final List<String> PHASES_PROMOTIONAL_PACK_COMPLEX = new List<String> {
        DEFINE_PHASE,
        DESIGN_PHASE,
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

    private static final Map<String, String> MAP_DECISION_STEP = new Map<String, String>{
        DISCOVER_PHASE => DECISION_STEP_OPPORTUNITY,
        DEFINE_PHASE => DECISION_STEP_BCA,
        DESIGN_PHASE => DECISION_STEP_BCV,
        DEVELOP_PHASE => DECISION_STEP_COMMERCIAL,
        DEPLOY_PHASE => DECISION_STEP_PRODUCTION,
        DIAGNOSE_PHASE => DECISION_STEP_PLR
    };

    private static final Map<String, String> MAP_DECISION_STEP_REPACK_ARTWORK_CHANGE = new Map<String, String>{
        DISCOVER_PHASE => DECISION_STEP_OPPORTUNITY,
        DEFINE_PHASE => DECISION_STEP_BCA,
        DESIGN_PHASE => DECISION_STEP_BCV,
        DEPLOY_PHASE => DECISION_STEP_PRODUCTION,
        DIAGNOSE_PHASE => DECISION_STEP_PLR //???
    };

    private static final Map<String, String> MAP_DECISION_STEP_SIMPLE_PROMOTIONAL_PACK = new Map<String, String>{
        DEPLOY_PHASE => DECISION_STEP_PRODUCTION,
        DIAGNOSE_PHASE => DECISION_STEP_PRODUCTION
    };

    private static final Map<String, String> MAP_DECISION_STEP_SIMPLE_CI_MANDATORY_GEO = new Map<String, String>{
        DIAGNOSE_PHASE => DECISION_STEP_BCA
    };

    private static final Map<String, String> MAP_DECISION_STEP_PACK_NEW_CHANGE = new Map<String, String>{
        DESIGN_PHASE => DECISION_STEP_BCV,
        DEPLOY_PHASE => DECISION_STEP_PRODUCTION,
        DIAGNOSE_PHASE => DECISION_STEP_PRODUCTION
    };

    private static final Map<String, String> MAP_DECISION_STEP_GEO_EXTENSION_LOW_COMPLEXITY = new Map<String, String>{
        DEFINE_PHASE => DECISION_STEP_BCA,
        DEVELOP_PHASE => DECISION_STEP_COMMERCIAL,
        DIAGNOSE_PHASE => DECISION_STEP_PLR
    };

    private static final Map<String, String> MAP_DECISION_STEP_GEO_EXTENSION_MEDIUM_COMPLEXITY = new Map<String, String>{
        DEFINE_PHASE => DECISION_STEP_BCA,
        DEVELOP_PHASE => DECISION_STEP_COMMERCIAL,
        DEPLOY_PHASE => DECISION_STEP_PRODUCTION,
        DIAGNOSE_PHASE => DECISION_STEP_PRODUCTION
    };

    private static final Map<String, String> MAP_SUBMISSION_STATUS = new Map<String, String>{
        DEFINE_PHASE => SUBMISSION_STATUS_OPPORTUNITY_APPROVED,
        DESIGN_PHASE => SUBMISSION_STATUS_BCA_APPROVED,
        DEVELOP_PHASE => SUBMISSION_STATUS_BCV_APPROVED,
        DEPLOY_PHASE => SUBMISSION_STATUS_DEPLOY,
        DIAGNOSE_PHASE => SUBMISSION_STATUS_DIAGNOSE
    };

    private static final Map<String, String> MAP_SUBMISSION_STATUS_REPACK_ARTWORK_CHANGE = new Map<String, String>{
        DEFINE_PHASE => SUBMISSION_STATUS_OPPORTUNITY_APPROVED,
        DESIGN_PHASE => SUBMISSION_STATUS_BCA_APPROVED,
        DEPLOY_PHASE => SUBMISSION_STATUS_BCV_APPROVED,
        DIAGNOSE_PHASE => SUBMISSION_STATUS_DIAGNOSE
    };

    private static final Map<String, String> MAP_SUBMISSION_STATUS_SIMPLE = new Map<String, String>{
        DESIGN_PHASE => SUBMISSION_STATUS_BCA_APPROVED,
        DIAGNOSE_PHASE => SUBMISSION_STATUS_BCV_APPROVED
    };

    private static final Map<String, String> MAP_SUBMISSION_STATUS_PROMOTIONAL_PACK_SIMPLE = new Map<String, String>{
        DEPLOY_PHASE => SUBMISSION_STATUS_BCA_APPROVED,
        DIAGNOSE_PHASE => SUBMISSION_STATUS_DIAGNOSE
    };

    private static final Map<String, String> MAP_SUBMISSION_STATUS_SIMPLE_CI_MANDATORY_GEO = new Map<String, String>{
        DIAGNOSE_PHASE => SUBMISSION_STATUS_BCA_APPROVED
    };

    private static final Map<String, String> MAP_SUBMISSION_STATUS_PACK_NEW_CHANGE = new Map<String, String>{
        DESIGN_PHASE => SUBMISSION_STATUS_BCA_APPROVED,
        DEPLOY_PHASE => SUBMISSION_STATUS_BCV_APPROVED,
        DIAGNOSE_PHASE => SUBMISSION_STATUS_DIAGNOSE
    };

    private static final Map<String, String> MAP_SUBMISSION_STATUS_GEO_EXTENSION_LOW_COMPLEXITY = new Map<String, String> {
        DEFINE_PHASE => SUBMISSION_STATUS_OPPORTUNITY_APPROVED,
        DEVELOP_PHASE => SUBMISSION_STATUS_BCA_APPROVED,
        DIAGNOSE_PHASE => SUBMISSION_STATUS_DEPLOY
    };

    private static final Map<String, String> MAP_SUBMISSION_STATUS_GEO_EXTENSION_MEDIUM_COMPLEXITY = new Map<String, String> {
        DEFINE_PHASE => SUBMISSION_STATUS_OPPORTUNITY_APPROVED,
        DEVELOP_PHASE => SUBMISSION_STATUS_BCA_APPROVED,
        DEPLOY_PHASE => SUBMISSION_STATUS_DEPLOY,
        DIAGNOSE_PHASE => SUBMISSION_STATUS_DIAGNOSE
    };

    private static final Map<String, String> MAP_REJECTED_SUBMISSION_STATUS = new Map<String, String>{
        DEFINE_PHASE => SUBMISSION_STATUS_BCA_REJECTED,
        DESIGN_PHASE => SUBMISSION_STATUS_BCV_REJECTED
    };

    private static final List<String> AUTOMATIC_APPROVAL_PHASES = new List<String>{
        DISCOVER_PHASE,
        DEPLOY_PHASE
    };

    private static final List<String> AUTOMATIC_APPROVAL_PHASES_SIMPLE_PROMOTIONAL_PACK = new List<String>{DESIGN_PHASE};
    private static final List<String> AUTOMATIC_APPROVAL_PHASES_SIMPLE_MANDATORY = new List<String>{
        DEFINE_PHASE
    };

    public static void updateProjectRejectedStatus(Project__c project) {
        if (DEFINE_PHASE.equals(project.ProjectPhase__c) || DESIGN_PHASE.equals(project.ProjectPhase__c)) {
            project.SubmissionStatus__c = MAP_REJECTED_SUBMISSION_STATUS.get(project.ProjectPhase__c);
        }
    }

    public static void updateProjectStatus(Project__c project, String previousState) {
        final String previousPhase = project.ProjectPhase__c;
        final Boolean hasAdditionalApprovers = project.AdditionalApprover1__c != null || project.AdditionalApprover2__c != null || project.AdditionalApprover3__c != null || project.AdditionalApprover4__c != null || project.AdditionalApprover5__c != null || project.AdditionalApprover6__c != null || project.AdditionalApprover7__c != null || project.AdditionalApprover8__c != null || project.AdditionalApprover9__c != null || project.AdditionalApprover10__c != null;
        final Boolean isGeoExtension = project.ProjectClassification__c == GEO_EXTENSION;
        final Boolean isFirstSubmission = project.ApprovalProcessStatus__c == APPROVED_STATUS && FIRST_SUBMISSION.equals(previousState);
        final Boolean isFirstSubmissionApproved = project.ApprovalProcessStatus__c == APPROVED_STATUS && FIRST_SUBMISSION_APPROVED_STATUS.equals(previousState);
        final Boolean isMultiRegionSubmission = project.ApprovalProcessStatus__c == APPROVED_STATUS && MULTI_REGION_SUBMISSION.equals(previousState);
        final Boolean isMultiRegionApproved = project.ApprovalProcessStatus__c == APPROVED_STATUS && MULTI_REGION_APPROVED.equals(previousState);
        final Boolean isSecondSubmission = project.ApprovalProcessStatus__c == APPROVED_STATUS && SECOND_SUBMISSION.equals(previousState);
        final Boolean hasCompletedFirstAdditionalApproversInGeoExtension = previousState == InnovatorConstants.SECOND_SUBMISSION_WITH_PRIOR_ADDITIONAL_APPROVERS;
        final Boolean hasCompletedFirstAdditionalApprovers =  project.ApprovalProcessStatus__c == APPROVED_STATUS && FIRST_SUBMISSION_APPROVED_STATUS.equals(previousState);
        final Boolean hasCompletedFirstAdditionalApproversAndIsNotMultiRegion = hasCompletedFirstAdditionalApprovers && !project.isMultiRegion__c;
        if ((!hasAdditionalApprovers && (isFirstSubmission || isFirstSubmissionApproved || isMultiRegionSubmission || isMultiRegionApproved || hasCompletedFirstAdditionalApproversAndIsNotMultiRegion))  || (hasAdditionalApprovers && isGeoExtension && isFirstSubmission) || (hasCompletedFirstAdditionalApproversInGeoExtension && isGeoExtension)) {
            Boolean phasesOrdered = project.ProjectClassification__c == FEARLESS_BET || project.ProjectClassification__c == BRAND_ENERGIZER || project.ProjectClassification__c == BUSINESS_ENABLER;
            if (phasesOrdered) {
                project = updateProjectStatusFieldsAndSendNotifications(project, PHASES_ORDERED, false);
            }

            Boolean isPromotionalPack = project.ProjectClassification__c == PROMOTIONAL_PACK;
            Boolean isLowPromotionalPack = project.ProjectClassificationSubtype__c == InnovatorConstants.NECK_TAG_SUBTYPE || (project.ProjectClassificationSubtype__c == InnovatorConstants.REPEATING_PROMOTIONAL_PACK_SUBTYPE && project.IsSameMarketPromotionalPack__c);
            if (isPromotionalPack) {
                if (InnovatorConstants.NECK_TAG_SUBTYPE.equals(project.ProjectClassificationSubtype__c) && (DEFINE_PHASE.equals(project.ProjectPhase__c))) {
                    EmailManager.sendEmailToSCDirector(project, false, false, previousPhase); //todo we send notification only to Brand Director test
                }
                if (isLowPromotionalPack) {
                    project = updateProjectStatusFieldsAndSendNotifications(project, PHASES_PROMOTIONAL_PACK_SIMPLE, true);
                } else {
                    project = updateProjectStatusFieldsAndSendNotifications(project, PHASES_PROMOTIONAL_PACK_COMPLEX, true);
                }
                if (project.ProjectPhase__c == DIAGNOSE_PHASE) {
                    project.EndOfProject__c = true;
                }
            }

            if (isGeoExtension) {
                project = setGeoExtensionProjectSubType(project);
                if (project.ProjectClassificationSubtype__c == GEO_EXTENSION_IPC) {
                    if (!hasAdditionalApprovers) {
                        project = updateProjectStatusFieldsAndSendNotifications(project, PHASES_GEO_EXTENSION_PRODUCT_MODIFICATION_IPC_EXTENSION, true);
                    }
                    project.EndOfProject__c = project.ProjectPhase__c == DIAGNOSE_PHASE;
                } else if (project.ProjectClassificationSubtype__c == GEO_EXTENSION_CHANGE) {
                    if (project.ProjectPhase__c != DEFINE_PHASE) {
                        project.EndOfProject__c = project.ProjectPhase__c == DIAGNOSE_PHASE;
                    }
                    if (!hasAdditionalApprovers) {
                        project = updateProjectStatusFieldsAndSendNotifications(project, PHASES_GEO_EXTENSION_SIMPLE_PACK_NEW_CHANGE, true);
                    }
                } else {
                    if (project.ProjectPhase__c != DEFINE_PHASE) {
                        project = updateProjectStatusFieldsAndSendNotifications(project, PHASES_GEO_EXTENSION_PRODUCT_MODIFICATION, false);
                        if (project.ProjectPhase__c == DEPLOY_PHASE) {
                            project.EndOfProject__c = true;
                            project.DecisionStep__c = SHORT_DIAGNOSE_DECISION_STEP;
                        }
                    }
                }
            }

            if (project.ProjectClassification__c == REPACK) {
                if (project.ProjectClassificationSubtype__c == REPACK_ARTWORK_CHANGE_ONLY) {
                    project = updateProjectStatusFieldsAndSendNotifications(project, PHASES_REPACK_ARTWORK_CHANGE_ONLY, true);
                } else {
                    project = updateProjectStatusFieldsAndSendNotifications(project, PHASES_ORDERED, false);
                }
            }

            Boolean isCIOrMandatory = CONTINUOUS_IMPROVEMENT.equals(project.ProjectClassification__c) || MANDATORY.equals(project.ProjectClassification__c);
            Boolean isCIOrMandatorySimple = CI_MANDATORY_ARTWORK_CHANGE.equals(project.ProjectClassificationSubtype__c) || CI_MANDATORY_LIQ_PACK_CHANGE.equals(project.ProjectClassificationSubtype__c);
            if (isCIOrMandatory) {
                if (CONTINUOUS_IMPROVEMENT.equals(project.ProjectClassification__c) && (DEFINE_PHASE.equals(project.ProjectPhase__c) || DESIGN_PHASE.equals(project.ProjectPhase__c))) {
                    EmailManager.sendEmailToSCDirector(project, false, false, previousPhase);
                }
                if (isCIOrMandatorySimple && CI_MANDATORY_ARTWORK_CHANGE.equals(project.ProjectClassificationSubtype__c)) {
                    project = updateProjectStatusFieldsAndSendNotifications(project, PHASES_CI_MANDATORY_SIMPLE, true);
                } else if (isCIOrMandatorySimple && CI_MANDATORY_LIQ_PACK_CHANGE.equals(project.ProjectClassificationSubtype__c)) {
                    project = updateProjectStatusFieldsAndSendNotifications(project, PHASES_SIMPLE_PACK_NEW_CHANGE, true);
                } else {
                    project = updateProjectStatusFieldsAndSendNotifications(project, PHASES_CI_MANDATORY_COMPLEX, false);
                }
                if (DIAGNOSE_PHASE.equals(project.ProjectPhase__c)) {
                    project.EndOfProject__c = true;
                    if (!isCIOrMandatorySimple) {
                        project.DecisionStep__c = SHORT_DIAGNOSE_DECISION_STEP;
                    }
                }
            }
        }
        if (!hasAdditionalApprovers && isSecondSubmission && isGeoExtension) {
            project = updateProjectStatusFieldsAndSendNotifications(project, PHASES_GEO_EXTENSION_PRODUCT_MODIFICATION, false);
        }
        if (Project.ProjectPhase__c != previousPhase) {
            project = setFinancialThersholdsCheck(project);
        }
        Boolean isFirstStepFinishedButWeHaveAdditionalApprovers = hasAdditionalApprovers && project.ApprovalProcessStatus__c == FIRST_SUBMISSION_APPROVED_STATUS && FIRST_SUBMISSION.equals(previousState);
        if (isFirstStepFinishedButWeHaveAdditionalApprovers) {
            //reset the approval status as value to "submitted" so that we can go through the update flow at the end of the 3rd step
            // Boolean notAMultiRegionProjectClassification = (project.ProjectClassification__c == MANDATORY || project.ProjectClassification__c == CONTINUOUS_IMPROVEMENT || project.ProjectClassification__c == PROMOTIONAL_PACK);
            // if (notAMultiRegionProjectClassification) {
            //     project.ApprovalProcessStatus__c = FIRST_SUBMISSION;
            // }
            ProcessInstance processInstance = ApprovalHistoryRepository.getLastApprovalProcess(project.Id);
            List<ProcessInstanceStep> processInstanceSteps = ApprovalHistoryRepository.getProcessInstanceSteps(processInstance.Id);
            EmailManager.sendEmailForApprovers(project, true, null, processInstanceSteps[0].Comments, false, true);
        }

        if (project.IsMultiRegion__c && !hasAdditionalApprovers && (FIRST_SUBMISSION_APPROVED_STATUS.equals(project.ApprovalProcessStatus__c) || FIRST_SUBMISSION_ADDITIONAL_APPROVERS_APPROVED_STATUS.equals(project.ApprovalProcessStatus__c)) && (project.ProjectClassification__c != MANDATORY && project.ProjectClassification__c != CONTINUOUS_IMPROVEMENT && project.ProjectClassification__c != PROMOTIONAL_PACK)) {
            project.ApprovalProcessStatus__c = MULTI_REGION_SUBMISSION;
        }
        if (project.IsMultiRegion__c && hasAdditionalApprovers && project.ApprovalProcessStatus__c == MULTI_REGION_APPROVED) {
            ProcessInstance processInstance = ApprovalHistoryRepository.getLastApprovalProcess(project.Id);
            List<ProcessInstanceStep> processInstanceSteps = ApprovalHistoryRepository.getProcessInstanceSteps(processInstance.Id);
            EmailManager.sendEmailForApprovers(project, true, null, processInstanceSteps[0].Comments, false, true);
        }
        if (project.ApprovalProcessStatus__c == InnovatorConstants.SECOND_SUBMISSION_WITH_PRIOR_ADDITIONAL_APPROVERS || (project.IsMultiRegion__c && hasAdditionalApprovers && project.ApprovalProcessStatus__c == MULTI_REGION_SUBMISSION)) {
            ProcessInstance processInstance = ApprovalHistoryRepository.getLastApprovalProcess(project.Id);
            List<ProcessInstanceStep> processInstanceSteps = ApprovalHistoryRepository.getProcessInstanceSteps(processInstance.Id);
            EmailManager.sendEmailForApprovers(project, true, null, processInstanceSteps[0].Comments, false, true);
        }
        Boolean isEnteringSecondSubmission = project.ApprovalProcessStatus__c == SECOND_SUBMISSION && previousState != SECOND_SUBMISSION;
        Boolean isEnteringMultiRegionSubmission = project.ApprovalProcessStatus__c == MULTI_REGION_SUBMISSION && previousState != MULTI_REGION_SUBMISSION;
        //Boolean hasAdditionalRegions = String.isNotBlank(project.AddAdditionalRegionOrRegions__c);
        if (isEnteringMultiRegionSubmission) {
            ApprovalMatrixService.fillProjectWithApprovalMatrix(new List<Project__c>{ project }, ApprovalMatrixService.FIRST_APPROVAL_STEP, '', true);
        } else if (isEnteringSecondSubmission) {
            ApprovalMatrixService.fillProjectWithApprovalMatrix(new List<Project__c>{ project }, ApprovalMatrixService.SECOND_APPROVAL_STEP, '', true);
        }
    }

    public static Project__c updateProjectStatusFieldsAndSendNotifications(Project__c project, List<String> phases, Boolean isSimple) {
        String nextPhase = phases.get(phases.indexOf(project.ProjectPhase__c) + 1);
        project.ProjectPhase__c = nextPhase;
        Boolean isLowPromotionalPack = project.ProjectClassificationSubtype__c == InnovatorConstants.NECK_TAG_SUBTYPE ||
                                       (project.ProjectClassificationSubtype__c== InnovatorConstants.REPEATING_PROMOTIONAL_PACK_SUBTYPE &&
                                        project.IsSameMarketPromotionalPack__c);
        if (!isSimple) {
            String nextSubmissionStatus = MAP_SUBMISSION_STATUS.get(project.ProjectPhase__c);
            project.SubmissionStatus__c = nextSubmissionStatus;
            String nextDecisionStep = InnovatorConstants.MAP_DECISION_STEP.get(project.ProjectPhase__c);
            project.DecisionStep__c = nextDecisionStep;
        } else if (project.ProjectClassification__c == PROMOTIONAL_PACK && isLowPromotionalPack) {
            String nextSubmissionStatus = MAP_SUBMISSION_STATUS_PROMOTIONAL_PACK_SIMPLE.get(project.ProjectPhase__c);
            project.SubmissionStatus__c = nextSubmissionStatus;
            String nextDecisionStep = MAP_DECISION_STEP_SIMPLE_PROMOTIONAL_PACK.get(project.ProjectPhase__c);
            project.DecisionStep__c = nextDecisionStep;
        } else if (((project.ProjectClassification__c == CONTINUOUS_IMPROVEMENT || project.ProjectClassification__c == MANDATORY) && project.ProjectClassificationSubtype__c == CI_MANDATORY_ARTWORK_CHANGE)) {
            String nextSubmissionStatus = MAP_SUBMISSION_STATUS_SIMPLE_CI_MANDATORY_GEO.get(project.ProjectPhase__c);
            project.SubmissionStatus__c = nextSubmissionStatus;
            String nextDecisionStep = MAP_DECISION_STEP_SIMPLE_CI_MANDATORY_GEO.get(project.ProjectPhase__c);
            project.DecisionStep__c = nextDecisionStep;
        } else if ((project.ProjectClassification__c == PROMOTIONAL_PACK && !isLowPromotionalPack) ||
            ((project.ProjectClassification__c == CONTINUOUS_IMPROVEMENT || project.ProjectClassification__c == MANDATORY) && project.ProjectClassificationSubtype__c == CI_MANDATORY_LIQ_PACK_CHANGE)) {
            String nextSubmissionStatus = MAP_SUBMISSION_STATUS_PACK_NEW_CHANGE.get(project.ProjectPhase__c);
            project.SubmissionStatus__c = nextSubmissionStatus;
            String nextDecisionStep = MAP_DECISION_STEP_PACK_NEW_CHANGE.get(project.ProjectPhase__c);
            project.DecisionStep__c = nextDecisionStep;
        } else if (project.ProjectClassification__c == GEO_EXTENSION && project.ProjectClassificationSubtype__c == GEO_EXTENSION_CHANGE) {
            String nextSubmissionStatus = MAP_SUBMISSION_STATUS_GEO_EXTENSION_MEDIUM_COMPLEXITY.get(project.ProjectPhase__c);
            project.SubmissionStatus__c = nextSubmissionStatus;
            String nextDecisionStep = MAP_DECISION_STEP_GEO_EXTENSION_MEDIUM_COMPLEXITY.get(project.ProjectPhase__c);
            project.DecisionStep__c = nextDecisionStep;
        } else if (project.ProjectClassification__c == GEO_EXTENSION && project.ProjectClassificationSubtype__c == GEO_EXTENSION_IPC) {
            String nextSubmissionStatus = MAP_SUBMISSION_STATUS_GEO_EXTENSION_LOW_COMPLEXITY.get(project.ProjectPhase__c);
            project.SubmissionStatus__c = nextSubmissionStatus;
            String nextDecisionStep = MAP_DECISION_STEP_GEO_EXTENSION_LOW_COMPLEXITY.get(project.ProjectPhase__c);
            project.DecisionStep__c = nextDecisionStep;
        } else if (project.ProjectClassification__c == REPACK && project.ProjectClassificationSubtype__c == REPACK_ARTWORK_CHANGE_ONLY) {
            String nextSubmissionStatus = MAP_SUBMISSION_STATUS_REPACK_ARTWORK_CHANGE.get(project.ProjectPhase__c);
            project.SubmissionStatus__c = nextSubmissionStatus;
            String nextDecisionStep = MAP_DECISION_STEP_REPACK_ARTWORK_CHANGE.get(project.ProjectPhase__c);
            project.DecisionStep__c = nextDecisionStep;
        }
        project.BypassComercialTolerances__c = false;
        project.BypassFinancialTolerances__c = false;
        return project;
    }

    public static Project__c setFinancialThersholdsCheck(Project__c project) {
        Boolean fearlessBet = project.ProjectClassification__c == InnovatorConstants.FEARLESS_BET;
        Boolean brandEnergizer = project.ProjectClassification__c == InnovatorConstants.BRAND_ENERGIZER;
        if ((fearlessBet || brandEnergizer) && project.ProjectPhase__c == InnovatorConstants.DEFINE_PHASE) {
            project.FinancialThresholdsNotMet__c = false;
            project.FinancialThresholdNotMetComment__c = '';
        }
        return project;
    }

    public static Project__c setGeoExtensionProjectSubType(Project__c project) {
        Boolean isIPCExtension = ((project.IPCExtensionWithoutArtworkChange__c || project.ArtworkChange__c) && !project.NewLiquid__c && !project.NewPrimaryPack__c && !project.SourcingChange__c);
        if (isIPCExtension) {
            project.ProjectClassificationSubtype__c = GEO_EXTENSION_IPC;
        } else {
            project.ProjectClassificationSubtype__c = GEO_EXTENSION_CHANGE;
        }
        return project;
    }

    public static Project__c setRepackSubType(Project__c project) {
        Boolean isArtworkChange = project.NewPrimaryPack__c == false && project.ArtworkChange__c == true;
        if (isArtworkChange) {
            project.ProjectClassificationSubtype__c = REPACK_ARTWORK_CHANGE_ONLY;
        } else {
            project.ProjectClassificationSubtype__c = REPACK_PRIMARY_PACK_CHANGE;
        }
        return project;
    }

    public static Project__c setCiMandatorySubType(Project__c project) {
        Boolean isArtworkChangeOnly = project.ArtworkChange__c == true && project.ValueCreation__c == false && project.NewLiquid__c == false && project.PrimarySecondaryPackChange__c == false && project.SourcingChange__c == false;
        Boolean isArtworkChangeWithValueCreationProject = project.ArtworkChange__c == true && project.ValueCreation__c == true && project.ProjectClassification__c.equals(CONTINUOUS_IMPROVEMENT) && project.NewLiquid__c == false && project.PrimarySecondaryPackChange__c == false && project.SourcingChange__c == false;
        Boolean isNewLiquidAndPrimaryPackWithSourcingChangeProject = project.NewLiquid__c == true || project.PrimarySecondaryPackChange__c == true || project.SourcingChange__c == true;
        if (isArtworkChangeOnly || isArtworkChangeWithValueCreationProject) {
            project.ProjectClassificationSubtype__c = CI_MANDATORY_ARTWORK_CHANGE;
        } else if (isNewLiquidAndPrimaryPackWithSourcingChangeProject) {
            project.ProjectClassificationSubtype__c = CI_MANDATORY_LIQ_PACK_CHANGE;
        } else {
            project.ProjectClassificationSubtype__c = CI_MANDATORY_LIQ_PACK_CHANGE;
        }
        return project;
    }

    public static void setAdditionalApproversToNull(Project__c project) {
        project.AdditionalApprover1__c = null;
        project.AdditionalApprover2__c = null;
        project.AdditionalApprover3__c = null;
        project.AdditionalApprover4__c = null;
        project.AdditionalApprover5__c = null;
        project.AdditionalApprover6__c = null;
        project.AdditionalApprover7__c = null;
        project.AdditionalApprover8__c = null;
        project.AdditionalApprover9__c = null;
        project.AdditionalApprover10__c = null;
    }

    /**
     * @description to fetch comments of all approver
     */
    public static String getApproverComments(Id projectId, String action) {
        String comment = '';
        List<ProcessInstance> processInstances = ApprovalMatrixRepository.getRecentlyApprovedProcessInstanceId(projectId);
        String processInstancesId = processInstances.get(0).id;
        List<ProcessInstanceStep> processInstanceSteps = ApprovalMatrixRepository.getApprovalComments(projectId, processInstancesId);
        for (ProcessInstanceStep step : processInstanceSteps) {
            final Boolean changeComment = action == InnovatorConstants.APPROVAL_ACTION_APPROVE || (action == InnovatorConstants.APPROVAL_ACTION_REJECT && step.StepStatus == InnovatorConstants.REJECTED_STATUS) || (action == InnovatorConstants.APPROVAL_ACTION_REWORK && step.StepStatus == InnovatorConstants.REWORKED_STATUS);
            if (String.isNotBlank(step.Comments) && changeComment) {
                comment += '<li>' + step.Actor.Name + ': ' + step.Comments + '</li>';
            }
        }
        if (String.isNotBlank(comment)) {
            comment = '<ul>' + comment + '</ul>';
            if (action == InnovatorConstants.APPROVAL_ACTION_APPROVE) {
                comment = '<p>This comment has been added by: ' + comment + '</p>';
            }
        }
        return comment;
    }
}