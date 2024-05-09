public with sharing class ApprovalRuleTriggerHandler {

    public static void handleIsBeforeUpdate() {
        Map<Id, List<ApprovalMatrix__c>> approverToApprovalMatrix = ApprovalRuleService.prepareApproverChangeMap();
        Set<String> decisionSteps = new Set<String>();
        Set<String> projectClassifications = new Set<String>();
        for (Id approver : approverToApprovalMatrix.keySet()) {
            List<ApprovalMatrix__c> approvalMatrixes = approverToApprovalMatrix.get(approver);
            for (ApprovalMatrix__c approvalMatrix : approvalMatrixes) {
                decisionSteps.addAll(approvalMatrix.DecisionStep__c.split(';'));
                projectClassifications.addAll(approvalMatrix.ProjectClassification__c.split(';'));
            }
        }
        Map<Id, Project__c> projects = new Map<Id, Project__c>(ProjectRepository.getProjectForApprovalRuleMatching(decisionSteps, projectClassifications));
        List<ProcessInstance> pendingApprovals = ProcessInstanceRepository.getProcessInstances(approverToApprovalMatrix.keySet(), projects.keySet());
        Set<Project__c> projectsToUpdate = new Set<Project__c>();
        List<ProcessInstanceWorkitem> allProcessWorkItems =  ApprovalRuleService.prepareProcessWorkItemsToUpdate(pendingApprovals, approverToApprovalMatrix, projects, projectsToUpdate);
        if (!projectsToUpdate.isEmpty()) {
            update new List<Project__c>(projectsToUpdate);
        }
        if (!allProcessWorkItems.isEmpty()) {
            update allProcessWorkItems;
        }
        
    }

}