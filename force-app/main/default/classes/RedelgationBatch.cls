public with sharing class RedelgationBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext batchableContext) {
        return Database.getQueryLocator('SELECT Id, DelegatedApproverId, Start__c, End__c, PendingProjectsToReassign__c FROM User WHERE End__c <= TODAY');
    }

    public void execute(Database.BatchableContext batchableContext, List<User> users) {
        Map<Id, ProcessInstanceWorkitem> reassignments = new Map<Id, ProcessInstanceWorkitem>();
        Map<Id, ProcessInstanceWorkitem> approvalsFromUserRecord = new Map<Id, ProcessInstanceWorkitem>();
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        List<Id> projectIds = new List<Id>();
        List<Id> projectIdsWithApprovals = new List<Id>();
        Map<String, Set<String>> approvalIdsByUsersIds = new Map<String, Set<String>>();
        Set<String> approvalIdsToFind = new Set<String>();
        List<Map<String, String>> projectsToReturn = new List<Map<String, String>>();
        for (User user : users) {
            Map<String, Set<String>> projectIdToApprovals = user.PendingProjectsToReassign__c != null ? (Map<String, Set<String>>)(JSON.deserialize(user.PendingProjectsToReassign__c, Map<String, Set<String>>.class)) : new Map<String, Set<String>>();
            if (!projectIdToApprovals.isEmpty()) {
                Set<String> approvalIds = new Set<String>();
                for (String projectId : projectIdToApprovals.keySet()) {
                    if (projectIdToApprovals.get(projectId).isEmpty()) {
                    projectIds.add(projectId);
                    projectsToReturn.add(new Map<String, String> {
                        'projectId' => projectId,
                        'oldUser' => user.DelegatedApproverId,
                        'newUser' => user.Id
                    });
                    } else {
                        for (Id itemId : projectIdToApprovals.get(projectId)) {
                            approvalIds.add(itemId);
                            approvalIdsToFind.add(itemId);
                            projectIdsWithApprovals.add(projectId);
                        }
                    }
                }
                if (!approvalIds.isEmpty()) {
                    approvalIdsByUsersIds.put(user.Id, approvalIds);
                }
            }

                user.DelegatedApproverId = null;
                user.Start__c = null;
                user.End__c = null;
                user.PendingProjectsToReassign__c = null;
                user.DelegatedApproverName__c = null;
        }

        if (!approvalIdsToFind.isEmpty()) {
            approvalsFromUserRecord = CustomApprovalProcessControlsRepository.getApprovalsMap(approvalIdsToFind);
            Map<Id, Project__c> projectsWithApprovalsMap = new Map<Id, Project__c>(ProjectRepository.getProjectsByIds(projectIdsWithApprovals));

            if (!approvalsFromUserRecord.isEmpty()) {
                for (Id userId : approvalIdsByUsersIds.keySet()) {
                    for (Id itemId : approvalIdsByUsersIds.get(userId)) {
                        if (approvalsFromUserRecord.containsKey(itemId)) {
                            approvalsFromUserRecord.get(itemId).ActorId = userId;
                            reassignments.put(itemId, approvalsFromUserRecord.get(itemId));

                            if (projectsWithApprovalsMap.containsKey(approvalsFromUserRecord.get(itemId).ProcessInstance.TargetObjectId)) {
                            emails.add(EmailManager.sendEmailForApprovers(projectsWithApprovalsMap.get(approvalsFromUserRecord.get(itemId).ProcessInstance.TargetObjectId), false, new Set<Id> { userId }, '', true, false));
                            }
                        }
                    }
            }
            }
        }

        if (!projectIds.isEmpty()) {
        Map<Id, Project__c> projectsMap = new Map<Id, Project__c>(ProjectRepository.getProjectsByIds(projectIds));
        for (Map<String, String> projectMap : projectsToReturn) {
                List<ProcessInstanceWorkitem> processInstanceWorkItems = CustomApprovalProcessControlsService.reassignWithReturn(projectsMap.get(projectMap.get('projectId')), (Id)projectMap.get('newUser'), (Id)projectMap.get('oldUser'), '', emails, true);
                if (!processInstanceWorkItems.isEmpty()) {
                    for (ProcessInstanceWorkitem item : processInstanceWorkItems) {
                        if (!reassignments.containsKey(item.Id)) {
                            reassignments.put(item.Id, item);
                        }
            }
        }
            }
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
        update users;
        update reassignments.values();
    }

    public void finish(Database.BatchableContext batchableContext) {}
}