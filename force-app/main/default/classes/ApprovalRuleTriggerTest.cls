@IsTest
public with sharing class ApprovalRuleTriggerTest {

    public static final String FIRST_APPROVAL_STEP = '1';
    public static final String DUMMY_SUBMIT_COMMENT = 'submit comment';
    
    @TestSetup
    static void makeData(){
        TestFactory.generateBasicSetUp();
    }

    @IsTest
    static void beforeUpdateTest() {
        ApprovalMatrix__c approvalMatrix = [SELECT Id, Approver__c FROM ApprovalMatrix__c WHERE DecisionStep__c = 'Opportunity' LIMIT 1];
        User user = [SELECT Id FROM User WHERE FirstName = 'Innovap User 2'];
        Project__c project = [SELECT Id, Approver_1_For_Current_Milestone__c FROM Project__c WHERE ProjectClassification__c = 'Fearless Bet' LIMIT 1];
        Test.startTest();
		Approval.ProcessSubmitRequest submition = new Approval.ProcessSubmitRequest();
		submition.setObjectId(project.Id);
       	User projectManagerUser = [SELECT Id FROM User WHERE FirstName = 'Project Manager 1'];
        project.Approver_1_For_Current_Milestone__c = projectManagerUser.Id;
        project.Approver_2_For_Current_Milestone__c = projectManagerUser.Id;
        project.Approver_3_For_Current_Milestone__c = projectManagerUser.Id;
        project.Approver_4_For_Current_Milestone__c = projectManagerUser.Id;
        project.Approver_5_For_Current_Milestone__c = projectManagerUser.Id;
        project.Approver_6_For_Current_Milestone__c = projectManagerUser.Id;
        project.Approver_7_For_Current_Milestone__c = projectManagerUser.Id;
        project.Approver_8_For_Current_Milestone__c = projectManagerUser.Id;
        project.Approver_9_For_Current_Milestone__c = projectManagerUser.Id;
        project.Approver_10_For_Current_Milestone__c = projectManagerUser.Id;
        project.Approver_11_For_Current_Milestone__c = projectManagerUser.Id;
        project.Approver_12_For_Current_Milestone__c = projectManagerUser.Id;
        project.Approver_13_For_Current_Milestone__c = projectManagerUser.Id;
        project.Approver_14_For_Current_Milestone__c = projectManagerUser.Id;
        project.Approver_15_For_Current_Milestone__c = projectManagerUser.Id;
        project.Approver_16_For_Current_Milestone__c = projectManagerUser.Id;
        project.Approver_17_For_Current_Milestone__c = projectManagerUser.Id;
        project.Approver_18_For_Current_Milestone__c = projectManagerUser.Id;
        project.Approver_19_For_Current_Milestone__c = projectManagerUser.Id;
        project.Approver_20_For_Current_Milestone__c = projectManagerUser.Id;
        update project;
		Approval.ProcessResult result = Approval.process(submition);
        approvalMatrix.Approver__c = user.Id;
        update approvalMatrix;
        Test.stopTest();
    }

}