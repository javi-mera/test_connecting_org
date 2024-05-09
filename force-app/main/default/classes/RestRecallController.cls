@RestResource(urlMapping='/approvals/*')
global with sharing class RestRecallController {

    @HttpPost
    global static void recall(String projectId, String comment) {
        String recordId = projectId;
        ProcessInstanceWorkitem[] processInstanceWorkItems = CustomApprovalProcessControlsRepository.getPendingApprovalsForProject(recordId);
        if(processInstanceWorkItems.size() > 0){
            Approval.ProcessWorkItemRequest processWorkItemRequest = new Approval.ProcessWorkItemRequest();
            processWorkItemRequest.setAction('Removed');
            processWorkItemRequest.setWorkItemId(processInstanceWorkItems[0].Id);
            processWorkItemRequest.setComments(comment);
            Approval.ProcessResult result = Approval.process(processWorkItemRequest);
            if (result.isSuccess()) {
                Project__c project = ProjectRepository.getProject(projectId);
                Boolean changed = false;
                if (project.ApprovalProcessStatus__c == 'Multi Region Submission') {
                    project.ApprovalProcessStatus__c = 'Submitted';
                }
                if (project.SubmissionStatus__c == 'Business Case Ambition Submitted') {
                    project.SubmissionStatus__c = 'Business Case Ambition asked for Rework';
                } else if (project.SubmissionStatus__c == 'Business Case Validation Submitted') {
                    project.SubmissionStatus__c = 'Business Case Validation asked for Rework';
                }
                project.ProjectPL__c = true;
                project.ProjectDevelopmentDocument__c = true;
                update project;

                String processInstanceId = result.getInstanceId();
                
                ApprovalHistory.saveStepName(project, processInstanceId, new List<Id>(), false, true, null);
            }
        }
    }

    @HttpPut
    global static void updateApprovalHistory(String projectId, String approvalHistoryData) {
        Project__c projectToUpdate = new Project__c();
        projectToUpdate.Id = projectId;
        projectToUpdate.approvalStepName__c = approvalHistoryData;
        update projectToUpdate;
        ApprovalHistory.publishPlatformEvent();
    }
}