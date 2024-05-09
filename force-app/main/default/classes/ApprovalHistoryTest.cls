@IsTest
public class ApprovalHistoryTest {
    
    private static final String APPROVAL_HISTORICAL_DATA = '{"Business Case Validation":{"David Lewis":"Commercial Director","Andres Smith":"Rgl CFO","Roberto McThompson":"Rgl Marketing VP","Pamela Lion":"Rgl Supply Chain VP","Business Case Validation Meeting":"Inno Decision Meeting (Admin on behalf)"},"Commercial":{"David Steward":"Commercial Director","Andres Roberts":"Rgl CFO","Roberto Simon":"Rgl Marketing VP","Sean Paulson":"Commercial Director","Olivier Smith":"OC Director","Jennifer Eniston":"Brand VP","Jennifer Lewis":"Rgl CFO","Alexander McAvoy":"Rgl Marketing VP"}}';

    @IsTest
    static void statusAdjustmentForReworkStepsTest() {
        Id projectLeaderProfileId = [SELECT Id FROM Profile WHERE Name = :InnovatorConstants.PROJECT_LEADER_USER_PROFILE LIMIT 1].Id;
        Id projectManagerProfileId = [SELECT Id FROM Profile WHERE Name = :InnovatorConstants.PROJECT_MANAGER_USER_PROFILE LIMIT 1].Id;
        User projectLeader = TestFactory.newUser('Project Leader', projectLeaderProfileId, true);
        User projectManager = TestFactory.newUser('Project Manager', projectManagerProfileId, true);
        CustomTeams__Teams__c team = TestFactory.newCustomTeam('Fearless Bet Project Team', true);
        Project__c project = TestFactory.newProject(
            'Fearless Bet Project', 
        	InnovatorConstants.FEARLESS_BET,
        	InnovatorConstants.DISCOVER_PHASE,
        	projectLeader,
        	projectManager,
        	team,
        	false
        );
        project.approvalStepName__c = '[{"stepName":"Business Case Validation","stepIds":["04i8E000001MPrVQAW","04i8E000001MPrWQAW","04g8E000001CfwbQAC"],"pid":"04g8E000001CfwbQAC"}]';
        project.ApprovalReassignmentComment__c = '[{"stepId":"04i8E000001MPrVQAW","pid":"04g8E000001CfwbQAC","oldUser":"0057Q000007f8bFQAQ","newUser":"0057Q000007fA0AQAU","comment":"test"}]';
        insert project;
        ApprovalHistory.CustomApprovalHistory customApprovalHistory = new ApprovalHistory.CustomApprovalHistory();
        customApprovalHistory.stepId = 'Test';
        customApprovalHistory.comment = '\\:Test\\,Hello';
        customApprovalHistory.actualApproverName = 'Test';
        customApprovalHistory.originalActorName = 'Test';
        customApprovalHistory.status = 'Rework';
        List<ApprovalHistory.CustomApprovalHistory> approvalHistories = new List<ApprovalHistory.CustomApprovalHistory> { customApprovalHistory };
        Map<String, String> stepNames = ApprovalHistory.prepareStepNameMap(project);
        Map<String, String> reassignCommentMap = ApprovalHistory.prepareReassignCommentMap(project);
        ProcessInstance processInstance = new ProcessInstance();
        List<ProcessInstance> processInstances = new List<ProcessInstance> { processInstance };
        Test.startTest();
        ApprovalHistory.statusAdjustmentForReworkSteps(new Map<String, List<ApprovalHistory.CustomApprovalHistory>> { '04g8E000001CfwbQAC' => approvalHistories });
        Test.stopTest();
    }
    
    @IsTest
    static void parseReworkCommentTest() {
        ApprovalHistory.parseReworkComment('Rework requested by: Nuvolar Admin. Comments: asd');
    }
    
    @IsTest
    static void addHistoricalDataTest() {
        Id projectLeaderProfileId = [SELECT Id FROM Profile WHERE Name = :InnovatorConstants.PROJECT_LEADER_USER_PROFILE LIMIT 1].Id;
        Id projectManagerProfileId = [SELECT Id FROM Profile WHERE Name = :InnovatorConstants.PROJECT_MANAGER_USER_PROFILE LIMIT 1].Id;
        User projectLeader = TestFactory.newUser('Project Leader', projectLeaderProfileId, true);
        User projectManager = TestFactory.newUser('Project Manager', projectManagerProfileId, true);
        CustomTeams__Teams__c team = TestFactory.newCustomTeam('Fearless Bet Project Team', true);
        Project__c project = TestFactory.newProject(
            'Fearless Bet Project', 
        	InnovatorConstants.FEARLESS_BET,
        	InnovatorConstants.DISCOVER_PHASE,
        	projectLeader,
        	projectManager,
        	team,
        	false
        );
        project.ApprovalHistoricalData__c = '[{"projectNumber":1004109,"phase":"Define","email":"' + projectLeader.Email + '","comments":null,"status":"Approved","delegatedTo":null,"createdDate":"2022-06-03 17:16:55"}, {"projectNumber":1004109,"phase":"Define","email":"test@email.com","comments":null,"status":"Approved","delegatedTo":"' + projectLeader.Email + '","createdDate":"2022-06-03 17:16:55"}]';
        insert project;
        ApprovalHistory.CustomApprovalHistory customApprovalHistory = new ApprovalHistory.CustomApprovalHistory();
        customApprovalHistory.stepId = 'Test';
        customApprovalHistory.comment = '\\:Test\\,Hello';
        List<ApprovalHistory.CustomApprovalHistory> approvalHistories = new List<ApprovalHistory.CustomApprovalHistory> { customApprovalHistory };
        Test.startTest();
        ApprovalHistory.addHistoricalData(approvalHistories, project.Id);
        Test.stopTest();
    }
    
