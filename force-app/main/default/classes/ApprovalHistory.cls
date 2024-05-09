public with sharing class ApprovalHistory {

    private static final String OPPORTUNITY_NAME_ADDITION = 'Milestone';
    private static final String AUTO_APPROVAL_NAME_ADDITION = '(Notification Sent)';
    private static final String BLANK_URL = 'javascript:void(0)';
    private static final String REWORK_ASSIGNEE_START = 'Rework requested by:';
    private static final String AUTO_APPROVAL_COMMENT_START = 'Notification sent to';
    private static final String APPROVAL_REQUEST_SUBMITTED_MSG = 'Approval Request Submitted';
    private static final String NO_RESPONSE_STATUS = 'No Response';
    private static final String PENDING_STATUS = 'Pending';
    private static final String REJECTED_COMMENT = 'Project cancelled by';
    public static final String PROJECT_NUMBER = 'projectNumber';

    public class CustomApprovalHistory implements Comparable{
        @AuraEnabled public String id {get; set;}
        @AuraEnabled public String stepName {get; set;}
        @AuraEnabled public Date stepDate {get; set;}
        @AuraEnabled public Datetime createdDate{get; set;}
        @AuraEnabled public String status {get; set;}
        @AuraEnabled public String submittedById {get; set;}
        @AuraEnabled public String submittedByName {get; set;}
        @AuraEnabled public String actualApproverId {get; set;}
        @AuraEnabled public String actualApproverName {get; set;}
        @AuraEnabled public String comment {get; set;}
        @AuraEnabled public Decimal elapsedTimeInDays {get; set;}
        @AuraEnabled public String originalActorName {get; set;}
        @AuraEnabled public String originalActorId {get; set;}
        @AuraEnabled public String assignedApproverRole { get; set; }
        @AuraEnabled public String processInstanceId {get; set;}
        @AuraEnabled public String stepId {get; set;}
        @AuraEnabled public String stepUrl {get; set;}

        public Integer compareTo(Object compareTo) {
            Integer returnValue = 1;
            CustomApprovalHistory compareToApproval = (CustomApprovalHistory)compareTo;
            if(PENDING_STATUS.equalsIgnoreCase(compareToApproval.status)){
                returnValue = 1;
            }
            else if(compareToApproval.createdDate > createdDate){
                returnValue = 1;
            }else if(compareToApproval.createdDate < createdDate){
                returnValue = -1;
            }else {
                if (compareToApproval.status == InnovatorConstants.SUBMITTED_STATUS) {
                    returnValue = 0;
                }
            }
            
            return returnValue;
        }
    }
    
    public class StepNameParsing{
    
        private List<String> stepIds {get; set;}
        private String stepName {get; set;}
        private String pid {get; set;}
    
        private List<StepNameParsing> parse(String json) {
            return (List<StepNameParsing>) System.JSON.deserialize(json, List<StepNameParsing>.class);
        }
    }

    
    public class ReassignCommentParsing{
    
        private String stepId {get; set;}
        private String comment {get; set;}
        private String pid {get; set;}
        private String newUser {get; set;}
        private String oldUser {get; set;}
        
        ReassignCommentParsing(){

        }
        ReassignCommentParsing(String stepId, String pid, String comment, String newUser, String oldUser){
            this.comment = comment;
            this.pid = pid;
            this.stepId = stepId;
            this.newUser = newUser;
            this.oldUser = oldUser;
        }

        private List<ReassignCommentParsing> parse(String json) {
            return (List<ReassignCommentParsing>) System.JSON.deserialize(json, List<ReassignCommentParsing>.class);
        }
    }


    /**
     * @description to fetch user name from the auto approval history comment and to clone steps for each user
     */
    public static void parseAutoApprovalHistoryComment(Map<String, List<CustomApprovalHistory>> customApprovalHistory, Map<String, String> stepsToParse, Project__c project){
        Map<Id,Set<String>> userNamesByApprovalProcess = new Map<Id,Set<String>>(); 
        for(String stepId : stepsToParse.keySet()){
            List<CustomApprovalHistory> approvalHistory =  customApprovalHistory.get(stepsToParse.get(stepId));
            List<String> users = parseAutoApprovalCommentToGetUserList(approvalHistory, stepId);
            List<CustomApprovalHistory> clonedApprovalHistory = cloneApprovalStepforEachUser(approvalHistory, users, project, userNamesByApprovalProcess);
            approvalHistory.addAll(clonedApprovalHistory);
        }
    }

    public static List<String> parseAutoApprovalCommentToGetUserList(List<CustomApprovalHistory> approvalHistory, String stepId){
        List<String> users = new List<String>();
        for(CustomApprovalHistory approval : approvalHistory){
            if(approval.stepId == stepId){
                List<String> parsedComment = approval.comment.split('\\:');
                String usersString = parsedComment[1];
                users = usersString.split('\\,');
                break;
            }
        }
        return users;
    }

    /**
     * @description To create copy of each step according to ecah user in case of auto approval
     */
    public static List<CustomApprovalHistory> cloneApprovalStepforEachUser(List<CustomApprovalHistory> approvalHistory, List<String> users, Project__c project, 
    Map<Id,Set<String>> userNamesByApprovalProcess) {
        List<CustomApprovalHistory> cloneApprovalHistoryList = new List<CustomApprovalHistory>();
        CustomApprovalHistory approvalToClone = new CustomApprovalHistory();
        Integer index = 0;
        for(CustomApprovalHistory approval :approvalHistory){
            //we need to clone approval history records other than submitted one
            if (approval.status != InnovatorConstants.SUBMITTED_STATUS) {
                approvalToClone = approval;
                break;
            }
            index++;
        }

        //Filter to ensure that users who are in the 1st step approval + multi-region step for auto-approvals only show once
        Id processInstanceId = approvalHistory[0].processInstanceId;
        Set<String> userNamesInCurrentApprovalProcess = userNamesByApprovalProcess.get(processInstanceId);
        if (userNamesInCurrentApprovalProcess == null) {
            userNamesInCurrentApprovalProcess = new Set<String>();
            userNamesByApprovalProcess.put(processInstanceId, userNamesInCurrentApprovalProcess);
        }

        for(String userName: users){
            //skip steps for project leader and project manager and ensure that users who are in the 1st step approval + multi-region step only show once
            Boolean userNotInCurrentApprovalSteps = !userNamesInCurrentApprovalProcess.contains(userName.trim());
            if((userName.trim() != project.ProjectLeader__r.name) && (userName.trim() != project.ProjectManager__r.name) && userNotInCurrentApprovalSteps){
                CustomApprovalHistory copy = copyApprovalHistory(approvalToClone, userName);
                cloneApprovalHistoryList.add(copy);
                //add each user that has a new row into the list of names for that step, so that we can later filter the repeated names
                userNamesInCurrentApprovalProcess.add(userName.trim());
            }
        }
        
        //remove the existing approval record that we have splitted
        approvalHistory.remove(index);
        return cloneApprovalHistoryList;
    }

    public static CustomApprovalHistory copyApprovalHistory(CustomApprovalHistory approvalHistory, String userName){
        CustomApprovalHistory copy =  new CustomApprovalHistory();
        copy.stepName = approvalHistory.stepName;
        copy.stepDate = approvalHistory.stepDate;
        copy.createdDate = approvalHistory.createdDate;
        copy.status = approvalHistory.status;
        copy.submittedById = approvalHistory.submittedById;
        copy.submittedByName = approvalHistory.submittedByName;
        copy.actualApproverId = approvalHistory.actualApproverId;
        copy.actualApproverName = userName;
        copy.elapsedTimeInDays = approvalHistory.elapsedTimeInDays;
        copy.originalActorName = userName;
        copy.originalActorId = approvalHistory.originalActorId;
        copy.comment = '';
        copy.processInstanceId = approvalHistory.ProcessInstanceId;
        copy.stepId = approvalHistory.id;
        copy.stepUrl = approvalHistory.stepUrl;

        return copy;
    }

    /**
     * @description to fetch each approval process data for a project and to build a map accordingly
     */
    public static Map<String, String> prepareCustomApprovalHistoryList(List<ProcessInstance> processInstances, Map<String, List<CustomApprovalHistory>> customApprovalHistory, Map<String, String> stepNames, Map<String, String> reassignCommentMap){
        Map<String, String> stepsToParse = new Map<String, String>();
        Map<String, String> stepStatusMap = getStepStatusList();
        for (ProcessInstance processInstance : processInstances) {
           for (ProcessInstanceHistory processInstanceHistory : processInstance.StepsAndWorkItems) {
                
            CustomApprovalHistory approval = fillCustomApprovalObject(processInstanceHistory, processInstance, stepsToParse, stepNames, stepStatusMap, reassignCommentMap);
            String pid = processInstanceHistory.ProcessInstanceId;
            List<CustomApprovalHistory> temp = new List<CustomApprovalHistory>();
                if(customApprovalHistory.containsKey(pid)){
                    temp = customApprovalHistory.get(pid);
                }
                temp.add(approval);
                customApprovalHistory.put(processInstanceHistory.ProcessInstanceId, temp);
           }    
       }
       return stepsToParse;
    }

    public static CustomApprovalHistory fillCustomApprovalObject(ProcessInstanceHistory processInstanceHistory, ProcessInstance processInstance, Map<String, String> stepsToParse, Map<String, String> stepNames, Map<String, String> stepStatusMap, Map<String, String> reassignCommentMap){
        CustomApprovalHistory approval = new CustomApprovalHistory();
        approval.status = stepStatusMap.get(processInstanceHistory.StepStatus);
        approval.id = processInstance.TargetObjectId;
        approval.actualApproverId = processInstanceHistory.ActorId;
        approval.actualApproverName = processInstanceHistory.Actor.Name;
        approval.originalActorName = processInstanceHistory.OriginalActor.Name;
        approval.originalActorId = processInstanceHistory.OriginalActorId;
        approval.createdDate = processInstanceHistory.CreatedDate;
        approval.processInstanceId = processInstanceHistory.ProcessInstanceId;
        approval.stepId = processInstanceHistory.id;
        String comment = String.valueof(processInstanceHistory.Comments);
        approval.comment = comment;
        if( !(String.isEmpty(comment)) && comment.contains(AUTO_APPROVAL_COMMENT_START) ){
            stepsToParse.put(processInstanceHistory.id ,processInstanceHistory.ProcessInstanceId);
        }
        //parse comment in case of reworked approval
        else if(!(String.isEmpty(comment)) && comment.contains(REWORK_ASSIGNEE_START) ) {
            Map<String, String> parsedReassignComment = parseReworkComment(comment);
            approval.comment = parsedReassignComment.get('comment');
            approval.actualApproverName = parsedReassignComment.get('approverName');
        }
        Decimal days = processInstanceHistory.ElapsedTimeInDays;
        days = days != null? days : 0; 
        approval.elapsedTimeInDays = days.round(System.RoundingMode.FLOOR);
        //stepName parsing
        approval.stepName = processInstanceHistory.ProcessNode.Name;
        if(stepNames.containsKey(approval.stepId) || stepNames.containsKey(approval.processInstanceId)){
            if(!String.isEmpty(stepNames.get(approval.stepId)) ){
                approval.stepName = stepNames.get(approval.stepId);
            }else{
                approval.stepName = stepNames.get(approval.processInstanceId);
            }
        }
       else if (approval.status == InnovatorConstants.SUBMITTED_STATUS) {
            approval.stepName = APPROVAL_REQUEST_SUBMITTED_MSG;
        }
        //replace recalled with rework
        if (approval.status == InnovatorConstants.RECALLED_STATUS) {
            approval.status = InnovatorConstants.APPROVAL_ACTION_REWORK;
        }
        //add reassigmnet comment
        if(reassignCommentMap.containsKey(approval.stepId)){
            approval.comment = reassignCommentMap.get(approval.stepId);
        }

        approval.stepUrl =  System.Url.getOrgDomainUrl().toExternalForm() + '/lightning/r/ProcessInstanceStep/' + approval.stepId + '/view';

        return approval;
    }
    public static void addHistoricalData(List<CustomApprovalHistory> finalApprovalList, String id){
        System.debug('finalApprovalList befre sort: ' + finalApprovalList);
        System.debug('0' + finalApprovalList[0].stepUrl);
        Project__c project = ApprovalHistoryRepository.getProject(id);
        Map<String,List<CustomApprovalHistory>> mapByStepNames = new Map<String,List<CustomApprovalHistory>>();
        if(String.isNotBlank(project.ApprovalHistoricalData__c) && project.ApprovalHistoricalData__c.contains(PROJECT_NUMBER)) {
            List<ApprovalHistoricalDTO> dtos = (List<ApprovalHistoricalDTO>)JSON.deserialize(project.ApprovalHistoricalData__c, List<ApprovalHistoricalDTO>.class);
            dtos.sort();
            Map<String, User> usersByEmail = new Map<String,User>();
            Set<String> userEmails = new Set<String>();
            for(ApprovalHistoricalDTO dto : dtos){
                userEmails.add(dto.email);
                if(String.isNotBlank(dto.delegatedTo)){
                    userEmails.add(dto.delegatedTo);
                }
            }
            List<User> userList = ApprovalHistoryRepository.getUsersByEmail(userEmails);
            for(User u :userList){
                usersByEmail.put(u.Email,u);
            }
            for(Integer i=InnovatorConstants.MAP_DECISION_STEP.values().size()-1; i>=0; i--){
                mapByStepNames.put(InnovatorConstants.MAP_DECISION_STEP.values().get(i),new List<CustomApprovalHistory>());
            }
            for(ApprovalHistoricalDTO dto : dtos){
                CustomApprovalHistory approval = fillCustomApprovalObject(dto,usersByEmail);
                List<CustomApprovalHistory> listOfApprovals = mapByStepNames.get(approval.stepName);
                listOfApprovals.add(approval);
                mapByStepNames.put(approval.stepName,listOfApprovals);
            }
        }
        finalApprovalList.addAll(sortApprovalHistory(mapByStepNames));
    }

    public static CustomApprovalHistory fillCustomApprovalObject(ApprovalHistoricalDTO historicalDTO, Map<String, User> usersByEmail){
        String stepName = InnovatorConstants.MAP_DECISION_STEP.get(historicalDTO.phase);
        CustomApprovalHistory approval = new CustomApprovalHistory();
        approval.status = historicalDTO.status;
        approval.stepName = stepName;
        if (String.isNotBlank(historicalDTO.createdDate) && !historicalDTO.createdDate.contains('null')) {
            approval.createdDate = DateTime.valueOf(historicalDTO.createdDate);
        }
        //since the historical approvals are not real SF records we add the blank url in order to display the stepName
        User approver = usersByEmail.get(historicalDTO.email);
        approval.stepUrl = BLANK_URL;
        if (approver != null) {
            setOriginalApproverIdAndName(approval, approver);
        } else {
            approval.originalActorName = historicalDTO.email;
        }
        if (String.isBlank(historicalDTO.delegatedTo) && approver != null) {
            setActualApproverIdAndName(approval, approver);
        } else {
            User delegatedApprover = usersByEmail.get(historicalDTO.delegatedTo);
            if (delegatedApprover != null) {
                setOriginalApproverIdAndName(approval, delegatedApprover);
                if (approver != null) {
                    setActualApproverIdAndName(approval, approver);
                } else {
                    approval.actualApproverName = historicalDTO.email;
                }
            } else {
                if (String.isBlank(historicalDTO.delegatedTo)) {
                    approval.actualApproverName = historicalDTO.email;
                } else {
                    approval.originalActorName = historicalDTO.delegatedTo;
                    if (approver != null) {
                        setActualApproverIdAndName(approval, approver);
                    } else {
                        approval.actualApproverName = historicalDTO.email;
                    }
                }
            }
        }
        approval.comment = historicalDTO.comments;
        return approval;
    }

    private static void setActualApproverIdAndName(CustomApprovalHistory approval, User approver) {
        approval.actualApproverId = approver.Id;
        approval.actualApproverName = approver.Name;
    }

    private static void setOriginalApproverIdAndName(CustomApprovalHistory approval, User approver) {
        approval.originalActorId = approver.Id;
        approval.originalActorName = approver.Name;
    }

    /**
     * @description To parse rework comment in order to extract Actual approver name and comment
     */
    public static Map<String, String> parseReworkComment(String actualComment){
        Map<String, String> parsedReassignComment = new Map<String, String>();
        List<String> splitttedComment = actualComment.split('\\:');
        String approverName = splitttedComment[1];
        List<String> splitttedApproverName = approverName.split('\\.');
        parsedReassignComment.put('approverName', splitttedApproverName[0]);
        parsedReassignComment.put('comment', splitttedComment[2]);
        return parsedReassignComment;
    }

    public static Map<String, String> prepareStepNameMap(Project__c project){
        Map<String, String> stepNameMap = new Map<String, String>();
        
        StepNameParsing temp = new StepNameParsing();
        if(!String.isEmpty(project.approvalStepName__c)){
            List<StepNameParsing> stepsInfo =  temp.parse(project.approvalStepName__c);
            for(StepNameParsing step: stepsInfo)
            {
                for(String stepId: step.stepIds){
                    stepNameMap.put(stepId, step.stepName);
                }
                stepNameMap.put(step.pid, step.stepName);
            }
        }
        return stepNameMap;
    }

    /**
     * @description To sort steps for each apoproval process instance of a project
     */
    public static List<CustomApprovalHistory> sortApprovalHistory(Map<String, List<CustomApprovalHistory>> customApprovalHistory){
        List<CustomApprovalHistory> sortedList = new List<CustomApprovalHistory>();
        for(String key: customApprovalHistory.keySet()){
            List<CustomApprovalHistory> approvalList = customApprovalHistory.get(key);
            approvalList.sort();
            sortedList.addAll(approvalList);
        }
        return sortedList;
    }

    public static Map<String, String> getStepStatusList(){
        Map<String, String> stepStatusMap = new Map<String ,String>();
         Schema.DescribeFieldResult fieldResult = ProcessInstanceStep.StepStatus.getDescribe();
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        System.debug('ple ' + ple);
         for( Schema.PicklistEntry pickListVal : ple){
            stepStatusMap.put(pickListVal.getValue(), pickListVal.getLabel());
         }
        System.debug('stepStatusMap ' + stepStatusMap);
         return stepStatusMap;
    }

     /**
      * @description To publish platform event in order to refresh the Custom History LWC
      */
     public static void publishPlatformEvent(){
         Custom_Approval_History__e event = new Custom_Approval_History__e();
        Database.SaveResult sr = EventBus.publish(event);
        if (sr.isSuccess()) {
        } else {
            for(Database.Error err : sr.getErrors()) {
                System.debug('Error returned: ' + err.getStatusCode() +' - ' + err.getMessage());
            }
        }
     }

    /**
      * @description To prepare map containing reassignmnet comment against each step
      */
    public static Map<String, String> prepareReassignCommentMap(Project__c project){
        Map<String, String> stepCommentMap = new Map<String, String>();
        ReassignCommentParsing temp = new ReassignCommentParsing();
        if(!String.isEmpty(project.ApprovalReassignmentComment__c)){
            List<ReassignCommentParsing> stepsInfo =  temp.parse(project.ApprovalReassignmentComment__c);
            for(ReassignCommentParsing step: stepsInfo)
            {
                stepCommentMap.put(step.stepId, step.comment);
            }
        }
        return stepCommentMap;
    }

    /**
     * @description Keep Rework for the requester, change status to No response for everyone else that had it pending
     * and show rework comment only for requester, if admin ask for rework then for everyone
     */
    public static void statusAdjustmentForReworkSteps(Map<String, List<CustomApprovalHistory>> customApprovalHistory) {
        for (String key: customApprovalHistory.keySet()) {
            List<CustomApprovalHistory> approvalList = customApprovalHistory.get(key);
            Boolean isReworkRequestedByAdmin = isReworkRequestedByAdmin(approvalList);
            for (CustomApprovalHistory approval : approvalList) {
                Boolean reworkOrRecalled = approval.status == InnovatorConstants.APPROVAL_ACTION_REWORK || approval.status == InnovatorConstants.RECALLED_STATUS;
                Boolean rejected = approval.status == InnovatorConstants.REJECTED_STATUS;
                Boolean actualNotEqualsOriginalActor = approval.actualApproverName.trim() != approval.originalActorName.trim();
                if (!isReworkRequestedByAdmin && reworkOrRecalled && actualNotEqualsOriginalActor) {
                    approval.comment = '';
                    approval.status = NO_RESPONSE_STATUS;
                }
                if (rejected && approval.comment.contains(REJECTED_COMMENT)) {
                    approval.status = NO_RESPONSE_STATUS;
                }
            }
        }
    }

    public static Boolean isReworkRequestedByAdmin(List<CustomApprovalHistory> approvalList) {
        Boolean isReworkRequestedByAdmin = true;
        for (CustomApprovalHistory approval : approvalList) {
            Boolean reworkOrRecalled = approval.status == InnovatorConstants.APPROVAL_ACTION_REWORK || approval.status == InnovatorConstants.RECALLED_STATUS;
            Boolean actualEqualsOriginalActor = approval.actualApproverName.trim() == approval.originalActorName.trim();
            if (reworkOrRecalled && actualEqualsOriginalActor) {                
                isReworkRequestedByAdmin = false;
            } 
        }
        return isReworkRequestedByAdmin;
    }

    /**
     * @description To save the step name info in the form of JSON in long area text field
     */
    public static Boolean saveStepName(Project__c project, String processInstanceId, List<Id> paramNewWorkItemIds, Boolean isAutomaticApproval, Boolean isRework, String reasonForStatusChange) {
        //cloning the list to avoid modifing the list passed as parameter
        List<Id> newWorkItemIds = paramNewWorkItemIds.clone();
        Boolean needToUpdate = false;
        if (!newWorkItemIds.contains(processInstanceId)) {
            newWorkItemIds.add(processInstanceId);
        }
        //if project has been submitted for the first time
        if (String.isEmpty(project.approvalStepName__c)) {
            List<StepNameParsing> steps = new List<StepNameParsing>();
            StepNameParsing step  = new StepNameParsing();
            step.pid = processInstanceId;
            if (isAutomaticApproval && InnovatorConstants.DECISION_STEP_OPPORTUNITY_SHORT.equalsIgnoreCase(project.DecisionStep__c)) {
                step.stepName = project.DecisionStep__c + ' ' + OPPORTUNITY_NAME_ADDITION + ' ' + AUTO_APPROVAL_NAME_ADDITION;
            } else if(isAutomaticApproval) {
                step.stepName = project.DecisionStep__c + ' ' + AUTO_APPROVAL_NAME_ADDITION;
            } else{
                step.stepName = project.DecisionStep__c;
            }
            step.stepIds =  newWorkItemIds;
            steps.add(step);
            project.approvalStepName__c = JSON.serialize(steps);
            needToUpdate = true;
        } else {
            StepNameParsing temp = new StepNameParsing();
            List<StepNameParsing> stepsInfo =  temp.parse(project.approvalStepName__c);
            Boolean alreadyExist = checkProcessInstanceAlreadyExist(stepsInfo, processInstanceId);
            //if process instance already in the approval setp name json field then we will only replace id's if approved
            if (alreadyExist) {
                needToUpdate = updateStepNameInfo(project, processInstanceId, newWorkItemIds, stepsInfo);
            } else {
                addProcessInstanceInfo(project, processInstanceId, newWorkItemIds, stepsInfo, isAutomaticApproval);
                needToUpdate = true;
            }
        }

        if (needToUpdate && !Test.isRunningTest()) {
            if (isRework || !String.isEmpty(reasonForStatusChange)) {
                RestRecallController.updateApprovalHistory(project.Id, project.approvalStepName__c);
            } else {
                ApprovalHistoryRestService.updateProjectWithStepNameData(project.Id, project.approvalStepName__c);
            }
        }

        return needToUpdate;
    }


    public static void addProcessInstanceInfo(Project__c project, String processInstanceId, List<Id> newWorkItemIds, List<StepNameParsing> stepsInfo, Boolean isAutomaticApproval){
        StepNameParsing step  = new StepNameParsing();
        step.pid = processInstanceId;
        if (isAutomaticApproval && InnovatorConstants.DECISION_STEP_OPPORTUNITY_SHORT.equalsIgnoreCase(project.DecisionStep__c)) {
            step.stepName = project.DecisionStep__c + ' '+ OPPORTUNITY_NAME_ADDITION + ' '+AUTO_APPROVAL_NAME_ADDITION;
        }
        else if(isAutomaticApproval){
            step.stepName = project.DecisionStep__c+ ' '+AUTO_APPROVAL_NAME_ADDITION;
        }else{
            step.stepName = project.DecisionStep__c;
        }
        step.stepIds =  newWorkItemIds;
        stepsInfo.add(step);
        String s = JSON.serialize(stepsInfo);
        project.approvalStepName__c = s;
    }

    public static Boolean checkProcessInstanceAlreadyExist(List<StepNameParsing> stepsInfo, String processInstanceId){
        Boolean alreadyExist = false;
        for(StepNameParsing stepInfo :  stepsInfo){
            if(stepInfo.pid == processInstanceId){
                alreadyExist = true;
                break;
            }
        }
        return alreadyExist;
    }

    /**
     * @description once every approval has approved, we need to replace the ProcessWorkItem record id with the ProcessInstanceStep record id
     */
    public static Boolean updateStepNameInfo(Project__c project, String processInstanceId, List<Id> newWorkItemIds, List<StepNameParsing> stepsInfo){
        Boolean needToUpdate = false;
        Boolean isApproved = isApprovalProcessInProgress(processInstanceId);
        if(isApproved){
            Map<Id, ProcessInstanceStep> stepMap = ApprovalHistoryRepository.getProcessSteps(processInstanceId);
            replaceWorkIdWithStepId(stepMap.keySet(), stepsInfo, processInstanceId);
            project.approvalStepName__c = JSON.serialize(stepsInfo);
            needToUpdate = true;
        }
        return needToUpdate;
    }

    public static void replaceWorkIdWithStepId(Set<Id> stepsId, List<StepNameParsing> stepsInfo, String processInstanceId){
        List<Id> stepIdList = new List<Id>(stepsId);
        List<String> stepIdList1 = new List<String>();

        for(Id id : stepIdList){
            stepIdList1.add((String)id);
        }
        for(StepNameParsing stepInfo :  stepsInfo){
            if(stepInfo.pid == processInstanceId){
                stepInfo.stepIds = stepIdList;
            }
        }
    }

    /**
     * @description to check the status of a approval
     */
    public static Boolean isApprovalProcessInProgress(String processInstanceId){
        Boolean isApproved = true;
        List<ProcessInstanceWorkitem> approvals = ApprovalHistoryRepository.getProcessWorkItems(processInstanceId);
        if(approvals != null && approvals.size() > 0){
            isApproved = false;
        }
        return isApproved;
    }

    /**
     * @description to save reassignment comment once approval has been reassigned
     */
    public static void saveReassignComment(Id projectId, String comment, String pid, String stepId, String newUser, String oldUser){
        Project__c project = ApprovalHistoryRepository.getProject(projectId);
        List<ReassignCommentParsing> stepsInfo = new List<ReassignCommentParsing>();

        if(!(String.isEmpty(project.ApprovalReassignmentComment__c))){
            ReassignCommentParsing temp = new ReassignCommentParsing();
            stepsInfo =  temp.parse(project.ApprovalReassignmentComment__c);
        }
        ProcessInstanceStep newProcessInstanceStep = ApprovalHistoryRepository.getRecentReassignProcessInstanceStep(pid);
        ReassignCommentParsing step  = new ReassignCommentParsing(newProcessInstanceStep.id, pid, comment, newUser, oldUser);
        stepsInfo.add(step);
        project.ApprovalReassignmentComment__c = JSON.serialize(stepsInfo);
        ApprovalHistoryRestService.updateProjectWithReassignCommentData(projectId, project.ApprovalReassignmentComment__c);
    }
}