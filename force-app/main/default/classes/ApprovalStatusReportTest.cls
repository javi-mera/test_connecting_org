@isTest
public with sharing class ApprovalStatusReportTest {

    private static final String DEFINE_PHASE = 'Define';
    private static final String DESIGN_PHASE = 'Design';
    private static final String PROJECT_CLASSIFICATION_REPACK = 'Repack';

    @TestSetup
    static void testSetup() {
        TestFactory.generateBasicSetUp();
    }

    @isTest
    public static void testApprovalStatusReport() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{
            PROJECT_CLASSIFICATION_REPACK
        }).get(0);
        Test.startTest();
        ApprovalMatrixService.fillProjectWithApprovalMatrix(new List<Project__c>{
            project
        }, '1', '', false);
        project = ProjectRepository.getProject(project.Id);
        List<ProcessInstanceWorkitem> pworkList = [SELECT Id, OriginalActor.Name, Actor.Name FROM ProcessInstanceWorkitem WHERE ProcessInstance.targetObjectId = :project.Id];
        Test.stopTest();
        ApprovalStatusReportScheduler approvalStatusReportScheduler = new ApprovalStatusReportScheduler();
        approvalStatusReportScheduler.execute(null);
    }

    @isTest
    public static void testApprovalStatusReportCodeCoverage() {
        ApprovalStatusReport.getSiteUrl();
    }
}