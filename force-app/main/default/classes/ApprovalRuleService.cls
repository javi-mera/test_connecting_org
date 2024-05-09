public with sharing class ApprovalRuleService {

    public static Map<Id, List<ApprovalMatrix__c>> prepareApproverChangeMap() {
        Map<Id, List<ApprovalMatrix__c>> approverChangeMap = new Map<Id, List<ApprovalMatrix__c>>();
        for (ApprovalMatrix__c approvalMatrix : (List<ApprovalMatrix__c>) Trigger.new) {
            ApprovalMatrix__c oldApprovalMatrix = (ApprovalMatrix__c) Trigger.oldMap.get(approvalMatrix.Id);
            if (oldApprovalMatrix.Approver__c != approvalMatrix.Approver__c) {
                if (!approverChangeMap.containsKey(oldApprovalMatrix.Approver__c)) {
                    approverChangeMap.put(oldApprovalMatrix.Approver__c, new List<ApprovalMatrix__c>{ approvalMatrix });
                } else {
                    List<ApprovalMatrix__c> approvalMatrixes = approverChangeMap.get(oldApprovalMatrix.Approver__c);
                    approvalMatrixes.add(approvalMatrix);
                }
            }
        }
        return approverChangeMap;
    }
    
    public static List<ProcessInstanceWorkitem> prepareProcessWorkItemsToUpdate(List<ProcessInstance> pendingApprovals, Map<Id, List<ApprovalMatrix__c>> approverToApprovalMatrix, Map<Id, Project__c> projects, Set<Project__c> projectsToUpdate) {
        Id matrixId = Schema.SObjectType.ApprovalMatrix__c.getRecordTypeInfosByDeveloperName().get(ApprovalMatrixService.MATRIX_RT).getRecordTypeId();
        List<ProcessInstanceWorkitem> allProcessWorkItems = new List<ProcessInstanceWorkitem>();
        if (pendingApprovals.size() > 0) {
            for (ProcessInstance instance : pendingApprovals) {
                Project__c project = (Project__c) projects.get(instance.TargetObjectId);
                String approvalStep = project.ApprovalProcessStatus__c == 'Submitted' ? '1' : '2';
                List<ProcessInstanceWorkitem> processWorkItems = instance.Workitems;
                if (instance.Workitems.size() > 0) {
                    Set<Id> newApproverIds = new Set<Id>();
                    for (ProcessInstanceWorkitem processInstanceWorkItem : processWorkItems) {
                        List<ApprovalMatrix__c> approvalMatrixes = approverToApprovalMatrix.get(processInstanceWorkItem.ActorId);
                        newApproverIds = configApprovalMatrixes(approvalMatrixes, project, approvalStep, matrixId, projectsToUpdate, processInstanceWorkItem, allProcessWorkItems);
                    }
                    if (newApproverIds.size() > 0) {
                        EmailManager.sendEmailForApprovers(project, false, newApproverIds, '', false, true);
                    }
                }
            }
        }
        return allProcessWorkItems;
    }

    public static Set<Id> configApprovalMatrixes(List<ApprovalMatrix__c> approvalMatrixes, Project__c project, String approvalStep, Id matrixId, Set<Project__c> projectsToUpdate, ProcessInstanceWorkitem processInstanceWorkItem, List<ProcessInstanceWorkitem> allProcessWorkItems) {
        Set<Id> newApproverIds = new Set<Id>();
        if (approvalMatrixes != null) {
            for (ApprovalMatrix__c approvalMatrix : approvalMatrixes) {
                List<String> matchProjectClassifications = approvalMatrix.ProjectClassification__c.split(';');
                if (!matchProjectClassifications.contains(project.ProjectClassification__c)) {
                    break;
                }
                if (approvalMatrix.ProjectClassificationSubtype__c != null) {
                    List<String> matchProjectClassificationSubtypes = approvalMatrix.ProjectClassificationSubtype__c.split(';');
                    if (!matchProjectClassificationSubtypes.isEmpty() && !matchProjectClassificationSubtypes.contains( project.ProjectClassificationSubtype__c)) {
                        break;
                    }
                }
                Boolean isCategoryMatching = RuleMatchingService.isRuleMatching(approvalMatrix.Category__c, project.Category__c);
                if (!isCategoryMatching) {
                    break;
                }
                Boolean isBrandMatching = RuleMatchingService.isRuleMatching(approvalMatrix.Brand__c, project.Brand__c);
                if (!isBrandMatching) {
                    break;
                }
                Boolean isSubBrandMatching = RuleMatchingService.isRuleMatching(approvalMatrix.SubBrand__c, project.Subrand__c);
                if (!isSubBrandMatching) {
                    break;
                }
                Boolean isHubMatching = RuleMatchingService.isRuleMatching(approvalMatrix.Hub__c, project.Hub__c);
                if (!isHubMatching) {
                    break;
                }
                Boolean isClusterMatching = RuleMatchingService.isRuleMatching(approvalMatrix.Cluster__c, project.Cluster__c);
                if (!isClusterMatching) {
                    break;
                }
                Boolean isLeadMarketMatching = RuleMatchingService.isRuleMatching(approvalMatrix.LeadMarket__c, project.LeadMarket__c);
                if (!isLeadMarketMatching) {
                    break;
                }
                if (!approvalMatrix.TradeTypeExactMatch__c) {
                    Boolean isTradeTypeMatching = RuleMatchingService.isRuleMatching(approvalMatrix.TradeType__c, project.TradeType__c);
                    if (!isTradeTypeMatching) {
                        break;
                    }
                } else {
                    if (approvalMatrix.TradeType__c != project.TradeType__c) {
                        break;
                    }
                }
                
                Boolean isDistributionChannelMatching = RuleMatchingService.isRuleMatching(approvalMatrix.DistributionChannel__c, project.DC__c);
                if (!isDistributionChannelMatching) {
                    break;
                }
                List<ApprovalMatrix__c> approvalMatrixList = ApprovalMatrixRepository.loadMatrixByType(project.ProjectClassification__c, project.Category__c, project.Brand__c, project.Subrand__c, project.Hub__c, project.Cluster__c, project.LeadMarket__c, project.DC__c, project.TradeType__c, matrixId, approvalStep);
                Map<Id, User> usersMap = ApprovalProcessRepository.getAllActiveUsers();
                Map<Id, Map<String, String>> currentProjectApproverIds = ApprovalMatrixService.assignMatrixApprovers(project, approvalMatrixList, new List<User>(), usersMap);
                if (currentProjectApproverIds.containsKey(approvalMatrix.Approver__c)) {
                    if (project.AdditionalApprover1__c == null) {
                        project.AdditionalApprover1__c = approvalMatrix.Approver__c;
                    }
                    if (project.AdditionalApprover2__c == null || project.AdditionalApprover1__c == project.AdditionalApprover2__c) {
                        project.AdditionalApprover2__c = approvalMatrix.Approver__c;
                    }
                    if (project.AdditionalApprover3__c == null || project.AdditionalApprover2__c == project.AdditionalApprover3__c) {
                        project.AdditionalApprover3__c = approvalMatrix.Approver__c;
                    }
                    if (project.AdditionalApprover4__c == null || project.AdditionalApprover3__c == project.AdditionalApprover4__c) {
                        project.AdditionalApprover4__c = approvalMatrix.Approver__c;
                    }
                    if (project.AdditionalApprover5__c == null || project.AdditionalApprover4__c == project.AdditionalApprover5__c) {
                        project.AdditionalApprover5__c = approvalMatrix.Approver__c;
                    }
                    if (project.AdditionalApprover6__c == null || project.AdditionalApprover5__c == project.AdditionalApprover6__c) {
                        project.AdditionalApprover6__c = approvalMatrix.Approver__c;
                    }
                    if (project.AdditionalApprover7__c == null || project.AdditionalApprover6__c == project.AdditionalApprover7__c) {
                        project.AdditionalApprover7__c = approvalMatrix.Approver__c;
                    }
                    if (project.AdditionalApprover8__c == null || project.AdditionalApprover7__c == project.AdditionalApprover8__c) {
                        project.AdditionalApprover8__c = approvalMatrix.Approver__c;
                    }
                    if (project.AdditionalApprover9__c == null || project.AdditionalApprover8__c == project.AdditionalApprover9__c) {
                        project.AdditionalApprover9__c = approvalMatrix.Approver__c;
                    }
                    project.AvoidSnapshotCreation__c = true;
                    projectsToUpdate.add(project);
                } else if (processInstanceWorkItem != null && allProcessWorkItems != null) {
                    processInstanceWorkItem.ActorId = approvalMatrix.Approver__c;
                    allProcessWorkItems.add(processInstanceWorkItem);
                    newApproverIds.add(processInstanceWorkItem.ActorId);
                }
            }
        }
        return newApproverIds;
    }
}