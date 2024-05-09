public with sharing class PendingApprovalReportReassignController {
    private static final String STANDARD_USER_ICON = 'standard:user';
    private static final String USER_SOBJECT  = 'User';

    @AuraEnabled
    public static List<LookupSearchResult> getAllPendingApprovers() {
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        Set<Id> actorIds = new Set<Id>();
        for (ProcessInstance processInstance: ApprovalStatusReportRepository.getAllPendingApproversWithoutElapsedTime()) {
            for (ProcessInstanceHistory processInstanceHistory : processInstance.StepsAndWorkItems) {
                if (!actorIds.contains(processInstanceHistory.Actor.Id)) {
                    results.add(
                        new LookupSearchResult(
                            processInstanceHistory.Actor.Id,
                            USER_SOBJECT,
                            STANDARD_USER_ICON,
                            processInstanceHistory.Actor.Name,
                            processInstanceHistory.Actor.Name,
                            processInstanceHistory.Actor.Name
                        )
                    );
                    actorIds.add(processInstanceHistory.Actor.Id);
                }
            }    
        }
        return results;
    }

    @AuraEnabled
    public static List<LookupSearchResult> getPendingApproversByName(String searchTerm) {
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        Set<Id> actorIds = new Set<Id>();
        searchTerm += '%';
        for (ProcessInstance processInstance: ApprovalStatusReportRepository.getPendingApproversByNameWithoutElapsedTime(searchTerm)) {
            for (ProcessInstanceHistory processInstanceHistory : processInstance.StepsAndWorkItems) {
                if (!actorIds.contains(processInstanceHistory.Actor.Id)) {
                    results.add(
                        new LookupSearchResult(
                            processInstanceHistory.Actor.Id,
                            USER_SOBJECT,
                            STANDARD_USER_ICON,
                            processInstanceHistory.Actor.Name,
                            processInstanceHistory.Actor.Name,
                            processInstanceHistory.Actor.Name
                        )
                    );
                    actorIds.add(processInstanceHistory.Actor.Id);
                }
            }    
        }
        return results;
    }

    @AuraEnabled
    public static List<ItemsToApproveController.ItemToApprove> getItemsToApprove(Id userId) {
        List<ItemsToApproveController.ItemToApprove> results = new List<ItemsToApproveController.ItemToApprove>();
        List<ProcessInstanceWorkItem> processInstanceWorkItems = ItemsToApproveRepository.getSelectedUserPendingApprovals(userId);
        List<Id> projectIds = new List<Id>();
        for (ProcessInstanceWorkItem instanceWorkItem : processInstanceWorkItems) {
            projectIds.add(instanceWorkItem.ProcessInstance.TargetObjectId);
        }

        Map<Id, Project__c> projects = ItemsToApproveRepository.getMapOfActiveProjects(projectIds);
        for (ProcessInstanceWorkItem instanceWorkItem : processInstanceWorkItems) {
            if (projects.containsKey(instanceWorkItem.ProcessInstance.TargetObjectId)) {
                Project__c project = projects.get(instanceWorkItem.ProcessInstance.TargetObjectId);
                ItemsToApproveController.ItemToApprove itemToApprove = new ItemsToApproveController.ItemToApprove(instanceWorkItem.Id, instanceWorkItem.ProcessInstance.TargetObject.Id, instanceWorkItem.ProcessInstance.TargetObject.Name, instanceWorkItem.ProcessInstance.SubmittedBy.Name, instanceWorkItem.ProcessInstance.CreatedDate, instanceWorkItem.ProcessInstance.TargetObjectId, instanceWorkItem.ProcessInstance.SubmittedById);
                itemToApprove.decisionStepStatus = project.SubmissionStatus__c;
                results.add(itemToApprove);
            }
        }
        return results;
    }


}