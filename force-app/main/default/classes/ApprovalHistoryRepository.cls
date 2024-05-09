public with sharing class ApprovalHistoryRepository {
    
    public static final String REASSIGNED_STEP_STATUS = 'Reassigned';
    
    public static List<ProcessInstance> getApprovalHistoryRecords(String id){
        return [SELECT Id, Status, TargetObjectId, TargetObject.Name, 
                    (SELECT Id, ActorId, Actor.Name, ProcessNodeId, OriginalActorId, OriginalActor.Name, StepStatus, CreatedDate,Comments, ElapsedTimeInDays, ProcessInstanceId, ProcessNode.Name
                        FROM StepsAndWorkitems ORDER BY createdDate DESC)
                FROM ProcessInstance WHERE TargetObjectId =:id ORDER BY createdDate DESC];
    }

    public static ProcessInstance getLastApprovalProcess(Id projectId) {
        return [SELECT Id, CreatedDate, TargetObject.Name FROM ProcessInstance WHERE TargetObjectId =: projectId ORDER BY CreatedDate DESC LIMIT 1];
    } 

    public static List<ProcessInstanceStep> getProcessInstanceSteps(Id processInstanceId) {
        return [SELECT Id, CreatedDate, ProcessInstanceId, Actor.Name, ProcessInstance.TargetObjectId, Comments FROM ProcessInstanceStep WHERE ProcessInstanceId =: processInstanceId ORDER BY CreatedDate ASC LIMIT 1];
    }

    public static List<ProcessInstanceWorkitem> getProcessWorkItems(Id recordId) {
        return [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstanceId =: recordId];
    }

    public static Map<Id, ProcessInstanceStep> getProcessSteps(Id recordId) {
        Map<Id, ProcessInstanceStep> stepMap = new Map<Id, ProcessInstanceStep>([SELECT Id FROM ProcessInstanceStep where ProcessInstanceId =:recordId]);
        return stepMap;
    }

    public static Project__c getProject(Id recordId) {
        return [SELECT id, approvalStepName__c, ApprovalHistoricalData__c, ApprovalReassignmentComment__c, ProjectLeader__c, ProjectLeader__r.name, ProjectManager__c, ProjectManager__r.name	 from project__c where id = :recordId limit 1];
    }
    public static List<User> getUsersByEmail(Set<String> emails){
        return [SELECT Id, Name, Email, IsActive FROM User WHERE Email IN :emails AND IsActive = true];
    }

    public static ProcessInstanceStep getRecentReassignProcessInstanceStep(Id pid){
        return [SELECT Id, ProcessInstanceId, StepStatus, createdDate, ActorId, OriginalActorId, Comments FROM ProcessInstanceStep where ProcessInstanceId=:pid
            AND StepStatus =:REASSIGNED_STEP_STATUS  Order By createdDate DESC Limit 1
        ];
    }
}