	@IsTest
    static void fillCustomApprovalObjectTest() {        
        Id projectLeaderProfileId = [SELECT Id FROM Profile WHERE Name = :InnovatorConstants.PROJECT_LEADER_USER_PROFILE LIMIT 1].Id;
        Id projectManagerProfileId = [SELECT Id FROM Profile WHERE Name = :InnovatorConstants.PROJECT_MANAGER_USER_PROFILE LIMIT 1].Id;
        User projectLeader = TestFactory.newUser('Project Leader', projectLeaderProfileId, true);
        User projectManager = TestFactory.newUser('Project Manager', projectManagerProfileId, true);
        CustomTeams__Teams__c team = TestFactory.newCustomTeam('Fearless Bet Project Team', true);
        Project__c project = TestFactory.newProject(
            'Fearless Bet Project', 
        	InnovatorConstants.FEARLESS_BET,
        	InnovatorConstants.DISCOVER_PHASE,
        	projectLeader,
        	projectManager,
        	team,
        	false
        );
        project.approvalStepName__c = '[{"stepName":"Business Case Validation","stepIds":["04i8E000001MPrVQAW","04i8E000001MPrWQAW","04g8E000001CfwbQAC"],"pid":"04g8E000001CfwbQAC"}]';
        project.ApprovalReassignmentComment__c = '[{"stepId":"04i8E000001MPrVQAW","pid":"04g8E000001CfwbQAC","oldUser":"0057Q000007f8bFQAQ","newUser":"0057Q000007fA0AQAU","comment":"test"}]';
        project.ApprovalHistoricalData__c = APPROVAL_HISTORICAL_DATA;
        insert project;
        ApprovalHistory.CustomApprovalHistory customApprovalHistory = new ApprovalHistory.CustomApprovalHistory();
        customApprovalHistory.stepId = 'Test';
        customApprovalHistory.comment = '\\:Test\\,Hello';
        List<ApprovalHistory.CustomApprovalHistory> approvalHistories = new List<ApprovalHistory.CustomApprovalHistory> { customApprovalHistory };
        Map<String, String> stepNames = ApprovalHistory.prepareStepNameMap(project);
        Map<String, String> reassignCommentMap = ApprovalHistory.prepareReassignCommentMap(project);
        Map<String, String> stepsToParse = new Map<String, String> { 
            'Test' => '04g8E000001CfwbQAC'
        };
        Map<String, String> stepStatusMap = ApprovalHistory.getStepStatusList();
        ProcessInstance processInstance = new ProcessInstance();
        ProcessInstanceHistory processInstanceHistory = new ProcessInstanceHistory();
        Test.startTest();
        ApprovalHistory.fillCustomApprovalObject(processInstanceHistory, processInstance, stepsToParse, stepNames, stepStatusMap, reassignCommentMap);
        Test.stopTest();
    }

