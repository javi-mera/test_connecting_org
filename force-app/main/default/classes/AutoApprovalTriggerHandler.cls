public with sharing class AutoApprovalTriggerHandler {
    private static final String MATRIX_RT = 'Approval_Matrix';

    public static void afterInsert(List<AutoApproval__e> newRecords) {
        Id matrixId = Schema.SObjectType.ApprovalMatrix__c.getRecordTypeInfosByDeveloperName().get(MATRIX_RT).getRecordTypeId();
        for (AutoApproval__e autoApproval : newRecords) {
            final ProcessInstance processInstance = ProcessInstanceRepository.getProcessInstanceByTargetObjectId(autoApproval.Project__c);
            if (processInstance != null) {
                Map<Id, ProcessInstanceWorkitem> processInstanceWorkitemMap = new Map<Id, ProcessInstanceWorkitem>(ProcessInstanceRepository.getProcessInstanceWorkitemsByProcessInstance(processInstance.Id));
                final List<Id> newWorkItemIds = new List<Id>(processInstanceWorkitemMap.keySet());
                final Project__c project = ProjectRepository.getProject(autoApproval.Project__c);
                final String nextPhase = ApprovalMatrixService.getNextPhaseName(project);
                List<ApprovalMatrix__c> rules = ApprovalMatrixRepository.loadMatrixByType(project.ProjectClassification__c, project.Category__c, project.Brand__c, project.Subrand__c, project.Hub__c, project.Cluster__c, project.LeadMarket__c, project.DC__c, project.TradeType__c, matrixId, '1');
                Set<Id> selectedApproverIds = ApprovalMatrixService.getIdsForNotificationUsers(project, rules);
                selectedApproverIds.add(project.ProjectManager__c);
                selectedApproverIds.add(project.ProjectLeader__c);
                List<ProcessInstanceStep> processInstanceSteps = ApprovalHistoryRepository.getProcessInstanceSteps(processInstance.Id);
                EmailManager.sendEmailForAutoApprovalAndGetListOfRecipients(project, selectedApproverIds, processInstanceSteps[0].Comments, nextPhase, true);
                String processInstanceId;
                for (Id approvalId : newWorkItemIds) {
                    Approval.ProcessWorkitemRequest processWorkItemRequest = new Approval.ProcessWorkitemRequest();
                    processWorkItemRequest.setComments('Project progressed to ' + nextPhase + ' phase. \n Notification sent to: ' + processInstanceWorkitemMap.get(approvalId).OriginalActor.Name);
                    processWorkItemRequest.setAction('Approve');
                    processWorkItemRequest.setWorkitemId(approvalId);
                    Approval.ProcessResult res = Approval.process(processWorkItemRequest);
                    processInstanceId = res.getInstanceId();
                    Boolean needToUpdate = ApprovalHistory.saveStepName(project, processInstanceId, newWorkItemIds, true, false, null);
                }
            }
        }
    }
}