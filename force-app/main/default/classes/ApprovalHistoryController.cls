public with sharing class ApprovalHistoryController {
    /**
     * @description To prepare list of approval steps for LWC 
     */
    @AuraEnabled
    public static List<ApprovalHistory.CustomApprovalHistory> getApprovalHistory(String id) {
        Map<String, List<ApprovalHistory.CustomApprovalHistory>> customApprovalHistory = new Map<String, List<ApprovalHistory.CustomApprovalHistory>>();
        Project__c project = ApprovalHistoryRepository.getProject(id);
        try {
            Map<String, String> stepNames = ApprovalHistory.prepareStepNameMap(project);
            Map<String, String> reassignCommentMap = ApprovalHistory.prepareReassignCommentMap(project);
            List<ProcessInstance> processInstances = ApprovalHistoryRepository.getApprovalHistoryRecords(id);
            Map<String, String> stepsToParse = ApprovalHistory.prepareCustomApprovalHistoryList(processInstances, customApprovalHistory, stepNames, reassignCommentMap);
            ApprovalHistory.parseAutoApprovalHistoryComment(customApprovalHistory, stepsToParse, project);
            ApprovalHistory.statusAdjustmentForReworkSteps(customApprovalHistory);
            List<ApprovalHistory.CustomApprovalHistory> finalApprovalList = ApprovalHistory.sortApprovalHistory(customApprovalHistory);
            ApprovalHistory.addHistoricalData(finalApprovalList, id);
            System.debug('finalApprovalList ' + finalApprovalList);
            return finalApprovalList;
        } catch (Exception e) {
            System.debug('---Trace----' + e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<ApprovalHistory.CustomApprovalHistory> setApproversRoles(List<ApprovalHistory.CustomApprovalHistory> approvalHistories, String projectId) {
        Project__c project = ApprovalHistoryRepository.getProject(projectId);
        String approvalHistoricalData;
        if (String.isNotBlank(project.ApprovalHistoricalData__c)) {
            approvalHistoricalData = project.ApprovalHistoricalData__c.contains(ApprovalHistory.PROJECT_NUMBER) ? '' : project.ApprovalHistoricalData__c;
        }
        if (String.isNotBlank(approvalHistoricalData)) {
            Map<String, Object> approvalHistoricalDataParsed = (Map<String, Object>) JSON.deserializeUntyped(approvalHistoricalData);
            Map<String, Map<String, String>> approvalHistoricalDataMap = new Map<String, Map<String, String>>();
            for (String milestone : approvalHistoricalDataParsed.keySet()) {
                String nameRoleString = JSON.serialize(approvalHistoricalDataParsed.get(milestone));
                List<String> nameRoleStringList = nameRoleString.remove('{').remove('}').remove('"').split(',');
                Map<String, String> currentMilestoneValuesMap = new Map<String, String>();
                for (String str : nameRoleStringList) {
                    currentMilestoneValuesMap.put(str.substringBefore(':'), str.substringAfter(':'));
                    approvalHistoricalDataMap.put(milestone, currentMilestoneValuesMap);
                }
            }
            for (ApprovalHistory.CustomApprovalHistory approvalHistory : approvalHistories) {
                Map<String, String> rolesByNamesMap = approvalHistoricalDataMap.get(InnovatorConstants.MAP_APPROVAL_HISTORY_STEP_NAMES_TO_MILESTONES.get(approvalHistory.stepName));
                if (rolesByNamesMap != null) {
                    approvalHistory.assignedApproverRole = rolesByNamesMap.get(approvalHistory.originalActorName.trim());
                }
            }
        }
        return approvalHistories;
    }
}