    @IsTest
    static void prepareCustomApprovalHistoryListTest() {
        Id projectLeaderProfileId = [SELECT Id FROM Profile WHERE Name = :InnovatorConstants.PROJECT_LEADER_USER_PROFILE LIMIT 1].Id;
        Id projectManagerProfileId = [SELECT Id FROM Profile WHERE Name = :InnovatorConstants.PROJECT_MANAGER_USER_PROFILE LIMIT 1].Id;
        User projectLeader = TestFactory.newUser('Project Leader', projectLeaderProfileId, true);
        User projectManager = TestFactory.newUser('Project Manager', projectManagerProfileId, true);
        CustomTeams__Teams__c team = TestFactory.newCustomTeam('Fearless Bet Project Team', true);
        Project__c project = TestFactory.newProject(
            'Fearless Bet Project', 
        	InnovatorConstants.FEARLESS_BET,
        	InnovatorConstants.DISCOVER_PHASE,
        	projectLeader,
        	projectManager,
        	team,
        	false
        );
        project.approvalStepName__c = '[{"stepName":"Business Case Validation","stepIds":["04i8E000001MPrVQAW","04i8E000001MPrWQAW","04g8E000001CfwbQAC"],"pid":"04g8E000001CfwbQAC"}]';
        project.ApprovalReassignmentComment__c = '[{"stepId":"04i8E000001MPrVQAW","pid":"04g8E000001CfwbQAC","oldUser":"0057Q000007f8bFQAQ","newUser":"0057Q000007fA0AQAU","comment":"test"}]';
        project.ApprovalHistoricalData__c = APPROVAL_HISTORICAL_DATA;
        insert project;
        ApprovalHistory.CustomApprovalHistory customApprovalHistory = new ApprovalHistory.CustomApprovalHistory();
        customApprovalHistory.stepId = 'Test';
        customApprovalHistory.comment = '\\:Test\\,Hello';
        List<ApprovalHistory.CustomApprovalHistory> approvalHistories = new List<ApprovalHistory.CustomApprovalHistory> { customApprovalHistory };
        Map<String, String> stepNames = ApprovalHistory.prepareStepNameMap(project);
        Map<String, String> reassignCommentMap = ApprovalHistory.prepareReassignCommentMap(project);
        ProcessInstance processInstance = new ProcessInstance();
        List<ProcessInstance> processInstances = new List<ProcessInstance> { processInstance };
        Test.startTest();
        ApprovalHistory.prepareCustomApprovalHistoryList(processInstances, new Map<String, List<ApprovalHistory.CustomApprovalHistory>> { '04g8E000001CfwbQAC' => approvalHistories }, stepNames, reassignCommentMap);
        Test.stopTest();
    }
    
    @IsTest
    static void parseAutoApprovalHistoryCommentTest() {
        Id projectLeaderProfileId = [SELECT Id FROM Profile WHERE Name = :InnovatorConstants.PROJECT_LEADER_USER_PROFILE LIMIT 1].Id;
        Id projectManagerProfileId = [SELECT Id FROM Profile WHERE Name = :InnovatorConstants.PROJECT_MANAGER_USER_PROFILE LIMIT 1].Id;
        User projectLeader = TestFactory.newUser('Project Leader', projectLeaderProfileId, true);
        User projectManager = TestFactory.newUser('Project Manager', projectManagerProfileId, true);
        CustomTeams__Teams__c team = TestFactory.newCustomTeam('Fearless Bet Project Team', true);
        Project__c project = TestFactory.newProject(
            'Fearless Bet Project', 
        	InnovatorConstants.FEARLESS_BET,
        	InnovatorConstants.DISCOVER_PHASE,
        	projectLeader,
        	projectManager,
        	team,
        	false
        );
        project.approvalStepName__c = '[{"stepName":"Business Case Validation","stepIds":["04i8E000001MPrVQAW","04i8E000001MPrWQAW","04g8E000001CfwbQAC"],"pid":"04g8E000001CfwbQAC"}]';
        project.ApprovalReassignmentComment__c = '[{"stepId":"04i8E000001MPrVQAW","pid":"04g8E000001CfwbQAC","oldUser":"0057Q000007f8bFQAQ","newUser":"0057Q000007fA0AQAU","comment":"test"}]';
        insert project;
        ApprovalHistory.CustomApprovalHistory customApprovalHistory = new ApprovalHistory.CustomApprovalHistory();
        customApprovalHistory.stepId = 'Test';
        customApprovalHistory.comment = '\\:Test\\,Hello';
        List<ApprovalHistory.CustomApprovalHistory> approvalHistories = new List<ApprovalHistory.CustomApprovalHistory> { customApprovalHistory };
        Map<String, String> stepNames = ApprovalHistory.prepareStepNameMap(project);
        Map<String, String> reassignCommentMap = ApprovalHistory.prepareReassignCommentMap(project);
        Map<String, String> stepsToParse = new Map<String, String> { 
            'Test' => '04g8E000001CfwbQAC'
        };
        Test.startTest();
        ApprovalHistory.parseAutoApprovalHistoryComment(new Map<String, List<ApprovalHistory.CustomApprovalHistory>> { '04g8E000001CfwbQAC' => approvalHistories }, stepsToParse, project);
        Test.stopTest();
    }
    
    @IsTest
    static void parseAutoApprovalCommentToGetUserListTest() {
        ApprovalHistory.CustomApprovalHistory customApprovalHistory = new ApprovalHistory.CustomApprovalHistory();
        customApprovalHistory.stepId = 'Test';
        customApprovalHistory.comment = '\\:Test\\,Hello';
        List<ApprovalHistory.CustomApprovalHistory> approvalHistories = new List<ApprovalHistory.CustomApprovalHistory> { customApprovalHistory };
        Test.startTest();
        List<String> userIds = ApprovalHistory.parseAutoApprovalCommentToGetUserList(approvalHistories, 'Test');
        Test.stopTest();
    }

}