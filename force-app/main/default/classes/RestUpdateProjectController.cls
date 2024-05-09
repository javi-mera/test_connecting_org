@RestResource(UrlMapping='/projectUpdates/*')
global class RestUpdateProjectController {
    @HttpPost
    global static void updateProjectStatus(String projectId, String projectStatus, String rejectionReason, String reasonForStatusChange,
        String userProfileName, String userName) {
        Project__c projectToUpdate = new Project__c();
        projectToUpdate.Id = projectId;
        projectToUpdate.JustificationForProjectStatusChange__c = reasonForStatusChange;

        if (projectStatus == 'Cancelled') {
            projectToUpdate.RejectionReason__c = rejectionReason;
            projectToUpdate.RejectionComment__c = reasonForStatusChange;
            String comment = 'Project cancelled by ' + userName + ': \'' + rejectionReason + ': ' + reasonForStatusChange + '\'';
            CustomApprovalProcessControlsService.reject(projectId, comment, rejectionReason, reasonForStatusChange);
        } else {
            projectToUpdate.ProjectStatus__c = projectStatus;
        }

        update projectToUpdate;
    }
}