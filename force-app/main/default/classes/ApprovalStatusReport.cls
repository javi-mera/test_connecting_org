public with sharing class ApprovalStatusReport {
    private static final String PROJECT_STTAUS = 'Active';
    public static List<ApprovalWrapperClass> wrapList = new List<ApprovalWrapperClass>();
    public static Integer totalCount = 0;


    public static List<ApprovalWrapperClass> getWrapList() {
        List<ApprovalWrapperClass> tempWrapList = new List<ApprovalWrapperClass>();
        Set<Id> projectIds = getPendingApprovalDetail(tempWrapList);
        wrapList = addProjectNumberAndFilterOutNonActiveProject(tempWrapList, projectIds);
        totalCount = wrapList.size();
        wrapList.sort();
        return wrapList;
    }

    /**
     * @description This function is being used to prepare list of pending approval detial
     * @return  `Set<Id>`
     */
    public static Set<Id> getPendingApprovalDetail(List<ApprovalWrapperClass> tempWrapList) {
        
        Set<Id> projectIds  = new Set<Id>();

        for (ProcessInstance processInstance: ApprovalStatusReportRepository.getApprovalStatus()) {
           for (ProcessInstanceHistory processInstanceHistory : processInstance.StepsAndWorkItems) {
               ApprovalWrapperClass pendingApprovalWrap = new ApprovalWrapperClass();
               pendingApprovalWrap.status = processInstanceHistory.StepStatus;
               pendingApprovalWrap.recordName = String.valueOf(processInstance.TargetObject.Name);
               pendingApprovalWrap.recordId = String.valueOf(processInstance.TargetObjectId);
               projectIds.add(pendingApprovalWrap.RecordId);
               pendingApprovalWrap.recordObject = String.valueOf(processInstance.TargetObjectId.getSObjectType()).split('__')[0];
               pendingApprovalWrap.approverId = processInstanceHistory.ActorId;
               pendingApprovalWrap.approverName = processInstanceHistory.Actor.Name;
               pendingApprovalWrap.createdDate = String.valueOf(processInstanceHistory.CreatedDate);
               Decimal days = processInstanceHistory.ElapsedTimeInDays;
               days = days != null? days : 0;
               pendingApprovalWrap.elapsedTimeInDays = days.round(System.RoundingMode.FLOOR);
               tempWrapList.add(pendingApprovalWrap);
           }    
       }
       return projectIds;
    }

    /**
     * @description This function will add project number in the wraper list and filter out the non active project from the list
     * @param wrapList 
     * @return  `List<ApprovalWrapperClass>`
     */
    public static List<ApprovalWrapperClass> addProjectNumberAndFilterOutNonActiveProject(List<ApprovalWrapperClass> tempWrapList, Set<Id> projectIds){
        //fetch projects with active status
        Map<Id, Project__c> projects = ApprovalStatusReportRepository.getProjectsDetail(projectIds);
        
        //add project number info
        for (ApprovalWrapperClass wrapRecord : tempWrapList) {
            if(projects.containsKey(wrapRecord.recordId)){
                Project__c project = projects.get(wrapRecord.recordId);
                wrapRecord.porjectNumber = project.ProjectNumberFormula__c;
                wrapRecord.projectStatus = project.ProjectStatus__c;
            }            
        }

        //filter out project with non-active status
        List<ApprovalWrapperClass> wrapList = new List<ApprovalWrapperClass>();
        for (ApprovalWrapperClass wrapRecord : tempWrapList) {
            if(wrapRecord.projectStatus == PROJECT_STTAUS){
                wrapList.add(wrapRecord);
            }
        }
        return wrapList;
    }

    public static Integer getTotalCount(){
        return totalCount;
    }

    public static String getSiteUrl(){
        return String.valueOf(System.URL.getOrgDomainUrl().toExternalForm());
    }

    public class ApprovalWrapperClass implements Comparable{
        public String porjectNumber {get; set;}
        public String status {get; set;}
        public String recordName {get; set;}
        public String recordId {get; set;}
        public String recordObject {get; set;}
        public String assignedToName {get; set;}
        public String approverId {get; set;}
        public String approverName {get; set;}
        public String createdDate {get; set;}
        public Decimal elapsedTimeInDays {get; set;}
        public String projectStatus {get; set;}

        /**
         * @description This function sorted list the in descending order
         * @return  `Integer`
         */
        public Integer compareTo(Object compareTo) {
            ApprovalWrapperClass compareToAp = (ApprovalWrapperClass)compareTo;
            
            Integer returnValue = 0;
            if (elapsedTimeInDays > compareToAp.elapsedTimeInDays) {
                returnValue = -1;
            }else if (elapsedTimeInDays < compareToAp.elapsedTimeInDays) {
                returnValue = 1;
            }
            return returnValue;
        }
    }

}