public with sharing class ProcessInstanceRepository {

    public static List<ProcessInstance> getProcessInstances(Set<Id> approverIds, Set<Id> projectIds) {
        return [
            SELECT Id, TargetObjectId, (SELECT  Id, ActorId, OriginalActorId FROM Workitems WHERE ActorId IN: approverIds)
            FROM  ProcessInstance 
            WHERE TargetObjectId IN: projectIds
        ];
    }

    public static ProcessInstance getProcessInstanceByTargetObjectId(Id targetObjectId) {
        return [
            SELECT Id, TargetObjectId, CreatedDate 
            FROM ProcessInstance 
            WHERE TargetObjectId =: targetObjectId AND (Status = 'Pending' OR Status = 'Started')
            LIMIT 1
        ];
    }

    public static List<ProcessInstanceWorkitem> getProcessInstanceWorkitemsByProcessInstance(Id processInstanceId) {
        return [
            SELECT Id, OriginalActorId, OriginalActor.Name 
            FROM ProcessInstanceWorkitem 
            WHERE ProcessInstanceId =: processInstanceId
        ];
    }

}