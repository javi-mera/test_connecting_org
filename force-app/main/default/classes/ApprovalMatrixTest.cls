@isTest
public class ApprovalMatrixTest {
  private static final String DEFINE_PHASE = 'Define';
  private static final String DESIGN_PHASE = 'Design';
  private static final String PROJECT_CLASSIFICATION_REPACK = 'Repack';
  private static final String COMMENT = 'Project progressed';
  private static final String ACTION = 'Approve';
  private static final String PROJECT_PHASE_MESSAGE = 'Project Phase should be Define is: ';
  public static final String FIRST_APPROVAL_STEP = '1';
  public static final String DUMMY_SUBMIT_COMMENT = 'submit comment';

  @TestSetup
  static void testSetup() {
    TestFactory.generateBasicSetUp();
  }

  @IsTest
  static void approvalMatrixRepackPrimaryPackChangeDiscoverToDefineTest() {
    Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{ PROJECT_CLASSIFICATION_REPACK }).get(0);
    project = ProjectRepository.getProject(project.Id);
	Test.startTest();
    ApprovalMatrixService.fillProjectWithApprovalMatrix(new List<Project__c>{ project }, FIRST_APPROVAL_STEP, DUMMY_SUBMIT_COMMENT, false);
    project = ProjectRepository.getProject(project.Id);
    System.assert(project.ProjectPhase__c == 'Define', PROJECT_PHASE_MESSAGE + project.ProjectPhase__c);
    List<ProcessInstanceWorkitem> pworkList = [
      SELECT Id, OriginalActor.Name, Actor.Name
      FROM ProcessInstanceWorkitem
      WHERE ProcessInstance.targetObjectId = :project.Id
    ];
    Test.stopTest();
  }

  @IsTest
  static void approvalMatrixRepackPrimaryPackChangeDiscoverToDefineApplejacksTest() {
    Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{ PROJECT_CLASSIFICATION_REPACK }).get(0);
	project = ProjectRepository.getProject(project.Id);
	project.Brand__c = 'APPLEJACKS';
    update project;
    Test.startTest();
    ApprovalMatrixService.fillProjectWithApprovalMatrix(
      new List<Project__c>{ project },
      FIRST_APPROVAL_STEP,
      DUMMY_SUBMIT_COMMENT,
      false
    );
    project = ProjectRepository.getProject(project.Id);
    System.assert(
      project.ProjectPhase__c == 'Define',
      PROJECT_PHASE_MESSAGE + project.ProjectPhase__c
    );
    List<ProcessInstanceWorkitem> pworkList = [
      SELECT Id, OriginalActor.Name, Actor.Name
      FROM ProcessInstanceWorkitem
      WHERE ProcessInstance.targetObjectId = :project.Id
    ];
    Test.stopTest();
  }

  @IsTest
  static void approvalMatrixRepackPrimaryPackChangeDefineToDesignTest() {
    Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{ PROJECT_CLASSIFICATION_REPACK }).get(0);
	project = ProjectRepository.getProject(project.Id);
    Test.startTest();
    ApprovalMatrixService.fillProjectWithApprovalMatrix(
      new List<Project__c>{ project },
      FIRST_APPROVAL_STEP,
      DUMMY_SUBMIT_COMMENT,
      false
    );
    project = ProjectRepository.getProject(project.Id);
    List<ProcessInstanceWorkitem> pworkList = [
      SELECT Id, OriginalActor.Name, Actor.Name
      FROM ProcessInstanceWorkitem
      WHERE ProcessInstance.targetObjectId = :project.Id
    ];
    for (ProcessInstanceWorkitem pworkListItem : pworkList) {
      Approval.ProcessWorkitemRequest request = new Approval.ProcessWorkitemRequest();
      request.setComments(COMMENT);
      request.setAction(ACTION);
      request.setWorkitemId(pworkListItem.Id);
      Approval.process(request);
    }
    pworkList = [
      SELECT Id, OriginalActor.Name, Actor.Name
      FROM ProcessInstanceWorkitem
      WHERE ProcessInstance.targetObjectId = :project.Id
    ];
    project = ProjectRepository.getProject(project.Id);
    System.assert(
      project.ProjectPhase__c == 'Define',
      PROJECT_PHASE_MESSAGE + project.ProjectPhase__c
    );
    Test.stopTest();
  }

  @IsTest
  static void approvalMatrixRepackPrimaryPackChangeDesignToDevelopTest() {
    Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{ PROJECT_CLASSIFICATION_REPACK }).get(0);
	project = ProjectRepository.getProject(project.Id);
    Test.startTest();
    ApprovalMatrixService.fillProjectWithApprovalMatrix(
      new List<Project__c>{ project },
      FIRST_APPROVAL_STEP,
      DUMMY_SUBMIT_COMMENT,
      false
    );
    project = ProjectRepository.getProject(project.Id);
    List<ProcessInstanceWorkitem> pworkList = [
      SELECT Id, OriginalActor.Name, Actor.Name
      FROM ProcessInstanceWorkitem
      WHERE ProcessInstance.targetObjectId = :project.Id
    ];
    for (ProcessInstanceWorkitem pworkListItem : pworkList) {
      Approval.ProcessWorkitemRequest request = new Approval.ProcessWorkitemRequest();
      request.setComments(COMMENT);
      request.setAction(ACTION);
      request.setWorkitemId(pworkListItem.Id);
      Approval.process(request);
    }
    pworkList = [
      SELECT Id, OriginalActor.Name, Actor.Name
      FROM ProcessInstanceWorkitem
      WHERE ProcessInstance.targetObjectId = :project.Id
    ];
    project = ProjectRepository.getProject(project.Id);
    System.assert(
      project.ProjectPhase__c == 'Define',
      PROJECT_PHASE_MESSAGE + project.ProjectPhase__c
    );
    Test.stopTest();
  }

  @IsTest
  static void approvalMatrixRepackPrimaryPackChangeDevelopToDeployTest() {
    Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{ PROJECT_CLASSIFICATION_REPACK }).get(0);
	project = ProjectRepository.getProject(project.Id);
	Test.startTest();
    ApprovalMatrixService.fillProjectWithApprovalMatrix(
      new List<Project__c>{ project },
      FIRST_APPROVAL_STEP,
      DUMMY_SUBMIT_COMMENT,
      false
    );
    project = ProjectRepository.getProject(project.Id);
    List<ProcessInstanceWorkitem> pworkList = [
      SELECT Id, OriginalActor.Name, Actor.Name
      FROM ProcessInstanceWorkitem
      WHERE ProcessInstance.targetObjectId = :project.Id
    ];
    for (ProcessInstanceWorkitem pworkListItem : pworkList) {
      Approval.ProcessWorkitemRequest request = new Approval.ProcessWorkitemRequest();
      request.setComments(COMMENT);
      request.setAction(ACTION);
      request.setWorkitemId(pworkListItem.Id);
      Approval.process(request);
    }
    Test.stopTest();
  }

  @IsTest
  static void approvalMatrixRepackPrimaryPackChangeDeployToDiagnoseTest() {
    Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{ PROJECT_CLASSIFICATION_REPACK }).get(0);
	project = ProjectRepository.getProject(project.Id);
    Test.startTest();
    ApprovalMatrixService.fillProjectWithApprovalMatrix(
      new List<Project__c>{ project },
      FIRST_APPROVAL_STEP,
      DUMMY_SUBMIT_COMMENT,
      false
    );
    project = ProjectRepository.getProject(project.Id);
    List<ProcessInstanceWorkitem> pworkList = [
      SELECT Id, OriginalActor.Name, Actor.Name
      FROM ProcessInstanceWorkitem
      WHERE ProcessInstance.targetObjectId = :project.Id
    ];
    for (ProcessInstanceWorkitem pworkListItem : pworkList) {
      Approval.ProcessWorkitemRequest request = new Approval.ProcessWorkitemRequest();
      request.setComments(COMMENT);
      request.setAction(ACTION);
      request.setWorkitemId(pworkListItem.Id);
      Approval.process(request);
    }
    pworkList = [
      SELECT Id, OriginalActor.Name, Actor.Name
      FROM ProcessInstanceWorkitem
      WHERE ProcessInstance.targetObjectId = :project.Id
    ];
    project = ProjectRepository.getProject(project.Id);
    System.assert(
      project.ProjectPhase__c == 'Define',
      PROJECT_PHASE_MESSAGE + project.ProjectPhase__c
    );
    Test.stopTest();
  }
}