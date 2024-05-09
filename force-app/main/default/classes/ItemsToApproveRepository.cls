public with sharing class ItemsToApproveRepository {
    
    public static List<ProcessInstanceWorkItem> getCurrentUsersPendingApprovals () {
        return [
            SELECT
                Id,
                ProcessInstance.TargetObjectId,
                ProcessInstance.TargetObject.Name,
                ProcessInstance.SubmittedById,
                ProcessInstance.SubmittedBy.Name,
                ProcessInstance.CreatedDate
            FROM
                ProcessInstanceWorkItem
            WHERE
                ActorId =: UserInfo.getUserId() AND  ProcessInstance.Status = 'Pending'
        ];
    }

    public static List<ProcessInstanceWorkItem> getSelectedUserPendingApprovals (Id userId) {
        return [
            SELECT
                Id,
                ProcessInstance.TargetObjectId,
                ProcessInstance.TargetObject.Name,
                ProcessInstance.SubmittedById,
                ProcessInstance.SubmittedBy.Name,
                ProcessInstance.CreatedDate
            FROM
                ProcessInstanceWorkItem
            WHERE
                ActorId =: userId AND  ProcessInstance.Status = 'Pending'
        ];
    }

    public static Map<Id, Project__c> getMapOfActiveProjects(List<Id> projectIds) {
        return new Map<Id, Project__c>([SELECT Id, SubmissionStatus__c FROM Project__c WHERE Id IN: projectIds AND ProjectStatus__c = 'Active']);
    } 
    

}