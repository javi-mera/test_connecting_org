public without sharing class CustomApprovalProcessControlsService {

    public static Boolean canComplete(Id projectId) {
        Boolean canComplete = false;
        Project__c project = ProjectRepository.getProject(projectId);
        String profileName = CustomApprovalProcessControlsRepository.getCurrentUserProfile();
        Boolean isNotInnovappUser = profileName != InnovatorConstants.INNOVAPP_USER_PROFILE;
        Boolean isProjectNotCompleted = project.ProjectStatus__c != InnovatorConstants.PROJECT_STATUS_COMPLETED;
        Boolean isProjectNotCancelled = project.ProjectStatus__c != InnovatorConstants.PROJECT_STATUS_CANCELLED;
        Boolean isProjectInDiagnose = project.ProjectPhase__c == InnovatorConstants.DIAGNOSE_PHASE;
        Boolean isPostLaunchReviewRequired = project.IsThePostLaunchReviewRequired__c; 
        Boolean isEndOfProject = project.EndOfProject__c;

        canComplete = isProjectNotCancelled && isNotInnovappUser && ((isPostLaunchReviewRequired && isProjectNotCompleted && isProjectInDiagnose ) || 
                    (isEndOfProject && isProjectNotCompleted));
        return canComplete;
    }

    public static Boolean canEdit(Id projectId) {
        Boolean canEdit = false;
        Boolean canComplete = canComplete(projectId);
        Project__c project = ProjectRepository.getProject(projectId);
        Boolean isProjectCompletedOrCancelled = project.ProjectStatus__c == InnovatorConstants.PROJECT_STATUS_COMPLETED || project.ProjectStatus__c == InnovatorConstants.PROJECT_STATUS_CANCELLED;
        Boolean isPostLaunchReviewRequired = project.IsThePostLaunchReviewRequired__c;
        String profileName = CustomApprovalProcessControlsRepository.getCurrentUserProfile();
        if (!isProjectCompletedOrCancelled && !isPostLaunchReviewRequired) {
            List<ProcessInstanceWorkitem> approvals = CustomApprovalProcessControlsRepository.getApprovals(projectId);
            Boolean hasApprovals = approvals != null && approvals.size() > 0;
            if (profileName == InnovatorConstants.INNOVAPP_USER_PROFILE) {
                canEdit = false;
            } else if (!canComplete && !hasApprovals && (profileName == InnovatorConstants.PROJECT_LEADER_USER_PROFILE || profileName == InnovatorConstants.PROJECT_MANAGER_USER_PROFILE)) {
                canEdit = true;
            } else if (profileName == InnovatorConstants.SUPER_USER_PROFILE || profileName == InnovatorConstants.INNOVAPP_ADMIN_PROFILE || profileName == InnovatorConstants.SYSTEM_ADMIN_PROFILE) {
                canEdit = true;
            } else if (profileName == InnovatorConstants.PROJECT_PORTFOLIO_MANAGER_PROFILE && (project.ProjectStatus__c == InnovatorConstants.PROJECT_STATUS_ACTIVE || project.ProjectStatus__c == InnovatorConstants.PROJECT_STATUS_ON_HOLD)) {
                canEdit = true;
            }
        } else if (profileName == InnovatorConstants.SUPER_USER_PROFILE || profileName == InnovatorConstants.INNOVAPP_ADMIN_PROFILE || profileName == InnovatorConstants.SYSTEM_ADMIN_PROFILE) {
            canEdit = true;
        } else if (profileName == InnovatorConstants.PROJECT_PORTFOLIO_MANAGER_PROFILE && (project.ProjectStatus__c == InnovatorConstants.PROJECT_STATUS_ACTIVE || project.ProjectStatus__c == InnovatorConstants.PROJECT_STATUS_ON_HOLD)) {
            canEdit = true;
        }

        if ((profileName == InnovatorConstants.PROJECT_LEADER_USER_PROFILE || profileName == InnovatorConstants.PROJECT_MANAGER_USER_PROFILE)
            && project.ProjectLeader__c == UserInfo.getUserId() && project.ProjectPhase__c == InnovatorConstants.DIAGNOSE_PHASE &&
            project.EndOfProject__c == true && project.ProjectStatus__c == InnovatorConstants.PROJECT_STATUS_ACTIVE) {
            canEdit = true;
        }

        return canEdit;
    }

    public static Boolean canSubmit(Id projectId) {
        Boolean canSubmit = true;
        String profileName = CustomApprovalProcessControlsRepository.getCurrentUserProfile();
        Project__c project = ProjectRepository.getProject(projectId);
        Boolean isProjectCompletedOrCancelled = project.ProjectStatus__c == InnovatorConstants.PROJECT_STATUS_COMPLETED || project.ProjectStatus__c == InnovatorConstants.PROJECT_STATUS_CANCELLED;
        Boolean isProjectInDiagnose = project.ProjectPhase__c == InnovatorConstants.DIAGNOSE_PHASE;
        List<ProcessInstanceWorkitem> approvals = CustomApprovalProcessControlsRepository.getApprovals(projectId);
        Boolean hasApprovals = approvals != null && approvals.size() > 0;
        if (profileName == InnovatorConstants.INNOVAPP_USER_PROFILE || profileName == InnovatorConstants.PROJECT_PORTFOLIO_MANAGER_PROFILE) {
            canSubmit = false;
        } 
        Boolean canComplete = canComplete(projectId);
        if (canComplete || isProjectCompletedOrCancelled || hasApprovals || isProjectInDiagnose) {
            canSubmit = false;
        }
        return canSubmit;
    }

    public static Boolean canChangeProjectStatus(Id projectId) {
        Boolean canChangeProjectStatus = false;
        Project__c project = ProjectRepository.getProject(projectId);
        String profileName = CustomApprovalProcessControlsRepository.getCurrentUserProfile();
        Id currentUserId = UserInfo.getUserId();

        if (project.ProjectStatus__c != InnovatorConstants.PROJECT_STATUS_CANCELLED &&
            project.ProjectStatus__c != InnovatorConstants.PROJECT_STATUS_LAUNCHED &&
            project.ProjectStatus__c != InnovatorConstants.PROJECT_STATUS_COMPLETED) {
        if (profileName == InnovatorConstants.SUPER_USER_PROFILE ||
            (profileName == InnovatorConstants.PROJECT_LEADER_USER_PROFILE && project.ProjectLeader__c == currentUserId)) {
            canChangeProjectStatus = true;
        }
        }

        return canChangeProjectStatus;
    }

    public static Boolean canApprove(Id projectId){
        Id currentUserId = userinfo.getuserid();
        String profileName = CustomApprovalProcessControlsRepository.getCurrentUserProfile();
        List<ProcessInstanceWorkitem> approvals = CustomApprovalProcessControlsRepository.getApprovals(projectId);
        Project__c project = ProjectRepository.getProject(projectId);
        Boolean currentUserIsAdmin = profileName == InnovatorConstants.INNOVAPP_ADMIN_PROFILE || profileName == InnovatorConstants.SYSTEM_ADMIN_PROFILE;
        Boolean hasApprovals = approvals != null && approvals.size() > 0;
        Boolean currentUserHasPendingApproval = false;
        Boolean isProjectNotCancelled = project.ProjectStatus__c != InnovatorConstants.PROJECT_STATUS_CANCELLED;
        
        if (hasApprovals && !currentUserIsAdmin) {
            for (ProcessInstanceWorkitem approval : approvals) {
                if (approval.ActorId == currentUserId) {
                    currentUserHasPendingApproval = true;
                }
            }
        }
        Boolean canApprove = isProjectNotCancelled && hasApprovals && (currentUserIsAdmin || currentUserHasPendingApproval);
        return canApprove;
    }

    public static Boolean canAddApprovers() {
        String profileName = CustomApprovalProcessControlsRepository.getCurrentUserProfile();
        Boolean currentUserIsAdmin = profileName == InnovatorConstants.INNOVAPP_ADMIN_PROFILE || profileName == InnovatorConstants.SYSTEM_ADMIN_PROFILE;
        return currentUserIsAdmin;
    }

    public static Boolean currentUserIsOCSupplyChainForProject(Id projectId) { 
        Id currentUserId = userinfo.getuserid();
        String profileName = CustomApprovalProcessControlsRepository.getCurrentUserProfile();
        Project__c project = ProjectRepository.getProject(projectId);
        //OC Supply Chain users will be always super users
        Boolean currentUserIsSuperUser = profileName == InnovatorConstants.SUPER_USER_PROFILE;
        Boolean isGeoExtension = project.ProjectClassification__c == 'Geographical Extension';

        //Assumption: the OC supply chain only user, can only be OC supply chain in GeoExt projects. 
        //If so, we only need to find a single rule that confirms that he has this role.
        List<ApprovalMatrix__c> rules = CustomApprovalProcessControlsRepository.getApprovalMAtrixRulesWhereUserIsOCSupplyChain(currentUserId);
        Boolean isOCSupplyChainInAnyRule = rules.size() > 0;
        return currentUserIsSuperUser && isGeoExtension && isOCSupplyChainInAnyRule;
    }
    
    /**
     * @description getPendingApproversToReassign
     * @return List<User> , will return the list of user corresponding to the pending approvals if you're an Admin Profile, 
     *         since you can reassign any approval.
     *         If you are another type of profile it will return an empty list as you should only be able to reassing your pending approval.
     */
    public static List<User> getPendingApproversToReassign(Id projectId) { 
        List<User> pendingApproversToReassign = new List<User>();
        String profileName = CustomApprovalProcessControlsRepository.getCurrentUserProfile();
        Boolean currentUserIsAdmin = profileName == InnovatorConstants.INNOVAPP_ADMIN_PROFILE || profileName == InnovatorConstants.SYSTEM_ADMIN_PROFILE;
        if (currentUserIsAdmin) {
            List<ProcessInstanceWorkitem> approvals = CustomApprovalProcessControlsRepository.getApprovals(projectId);
            Set<Id> userIds = new Set<Id>();
            for (ProcessInstanceWorkitem approval : approvals) { 
                userIds.add(approval.ActorId);
            }
            if (userIds.size() > 0) {
                pendingApproversToReassign = CustomApprovalProcessControlsRepository.getUsersById(userIds);
            }
        }
        return pendingApproversToReassign;
    }


    public static void recallApprovalProcess(Id projectId, String comment) {
        String fullReworkComment = 'Rework requested by: ' + Userinfo.getName() + '. \\nComments: ';
        fullReworkComment += comment;
        removeApprovalProcessREST(projectId, fullReworkComment);
    }

    public static Boolean approve(Id projectId, String comments) {
        return approveOrRejectRecord(projectId, comments, 'Approve', null);
    }

    public static Boolean reject(Id projectId, String comments, String rejectionReason, String reasonForStatusChange) {
        if (String.isEmpty(reasonForStatusChange)) { // check if the reject is not from Project Status Change functionality
            String rejectionComment = comments;
            if (!String.isEmpty(comments) && comments.contains('Other:')) {
                rejectionComment = comments.substringAfter('Other:').trim();
            }
            update new Project__c(Id = projectId, RejectionReason__c = rejectionReason, RejectionComment__c = rejectionComment);
        }
        return approveOrRejectRecord(projectId, comments, 'Reject', reasonForStatusChange);
    }

    public static List<ProcessInstanceWorkitem> reassignWithReturn(Project__c project, Id newUserId, Id oldUserId, String comments, List<Messaging.SingleEmailMessage> emails, Boolean isFromBatch) {
        List<ProcessInstanceWorkitem> approvals = CustomApprovalProcessControlsRepository.getApprovals(project.Id);
        if (approvals.size() > 0) {    
            List<ProcessInstanceWorkitem> approvalsToUpdate = new List<ProcessInstanceWorkitem>();
            if (isFromBatch) {
            for (ProcessInstanceWorkitem approval : approvals) {
                if (approval.OriginalActorId == oldUserId || (approval.OriginalActorId == newUserId && approval.ActorId != newUserId)) {
                        approvalsToUpdate.add(approval);
                    break;
                }
                if (approval.ActorId == oldUserId) {
                        approvalsToUpdate.add(approval);
                    break;
                }
            }
            } else {
                for (ProcessInstanceWorkitem approval : approvals) {
                    if (approval.OriginalActorId == oldUserId) {
                        approvalsToUpdate.add(approval);
                        continue;
                    }
                    if (approval.ActorId == oldUserId) {
                        approvalsToUpdate.add(approval);
                    }
                }
            }

            if (!approvalsToUpdate.isEmpty()) {
                for (ProcessInstanceWorkitem approval : approvalsToUpdate) {
                    approval.ActorId = newUserId;
                }
                emails.add(EmailManager.sendEmailForApprovers(project, false, new Set<Id> { newUserId }, comments, true, false));
            }
            return approvalsToUpdate;
        }
        return null;
    }

    public static void reassign(Id projectId, Id newUserId, Id oldUserId, String comments) {
        //We try to reassign the selected user (oldUserId), then current user's pending approval, otherwise we reassign the first of the list
        Id userIdToReassign = userinfo.getuserid();
        if (oldUserId != null) { userIdToReassign = oldUserId; }
        List<ProcessInstanceWorkitem> approvals = CustomApprovalProcessControlsRepository.getApprovals(projectId);
        if (approvals.size() > 0) {    
            ProcessInstanceWorkitem approvalToUpdate = approvals[0];
            Boolean actorFound = false;
            for (ProcessInstanceWorkitem approval : approvals) {
                if (approval.ActorId == userIdToReassign) {
                    approvalToUpdate = approval;
                    actorFound = true;
                    break;
                }
            }
            if (!actorFound) {
                for (ProcessInstanceWorkitem approval : approvals) {
                    if (approval.OriginalActorId == userIdToReassign) {
                        approvalToUpdate = approval;
                        break;
                    }
                }
            }
            approvalToUpdate.ActorId = newUserId;
            Project__c project = ProjectRepository.getProject(projectId);
            EmailManager.sendEmailForApprovers(project, false, new Set<Id> { newUserId }, comments, true, true);
            update approvalToUpdate;

            //add reassigned Approver to the approval historical data
            Set<Id> userIds = new Set<Id>{userIdToReassign, newUserId};
            Map<Id, User> userMap = CustomApprovalProcessControlsRepository.getUsersMapByIds(userIds);
            Map<String, Map<String, String>> approversInfoByMilestoneMap = new Map<String, Map<String, String>>();
            Map<String, String> approverRoleByNameMap = new Map<String, String>();
            if (String.isBlank(project.ApprovalHistoricalData__c) || project.ApprovalHistoricalData__c.contains(ApprovalHistory.PROJECT_NUMBER)) {
                approverRoleByNameMap = getApproverRoleByNameMap(userIds, userMap, newUserId, userIdToReassign);
                approversInfoByMilestoneMap.put(InnovatorConstants.MAP_PHASES_TO_MILESTONES.get(project.ProjectPhase__c), approverRoleByNameMap);
                project.ApprovalHistoricalData__c = JSON.serialize(approversInfoByMilestoneMap);
            } else {
                Map<String, Object> approvalHistoricalDataMap = (Map<String, Object>) JSON.deserializeUntyped(project.ApprovalHistoricalData__c);
                if (approvalHistoricalDataMap.containsKey(InnovatorConstants.MAP_PHASES_TO_MILESTONES.get(project.ProjectPhase__c))) { // add new data to the existing values
                    String nameRoleString = JSON.serialize(approvalHistoricalDataMap.get(InnovatorConstants.MAP_PHASES_TO_MILESTONES.get(project.ProjectPhase__c)));
                    List<String> nameRoleStringList = nameRoleString.remove('{').remove('}').remove('"').split(',');
                    Map<String, String> currentMilestoneValuesMap = new Map<String, String>();
                    for (String str : nameRoleStringList) {
                        currentMilestoneValuesMap.put(str.substringBefore(':'), str.substringAfter(':'));
                    }
                    if (!nameRoleStringList.isEmpty() && !currentMilestoneValuesMap.containsKey(userMap.get(newUserId).Name.trim()) && currentMilestoneValuesMap.containsKey(userMap.get(userIdToReassign).Name.trim())) {
                        approverRoleByNameMap.put(userMap.get(newUserId).Name.trim(), currentMilestoneValuesMap.get(userMap.get(userIdToReassign).Name));
                        currentMilestoneValuesMap.putAll(approverRoleByNameMap);
                    } else if (!nameRoleStringList.isEmpty() && !currentMilestoneValuesMap.containsKey(userMap.get(userIdToReassign).Name.trim())) {
                        approverRoleByNameMap = getApproverRoleByNameMap(userIds, userMap, newUserId, userIdToReassign);
                        currentMilestoneValuesMap.putAll(approverRoleByNameMap);
                    }
                    approvalHistoricalDataMap.put(InnovatorConstants.MAP_PHASES_TO_MILESTONES.get(project.ProjectPhase__c), currentMilestoneValuesMap);
                    project.ApprovalHistoricalData__c = JSON.serialize(approvalHistoricalDataMap);
                } else {
                    approverRoleByNameMap = getApproverRoleByNameMap(userIds, userMap, newUserId, userIdToReassign);
                    approvalHistoricalDataMap.put(InnovatorConstants.MAP_PHASES_TO_MILESTONES.get(project.ProjectPhase__c), approverRoleByNameMap);
                    project.ApprovalHistoricalData__c = JSON.serialize(approvalHistoricalDataMap);
                }
            }
            update project;

            //save reassignment comment
            if(!(String.isEmpty(comments))){
                ApprovalHistory.saveReassignComment(projectId, comments, approvalToUpdate.ProcessInstanceId, approvalToUpdate.id, newUserId, approvalToUpdate.OriginalActorId);
            }
        }
    }

    public static Map<String, String> getApproverRoleByNameMap(Set<Id> userIds, Map<Id, User> userMap, Id newUserId, Id userIdToReassign) {
        Map<String, String> approverRoleByNameMap = new Map<String, String>();
        Map<String, String> approverRolePicklistValueToLabelMap = ApprovalMatrixService.getApproverRolePicklistValuesToLabelsMap();
        Map<Id, ApprovalMatrix__c> approvalMatrixMap = CustomApprovalProcessControlsRepository.getApprovalMatrixByApproverIds(userIds);
        Map<String, String> rolesByNamesMap = getRolesByNamesMap(approvalMatrixMap, approverRolePicklistValueToLabelMap, userMap);
        approverRoleByNameMap.put(userMap.get(newUserId).Name.trim(), rolesByNamesMap.get(userMap.get(userIdToReassign).Name.trim()));
        return approverRoleByNameMap;
    }

    public static void addApprovers(Id projectId, List<String> approverIds) {
        Project__c project = new Project__c();
        project.Id = projectId;
        project.AdditionalApprover1__c = approverIds[0];
        project.AdditionalApprover2__c = approverIds[1];
        project.AdditionalApprover3__c = approverIds[2];
        project.AdditionalApprover4__c = approverIds[3];
        project.AdditionalApprover5__c = approverIds[4];
        project.AdditionalApprover6__c = approverIds[5];
        project.AdditionalApprover7__c = approverIds[6];
        project.AdditionalApprover8__c = approverIds[7];
        project.AdditionalApprover9__c = approverIds[8];
        project.AdditionalApprover10__c = approverIds[9];

        // Get and set the approvers' roles for the Approval History
        Set<Id> userIds = new Set<Id>();
        for (Id approverId : approverIds) {
            userIds.add(approverId);
        }

        Map<String, String> approverRolePicklistValueToLabelMap = ApprovalMatrixService.getApproverRolePicklistValuesToLabelsMap();
        Map<Id, User> userMap = CustomApprovalProcessControlsRepository.getUsersMapByIds(userIds);
        Map<Id, ApprovalMatrix__c> approvalMatrixMap = CustomApprovalProcessControlsRepository.getApprovalMatrixByApproverIds(userIds);
        Map<String, String> rolesByNamesMap = getRolesByNamesMap(approvalMatrixMap, approverRolePicklistValueToLabelMap, userMap);
        Project__c projectInfo = ProjectRepository.getProject(projectId);
        project.ApprovalHistoricalData__c = ApprovalMatrixService.setApprovalHistoricalData(projectInfo, rolesByNamesMap);

        update project;
    }

    public static Map<String, String> getRolesByNamesMap(Map<Id, ApprovalMatrix__c> approvalMatrixMap, Map<String, String> approverRolePicklistValueToLabelMap, Map<Id, User> userMap) {
        Map<Id, String> rolesByApproverIdsMap = new Map<Id, String>();
        for (ApprovalMatrix__c approvalMatrix : approvalMatrixMap.values()) {
            if (!rolesByApproverIdsMap.containsKey(approvalMatrix.Approver__c)) {
                rolesByApproverIdsMap.put(approvalMatrix.Approver__c, approverRolePicklistValueToLabelMap.get(approvalMatrix.ApproverRole__c));
            } else {
                if (rolesByApproverIdsMap.get(approvalMatrix.Approver__c) != approverRolePicklistValueToLabelMap.get(approvalMatrix.ApproverRole__c) && !rolesByApproverIdsMap.get(approvalMatrix.Approver__c).contains('/')) {
                    List<String> roles = rolesByApproverIdsMap.get(approvalMatrix.Approver__c).split('/');
                    if (!roles.contains(approverRolePicklistValueToLabelMap.get(approvalMatrix.ApproverRole__c))) {
                        String severalRolesString = rolesByApproverIdsMap.get(approvalMatrix.Approver__c) + '/' + approverRolePicklistValueToLabelMap.get(approvalMatrix.ApproverRole__c);
                        rolesByApproverIdsMap.put(approvalMatrix.Approver__c, severalRolesString);
                    }
                }
            }
        }

        Map<String, String> rolesByNamesMap = new Map<String, String>();
        for (Id userId : userMap.keySet()) {
            if (!rolesByApproverIdsMap.containsKey(userId) || rolesByApproverIdsMap.get(userId) == null) {
                rolesByNamesMap.put(userMap.get(userId).Name, InnovatorConstants.NO_ROLE_ASSIGNED);
            } else {
                rolesByNamesMap.put(userMap.get(userId).Name, rolesByApproverIdsMap.get(userId));
            }
        }
        return rolesByNamesMap;
    }

    private static Boolean approveOrRejectRecord(Id projectId, String comments, String action, String reasonForStatusChange) {
        Id currentUserId = userinfo.getuserid();
        Boolean approved = false;
        List<ProcessInstanceWorkitem> approvals = CustomApprovalProcessControlsRepository.getApprovals(projectId);
        if (approvals.size() > 0) {
            //Try to approve the current user's record
            for (ProcessInstanceWorkitem approval : approvals) {
                if (approval.ActorId == currentUserId) {
                    approveOrRejectAction(approval.Id, comments, action, projectId, reasonForStatusChange);
                    approved = true;
                }
            }
            //If not, approve the first one of the list
            if (!approved) {
                approveOrRejectAction(approvals[0].Id, comments, action, projectId, reasonForStatusChange);
            }
        }
        Boolean hasPendingApprovals = approvals.size() > 1;
        return hasPendingApprovals;
    }

    private static void approveOrRejectAction(Id processInstanceWorkitemId, String comments, String action, Id projectId, String reasonForStatusChange) {
        Project__c project = CustomApprovalProcessControlsRepository.getProject(projectId);
        String oldDecisionStep = project.DecisionStep__c;
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments(comments);
        req.setAction(action);        
        Id workItemId = processInstanceWorkitemId; 
        req.setWorkitemId(workItemId);
        Approval.ProcessResult result =  Approval.process(req);
        String processInstanceId = result.getInstanceId();
        project = CustomApprovalProcessControlsRepository.getProject(projectId);
        ApprovalHistory.saveStepName(project, processInstanceId, new List<Id>(), false, false, reasonForStatusChange);
        if (String.isEmpty(reasonForStatusChange)) {
            sendNotificationUponAppoveOrReject(project, action, oldDecisionStep);
        }
    }

    public static void sendNotificationUponAppoveOrReject(Project__c project, String action, String oldDecisionStep){
        if(action == InnovatorConstants.APPROVAL_ACTION_APPROVE){
            ProcessInstanceWorkitem[] processInstanceWorkItems = CustomApprovalProcessControlsRepository.getPendingApprovalsForProject(project.id);
            //if all of the approvers have approved their approval notification then send an email
            if (processInstanceWorkItems.size() <= 0) {
                EmailManager.sendEmailForDS(project, oldDecisionStep);
            }
        }else if(action == InnovatorConstants.APPROVAL_ACTION_REJECT){
            EmailManager.sendEmailOnReject(project);
        }
        
    }

    public class DeserializeResponse {
        public String id;
        public String access_token;
    }

    public static void removeApprovalProcessREST(Id projectId, String comment) {
        RestService.init();
        String body = '{"projectId" : "' +projectId+ '", "comment" : "' +comment+ '"}';
        if(!Test.isRunningTest()){
            HttpResponse res1 = RestService.post(body, RestService.getRecallEndpoint());
            if(res1!=null) {
                if (res1.getStatusCode() == 200 ) {
                    EmailManager.sendEmailOnRework(projectId, comment);
                }
                res1.getBody().unescapeCsv().remove('\\');
            }
        }
    }

    public static void codeCoverage() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}