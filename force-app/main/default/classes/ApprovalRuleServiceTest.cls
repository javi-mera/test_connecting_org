@IsTest
public class ApprovalRuleServiceTest {

    @TestSetup
    static void makeData() {
        TestFactory.generateBasicSetUp();
    }
    
    @isTest
    static void testPrepareApproverChangeMap() {
        List<ApprovalMatrix__c> approvalMatrixes = [
            SELECT Id
            FROM ApprovalMatrix__c
        ];
        User user = [SELECT Id FROM User WHERE FirstName = 'Project Manager 1'];
        for (ApprovalMatrix__c approvalMatrix : approvalMatrixes) {
            approvalMatrix.Approver__c = user.Id;
            approvalMatrix.DecisionStep__c = 'Business Case Ambition';
            approvalMatrix.ProjectClassification__c = 'Repack';
        }
        update approvalMatrixes;
    }
    
    @isTest
    static void testConfigApprovalMatrixes() {
        List<ApprovalMatrix__c> approvalMatrixes = [
            SELECT
                Id,
                ProjectClassification__c,
                ProjectClassificationSubtype__c,
                Category__c,
                Brand__c,
                SubBrand__c,
                Hub__c,
                Cluster__c,
                LeadMarket__c,
                TradeTypeExactMatch__c,
                TradeType__c,
                DistributionChannel__c,
                Approver__c
            FROM ApprovalMatrix__c
        ];
        for (ApprovalMatrix__c approvalMatrixe : approvalMatrixes) {
            approvalMatrixe.ProjectClassification__c = 'Business Enabler';
        }
        update approvalMatrixes;
        Id matrixId = Schema.SObjectType.ApprovalMatrix__c.getRecordTypeInfosByDeveloperName().get(ApprovalMatrixService.MATRIX_RT).getRecordTypeId();
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{ 'Continuous Improvement' }).get(0);
        User user = [SELECT Id FROM User LIMIT 1];
        project.ApprovalProcessStatus__c = 'Submitted';
        project.ProjectClassification__c = 'Business Enabler';
        project.AdditionalApprover4__c = user.Id;
        project.AdditionalApprover5__c = user.Id;
        project.AdditionalApprover6__c = user.Id;
        project.AdditionalApprover7__c = user.Id;
        project.AdditionalApprover8__c = user.Id;
        project.AdditionalApprover9__c = user.Id;
        update project;
        String approvalStep = project.ApprovalProcessStatus__c == 'Submitted' ? '1' : '2';
        Set<Project__c> projectsToUpdate = new Set<Project__c>();
        ApprovalRuleService.configApprovalMatrixes(approvalMatrixes, project, approvalStep, matrixId, projectsToUpdate, null, null);
    }
}