public with sharing class EmailManager {

    private static final String PROJECT_NUMBER_FIELD = '{!Project__c.ProjectNumberFormula__c}';
    private static final String PROJECT_NAME_FIELD = '{!Project__c.Name}';
    private static final String PENDING_APPROVAL_PROJECTS_TAB = 'PendingApprovalProjects';
    public static final String MATRIX_RT = 'Approval_Matrix';
    public static final String FIRST_APPROVAL_STEP = '1';

    public static String sendEmailForAutoApprovalAndGetListOfRecipients(Project__c project, Set<Id> recipientIds, String submitterComment, String nextPhase, Boolean send) {
        if (recipientIds.isEmpty()) {
            return '';
        }
        List<User> users = ApprovalProcessRepository.getUsersByIds(recipientIds);
        String recordURL = URL.getOrgDomainUrl().toExternalForm() + '/' + project.id;
        List<String> toEmails = new List<String>();
        String nameList = prepareListOfEmailsAndNames(users, toEmails);
        if (send) {
            String decisionStep = project.DecisionStep__c == 'Opportunity' ? 'Opportunity Milestone' : project.DecisionStep__c;
            String projectNameAndNumber = '(' + project.ProjectNumberFormula__c + ' - ' + project.Name + ')';
            String subject = 'Innovator - ' + projectNameAndNumber + ' - ' + decisionStep + ' is PASSED';
            String htmlBody = '<p>Dear All,</p>';
            htmlBody += '<p>This is to inform you that project ' + projectNameAndNumber + ' has passed ' + decisionStep + ' and this is now in ';
            htmlBody += nextPhase + ' phase.';
            htmlBody += ' This notification is an FYI and no further action is required by approvers in Innovator at this time.</p>';
            if (String.isNotEmpty(submitterComment)) {
                htmlBody += '<p>This comment has been added by the project team while submitting the milestone: ' + submitterComment + '</p>';
            }
            htmlBody += '<p>Project classification: ' + project.ProjectClassification__c + '</p>';
            htmlBody += '<p>' + project.ProjectLeaderFormula__c + '</p>';
            if (project.ProjectManager__c != null) {
                htmlBody += '<p>' + project.ProjectManagerFormula__c + '</p>';
            }
            if (project.TargetOnShelfDateLeadRegion__c != null) {
                String targetOnShelfDate = String.valueOf(project.TargetOnShelfDateLeadRegion__c).removeEnd(' 00:00:00');
                htmlBody += '<p>Target on-shelf date: ' + targetOnShelfDate + '</p>';
            }
            htmlBody += '<p>BMC Classification: ' + (project.BMCClassification__c != null ? project.BMCClassification__c : 'N/A') + '</p>';
            htmlBody += '<p>Market Classification: ' + (project.MarketClassification__c != null ? project.MarketClassification__c : 'N/A') + '</p>';
            if (project.BMCComment__c != null) {
                htmlBody += '<p>Project Leader rationale for progressing project considering it is not a priority BMC (i.e. it is a Pebble, Sand or Air BMC): ' + project.BMCComment__c + '</p>';
            }
            if (String.isNotEmpty(project.FinancialThresholdNotMetComment__c) && InnovatorConstants.PROJECT_CLASSIFICATION_TO_NSV_THRESHOLD.keySet().contains(project.ProjectClassification__c)) {
                String nsvTarget = InnovatorConstants.PROJECT_CLASSIFICATION_TO_NSV_THRESHOLD.get(project.ProjectClassification__c);
                htmlBody += InnovatorConstants.THRESHOLD_NOT_MET_MILESTONE_MSG_START + nsvTarget;
                htmlBody += InnovatorConstants.THRESHOLD_NOT_MET_MSG_END + project.FinancialThresholdNotMetComment__c;
            }
            htmlBody += '<p>Click here to open the project: ' + recordURL + '</p>';
            htmlBody += '<p>Please contact the PL if you require additional information or have any information the project team needs to be aware of, which might impact how the project progresses.</p>';
            EmailService.sendEmail(toEmails, project.Id, subject, htmlBody);
        }
        return nameList;
    }

    public static void sendEmailOnReject(Project__c project) {
        EmailTemplate emailTemplate = ApprovalProcessRepository.getTemplateByName('Project Approval: Rejected');
        String recordURL = ProjectUtility.prepareRecordUrl(project.Id);
        Set<Id> userIds = new Set<Id> {project.ProjectLeader__c, project.ProjectManager__c};
        List<User> users = ApprovalProcessRepository.getUsersByIds(userIds);
        List<String> toEmails = prepareListOfEmails(users);
        String subject = emailTemplate.Subject;
        String body = emailTemplate.Body;
        String decisionStep = project.DecisionStep__c == 'Opportunity' ? 'Opportunity Milestone' : project.DecisionStep__c;
        subject = subject.replace('{!Project__c.ProjectNumberFormula__c}', project.ProjectNumberFormula__c);
        subject = subject.replace('{!Project__c.Name}', project.Name);
        subject = subject.replace('{!Project__c.DecisionStep__c}', decisionStep);
        body = body.replace('{!Project__c.ProjectNumberFormula__c}', project.ProjectNumberFormula__c);
        body = body.replace('{!Project__c.Name}', project.Name);
        body = body.replace('{!Project__c.ProjectClassification__c}', project.ProjectClassification__c);
        body = body.replace('{!Project__c.DecisionStep__c}', project.DecisionStep__c);
        if (project.ProjectLeader__c != null) {
            body = body.replace('Project Leader: {!Project__c.ProjectLeader__c}', project.ProjectLeaderFormula__c);
        } else {
            body = body.replace('{!Project__c.ProjectLeader__c}', '');
        }
        body = body.replace('{!Project__c.ProjectManager__c}', project.ProjectManager__c != null ? project.ProjectManagerFormula__c : '');
        body = body.replace('{!Project__c.Link}', recordURL);
        body = body.replace('{!RejecterComment}', ApprovalProcessService.getApproverComments(project.id, 'Reject'));
        EmailService.sendEmail(toEmails, project.Id, subject, body);
    }

    public static Messaging.SingleEmailMessage sendEmailForApprovers(Project__c project, Boolean additionalApprovers, Set<Id> selectedUserIds, String submitterComment, Boolean isReassign, Boolean send) {
        Messaging.SingleEmailMessage emailToBeSent = null;
        String name = InnovatorConstants.PHASE_TO_TEMPLATE.containsKey(project.ProjectPhase__c) ? InnovatorConstants.PHASE_TO_TEMPLATE.get(project.ProjectPhase__c) : InnovatorConstants.TEMPLATE_NAME_NO_BCA_BCV;
        EmailTemplate emailTemplate = ApprovalProcessRepository.getTemplateByName(name);
        Set<Id> userIds = new Set<Id>();
        if (selectedUserIds == null) {
            if (additionalApprovers) {
                userIds.add(project.AdditionalApprover1__c);
                userIds.add(project.AdditionalApprover2__c);
                userIds.add(project.AdditionalApprover3__c);
                userIds.add(project.AdditionalApprover4__c);
                userIds.add(project.AdditionalApprover5__c);
                userIds.add(project.AdditionalApprover6__c);
                userIds.add(project.AdditionalApprover7__c);
                userIds.add(project.AdditionalApprover8__c);
                userIds.add(project.AdditionalApprover9__c);
                userIds.add(project.AdditionalApprover10__c);
            } else {
                userIds.add(project.Approver_1_For_Current_Milestone__c);
                userIds.add(project.Approver_2_For_Current_Milestone__c);
                userIds.add(project.Approver_3_For_Current_Milestone__c);
                userIds.add(project.Approver_4_For_Current_Milestone__c);
                userIds.add(project.Approver_5_For_Current_Milestone__c);
                userIds.add(project.Approver_6_For_Current_Milestone__c);
                userIds.add(project.Approver_7_For_Current_Milestone__c);
                userIds.add(project.Approver_8_For_Current_Milestone__c);
                userIds.add(project.Approver_9_For_Current_Milestone__c);
                userIds.add(project.Approver_10_For_Current_Milestone__c);
            }
        } else {
            userIds = selectedUserIds;
        }
        List<User> users = ApprovalProcessRepository.getUsersByIds(userIds);
        List<String> toEmails = prepareListOfEmails(users);
        String subject = emailTemplate.Subject;
        String htmlBody = emailTemplate.HtmlValue;
        String recordURL = ProjectUtility.prepareRecordUrl(project.Id);
        String pendingApprovalProjectsTabURL = URL.getOrgDomainUrl().toExternalForm() + '/lightning/n/' + PENDING_APPROVAL_PROJECTS_TAB;
        subject = subject.replace(PROJECT_NUMBER_FIELD, project.ProjectNumberFormula__c);
        subject = subject.replace(PROJECT_NAME_FIELD, project.Name);
        htmlBody = htmlBody.replace(PROJECT_NUMBER_FIELD, project.ProjectNumberFormula__c);
        htmlBody = htmlBody.replace(PROJECT_NAME_FIELD, project.Name);
        if (project.ProjectPhase__c == 'Develop') {
            htmlBody = htmlBody.replace('{!CommercialMilestone}', 'Important: Upon approving this Commercial Milestone, please be aware you are also approving the project\'s Marketing & Commercial launch Plans. These plans can be found in the project\'s Development Document (in the Attachments section in Innovator of the project).');
        } else {
            htmlBody = htmlBody.replace('{!CommercialMilestone}', '');
        }
        htmlBody = htmlBody.replace('{!Project__c.DecisionStep__c}', project.DecisionStep__c);
        htmlBody = htmlBody.replace('{!Project__c.Volume__c}', String.valueOf(project.Volume__c));
        htmlBody = htmlBody.replace('{!Project__c.VolumeComments__c}', project.VolumeComments__c != null ? project.VolumeComments__c : '');
        htmlBody = htmlBody.replace('{!Project__c.TargetCOGs__c}', String.valueOf(project.TargetCOGs__c));
        htmlBody = htmlBody.replace('{!Project__c.TargetOGsComments__c}', project.TargetOGsComments__c != null ? project.TargetOGsComments__c : '');
        htmlBody = htmlBody.replace('{!Project__c.Legal__c}', String.valueOf(project.Legal__c));
        htmlBody = htmlBody.replace('{!Project__c.LegalComments__c}', project.LegalComments__c != null ? project.LegalComments__c : '');
        htmlBody = htmlBody.replace('{!Project__c.TargetLiquidPackExecution__c}', String.valueOf(project.TargetLiquidPackExecution__c));
        htmlBody = htmlBody.replace('{!Project__c.TargetLiquidOrPackExecutionComments__c}', project.TargetLiquidOrPackExecutionComments__c != null ? project.TargetLiquidOrPackExecutionComments__c : '');
        htmlBody = htmlBody.replace('{!Project__c.TargetTimeAtMarket__c}', project.TargetTimeAtMarket__c != null ? String.valueOf(project.TargetTimeAtMarket__c) : '');
        htmlBody = htmlBody.replace('{!Project__c.TargetTimeAtMarketComments__c}', project.TargetTimeAtMarketComments__c != null ? project.TargetTimeAtMarketComments__c : '');
        htmlBody = htmlBody.replace('{!Project__c.TargetOthers__c}', String.valueOf(project.TargetOthers__c));
        htmlBody = htmlBody.replace('{!Project__c.TargetOtherComments__c}', project.TargetOtherComments__c != null ? project.TargetOtherComments__c : '');
        htmlBody = htmlBody.replace('{!Project__c.SummaryOfChangesFromBusinessCase__c}', project.SummaryOfChangesFromBusinessCase__c != null ? project.SummaryOfChangesFromBusinessCase__c : '');
        htmlBody = htmlBody.replace('{!Project__c.ProjectClassification__c}', project.ProjectClassification__c);
        htmlBody = htmlBody.replace('{!Project__c.ProjectLeaderFormula__c}', project.ProjectLeaderFormula__c);
        htmlBody = htmlBody.replace('{!Project__c.TargetOnShelfDateLeadRegion__c}', project.TargetOnShelfDateLeadRegion__c != null ? String.valueOf(project.TargetOnShelfDateLeadRegion__c) : '');
        if (!isReassign) {
            if (String.isNotBlank(submitterComment)) {
                submitterComment = '<br/><br/>' + InnovatorConstants.PROJECT_SUBMITTER_TEXT + ': ' + submitterComment;
                htmlBody = htmlBody.replace('{!ProjectSubmitterComment}', submitterComment);
            } else {
                htmlBody = htmlBody.replace('{!ProjectSubmitterComment}<br/>', '');
            }
            htmlBody = htmlBody.replace('{!ProjectReassignComment}<br/><br/>', '');
        } else {
            ProcessInstance processInstance = ApprovalHistoryRepository.getLastApprovalProcess(project.Id);
            List<ProcessInstanceStep> processInstanceSteps = ApprovalHistoryRepository.getProcessInstanceSteps(processInstance.Id);
            if (processInstanceSteps[0]?.Comments != null && String.isNotBlank(processInstanceSteps[0]?.Comments)) {
                String submitterCommentBeforeReassign = '<br/><br/>' + InnovatorConstants.PROJECT_SUBMITTER_TEXT + ': ' + processInstanceSteps[0]?.Comments;
                htmlBody = htmlBody.replace('{!ProjectSubmitterComment}', submitterCommentBeforeReassign);
            } else {
                htmlBody = htmlBody.replace('{!ProjectSubmitterComment}<br/>', '');
            }
            if (String.isNotBlank(submitterComment)) {
                submitterComment = '<br/>' + InnovatorConstants.PROJECT_REASSIGN_TEXT + ': ' + submitterComment;
                htmlBody = htmlBody.replace('{!ProjectReassignComment}', submitterComment);
            } else {
                htmlBody = htmlBody.replace('{!ProjectReassignComment}<br/><br/>', '');
            }
        }
        htmlBody = htmlBody.replace('{!Project__c.Link}', recordURL);
        htmlBody = htmlBody.replace('{!Project__c.PendingApprovalsLink}', pendingApprovalProjectsTabURL);
        htmlBody = htmlBody.replace('{!BMC__c}<br/>', 'BMC Classification: ' + (project.BMCClassification__c != null ? project.BMCClassification__c : 'N/A') + '<br/>' + 'Market Classification: ' + (project.MarketClassification__c != null ? project.MarketClassification__c : 'N/A') + '<br/>');
        String projectRationale = project.BMCComment__c != null ? 'Project Leader rationale for progressing project considering it is not a priority BMC (i.e. it is a Pebble, Sand or Air BMC): ' + project.BMCComment__c+ '<br/>' : '';
        htmlBody = htmlBody.replace('{!ProjectPriorityJustification__c}<br/>', projectRationale);
        if (String.isNotEmpty(project.FinancialThresholdNotMetComment__c) && InnovatorConstants.PROJECT_CLASSIFICATION_TO_NSV_THRESHOLD.keySet().contains(project.ProjectClassification__c)) {
            String nsvTarget = InnovatorConstants.PROJECT_CLASSIFICATION_TO_NSV_THRESHOLD.get(project.ProjectClassification__c);
            String nsvText = InnovatorConstants.THRESHOLD_NOT_MET_MSG_START + nsvTarget + InnovatorConstants.THRESHOLD_NOT_MET_MSG_END + project.FinancialThresholdNotMetComment__c;
            htmlBody = htmlBody.replace('{!FinancialThresholdNotMetComment__c}', nsvText);
        } else {
            htmlBody = htmlBody.replace('{!FinancialThresholdNotMetComment__c}', '');
        }
        if (project.ActivationProfileTolerance__c != null && (project.ActivationProfileTolerance__c == InnovatorConstants.NO_CONCEPT_VALIDATION_PICKLIST_VALUE || project.ActivationProfileTolerance__c.contains('Stop')) && InnovatorConstants.CONCEPT_VALIDATION_CLASSIFICATION.contains(project.ProjectClassification__c)) {
            String conceptValidationText = InnovatorConstants.CONCEPT_VALIDATION_JUSTIFICATION_MSG_START + project.NoOrStoppedConceptValidationSummary__c;
            htmlBody = htmlBody.replace('{!NoOrStoppedConceptValidationSummary__c}', conceptValidationText);
        } else {
            htmlBody = htmlBody.replace('{!NoOrStoppedConceptValidationSummary__c}<br/><br/>', '');
        }
        if (send) {
            EmailService.sendEmail(toEmails, project.Id, subject, htmlBody);
        } else {
            emailToBeSent = EmailService.createEmail(toEmails, project.Id, subject, htmlBody);
        }
        return emailToBeSent;
    }

    public static void sendEmailForDS(Project__c project, String oldDecisionStep) {
        EmailTemplate emailTemplate = ApprovalProcessRepository.getTemplateByName('Project Approved BCA or BCV');
        Set<Id> userIds = new Set<Id> {project.ProjectLeader__c, project.ProjectManager__c};
        List<User> users = ApprovalProcessRepository.getUsersByIds(userIds);
        List<String> toEmails = prepareListOfEmails(users);
        String subject = emailTemplate.Subject;
        String htmlBody = emailTemplate.Body;
        String recordURL = ProjectUtility.prepareRecordUrl(project.Id);
        subject = subject.replace(PROJECT_NUMBER_FIELD, project.ProjectNumberFormula__c);
        subject = subject.replace(PROJECT_NAME_FIELD, project.Name);
        subject = subject.replace('{!Project__c.DecisionStep__c}', oldDecisionStep);
        htmlBody = htmlBody.replace(PROJECT_NUMBER_FIELD,project.ProjectNumberFormula__c);
        htmlBody = htmlBody.replace(PROJECT_NAME_FIELD, project.Name);
        htmlBody = htmlBody.replace('{!Project__c.ProjectPhase__c}', project.ProjectPhase__c);
        htmlBody = htmlBody.replace('{!Project__c.DecisionStep__c}', oldDecisionStep);
        htmlBody = htmlBody.replace('{!Project__c.ProjectClassification__c}', project.ProjectClassification__c);
        htmlBody = htmlBody.replace('{!Project__c.ProjectLeaderFormula__c}', project.ProjectLeaderFormula__c);
        htmlBody = htmlBody.replace('{Project__c.ProjectManager__c}', project.ProjectManager__c != null ? project.ProjectManagerFormula__c : '');
        htmlBody = htmlBody.replace('{!Project__c.Link}', recordURL);
        htmlBody = htmlBody.replace('{!ApproverComments}', ApprovalProcessService.getApproverComments(project.id, 'Approve'));
        EmailService.sendEmail(toEmails, project.Id, subject, htmlBody);
    }

    public static void sendEmailOnRework(String projectId, String comment) {
        Project__c project = CustomApprovalProcessControlsRepository.getProject(projectId);
        EmailTemplate emailTemplate = ApprovalProcessRepository.getTemplateByName('Project Approval: Rework');
        String recordURL = ProjectUtility.prepareRecordUrl(project.Id);
        Set<Id> userIds = new Set<Id> {project.ProjectLeader__c, project.ProjectManager__c};
        List<User> users = ApprovalProcessRepository.getUsersByIds(userIds);
        List<String> toEmails = prepareListOfEmails(users);
        String subject = emailTemplate.Subject;
        String htmlBody = emailTemplate.Body;
        String decisionStep = project.DecisionStep__c == 'Opportunity' ? 'Opportunity Milestone' : project.DecisionStep__c;
        subject = subject.replace(PROJECT_NUMBER_FIELD, project.ProjectNumberFormula__c);
        subject = subject.replace(PROJECT_NAME_FIELD, project.Name);
        subject = subject.replace('{!Project__c.DecisionStep__c}', decisionStep);
        htmlBody = htmlBody.replace('{!Project__c.ProjectNumberFormula__c}', project.ProjectNumberFormula__c);
        htmlBody = htmlBody.replace('{!Project__c.Name}', project.Name);
        htmlBody = htmlBody.replace('{!Project__c.ProjectClassification__c}', project.ProjectClassification__c);
        htmlBody = htmlBody.replace('{!Project__c.DecisionStep__c}', decisionStep);
        if (project.ProjectLeader__c != null) {
            htmlBody = htmlBody.replace('Project Leader: {!Project__c.ProjectLeader__c}', project.ProjectLeaderFormula__c);
        } else {
            htmlBody = htmlBody.replace('{!Project__c.ProjectLeader__c}', '');
        }
        htmlBody = htmlBody.replace('{!Project__c.ProjectManager__c}', project.ProjectManager__c != null ? project.ProjectManagerFormula__c : '');
        htmlBody = htmlBody.replace('{!Project__c.Link}', recordURL);
        comment = comment.replace('Rework requested by: ', '');
        comment = comment.replace('. \\nComments', '');
        String commentList = '<ul><li>' + comment + '</li></ul>';
        htmlBody = htmlBody.replace('{!ReworkComments}', commentList);
        EmailService.sendEmail(toEmails, project.Id, subject, htmlBody);
    }

    public static void sendEmailToSCDirector(Project__c project, Boolean isSupplyChainDirector, Boolean isMultiRegion, String currentPhase) {
        Set<Id> notificationUsers = new Set<Id>();
        List<String> hubs = new List<String>();
        Id matrixId = Schema.SObjectType.ApprovalMatrix__c.getRecordTypeInfosByDeveloperName().get(MATRIX_RT).getRecordTypeId();
        List<ApprovalMatrix__c> approvalRules = ApprovalMatrixRepository.loadMatrixByType(project.ProjectClassification__c, project.Category__c, project.Brand__c, project.Subrand__c, project.Hub__c, project.Cluster__c, project.LeadMarket__c, project.DC__c, project.TradeType__c, matrixId, FIRST_APPROVAL_STEP);
        Boolean isSecondRegionNotificationsOnly = false;
        Set<Id> leadApproversIds = new Set<Id>();
        if (isSupplyChainDirector) {
            isSecondRegionNotificationsOnly = true;
            String leadRegions = project.Hub__c;
            for (ApprovalMatrix__c rule : approvalRules) {
                Boolean isAMatch = ApprovalMatrixService.matchProjectToRuleMatrixByLeadRegion(project, rule, leadRegions, false);
                if (isAMatch && rule.Approver__c != null && rule.Approver__r.IsActive == true && rule.Approver__r.DelegatedApproverId == null) {
                    leadApproversIds.add(rule.Approver__c);
                } else if (isAMatch && rule.Approver__c != null && rule.Approver__r.IsActive == true && rule.Approver__r.DelegatedApproverId != null) {
                    leadApproversIds.add(rule.Approver__r.DelegatedApproverId);
                }
            }
        }
        for (ApprovalMatrix__c rule : approvalRules) {
            Boolean skipMatching = false;
            if (isSupplyChainDirector && leadApproversIds.contains(rule.Approver__c)) {
                skipMatching = true;
            }
            if (!skipMatching) {
                Boolean isAMatch = ApprovalMatrixService.matchProjectToRuleMatrixNotificationOnly(project, rule, hubs, isSupplyChainDirector, isMultiRegion, currentPhase, isSecondRegionNotificationsOnly);
                if (isAMatch && rule.Approver__c != null && rule.Approver__r.IsActive == true && rule.Approver__r.DelegatedApproverId == null) {
                    notificationUsers.add(rule.Approver__c);
                } else if (isAMatch && rule.Approver__c != null && rule.Approver__r.IsActive == true && rule.Approver__r.DelegatedApproverId != null) {
                    notificationUsers.add(rule.Approver__r.DelegatedApproverId);
                }
            }
        }
        if (notificationUsers.isEmpty()) {
            return;
        }
        ProcessInstance processInstance = ApprovalHistoryRepository.getLastApprovalProcess(project.Id);
        List<ProcessInstanceStep> processInstanceSteps = ApprovalHistoryRepository.getProcessInstanceSteps(processInstance.Id);
        String nextPhase = ProjectUtility.getNextPhaseName(project);
        String decisionStep = project.DecisionStep__c == 'Business Case Ambition' ? 'BCA' : 'BCV';
        String subject = 'Innovator (' + project.ProjectNumberFormula__c + ' - ' + project.Name + ') ' + decisionStep + ' is Passed' ;
        String recordURL = URL.getOrgDomainUrl().toExternalForm() + '/' + project.id;
        String htmlBody = '<p>This is to inform you that project (' + project.ProjectNumberFormula__c + ' - ' + project.Name + ') has passed ' + decisionStep + ' and this is now in ' + nextPhase + '. This notification is an FYI and no further action is required by approvers in Innovator at this time.</p>';
        if (processInstanceSteps[0].Comments != null) {
            htmlBody += '<p>This comment has been added by the project team while submitting the milestone: ' + processInstanceSteps[0].Comments + '</p>';
        }
        htmlBody += '<p>Project classification: ' + project.ProjectClassification__c + '</p>';
        htmlBody += '<p>' + project.ProjectLeaderFormula__c + '</p>';
        if (project.ProjectManager__c != null) {
            htmlBody += '<p>' + project.ProjectManagerFormula__c + '</p>';
        }
        if (project.TargetOnShelfDateLeadRegion__c != null) {
            String targetOnShelfDate = String.valueOf(project.TargetOnShelfDateLeadRegion__c).removeEnd(' 00:00:00');
            htmlBody += '<p>Target on-shelf date: ' + targetOnShelfDate + '</p>';
        }
        htmlBody += '<p>BMC Classification: ' + (project.BMCClassification__c != null ? project.BMCClassification__c : 'N/A') + '</p>';
        htmlBody += '<p>Market Classification: ' + (project.MarketClassification__c != null ? project.MarketClassification__c : 'N/A') + '</p>';
        if (project.BMCComment__c != null) {
            htmlBody += '<p>Project Leader rationale for progressing project considering it is not a priority BMC (i.e. it is a Pebble, Sand or Air BMC): ' + project.BMCComment__c + '</p>';
        }
        htmlBody += '<p>Click here to open the project: ' + recordURL + '</p>';
        EmailService.sendEmail(new List<Id>(notificationUsers), project.Id, subject, htmlBody);
    }

    public static void sendEmailToRegionalLeaders(Project__c project, Project__c oldProject, List<String> recipients, Boolean isMilestoneChangedEmail){
        EmailTemplate emailTemplate = isMilestoneChangedEmail ? ApprovalProcessRepository.getTemplateByName(InnovatorConstants.MILESTONE_PASSED_TO_REGIONAL_LEADERS_EMAIL_TEMPLATE_NAME) : ApprovalProcessRepository.getTemplateByName(InnovatorConstants.LEAD_REGION_EMAIL_TEMPLATE_NAME);
        String subject = '';
        String htmlBody = '';
        String additionalRegions = '';

        if (String.isNotBlank(project.AddAdditionalRegionOrRegions__c)) {
            for (String additionalRegion : project.AddAdditionalRegionOrRegions__c.split(';')) {
                if (project.Region__c != additionalRegion) {
                    additionalRegions += ', ' + additionalRegion;
                }
            }
            additionalRegions = additionalRegions.removeEnd(', ');
        }

        String tradeType = '';
        if (String.isNotEmpty(project.TradeType__c) && project.TradeType__c.contains(InnovatorConstants.ECOMMERCE_TRADE_TYPE)) {
            tradeType = ', ' + InnovatorConstants.ECOMMERCE_TRADE_TYPE;
        }
        String projectLink = Url.getSalesforceBaseUrl().toExternalForm() + '/' + project.Id;

        //replace projects fields with the values
        htmlBody = emailTemplate.HtmlValue.replace('{!Project__c.ProjectNumberFormula__c}', project.ProjectNumberFormula__c);
        htmlBody = htmlBody.replace('{!Project__c.Name}', project.Name);
        if (isMilestoneChangedEmail) {
            subject = emailTemplate.Subject.replace('{!Project__c.DecisionStep__c}', oldProject.DecisionStep__c);
        } else {
            subject = emailTemplate.Subject.replace('{!Project__c.ProjectNumberFormula__c}', project.ProjectNumberFormula__c);
            htmlBody = htmlBody.replace('{!Project__c.ProjectClassification__c}', project.ProjectClassification__c);
        }
        String decisionStep = oldProject.DecisionStep__c == InnovatorConstants.DECISION_STEP_OPPORTUNITY_SHORT ? InnovatorConstants.DECISION_STEP_OPPORTUNITY : oldProject.DecisionStep__c;
        htmlBody = htmlBody.replace('{!Project__c.DecisionStep__c}', decisionStep);
        htmlBody = htmlBody.replace('{!Project__c.Region__c}', project.Region__c);
        htmlBody = htmlBody.replace('{!Project__c.AddAdditionalRegionOrRegions__c}', additionalRegions);
        htmlBody = htmlBody.replace('{!Project__c.TradeType__c}', tradeType);
        htmlBody = htmlBody.replace('{!Project__c.Link}', projectLink);
        EmailService.sendEmail(recipients, project.Id, subject, htmlBody);
    }


    public static void sendEmailToDelegatedApprover(Id currentUserId, Id delegatedUserId, Date startDate, Date endDate) {
        User currentUser = UserRepository.getUserById(currentUserId);
        User delegatedUser = UserRepository.getUserById(delegatedUserId);
        String subject = 'You have been Delegated as an Approver in Innovator whilst an Approver is OOO';
        String htmlBody = '<p>Dear ' + delegatedUser.Name + ',</p>';
        htmlBody += '<p>Please be aware ' + currentUser.Name + ' has delegated approval of any Innovation and Product Modification projects that are submitted into Innovator between ' + ((DateTime)startDate).format('d MMMM YYYY') + ' to ' + ((DateTime)endDate).format('d MMMM YYYY') +', for which they were due to be an Approver of.</p>';
        htmlBody += '<p>You will be responsible for feeding back on these projects (Approval, Re-work or Reject) into the Innovator system. When any project is submitted for approval, you will be notified via an email from Innovator, which will contain a link to the project in the system, from where you can feedback.</p>';
        htmlBody += '<p>Should you have any questions, please click on this link for Approval Help</p><p><a href="' + System.Label.ELearningHowToApproverProjectsLink +'">E-Learning - How to Approve Projects in Innovator.mp4</a></p>';
        EmailService.sendEmail(new List<String> {delegatedUser.Email}, null, subject, htmlBody);
    }

    public static String prepareListOfEmailsAndNames(List<User> users, List<String> toEmails) {
        String result = '';
        for (User user : users) {
            toEmails.add(user.Email);
            result += user.Name + ' ,';
        }
        result = result.substring(0, result.length() - 2);
        return result;
    }

    public static List<String> prepareListOfEmails(List<User> users) {
        List<String> result = new List<String>();
        for (User user : users) {
            result.add(user.Email);
        }
        return result;
    }
}