public without sharing class ApprovalMatrixService {
    private static final String ALL_PICKLIST_VALUE = 'All';
    private static final String OC_TBD = 'Supply Center TBD';
    private static final String MULTI_REGION_SUBMISSION = 'Multi Region Submission';
    public static final String MATRIX_RT = 'Approval_Matrix';
    private static final String MEETING_APPROVALS = 'Meeting Approvals';
    private static final String ONLINE_APPROVALS = 'Online Approvals';
    private static final String NOTIFICATION = 'Online Notification';
    public static final String FIRST_APPROVAL_STEP = '1';
    public static final String SECOND_APPROVAL_STEP = '2';
    public static final String ERROR_MESSAGE = 'You are trying to submit a project with too many brands, subbrands and flavors. Please reduce the amount to proceed or contact your administrator.';
    public static final String NO_APPROVERS_ERROR_MESSAGE = 'No approver has been found for the current submission, please contact the Innovator Admins to setup the relevant approvers for your Project';

    public class FlowInputVariables {
        @InvocableVariable
        public Project__c projects;

        @InvocableVariable
        public String comment;

        public FlowInputVariables() {}
        public FlowInputVariables(Project__c projects, String comment) {
            this.projects = projects;
            this.comment = comment;
        }
    }

    @InvocableMethod(label='Set automatic approvers')
    public static void fillProjectWithApprovalMatrix(List<FlowInputVariables> request) {
        List<Project__c> projects = new List<Project__c>();
        projects.add(request[0].projects);
        fillProjectWithApprovalMatrix(projects, FIRST_APPROVAL_STEP, request[0].comment, false);
    }

    public static void fillProjectWithApprovalMatrix(List<Project__c> projects, String approvalStep, String comment, Boolean fromTrigger) {
        try {
            Project__c project = projects.get(0);
            Id matrixId = Schema.SObjectType.ApprovalMatrix__c.getRecordTypeInfosByDeveloperName().get(MATRIX_RT).getRecordTypeId();
            Boolean assignOC = FIRST_APPROVAL_STEP.equals(approvalStep) && (project.ProjectPhase__c.equals(InnovatorConstants.DISCOVER_PHASE) || (project.ProjectPhase__c.equals(InnovatorConstants.DEFINE_PHASE) && (project.ProjectClassification__c.equals(InnovatorConstants.BUSINESS_ENABLER) || project.ProjectClassification__c.equals(InnovatorConstants.GEO_EXTENSION) || project.ProjectClassification__c.equals(InnovatorConstants.PROMOTIONAL_PACK) || project.ProjectClassification__c.equals(InnovatorConstants.CONTINUOUS_IMPROVEMENT) || project.ProjectClassification__c.equals(InnovatorConstants.MANDATORY))));
            if (assignOC && project.OC__c == null) {
                Id ocId = Schema.SObjectType.ApprovalMatrix__c.getRecordTypeInfosByDeveloperName().get(InnovatorConstants.OC_RECORDTYPE).getRecordTypeId();
                List<ApprovalMatrix__c> ocList = ApprovalMatrixRepository.loadMatrixByType(project.ProjectClassification__c, project.Category__c, project.Brand__c, project.Subrand__c, project.Hub__c, project.Cluster__c, project.DC__c, ocId);
                setOC(project, ocList);
            }
            setProjectSubType(project);
            List<ApprovalMatrix__c> approvalMatrixList = ApprovalMatrixRepository.loadMatrixByType(project.ProjectClassification__c, project.Category__c, project.Brand__c, project.Subrand__c, project.Hub__c, project.Cluster__c, project.LeadMarket__c, project.DC__c, project.TradeType__c, matrixId, approvalStep);
            setApprovalMatrix(project, approvalMatrixList, approvalStep, comment, fromTrigger);
        } catch (QueryException ex) {
            throw new TooManySelectedException(ERROR_MESSAGE, ex);
        }
    }

    public static Set<Id> getIdsForNotificationUsers(Project__c project, List<ApprovalMatrix__c> rules) {
        Set<Id> notificationUsers = new Set<Id>();
        List<String> hubs = new List<String>();
        if (project.ApprovalProcessStatus__c == MULTI_REGION_SUBMISSION) {
            for (AggregateResult hubResult : LookupGeoHierarchyRepository.getGroupedGeoHierarchiesByRegion(project.Region__c)) {
                hubs.add((String) hubResult.get('HUB__c'));
            }
        }
        for (ApprovalMatrix__c rule : rules) {
            Boolean isAMatch = matchProjectToRuleMatrixNotificationOnly(project, rule, hubs, false, true, project.ProjectPhase__c, false);
            if (isAMatch && rule.Approver__c != null && rule.Approver__r.IsActive == true && rule.Approver__r.DelegatedApproverId == null) {
                notificationUsers.add(rule.Approver__c);
            } else if (isAMatch && rule.Approver__c != null && rule.Approver__r.IsActive == true && rule.Approver__r.DelegatedApproverId != null) {
                notificationUsers.add(rule.Approver__r.DelegatedApproverId);
            }
        }
        return notificationUsers;
    }

    public static Boolean matchProjectToRuleMatrixNotificationOnly(Project__c project, ApprovalMatrix__c ruleMatrix, List<String> hubs, Boolean isSupplyChainDirector, Boolean isMultiRegion, String currentPhase, Boolean isSecondRegionNotificationsOnly) {
        Boolean isAMatch = true;
        Boolean isSimplePromotionalPack = InnovatorConstants.PROMOTIONAL_PACK.equals(project.ProjectClassification__c) && (project.ProjectClassificationSubtype__c == InnovatorConstants.NECK_TAG_SUBTYPE || (project.ProjectClassificationSubtype__c == InnovatorConstants.REPEATING_PROMOTIONAL_PACK_SUBTYPE && project.IsSameMarketPromotionalPack__c));
        if (ruleMatrix.ProjectClassification__c != null && !ruleMatrix.ProjectClassification__c.contains(ALL_PICKLIST_VALUE) && !ruleMatrix.ProjectClassification__c.contains(project.ProjectClassification__c)) {
            isAMatch = false;
        }
        if (InnovatorConstants.PROJECT_CLASSIFICATIONS_WITH_SUBTYPES.contains(project.ProjectClassification__c)) {
            if ((!InnovatorConstants.PROMOTIONAL_PACK.equals(project.ProjectClassification__c)) || (InnovatorConstants.PROMOTIONAL_PACK.equals(project.ProjectClassification__c) && !project.ProjectClassificationSubType__c.equals(InnovatorConstants.REPEATING_PROMOTIONAL_PACK_SUBTYPE))) {
                isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.ProjectClassificationSubtype__c, project.ProjectClassificationSubtype__c, 'ProjectClassificationSubtype__c', isAMatch);
            } else {
                isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.ProjectClassificationSubtype__c, project.IsSameMarketPromotionalPack__c ? InnovatorConstants.REORDER_SAME_MARKET_PACK_SUBTYPE : InnovatorConstants.REORDER_DIFFERENT_MARKET_PACK_SUBTYPE, 'ProjectClassificationSubtype__c', isAMatch);
            }
        }

        String additionalHubs = project.AddAdditionalHubOrHubs__c;

        Boolean isMatchedBeforeAdditionalGeo = isAMatch;
        Boolean isMultiRegionNotification = false;
        if (project.IsMultiRegion__c) {
            isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.Hub__c, additionalHubs, 'AddAdditionalHubOrHubs__c', isAMatch);
            isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.Cluster__c, project.AddAdditionalClusterOrClusters__c, 'AddAdditionalClusterOrClusters__c', isAMatch);
            if (currentPhase != InnovatorConstants.DISCOVER_PHASE) {
                isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.LeadMarket__c, project.AddAdditionalMarketOrMarkets__c, 'AddAdditionalMarketOrMarkets__c', isAMatch);
            }

            if (project.ApprovalProcessStatus__c == MULTI_REGION_SUBMISSION &&
                currentPhase == InnovatorConstants.DEVELOP_PHASE || currentPhase == InnovatorConstants.DEPLOY_PHASE) {
                if (project.ProjectPhase__c.equals(InnovatorConstants.DEVELOP_PHASE)) {
                    if (project.ProjectClassification__c.equals(InnovatorConstants.GEO_EXTENSION)) {
                        isAMatch = isAMatch && InnovatorConstants.COMMERCIAL_GEO_EXTENSION_MULTI_REGION_APPROVERS.contains(ruleMatrix.ApproverRole__c);
                    } else {
                    isAMatch = isAMatch && InnovatorConstants.COMMERCIAL_MULTI_REGION_APPROVERS.contains(ruleMatrix.ApproverRole__c);
                    }
                } else if (project.ProjectPhase__c.equals(InnovatorConstants.DEPLOY_PHASE)) {
                    if (project.ProjectClassification__c.equals(InnovatorConstants.FEARLESS_BET)) {
                        isAMatch = isAMatch && InnovatorConstants.PRODUCTION_MULTI_REGION_APPROVERS.contains(ruleMatrix.ApproverRole__c);
                    } else if (project.ProjectClassification__c.equals(InnovatorConstants.GEO_EXTENSION)) {
                        isAMatch = isAMatch && InnovatorConstants.GEO_PRODUCTION_MULTI_REGION_APPROVERS.contains(ruleMatrix.ApproverRole__c);
                    } else {
                        isAMatch = isAMatch && InnovatorConstants.RP_BE_PRODUCTION_MULTI_REGION_APPROVERS.contains(ruleMatrix.ApproverRole__c);
                    }
                }
            }
        }

        isMultiRegionNotification = isAMatch;

        if ((!isMultiRegionNotification && !isSupplyChainDirector && isMultiRegion) || (!isMultiRegion && isSupplyChainDirector) || (!isMultiRegion && !isSupplyChainDirector)) {
            isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.Cluster__c, project.Cluster__c, 'Cluster__c', isMatchedBeforeAdditionalGeo);
            isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.Hub__c, project.Hub__c, 'Hub__c', isAMatch);
            if (currentPhase != InnovatorConstants.DISCOVER_PHASE ) {
                isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.LeadMarket__c, project.LeadMarket__c, 'LeadMarket__c', isAMatch);
            }
        }
        if (ruleMatrix.TradeTypeExactMatch__c) {
            isAMatch = ApprovalMatrixService.tradeTypeExactMatch(project.TradeType__c, ruleMatrix.TradeType__c, isAMatch);
        } else {
            isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.TradeType__c, project.TradeType__c, 'TradeType__c', isAMatch);
        }
        isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.DistributionChannel__c, project.DC__c, 'DistributionChannel__c', isAMatch);
        if (InnovatorConstants.CONTINUOUS_IMPROVEMENT.equals(project.ProjectClassification__c)) {
            isAMatch = isAMatch && ruleMatrix.ApproverRole__c.equals(InnovatorConstants.REGIONAL_SUPPLY_CHAIN_DIRECTOR);
        }
        if (InnovatorConstants.PROMOTIONAL_PACK.equals(project.ProjectClassification__c) && InnovatorConstants.NECK_TAG_SUBTYPE.equals(project.ProjectClassificationSubtype__c)) {
            isAMatch = isAMatch && ruleMatrix.ApproverRole__c.equals(InnovatorConstants.BRAND_DIRECTOR);
        }
        if (InnovatorConstants.PROJECT_CLASSIFICATIONS_WITH_SUBTYPES.contains(project.ProjectClassification__c)) {
            isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.ProjectClassificationSubtype__c, project.ProjectClassificationSubtype__c, 'ProjectClassificationSubtype__c', isAMatch);
        }
        isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.Category__c, project.Category__c, 'Category__c', isAMatch);

        isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.Brand__c, project.Brand__c, 'Brand__c', isAMatch);

        if (ruleMatrix.ExceptBrand__c != null) {
            Boolean isExceptMatch = RuleMatchingService.isRuleMatching(ruleMatrix.ExceptBrand__c, project.Brand__c) && project.Brand__c.split(';').size() == 1;
            isAMatch = isAMatch && !isExceptMatch;
        }

        isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.SubBrand__c, project.Subrand__c, 'SubBrand__c', isAMatch);

        isAMatch = isAMatch && (NOTIFICATION.equals(ruleMatrix.ApprovalType__c) || isMultiRegion);
        isAMatch = isAMatch && ruleMatrix.DecisionStep__c != null && ruleMatrix.DecisionStep__c.contains(InnovatorConstants.MAP_PHASES_TO_MILESTONES.get(currentPhase));

        return isAMatch;
    }

    private static void setProjectSubType(Project__c project) {
        Boolean assignSubtype = project.ProjectPhase__c.equals(InnovatorConstants.DEFINE_PHASE) && (project.ProjectClassification__c.equals(InnovatorConstants.CONTINUOUS_IMPROVEMENT) || project.ProjectClassification__c.equals(InnovatorConstants.MANDATORY) || project.ProjectClassification__c.equals(InnovatorConstants.REPACK));
        if (assignSubtype) {
            if (project.ProjectClassification__c.equals(InnovatorConstants.CONTINUOUS_IMPROVEMENT) || project.ProjectClassification__c.equals(InnovatorConstants.MANDATORY)) {
                project = ApprovalProcessService.setCiMandatorySubType(project);
            } else if (project.ProjectClassification__c.equals(InnovatorConstants.REPACK)) {
                project = ApprovalProcessService.setRepackSubType(project);
            }
        }
    }

    private static void setApprovalMatrix(Project__c project, List<ApprovalMatrix__c> approversDB, String approvalStep, String comment, Boolean fromTrigger) {
        Map<Id, User> usersMap = ApprovalProcessRepository.getAllActiveUsers();
        Map<Id, User> usersToUpdate = new Map<Id, User>();
        Map<Id, Map<String, String>> matrixApprovers = assignMatrixApprovers(project, approversDB, usersToUpdate, usersMap);
        if (!usersToUpdate.isEmpty()) {
            update new List<User>(new Set<User>(usersToUpdate.values()));
        }
        Map<Id, Map<String, String>> match = new Map<Id, Map<String, String>>();
        Boolean isSimplePromotionalPack = InnovatorConstants.PROMOTIONAL_PACK.equals(project.ProjectClassification__c) && (project.ProjectClassificationSubtype__c == InnovatorConstants.NECK_TAG_SUBTYPE || (project.ProjectClassificationSubtype__c == InnovatorConstants.REPEATING_PROMOTIONAL_PACK_SUBTYPE && project.IsSameMarketPromotionalPack__c));
        Boolean isComplexRepack = project.ProjectClassification__c.equals(InnovatorConstants.REPACK) && project.ProjectClassificationSubtype__c == InnovatorConstants.PRIMARY_PACK_CHANGE_SUBTYPE;
        String additionalHubs = project.AddAdditionalHubOrHubs__c;

        Boolean areApproversFound = !matrixApprovers.isEmpty() && matrixApprovers != null;
        //Logic to remove duplicate approvers in the multi-region approval step,
        //(if they approved in the previous steps in the current Approval process, we don't want them to have to approve again)
        if (fromTrigger && MULTI_REGION_SUBMISSION.equals(project.ApprovalProcessStatus__c)) {
            match = removeApproversFromPreviousStepsInCurrentApprovalProcess(project, matrixApprovers);
        } else {
            match = matrixApprovers.clone();
        }

        List<Id> newWorkItemIds = new List<Id>();
        Set<Id> selectedApproverIds = new Set<Id>();
        Set<Id> approverIds = new Set<Id>(match.keySet());

        replaceReassignedUser(approverIds, project.id, usersToUpdate.keySet());
        clearApprovers(project);
        if (approverIds != null && !approverIds.isEmpty()) {
            setApprovers(project, approverIds, selectedApproverIds);
            fillEmptyApprovers(project, approverIds);

            //logic for approver History
            Map<String, String> approverRoleByNameMap = new Map<String, String>();
            for (Id approverId : match.keySet()) {
                approverRoleByNameMap.putAll(match.get(approverId));
            }

            project.ApprovalHistoricalData__c = setApprovalHistoricalData(project, approverRoleByNameMap);
            final Boolean isFirstApprovalStep = FIRST_APPROVAL_STEP.equals(approvalStep);
            if (isFirstApprovalStep) {
                if (InnovatorConstants.MAP_PHASES_TO_SUBMISSION_STATUS.get(project.ProjectPhase__c) != null) {
                    project.SubmissionStatus__c = InnovatorConstants.MAP_PHASES_TO_SUBMISSION_STATUS.get(project.ProjectPhase__c);
                }
                if (isAutomaticApprovalProcess(project, isSimplePromotionalPack) && !MULTI_REGION_SUBMISSION.equals(project.ApprovalProcessStatus__c)) {
                    setApproversToCurrentUser(project);
                }
                final Boolean isDiscoverPhase = project.ProjectPhase__c == InnovatorConstants.DISCOVER_PHASE;
                final Boolean isDefinePhase = project.ProjectPhase__c == InnovatorConstants.DEFINE_PHASE;
                final Boolean isLegalAndRegulatoryDiscoverClassification = InnovatorConstants.LEGAL_AND_REGULATORY_DISCOVER_CLASSIFICATION.contains(project.ProjectClassification__c);
                final Boolean isLegalAndRegulatoryDefineClassification = InnovatorConstants.LEGAL_AND_REGULATORY_DEFINE_CLASSIFICATION.contains(project.ProjectClassification__c);
                if (((isDiscoverPhase && isLegalAndRegulatoryDiscoverClassification) || (isDefinePhase && isLegalAndRegulatoryDefineClassification)) && (project.ApprovalProcessStatus__c == null || !project.ApprovalProcessStatus__c.equals(MULTI_REGION_SUBMISSION))) {
                    LegalAndRegulatoryNotificationService.sendLegalAndRegulatoryNotifications(project);
                }
                if (!fromTrigger) {
                    update project;
                }
                if (!MULTI_REGION_SUBMISSION.equals(project.ApprovalProcessStatus__c)) {
                    Approval.ProcessSubmitRequest approvalProcessSubmitRequest = new Approval.ProcessSubmitRequest();
                    approvalProcessSubmitRequest.setObjectId(project.id);
                    approvalProcessSubmitRequest.setComments(comment);
                    Approval.ProcessResult result = Approval.process(approvalProcessSubmitRequest);
                    Boolean isAutomaticApproval = isAutomaticApprovalProcess(project, isSimplePromotionalPack);
                    newWorkItemIds = result.getNewWorkitemIds();
                    String processInstanceId = result.getInstanceId();
                    Boolean needToUpdate = ApprovalHistory.saveStepName(project, processInstanceId, newWorkItemIds, isAutomaticApproval, false, null);
                } else if (!isAutomaticApprovalProcess(project, isSimplePromotionalPack)) {
                    List<User> users = ApprovalProcessRepository.getUsersByIds(new Set<Id>{
                        project.ProjectLeader__c, project.ProjectManager__c
                    });
                    List<String> toEmails = new List<String>();
                    for (User user : users) {
                        toEmails.add(user.Email);
                    }
                    final String emailSubject = 'Innovator - (' + project.ProjectNumberFormula__c + ' - ' + project.Name + ') - Project Approval Status Update';
                    final String emailBody = '<p>To Project Leader and Project Manager,</p><p>This notification is to inform you that for your Project ' + '(' + project.ProjectNumberFormula__c + ' - ' + project.Name + ')' + ' the Approvers for the project’s lead region have approved the project, and now approval notifications have been sent to the project’s secondary regions for them to approve.<p>Please do not chase these approvers any earlier than 5 working days of receiving this email.</p><p>Click here to open the project in Innovator: ' + URL.getOrgDomainUrl().toExternalForm() + '/' + project.Id + '</p>';
                    EmailService.sendEmail(toEmails, project.Id, emailSubject, emailBody);
                }
            }
        } else if ((approverIds == null || approverIds.isEmpty()) && MULTI_REGION_SUBMISSION.equals(project.ApprovalProcessStatus__c) &&
            ((InnovatorConstants.DEFINE_PHASE.equals(project.ProjectPhase__c) && (InnovatorConstants.REPACK.equals(project.ProjectClassification__c) || InnovatorConstants.FEARLESS_BET.equals(project.ProjectClassification__c) || InnovatorConstants.BRAND_ENERGIZER.equals(project.ProjectClassification__c))) ||
                (InnovatorConstants.DESIGN_PHASE.equals(project.ProjectPhase__c) && (isComplexRepack || InnovatorConstants.FEARLESS_BET.equals(project.ProjectClassification__c) || InnovatorConstants.BRAND_ENERGIZER.equals(project.ProjectClassification__c))) ||
                additionalHubs.contains('GTR') || areApproversFound)) {
            //todo finish the logic
        } else {
            throw new NoApproversException(NO_APPROVERS_ERROR_MESSAGE);
        }
        if (MULTI_REGION_SUBMISSION.equals(project.ApprovalProcessStatus__c) && (InnovatorConstants.DISCOVER_PHASE.equals(project.ProjectPhase__c) || (InnovatorConstants.DEVELOP_PHASE.equals(project.ProjectPhase__c) && !InnovatorConstants.FEARLESS_BET.equals(project.ProjectClassification__c) && !InnovatorConstants.BRAND_ENERGIZER.equals(project.ProjectClassification__c) && !InnovatorConstants.BUSINESS_ENABLER.equals(project.ProjectClassification__c) && !InnovatorConstants.GEO_EXTENSION.equals(project.ProjectClassification__c)) || InnovatorConstants.DEPLOY_PHASE.equals(project.ProjectPhase__c))) {
            AutoApproval__e event = new AutoApproval__e(Project__c = project.Id, Comment__c = comment);
            EventBus.publish(event);
        }
        if (!newWorkItemIds.isEmpty() && isAutomaticApprovalProcess(project, isSimplePromotionalPack)) {
            sleep();
            String nextPhase = getNextPhaseName(project);
            selectedApproverIds.add(project.ProjectManager__c);
            selectedApproverIds.add(project.ProjectLeader__c);
            final Boolean sendAutoApprovalEmail = !project.IsMultiRegion__c;
            final String listOfPeopleNotified = EmailManager.sendEmailForAutoApprovalAndGetListOfRecipients(project, selectedApproverIds, comment, nextPhase, sendAutoApprovalEmail);
            String processInstanceId;
            for (Id approvalId : newWorkItemIds) {
                Approval.ProcessWorkitemRequest processWorkItemRequest = new Approval.ProcessWorkitemRequest();
                processWorkItemRequest.setComments('Project progressed to ' + nextPhase + ' phase. \n Notification sent to: ' + listOfPeopleNotified);
                processWorkItemRequest.setAction(InnovatorConstants.APPROVAL_ACTION_APPROVE);
                processWorkItemRequest.setWorkitemId(approvalId);
                Approval.ProcessResult res = Approval.process(processWorkItemRequest);
                processInstanceId = res.getInstanceId();
            }
            Boolean needToUpdate = ApprovalHistory.saveStepName(project, processInstanceId, newWorkItemIds, true, false, null);
        } else if (!newWorkItemIds.isEmpty()) {
            EmailManager.sendEmailForApprovers(project, false, null, comment, false, true);
        } else if (!selectedApproverIds.isEmpty() && project.ApprovalProcessStatus__c == MULTI_REGION_SUBMISSION && (!InnovatorConstants.DISCOVER_PHASE.equals(project.ProjectPhase__c) && !InnovatorConstants.DEPLOY_PHASE.equals(project.ProjectPhase__c)) || (InnovatorConstants.DEVELOP_PHASE.equals(project.ProjectPhase__c) && !InnovatorConstants.FEARLESS_BET.equals(project.ProjectClassification__c) && !InnovatorConstants.BRAND_ENERGIZER.equals(project.ProjectClassification__c) && !InnovatorConstants.BUSINESS_ENABLER.equals(project.ProjectClassification__c) && !InnovatorConstants.GEO_EXTENSION.equals(project.ProjectClassification__c))) {
            //TODO: review if we need to adjust this condition in case there are no approvers for the multi-region step
            ProcessInstance processInstance = ApprovalHistoryRepository.getLastApprovalProcess(project.Id);
            List<ProcessInstanceStep> processInstanceSteps = ApprovalHistoryRepository.getProcessInstanceSteps(processInstance.Id);
            EmailManager.sendEmailForApprovers(project, false, selectedApproverIds, processInstanceSteps[0].Comments, false, true);
        }
    }

    public static String setApprovalHistoricalData(Project__c project, Map<String, String> approverRoleByNameMap) {
        String approvalHistoricalData;
        Map<String, Map<String, String>> approversInfoByMilestoneMap = new Map<String, Map<String, String>>();
        if (String.isBlank(project.ApprovalHistoricalData__c) || project.ApprovalHistoricalData__c.contains(ApprovalHistory.PROJECT_NUMBER)) {
            approversInfoByMilestoneMap.put(InnovatorConstants.MAP_PHASES_TO_MILESTONES.get(project.ProjectPhase__c), approverRoleByNameMap);
            approvalHistoricalData = JSON.serialize(approversInfoByMilestoneMap);
        } else {
            Map<String, Object> approvalHistoricalDataMap = (Map<String, Object>) JSON.deserializeUntyped(project.ApprovalHistoricalData__c);
            if (approvalHistoricalDataMap.containsKey(InnovatorConstants.MAP_PHASES_TO_MILESTONES.get(project.ProjectPhase__c))) { // add new data to the existing values
                String nameRoleString = JSON.serialize(approvalHistoricalDataMap.get(InnovatorConstants.MAP_PHASES_TO_MILESTONES.get(project.ProjectPhase__c)));
                List<String> nameRoleStringList = nameRoleString.remove('{').remove('}').remove('"').split(',');
                Map<String, String> currentMilestoneValuesMap = new Map<String, String>();
                for (String str : nameRoleStringList) {
                    currentMilestoneValuesMap.put(str.substringBefore(':'), str.substringAfter(':'));
                }
                currentMilestoneValuesMap.putAll(approverRoleByNameMap);
                approvalHistoricalDataMap.put(InnovatorConstants.MAP_PHASES_TO_MILESTONES.get(project.ProjectPhase__c), currentMilestoneValuesMap);
                approvalHistoricalData = JSON.serialize(approvalHistoricalDataMap);
            } else {
                approvalHistoricalDataMap.put(InnovatorConstants.MAP_PHASES_TO_MILESTONES.get(project.ProjectPhase__c), approverRoleByNameMap);
                approvalHistoricalData = JSON.serialize(approvalHistoricalDataMap);
            }
        }
        return approvalHistoricalData;
    }

    private static void setApprovers(Project__c project, Set<Id> approverIds, Set<Id> selectedApproverIds) {
        for (Id approverId : approverIds) {
            if (project.Approver_1_For_Current_Milestone__c == null) {
                project.Approver_1_For_Current_Milestone__c = approverId;
                selectedApproverIds.add(approverId);
            } else if (project.Approver_2_For_Current_Milestone__c == null) {
                project.Approver_2_For_Current_Milestone__c = approverId;
                selectedApproverIds.add(approverId);
            } else if (project.Approver_3_For_Current_Milestone__c == null) {
                project.Approver_3_For_Current_Milestone__c = approverId;
                selectedApproverIds.add(approverId);
            } else if (project.Approver_4_For_Current_Milestone__c == null) {
                project.Approver_4_For_Current_Milestone__c = approverId;
                selectedApproverIds.add(approverId);
            } else if (project.Approver_5_For_Current_Milestone__c == null) {
                project.Approver_5_For_Current_Milestone__c = approverId;
                selectedApproverIds.add(approverId);
            } else if (project.Approver_6_For_Current_Milestone__c == null) {
                project.Approver_6_For_Current_Milestone__c = approverId;
                selectedApproverIds.add(approverId);
            } else if (project.Approver_7_For_Current_Milestone__c == null) {
                project.Approver_7_For_Current_Milestone__c = approverId;
                selectedApproverIds.add(approverId);
            } else if (project.Approver_8_For_Current_Milestone__c == null) {
                project.Approver_8_For_Current_Milestone__c = approverId;
                selectedApproverIds.add(approverId);
            } else if (project.Approver_9_For_Current_Milestone__c == null) {
                project.Approver_9_For_Current_Milestone__c = approverId;
                selectedApproverIds.add(approverId);
            } else if (project.Approver_10_For_Current_Milestone__c == null) {
                project.Approver_10_For_Current_Milestone__c = approverId;
                selectedApproverIds.add(approverId);
            } else if (project.Approver_11_For_Current_Milestone__c == null) {
                project.Approver_11_For_Current_Milestone__c = approverId;
                selectedApproverIds.add(approverId);
            } else if (project.Approver_12_For_Current_Milestone__c == null) {
                project.Approver_12_For_Current_Milestone__c = approverId;
                selectedApproverIds.add(approverId);
            } else if (project.Approver_13_For_Current_Milestone__c == null) {
                project.Approver_13_For_Current_Milestone__c = approverId;
                selectedApproverIds.add(approverId);
            } else if (project.Approver_14_For_Current_Milestone__c == null) {
                project.Approver_14_For_Current_Milestone__c = approverId;
                selectedApproverIds.add(approverId);
            } else if (project.Approver_15_For_Current_Milestone__c == null) {
                project.Approver_15_For_Current_Milestone__c = approverId;
                selectedApproverIds.add(approverId);
            } else if (project.Approver_16_For_Current_Milestone__c == null) {
                project.Approver_16_For_Current_Milestone__c = approverId;
                selectedApproverIds.add(approverId);
            } else if (project.Approver_17_For_Current_Milestone__c == null) {
                project.Approver_17_For_Current_Milestone__c = approverId;
                selectedApproverIds.add(approverId);
            } else if (project.Approver_18_For_Current_Milestone__c == null) {
                project.Approver_18_For_Current_Milestone__c = approverId;
                selectedApproverIds.add(approverId);
            } else if (project.Approver_19_For_Current_Milestone__c == null) {
                project.Approver_19_For_Current_Milestone__c = approverId;
                selectedApproverIds.add(approverId);
            } else if (project.Approver_20_For_Current_Milestone__c == null) {
                project.Approver_20_For_Current_Milestone__c = approverId;
                selectedApproverIds.add(approverId);
            }
        }
    }

    private static void fillEmptyApprovers(Project__c project, Set<Id> approverIds) {
        for (Id approverId : approverIds) {
            if (project.Approver_2_For_Current_Milestone__c == null) {
                project.Approver_2_For_Current_Milestone__c = approverId;
            }
            if (project.Approver_3_For_Current_Milestone__c == null) {
                project.Approver_3_For_Current_Milestone__c = approverId;
            }
            if (project.Approver_4_For_Current_Milestone__c == null) {
                project.Approver_4_For_Current_Milestone__c = approverId;
            }
            if (project.Approver_5_For_Current_Milestone__c == null) {
                project.Approver_5_For_Current_Milestone__c = approverId;
            }
            if (project.Approver_6_For_Current_Milestone__c == null) {
                project.Approver_6_For_Current_Milestone__c = approverId;
            }
            if (project.Approver_7_For_Current_Milestone__c == null) {
                project.Approver_7_For_Current_Milestone__c = approverId;
            }
            if (project.Approver_8_For_Current_Milestone__c == null) {
                project.Approver_8_For_Current_Milestone__c = approverId;
            }
            if (project.Approver_9_For_Current_Milestone__c == null) {
                project.Approver_9_For_Current_Milestone__c = approverId;
            }
            if (project.Approver_10_For_Current_Milestone__c == null) {
                project.Approver_10_For_Current_Milestone__c = approverId;
            }
            if (project.Approver_11_For_Current_Milestone__c == null) {
                project.Approver_11_For_Current_Milestone__c = approverId;
            }
            if (project.Approver_12_For_Current_Milestone__c == null) {
                project.Approver_12_For_Current_Milestone__c = approverId;
            }
            if (project.Approver_13_For_Current_Milestone__c == null) {
                project.Approver_13_For_Current_Milestone__c = approverId;
            }
            if (project.Approver_14_For_Current_Milestone__c == null) {
                project.Approver_14_For_Current_Milestone__c = approverId;
            }
            if (project.Approver_15_For_Current_Milestone__c == null) {
                project.Approver_15_For_Current_Milestone__c = approverId;
            }
            if (project.Approver_16_For_Current_Milestone__c == null) {
                project.Approver_16_For_Current_Milestone__c = approverId;
            }
            if (project.Approver_17_For_Current_Milestone__c == null) {
                project.Approver_17_For_Current_Milestone__c = approverId;
            }
            if (project.Approver_18_For_Current_Milestone__c == null) {
                project.Approver_18_For_Current_Milestone__c = approverId;
            }
            if (project.Approver_19_For_Current_Milestone__c == null) {
                project.Approver_19_For_Current_Milestone__c = approverId;
            }
            if (project.Approver_20_For_Current_Milestone__c == null) {
                project.Approver_20_For_Current_Milestone__c = approverId;
            }
        }
    }

    public static String getNextPhaseName(Project__c project) {
        String nextPhase = '';
        final Boolean isSimplePromotionalPack = (project.ProjectClassificationSubtype__c == InnovatorConstants.NECK_TAG_SUBTYPE || (project.ProjectClassificationSubtype__c == InnovatorConstants.REPEATING_PROMOTIONAL_PACK_SUBTYPE && project.IsSameMarketPromotionalPack__c));
        final Boolean isGeoExtension = project.ProjectClassification__c == InnovatorConstants.GEO_EXTENSION;
        final Boolean isCIOrMandatory = InnovatorConstants.CONTINUOUS_IMPROVEMENT.equals(project.ProjectClassification__c) || InnovatorConstants.MANDATORY.equals(project.ProjectClassification__c);
        if (InnovatorConstants.PROMOTIONAL_PACK.equals(project.ProjectClassification__c) && isSimplePromotionalPack) {
            nextPhase = InnovatorConstants.PHASES_PROMOTIONAL_PACK_SIMPLE.get(InnovatorConstants.PHASES_PROMOTIONAL_PACK_SIMPLE.indexOf(project.ProjectPhase__c) + 1);
        } else if (!isSimplePromotionalPack && InnovatorConstants.PROMOTIONAL_PACK.equals(project.ProjectClassification__c)) {
            nextPhase = InnovatorConstants.PHASES_PROMOTIONAL_PACK_COMPLEX.get(InnovatorConstants.PHASES_PROMOTIONAL_PACK_COMPLEX.indexOf(project.ProjectPhase__c) + 1);
        } else if (isGeoExtension) {
            if (project.ProjectClassificationSubtype__c == InnovatorConstants.IPC_SUBTYPE_API) {
                nextPhase = InnovatorConstants.PHASES_GEO_EXTENSION_PRODUCT_MODIFICATION_IPC_EXTENSION.get(InnovatorConstants.PHASES_GEO_EXTENSION_PRODUCT_MODIFICATION_IPC_EXTENSION.indexOf(project.ProjectPhase__c) + 1);
            } else {
                nextPhase = InnovatorConstants.PHASES_GEO_EXTENSION_PRODUCT_MODIFICATION.get(InnovatorConstants.PHASES_GEO_EXTENSION_PRODUCT_MODIFICATION.indexOf(project.ProjectPhase__c) + 1);
            }
        } else if (project.ProjectClassification__c == InnovatorConstants.REPACK && project.ProjectClassificationSubtype__c == InnovatorConstants.ARTWORK_CHANGE_ONLY_SUBTYPE) {
            nextPhase = InnovatorConstants.PHASES_REPACK_ARTWORK_CHANGE_ONLY.get(InnovatorConstants.PHASES_REPACK_ARTWORK_CHANGE_ONLY.indexOf(project.ProjectPhase__c) + 1);
        } else if (isCIOrMandatory) {
            if (project.ProjectClassificationSubtype__c == InnovatorConstants.ARTWORK_CHANGE_SUBTYPE) {
                nextPhase = InnovatorConstants.PHASES_CI_MANDATORY_SIMPLE.get(InnovatorConstants.PHASES_CI_MANDATORY_SIMPLE.indexOf(project.ProjectPhase__c) + 1);
            } else {
                nextPhase = InnovatorConstants.PHASES_CI_MANDATORY_COMPLEX.get(InnovatorConstants.PHASES_CI_MANDATORY_COMPLEX.indexOf(project.ProjectPhase__c) + 1);
            }
        } else {
            nextPhase = InnovatorConstants.PHASES_ORDERED.get(InnovatorConstants.PHASES_ORDERED.indexOf(project.ProjectPhase__c) + 1);
        }
        return nextPhase;
    }

    public static void clearApprovers(Project__c project) {
        project.Approver_1_For_Current_Milestone__c = null;
        project.Approver_2_For_Current_Milestone__c = null;
        project.Approver_3_For_Current_Milestone__c = null;
        project.Approver_4_For_Current_Milestone__c = null;
        project.Approver_5_For_Current_Milestone__c = null;
        project.Approver_6_For_Current_Milestone__c = null;
        project.Approver_7_For_Current_Milestone__c = null;
        project.Approver_8_For_Current_Milestone__c = null;
        project.Approver_9_For_Current_Milestone__c = null;
        project.Approver_10_For_Current_Milestone__c = null;
        project.Approver_11_For_Current_Milestone__c = null;
        project.Approver_12_For_Current_Milestone__c = null;
        project.Approver_13_For_Current_Milestone__c = null;
        project.Approver_14_For_Current_Milestone__c = null;
        project.Approver_15_For_Current_Milestone__c = null;
        project.Approver_16_For_Current_Milestone__c = null;
        project.Approver_17_For_Current_Milestone__c = null;
        project.Approver_18_For_Current_Milestone__c = null;
        project.Approver_19_For_Current_Milestone__c = null;
        project.Approver_20_For_Current_Milestone__c = null;
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

    private static void setApproversToCurrentUser(Project__c project) {
        Id userId = UserInfo.getUserId();
        project.Approver_1_For_Current_Milestone__c = userId;
        project.Approver_2_For_Current_Milestone__c = userId;
        project.Approver_3_For_Current_Milestone__c = userId;
        project.Approver_4_For_Current_Milestone__c = userId;
        project.Approver_5_For_Current_Milestone__c = userId;
        project.Approver_6_For_Current_Milestone__c = userId;
        project.Approver_7_For_Current_Milestone__c = userId;
        project.Approver_8_For_Current_Milestone__c = userId;
        project.Approver_9_For_Current_Milestone__c = userId;
        project.Approver_10_For_Current_Milestone__c = userId;
    }

    public static Map<Id, Map<String, String>> assignMatrixApprovers(Project__c project, List<ApprovalMatrix__c> rules, Map<Id, User> users, Map<Id, User> allActiveUsers) {
        Map<Id, Map<String, String>> approverInfoByIdsMap = new Map<Id, Map<String, String>>();
        List<AggregateResult> hubs = new List<AggregateResult>();
        List<String> hubNames = new List<String>();
        if (project.ApprovalProcessStatus__c == MULTI_REGION_SUBMISSION) {
            hubs = LookupGeoHierarchyRepository.getGroupedGeoHierarchiesByRegion(project.Region__c);
            for (AggregateResult hubResult : hubs) {
                hubNames.add((String) hubResult.get('HUB__c'));
            }
        }

        Boolean needsAdditionalHubFilterBCA = InnovatorConstants.DEFINE_PHASE.equals(project.ProjectPhase__c) &&
            (InnovatorConstants.REPACK.equals(project.ProjectClassification__c) || InnovatorConstants.BRAND_ENERGIZER.equals(project.ProjectClassification__c) || InnovatorConstants.FEARLESS_BET.equals(project.ProjectClassification__c));

        Boolean isComplexRepack = InnovatorConstants.REPACK.equals(project.ProjectClassification__c) && InnovatorConstants.PRIMARY_PACK_CHANGE_SUBTYPE.equals(project.ProjectClassificationSubtype__c);
        Boolean needsAdditionalHubFilterBCV = InnovatorConstants.DESIGN_PHASE.equals(project.ProjectPhase__c) &&
            (isComplexRepack || InnovatorConstants.BRAND_ENERGIZER.equals(project.ProjectClassification__c) || InnovatorConstants.FEARLESS_BET.equals(project.ProjectClassification__c));

        Boolean isOfflineMeeting = false;
        Set<Id> leadApproversIds = new Set<Id>();
        if (project.ApprovalProcessStatus__c == MULTI_REGION_SUBMISSION && (needsAdditionalHubFilterBCA || needsAdditionalHubFilterBCV)) {
            isOfflineMeeting = true;
            String leadRegions = project.Hub__c;
            for (ApprovalMatrix__c rule : rules) {
                Boolean isAMatch = matchProjectToRuleMatrixByLeadRegion(project, rule, leadRegions, true);
                if (isAMatch && rule.Approver__c != null && rule.Approver__r.IsActive == true && rule.Approver__r.DelegatedApproverId == null) {
                    leadApproversIds.add(rule.Approver__c);
                } else if (isAMatch && rule.Approver__c != null && rule.Approver__r.IsActive == true && rule.Approver__r.DelegatedApproverId != null) {
                    leadApproversIds.add(rule.Approver__r.DelegatedApproverId);
                    User user = allActiveUsers.get(rule.Approver__c);
                    Map<String, Set<String>> projectIdToApprovals = new Map<String, Set<String>>();
                    if (user.PendingProjectsToReassign__c != null) {
                        projectIdToApprovals = (Map<String, Set<String>>)(JSON.deserialize(user.PendingProjectsToReassign__c, Map<String, Set<String>>.class));
                        projectIdToApprovals.put(project.Id, new Set<String>());
                    } else {
                        Set<String> approvals = new Set<String>();
                        projectIdToApprovals.put(project.Id, approvals);
                    }
                    user.PendingProjectsToReassign__c = JSON.serialize(projectIdToApprovals);
                    users.put(user.Id, user);
                }
            }
        }

        Map<String, String> approverRolePicklistValueToLabelMap = getApproverRolePicklistValuesToLabelsMap();
        for (ApprovalMatrix__c rule : rules) {
            Boolean skipMatching = false;
            if (project.ApprovalProcessStatus__c == MULTI_REGION_SUBMISSION && !leadApproversIds.isEmpty() && leadApproversIds != null && (needsAdditionalHubFilterBCA || needsAdditionalHubFilterBCV)) {
                if (leadApproversIds.contains(rule.Approver__c) || leadApproversIds.contains(rule.Approver__r.DelegatedApproverId)) {
                    skipMatching = true;
                }
            }
            if (!skipMatching) {
                Boolean isAMatch = matchProjectToRuleMatrix(project, rule, hubNames, isOfflineMeeting);
                if (isAMatch && rule.Approver__c != null && rule.Approver__r.IsActive == true && rule.Approver__r.DelegatedApproverId == null) {
                    Map<String, String> approverInfo = new Map<String, String>();
                    if (approverInfoByIdsMap.containsKey(rule.Approver__c)) {
                        Map<String, String> roleByNameMap = approverInfoByIdsMap.get(rule.Approver__c);
                        if (roleByNameMap.get(rule.Approver__r.Name) != null) {
                            List<String> roles = new List<String>();
                            if (roleByNameMap.get(rule.Approver__r.Name).contains('/')) {
                                roles = roleByNameMap.get(rule.Approver__r.Name).split('/');
                            } else {
                                roles.add(roleByNameMap.get(rule.Approver__r.Name));
                            }
                            if (!roles.isEmpty() && !roles.contains(approverRolePicklistValueToLabelMap.get(rule.ApproverRole__c))) {
                                String severalRolesString = roleByNameMap.get(rule.Approver__r.Name) + '/' + approverRolePicklistValueToLabelMap.get(rule.ApproverRole__c);
                                approverInfo.put(rule.Approver__r.Name, severalRolesString);
                                approverInfoByIdsMap.put(rule.Approver__c, approverInfo);
                            }
                        }
                    } else {
                        approverInfo.put(rule.Approver__r.Name, approverRolePicklistValueToLabelMap.get(rule.ApproverRole__c));
                        approverInfoByIdsMap.put(rule.Approver__c, approverInfo);
                    }
                } else if (isAMatch && rule.Approver__c != null && rule.Approver__r.IsActive == true && rule.Approver__r.DelegatedApproverId != null) {
                    User delegatedUser = allActiveUsers.get(rule.Approver__r.DelegatedApproverId);
                    if (delegatedUser != null) {
                        Map<String, String> approverInfo = new Map<String, String>();
                        if (delegatedUser.DelegatedApproverId == null) {
                            if (!approverInfoByIdsMap.containsKey(rule.Approver__r.DelegatedApproverId)) {
                                approverInfo.put(delegatedUser.Name, approverRolePicklistValueToLabelMap.get(rule.ApproverRole__c));
                                approverInfoByIdsMap.put(rule.Approver__r.DelegatedApproverId, approverInfo);
                            }
                        } else {
                            if (!approverInfoByIdsMap.containsKey(delegatedUser.DelegatedApproverId)) {
                                User secondDelegatedUser = allActiveUsers.get(delegatedUser.DelegatedApproverId);
                                approverInfo.put(secondDelegatedUser.Name, approverRolePicklistValueToLabelMap.get(rule.ApproverRole__c));
                                approverInfoByIdsMap.put(delegatedUser.DelegatedApproverId, approverInfo);
                            }
                        }
                      }

                    User user = allActiveUsers.get(rule.Approver__c);
                    Map<String, Set<String>> projectIdToApprovals = new Map<String, Set<String>>();
                    if (user.PendingProjectsToReassign__c != null) {
                        projectIdToApprovals = (Map<String, Set<String>>)(JSON.deserialize(user.PendingProjectsToReassign__c, Map<String, Set<String>>.class));
                        projectIdToApprovals.put(project.Id, new Set<String>());
                    } else {
                        Set<String> approvals = new Set<String>();
                        projectIdToApprovals.put(project.Id, approvals);
                    }
                    user.PendingProjectsToReassign__c = JSON.serialize(projectIdToApprovals);
                    users.put(user.Id, user);
                }
            }
        }
        return approverInfoByIdsMap;
    }

    public static Map<String, String> getApproverRolePicklistValuesToLabelsMap() {
        List<Schema.PicklistEntry> picklistEntries = ApprovalMatrix__c.ApproverRole__c.getDescribe().getPicklistValues();
        Map<String, String> approverRolePicklistValuesToLabelsMap = new Map<String,String>();
        for (Schema.PicklistEntry picklistEntry : picklistEntries){
            if (picklistEntry.isActive()) {
                approverRolePicklistValuesToLabelsMap.put(picklistEntry.getValue(), picklistEntry.getLabel());
            }
        }

        return approverRolePicklistValuesToLabelsMap;
    }

    private static Boolean matchProjectToRuleMatrix(Project__c project, ApprovalMatrix__c ruleMatrix, List<String> hubs, Boolean isOfflineMeeting) {
        Boolean isAMatch = true;
        if (ruleMatrix.ProjectClassification__c != null && !ruleMatrix.ProjectClassification__c.contains(ALL_PICKLIST_VALUE) && !ruleMatrix.ProjectClassification__c.contains(project.ProjectClassification__c)) {
            isAMatch = false;
        }
        if (InnovatorConstants.PROJECT_CLASSIFICATIONS_WITH_SUBTYPES.contains(project.ProjectClassification__c)) {
            if ((!InnovatorConstants.PROMOTIONAL_PACK.equals(project.ProjectClassification__c)) || (InnovatorConstants.PROMOTIONAL_PACK.equals(project.ProjectClassification__c) && !project.ProjectClassificationSubType__c.equals(InnovatorConstants.REPEATING_PROMOTIONAL_PACK_SUBTYPE))) {
                isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.ProjectClassificationSubtype__c, project.ProjectClassificationSubtype__c, 'ProjectClassificationSubtype__c', isAMatch);
            } else {
                isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.ProjectClassificationSubtype__c, project.IsSameMarketPromotionalPack__c ? InnovatorConstants.REORDER_SAME_MARKET_PACK_SUBTYPE : InnovatorConstants.REORDER_DIFFERENT_MARKET_PACK_SUBTYPE, 'ProjectClassificationSubtype__c', isAMatch);
            }
        }
        isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.Category__c, project.Category__c, 'Category__c', isAMatch);
        isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.Brand__c, project.Brand__c, 'Brand__c', isAMatch);
        if (ruleMatrix.ExceptBrand__c != null) {
            Boolean isExceptMatch = RuleMatchingService.isRuleMatching(ruleMatrix.ExceptBrand__c, project.Brand__c) && project.Brand__c.split(';').size() == 1;
            isAMatch = isAMatch && !isExceptMatch;
        }
        isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.SubBrand__c, project.Subrand__c, 'SubBrand__c', isAMatch);
        if (project.ApprovalProcessStatus__c != MULTI_REGION_SUBMISSION) {
            isAMatch = isAMatch && ruleMatrix.ApprovalStep__c == '1';
            isAMatch = isAMatch && ((ONLINE_APPROVALS.equals(ruleMatrix.ApprovalType__c) || MEETING_APPROVALS.equals(ruleMatrix.ApprovalType__c)) || ((InnovatorConstants.DISCOVER_PHASE.equals(project.ProjectPhase__c) || InnovatorConstants.DEVELOP_PHASE.equals(project.ProjectPhase__c) || InnovatorConstants.DEPLOY_PHASE.equals(project.ProjectPhase__c)) && NOTIFICATION.equals(ruleMatrix.ApprovalType__c)));
        }
        if (project.ApprovalProcessStatus__c == MULTI_REGION_SUBMISSION) {
            isAMatch = isAMatch && (ONLINE_APPROVALS.equals(ruleMatrix.ApprovalType__c) || ((InnovatorConstants.DISCOVER_PHASE.equals(project.ProjectPhase__c) || InnovatorConstants.DEVELOP_PHASE.equals(project.ProjectPhase__c) || InnovatorConstants.DEPLOY_PHASE.equals(project.ProjectPhase__c)) && NOTIFICATION.equals(ruleMatrix.ApprovalType__c)));
            if (project.ProjectPhase__c.equals(InnovatorConstants.DISCOVER_PHASE)) {
                isAMatch = isAMatch && InnovatorConstants.OPPORTUNITY_MULTI_REGION_APPROVERS.contains(ruleMatrix.ApproverRole__c);
            } else if (project.ProjectPhase__c.equals(InnovatorConstants.DEFINE_PHASE)) {
                if (project.ProjectClassification__c.equals(InnovatorConstants.FEARLESS_BET) || (project.ProjectClassification__c.equals(InnovatorConstants.REPACK) && project.ProjectClassificationSubtype__c.equals(InnovatorConstants.PRIMARY_PACK_CHANGE_SUBTYPE))) {
                    isAMatch = isAMatch && InnovatorConstants.BCA_MULTI_REGION_APPROVERS.contains(ruleMatrix.ApproverRole__c);
                } else if (project.ProjectClassification__c.equals(InnovatorConstants.REPACK) && project.ProjectClassificationSubtype__c.equals(InnovatorConstants.ARTWORK_CHANGE_ONLY_SUBTYPE)) {
                    isAMatch = isAMatch && InnovatorConstants.REPACK_BCA_MULTI_REGION_APPROVERS.contains(ruleMatrix.ApproverRole__c);
                } else if (project.ProjectClassification__c.equals(InnovatorConstants.BUSINESS_ENABLER) || project.ProjectClassification__c.equals(InnovatorConstants.GEO_EXTENSION)) {
                    isAMatch = isAMatch && InnovatorConstants.BE_GEO_BCA_MULTI_REGION_APPROVERS.contains(ruleMatrix.ApproverRole__c) && (!ruleMatrix.Approver__r.Name.equals(InnovatorConstants.BCA_MEETING_APPROVER) && !ruleMatrix.Approver__r.Name.equals(InnovatorConstants.BCV_MEETING_APPROVER));
                }
            } else if (project.ProjectPhase__c.equals(InnovatorConstants.DESIGN_PHASE)) {
                if (project.ProjectClassification__c.equals(InnovatorConstants.FEARLESS_BET) || project.ProjectClassification__c.equals(InnovatorConstants.BRAND_ENERGIZER) || (project.ProjectClassification__c.equals(InnovatorConstants.REPACK) && project.ProjectClassificationSubtype__c.equals(InnovatorConstants.PRIMARY_PACK_CHANGE_SUBTYPE))) {
                    isAMatch = isAMatch && (InnovatorConstants.BCV_MULTI_REGION_APPROVERS.contains(ruleMatrix.ApproverRole__c) || InnovatorConstants.BCV_MULTI_REGION_APPROVERS.contains(ruleMatrix.Approver__r.Name));
                } else {
                    isAMatch = isAMatch && InnovatorConstants.RP_BE_GEO_BCV_MULTI_REGION_APPROVERS.contains(ruleMatrix.ApproverRole__c);
                }
            } else if (project.ProjectPhase__c.equals(InnovatorConstants.DEVELOP_PHASE)) {
                if (project.ProjectClassification__c.equals(InnovatorConstants.GEO_EXTENSION)) {
                    isAMatch = isAMatch && InnovatorConstants.COMMERCIAL_GEO_EXTENSION_MULTI_REGION_APPROVERS.contains(ruleMatrix.ApproverRole__c);
                } else {
                isAMatch = isAMatch && InnovatorConstants.COMMERCIAL_MULTI_REGION_APPROVERS.contains(ruleMatrix.ApproverRole__c);
                }
            } else if (project.ProjectPhase__c.equals(InnovatorConstants.DEPLOY_PHASE)) {
                if (project.ProjectClassification__c.equals(InnovatorConstants.FEARLESS_BET)) {
                    isAMatch = isAMatch && InnovatorConstants.PRODUCTION_MULTI_REGION_APPROVERS.contains(ruleMatrix.ApproverRole__c);
                } else if (project.ProjectClassification__c.equals(InnovatorConstants.GEO_EXTENSION)) {
                    isAMatch = isAMatch && InnovatorConstants.GEO_PRODUCTION_MULTI_REGION_APPROVERS.contains(ruleMatrix.ApproverRole__c);
                } else {
                    isAMatch = isAMatch && InnovatorConstants.RP_BE_PRODUCTION_MULTI_REGION_APPROVERS.contains(ruleMatrix.ApproverRole__c);
                }
            }

            String additionalHubs = project.AddAdditionalHubOrHubs__c;
            String additionalClusters = project.AddAdditionalClusterOrClusters__c;

            isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.Hub__c, additionalHubs, 'AddAdditionalHubOrHubs__c', isAMatch);
            isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.Cluster__c, additionalClusters, 'AddAdditionalClusterOrClusters__c', isAMatch);
            if (project.ProjectPhase__c != InnovatorConstants.DISCOVER_PHASE) {
                isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.LeadMarket__c, project.AddAdditionalMarketOrMarkets__c, 'AddAdditionalMarketOrMarkets__c', isAMatch);
            }
        } else {
            isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.Cluster__c, project.Cluster__c, 'Cluster__c', isAMatch);
            isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.Hub__c, project.Hub__c, 'Hub__c', isAMatch);
            if (project.ProjectPhase__c != InnovatorConstants.DISCOVER_PHASE) {
                isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.LeadMarket__c, project.LeadMarket__c, 'LeadMarket__c', isAMatch);
            }
        }
        isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.DistributionChannel__c, project.DC__c, 'DistributionChannel__c', isAMatch);
        if (ruleMatrix.TradeTypeExactMatch__c) {
            isAMatch = ApprovalMatrixService.tradeTypeExactMatch(project.TradeType__c, ruleMatrix.TradeType__c, isAMatch);
            if (MULTI_REGION_SUBMISSION.equals(project.ApprovalProcessStatus__c) && !isAutomaticApprovalProcess(project, false)) {
                isAMatch = false;
            }
        } else {
            isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.TradeType__c, project.TradeType__c, 'TradeType__c', isAMatch);
        }
        isAMatch = isAMatch && ruleMatrix.DecisionStep__c != null && ruleMatrix.DecisionStep__c.contains(InnovatorConstants.MAP_PHASES_TO_MILESTONES.get(project.ProjectPhase__c));
        return isAMatch;
    }

    public static Boolean matchProjectToRuleMatrixByLeadRegion(Project__c project, ApprovalMatrix__c ruleMatrix, String hubs, Boolean isOfflineMeeting) {
        Boolean isAMatch = true;
        if (ruleMatrix.ProjectClassification__c != null && !ruleMatrix.ProjectClassification__c.contains(ALL_PICKLIST_VALUE) && !ruleMatrix.ProjectClassification__c.contains(project.ProjectClassification__c)) {
            isAMatch = false;
        }

        isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.Category__c, project.Category__c, 'Category__c', isAMatch);
        isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.Brand__c, project.Brand__c, 'Brand__c', isAMatch);
        if (ruleMatrix.ExceptBrand__c != null) {
            Boolean isExceptMatch = RuleMatchingService.isRuleMatching(ruleMatrix.ExceptBrand__c, project.Brand__c) && project.Brand__c.split(';').size() == 1;
            isAMatch = isAMatch && !isExceptMatch;
        }
        isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.SubBrand__c, project.Subrand__c, 'SubBrand__c', isAMatch);

        if (isOfflineMeeting) {
            if (InnovatorConstants.DEFINE_PHASE.equals(project.ProjectPhase__c)) {
                isAMatch = isAMatch && InnovatorConstants.REGIONAL_PRESIDENT.equals(ruleMatrix.ApproverRole__c);
            } else if (InnovatorConstants.DESIGN_PHASE.equals(project.ProjectPhase__c)) {
                isAMatch = isAMatch && InnovatorConstants.BCV_LEAD_REGION_APPROVERS.contains(ruleMatrix.ApproverRole__c);
            }
        }

        isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.Hub__c, hubs, 'Hub__c', isAMatch);
        isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.Cluster__c, project.Cluster__c, 'Cluster__c', isAMatch);
        isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.LeadMarket__c, project.LeadMarket__c, 'LeadMarket__c', isAMatch);
        isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.DistributionChannel__c, project.DC__c, 'DistributionChannel__c', isAMatch);

        if (ruleMatrix.TradeTypeExactMatch__c) {
            isAMatch = ApprovalMatrixService.tradeTypeExactMatch(project.TradeType__c, ruleMatrix.TradeType__c, isAMatch);
        } else {
            isAMatch = RuleMatchingService.isRuleMatching(ruleMatrix.TradeType__c, project.TradeType__c, 'TradeType__c', isAMatch);
        }
        isAMatch = isAMatch && ruleMatrix.DecisionStep__c != null && ruleMatrix.DecisionStep__c.contains(InnovatorConstants.MAP_PHASES_TO_MILESTONES.get(project.ProjectPhase__c));
        return isAMatch;
    }

    private static String prepareAdditionalRegions(Project__c project) {
        List<String> additionalRegions = new List<String>();
        for (String region : project.AddAdditionalRegionOrRegions__c.split(';')) {
            if (project.Region__c != region) {
                additionalRegions.add(region);
            }
        }
        return String.join(additionalRegions, ';');
    }

    private static Boolean tradeTypeExactMatch(String projectTradeType, String ruleTradeType, Boolean isGlobalMatch) {
        Boolean matches = false;
        if (isGlobalMatch) {
            List<String> projectTradeTypeList = projectTradeType.split(';');
            List<String> approvalMatrixTradeTypeList = ruleTradeType.split(';');
            projectTradeTypeList.sort();
            approvalMatrixTradeTypeList.sort();
            if (projectTradeTypeList.equals(approvalMatrixTradeTypeList)) {
                matches = true;
            } else {
                approvalMatrixTradeTypeList.add(InnovatorConstants.BRAND_HOME_TRADE_TYPE);
                approvalMatrixTradeTypeList.sort();
                matches = projectTradeTypeList.equals(approvalMatrixTradeTypeList);
            }
        }
        return matches;
    }

    private static void setOC(Project__c project, List<ApprovalMatrix__c> ocRules) {
        List<ApprovalMatrix__c> matches = new List<ApprovalMatrix__c>();
        for (ApprovalMatrix__c ocRule : ocRules) {
            Boolean isAMatch = true;
            if (
                ocRule.ProjectClassification__c != null &&
                    !ocRule.ProjectClassification__c.contains(ALL_PICKLIST_VALUE) &&
                    !ocRule.ProjectClassification__c.contains(
                        project.ProjectClassification__c
                    )
            ) {
                isAMatch = false;
            }
            isAMatch = RuleMatchingService.isRuleMatching(
                ocRule.Category__c,
                project.Category__c,
                'Category__c',
                isAMatch
            );
            isAMatch = RuleMatchingService.isRuleMatching(
                ocRule.Brand__c,
                project.Brand__c,
                'Brand__c',
                isAMatch
            );
            isAMatch = RuleMatchingService.isRuleMatching(
                ocRule.SubBrand__c,
                project.Subrand__c,
                'SubBrand__c',
                isAMatch
            );
            isAMatch = RuleMatchingService.isRuleMatching(
                ocRule.Cluster__c,
                project.Cluster__c,
                'Cluster__c',
                isAMatch
            );
            isAMatch = RuleMatchingService.isRuleMatching(
                ocRule.Hub__c,
                project.Hub__c,
                'Hub__c',
                isAMatch
            );
            isAMatch = RuleMatchingService.isRuleMatching(
                ocRule.DistributionChannel__c,
                project.DC__c,
                'DistributionChannel__c',
                isAMatch
            );
            if (isAMatch) {
                matches.add(ocRule);
            }
        }
        if (matches.size() > 1 || matches.isEmpty()) {
            project.OC__c = OC_TBD;
        } else {
            project.OC__c = matches.get(0).OC__c;
        }
        update project;
    }

    public class TooManySelectedException extends Exception {
    }

    public class NoApproversException extends Exception {
    }

    private static Boolean isAutomaticApprovalProcess(Project__c project, Boolean isSimplePromotionalPack) {
        return InnovatorConstants.AUTOMATIC_APPROVAL_PHASES.contains(project.ProjectPhase__c) || (project.ProjectPhase__c == 'Develop' && project.ProjectClassification__c != 'Fearless Bet' && project.ProjectClassification__c != 'Brand Energizer' && project.ProjectClassification__c != 'Business Enabler'  && project.ProjectClassification__c != 'Geographical Extension') ;
    }

    //function only used the "lose time" in the code.
    private static void sleep() {
        for (Integer i = 0; i < 10000; i++) {
            Integer a = 0;
            a++;
        }
    }

    /**
    * @description to fetch user detail, if approval step was reassigned before asking for rework
    */
    public static Map<Id, Id> getReassignedUsersDetail(Id projectId) {
        List<Id> reassignedProcessInstanceIds = getReassignedProcessInstanceIds(
            projectId
        );
        Map<Id, Id> reassignedUser = new Map<Id, Id>();
        List<ProcessInstanceStep> processInstanceSteps = ApprovalMatrixRepository.getProcessInstanceSteps(
            projectId,
            reassignedProcessInstanceIds
        );
        for (ProcessInstanceStep step : processInstanceSteps) {
            if (step.StepStatus == InnovatorConstants.REASSIGNED_STATUS) {
                //if there is multi-level reassignment then only keep the latest one
                if (reassignedUser.get(step.OriginalActorId) != null) {
                    reassignedUser.remove(step.OriginalActorId);
                }
                reassignedUser.put(step.OriginalActorId, step.ActorId);
            }
        }
        return reassignedUser;
    }

    public static void replaceReassignedUser(Set<Id> approverIds, Id projectId, Set<Id> delegatedUserIds) {
        Map<Id, Id> reassignedUser = getReassignedUsersDetail(projectId);
        if (!reassignedUser.isEmpty()) {
            for (Id originalActorId : reassignedUser.keySet()) {
                if (approverIds.contains(originalActorId) && !delegatedUserIds.contains(reassignedUser.get(originalActorId))) {
                    approverIds.remove(originalActorId);
                    approverIds.add(reassignedUser.get(originalActorId));
                }
            }
        }
    }

    /**
    * @description to fetch all ProcessInstances id untill we find any approved or rejected process
    */
    public static List<Id> getReassignedProcessInstanceIds(Id projectId) {
        List<Id> reassignedProcessInstanceIds = new List<Id>();
        List<ProcessInstance> processInstances = ApprovalMatrixRepository.getProjectRelatedProcessInstances(
            projectId
        );
        //fetch Process Instance id untill a approved/reject process found
        for (ProcessInstance processInstance : processInstances) {
            if (
                processInstance.status == InnovatorConstants.APPROVED_STATUS ||
                    processInstance.status == InnovatorConstants.REJECTED_STATUS
            ) {
                break;
            } else {
                reassignedProcessInstanceIds.add(processInstance.id);
            }
        }
        return reassignedProcessInstanceIds;
    }

    /**
     * @description removeApproversFromPreviousStepsInCurrentApprovalProcess this function removes any approvers in the multi-region approval step,
     * that have already approved in the previous steps in the current Approval process, since we don't want them to have to approve again.
     * @return the list original list of approvers (matrixApprovers) minus the ones filtered due to having already approved in a previous step.
     */
    public static Map<Id, Map<String, String>> removeApproversFromPreviousStepsInCurrentApprovalProcess(Project__c project, Map<Id, Map<String, String>> matrixApprovers) {
        Map<Id, Map<String, String>> filteredApprovers = new Map<Id, Map<String, String>>();
        ProcessInstance processInstance = ApprovalHistoryRepository.getLastApprovalProcess(project.Id);
        List<Id> firstStepApprovers = new List<Id>();

        //get the users from the previous step that already approved
        List<ProcessInstanceStep> stepsApproved = ApprovalMatrixRepository.getProcessInstanceStepsFromProcessInstance(processInstance.Id);
        for (ProcessInstanceStep processInstanceStep : stepsApproved) {
            firstStepApprovers.add(processInstanceStep.OriginalActorId);
        }

        //get the user from the previous step whose approval triggers this transaction,
        //since it is not yet removed from ProcessInstanceWorkItem and added in the ProcessInstanceSteps record
        List<ProcessInstanceWorkItem> stepsPendingApproval = ApprovalMatrixRepository.getProcessInstanceWorkItemsFromProcessInstance(processInstance.Id);
        if (stepsPendingApproval != null && stepsPendingApproval.size() > 0) {
            for (ProcessInstanceWorkItem step : stepsPendingApproval) {
                firstStepApprovers.add(step.OriginalActorId);
            }
        }
        for (Id approverId : matrixApprovers.keySet()) {
            if (!firstStepApprovers.contains(approverId)) {
                filteredApprovers.put(approverId, matrixApprovers.get(approverId));
            }
        }

        return filteredApprovers;
    }
}