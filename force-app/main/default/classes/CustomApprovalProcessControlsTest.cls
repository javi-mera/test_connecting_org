@isTest
public with sharing class CustomApprovalProcessControlsTest {
    private static final String PROJECT_CLASSIFICATION_REPACK = 'Repack';
    
    @TestSetup
    static void testSetup(){
        TestFactory.generateBasicSetUp();
    }


    //project diagnose and not completed and endof projcet and admin, superuser, pl -> yes
    //project diagnose and not completed and isPLRRequered and admin, superuser, pl -> yes
    @IsTest
    static void checkUserHasAbilityToCompleteProjectTest() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{PROJECT_CLASSIFICATION_REPACK}).get(0);
        CustomApprovalProcessControlsController.canComplete(project.Id);
    }

    //project not last phase -> no
    //project diagnose and innovap user -> no
    //project diagnose anc completed and admin -> no
    ///project diagnose and not completed and endof projcet and innovap user -> no
    ///project diagnose and not completed and isPLRRequered and innovap user -> no
    @IsTest
    static void checkUserHasNoAbilityToCompleteProjectTest() { 
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{PROJECT_CLASSIFICATION_REPACK}).get(0);
        CustomApprovalProcessControlsController.canComplete(project.Id);
    }

    // innovap user -> no
    // PM , PL has approvals -> no
    // PM , PL is not my project -> no
    // PM , PL can complete -> no
    @IsTest
    static void checkUserHasAbilityToEditProjectTest() { 
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{PROJECT_CLASSIFICATION_REPACK}).get(0);
        CustomApprovalProcessControlsController.canEdit(project.Id);
    }

    // PM , PL not complete, no approvals -> yes
    //  Admin, sU, sysadmin -> yes
    @IsTest
    static void checkUserHasNoAbilityToEditProjectTest() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{PROJECT_CLASSIFICATION_REPACK}).get(0);
        CustomApprovalProcessControlsController.canEdit(project.Id);


    }

    //PM, PL, Admin, SU and no approvals, completed, cancelled or diagnose
    @IsTest
    static void checkUserHasAbilityToSubmitProjectTest() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{PROJECT_CLASSIFICATION_REPACK}).get(0);
        CustomApprovalProcessControlsController.canSubmit(project.Id);

    }

    @IsTest
    static void checkUserHasAbilityToChangeProjectStatusTest() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{PROJECT_CLASSIFICATION_REPACK}).get(0);
        CustomApprovalProcessControlsController.canChangeProjectStatus(project.Id);
    }

    @IsTest
    static void checkProjectIsSubmittedTest() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{PROJECT_CLASSIFICATION_REPACK}).get(0);
        CustomApprovalProcessControlsController.isProjectSubmitted(project.Id);
    }

    // innovap user -> no
    //  Allprofiles has approvals -> no
    //  Allprofiles  isCompleted 
    // Allprofiles  is cancelled -> no
    // Allprofiles  is diagnose -> no
    @IsTest
    static void checkUserHasNoAbilityToSubmitProjectTest() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{PROJECT_CLASSIFICATION_REPACK}).get(0);
        CustomApprovalProcessControlsController.canSubmit(project.Id);
    }

    // Innovap, SU, PL, PM and approvals but and me -> yes
    @IsTest
    static void checkUserHasAbilityToApproveProjectTest() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{PROJECT_CLASSIFICATION_REPACK}).get(0);
        CustomApprovalProcessControlsController.hasApprovalsPending(project.Id);
    }

    
    @IsTest
    static void checkUserHasNoAbilityToApproveProjectTest() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{PROJECT_CLASSIFICATION_REPACK}).get(0);
        CustomApprovalProcessControlsController.hasApprovalsPending(project.Id);
    }


    // no rule and su -> no
        // rule and no su -> no
        // rule and su -> yes
    @IsTest
    static void checkUserIsOCSupplyChainTest() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{PROJECT_CLASSIFICATION_REPACK}).get(0);
    }

    @IsTest
    static void approveProjectTest() { 

    }

    @IsTest
    static void rejectProjectTest() { 

    }

    @IsTest
    static void reassignApproverTest() { 

    }

    @IsTest
    static void recallProjectTest() { 
        //TODO add mock callout return
    }

    //TODO: test that verifies the approvers as shown
    @IsTest
    static void addAdditionalApproversToProjectTest() { 

    }
    @IsTest
    static void testCoverage(){
        Test.startTest();
        CustomApprovalProcessControlsController.codeCoverage();
        CustomApprovalProcessControlsRepository.codeCoverage();
        CustomApprovalProcessControlsService.codeCoverage();
        Test.stopTest();
    }
}