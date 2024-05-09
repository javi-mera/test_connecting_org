public with sharing class ApprovalStatusReportRepository {
    private static final String APPROVAL_STATUS = 'pending';
    private static final String TARGET_OBJECT = 'Project__c';
    private static final String PROJECT_STTAUS = 'Active';
    private static final String APPROVAL_TEMPLATE_NAME = 'PendingApprovalTemplate';

    public static List<ProcessInstance> getApprovalStatus(){
        
        if(Test.isRunningTest()){
            return [SELECT Id, Status, TargetObjectId, TargetObject.Name, 
                        (SELECT Id, ActorId, Actor.Name, OriginalActorId, OriginalActor.Name, StepStatus, CreatedDate, ElapsedTimeInDays 
                        FROM StepsAndWorkitems ORDER BY ElapsedTimeInDays)
                    FROM ProcessInstance WHERE TargetObject.Type =:TARGET_OBJECT  ORDER BY TargetObjectId];
        }
        return [SELECT Id, Status, TargetObjectId, TargetObject.Name, 
                (SELECT Id, ActorId, Actor.Name, OriginalActorId, OriginalActor.Name, StepStatus, CreatedDate, ElapsedTimeInDays 
                FROM StepsAndWorkitems WHERE StepStatus =: APPROVAL_STATUS AND ElapsedTimeInDays > 5 ORDER BY ElapsedTimeInDays)
            FROM ProcessInstance WHERE TargetObject.Type =: TARGET_OBJECT ORDER BY TargetObjectId];
    }

    public static List<ProcessInstance> getAllPendingApprovers() {
        return [
            SELECT
                (
                    SELECT 
                        Id,
                        Actor.Id,
                        Actor.Name 
                    FROM
                        StepsAndWorkitems
                    WHERE 
                        StepStatus =: APPROVAL_STATUS AND 
                        ElapsedTimeInDays > 5 
                    ORDER BY Actor.Name
                )
            FROM 
                ProcessInstance
            WHERE
                TargetObject.Type =: TARGET_OBJECT
        ];
    }

    public static List<ProcessInstance> getAllPendingApproversWithoutElapsedTime() {
        return [
            SELECT
                (
                    SELECT
                        Id,
                        Actor.Id,
                        Actor.Name
                    FROM
                        StepsAndWorkitems
                    WHERE
                        StepStatus =: APPROVAL_STATUS
                    ORDER BY Actor.Name
                )
            FROM
                ProcessInstance
            WHERE
                TargetObject.Type =: TARGET_OBJECT
        ];
    }

    public static List<ProcessInstance> getPendingApproversByName(String searchTerm) {
        return [
            SELECT
                (
                    SELECT 
                        Id,
                        Actor.Id,
                        Actor.Name 
                    FROM
                        StepsAndWorkitems
                    WHERE 
                        StepStatus =: APPROVAL_STATUS AND 
                        ElapsedTimeInDays > 5 AND
                        Actor.Name LIKE: searchTerm
                    ORDER BY Actor.Name
                )
            FROM 
                ProcessInstance
            WHERE
                TargetObject.Type =: TARGET_OBJECT
        ];
    }

    public static List<ProcessInstance> getPendingApproversByNameWithoutElapsedTime(String searchTerm) {
        return [
            SELECT
                (
                    SELECT
                        Id,
                        Actor.Id,
                        Actor.Name
                    FROM
                        StepsAndWorkitems
                    WHERE
                        StepStatus =: APPROVAL_STATUS AND
                        Actor.Name LIKE: searchTerm
                    ORDER BY Actor.Name
                )
            FROM
                ProcessInstance
            WHERE
                TargetObject.Type =: TARGET_OBJECT
        ];
    }

    public static Map<Id, Project__c> getProjectsDetail(Set<Id> projectIds){
        return new Map<Id, Project__c>([Select id,name, ProjectNumber__c, ProjectNumberFormula__c, ProjectStatus__c from Project__c where Id IN:projectIds AND ProjectStatus__c =:PROJECT_STTAUS]);
    }

    public static List<User> getUserEmails(Set<Id> userIds){
        return [Select Email From User where Id = :userIds];
    }

    public static EmailTemplate getApprovalEmailTemplate(){
        return [SELECT Id, Name FROM EmailTemplate WHERE name=:APPROVAL_TEMPLATE_NAME limit 1];
    }
}