@RestResource(urlMapping='/reassign/*')
global with sharing class RestReassignController {

    @HttpPut
    global static void updateResassignComment(String projectId, String approvalHistoryData) {
        Project__c projectToUpdate = new Project__c();
        projectToUpdate.Id = projectId;
        projectToUpdate.ApprovalReassignmentComment__c = approvalHistoryData;
        update projectToUpdate;
        ApprovalHistory.publishPlatformEvent();
    }
}