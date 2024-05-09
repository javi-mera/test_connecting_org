public with sharing class ItemsToApproveController {

    public class ItemToApprove {
        @AuraEnabled
        public String id;
        public Id projectId;
        @AuraEnabled
        public String relatedTo;
        @AuraEnabled
        public String decisionStepStatus;
        @AuraEnabled
        public String submittedBy;
        @AuraEnabled
        public DateTime dateSubmitted;
        @AuraEnabled
        public string relatedToUrl;
        @AuraEnabled
        public string submittedByUrl;
        public ItemToApprove(String id, Id projectId, String relatedTo, String submittedBy, DateTime dateSubmitted, String relatedToId, String submittedById) {
            this.id = id;
            this.projectId = projectId;
            this.relatedTo = relatedTo;
            this.submittedBy = submittedBy;
            this.dateSubmitted = dateSubmitted;
            this.relatedToUrl = '/lightning/r/' + relatedToId + '/view';
            this.submittedByUrl = '/lightning/r/' + submittedById + '/view';
        }
    }

    @AuraEnabled
    public static List<ItemToApprove> getItemsToApprove() {
        List<ItemToApprove> results = new List<ItemToApprove>();
        List<ProcessInstanceWorkItem> processInstanceWorkItems = ItemsToApproveRepository.getCurrentUsersPendingApprovals();
        List<Id> projectIds = new List<Id>();
        for (ProcessInstanceWorkItem instanceWorkItem : processInstanceWorkItems) {
            projectIds.add(instanceWorkItem.ProcessInstance.TargetObjectId);
        }

        Map<Id, Project__c> projects = ItemsToApproveRepository.getMapOfActiveProjects(projectIds);
        for (ProcessInstanceWorkItem instanceWorkItem : processInstanceWorkItems) {
            if (projects.containsKey(instanceWorkItem.ProcessInstance.TargetObjectId)) {
                Project__c project = projects.get(instanceWorkItem.ProcessInstance.TargetObjectId);
                ItemToApprove itemToApprove = new ItemToApprove(instanceWorkItem.Id, instanceWorkItem.ProcessInstance.TargetObject.Id, instanceWorkItem.ProcessInstance.TargetObject.Name, instanceWorkItem.ProcessInstance.SubmittedBy.Name, instanceWorkItem.ProcessInstance.CreatedDate, instanceWorkItem.ProcessInstance.TargetObjectId, instanceWorkItem.ProcessInstance.SubmittedById);
                itemToApprove.decisionStepStatus = project.SubmissionStatus__c;
                results.add(itemToApprove);
            }
        }
        return results;
    }

}