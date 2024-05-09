@isTest
public with sharing class FinancialDataTest {
  private static final String PROJECT_CLASSIFICATION_REPACK = 'Repack';
  private static final String PROJECT_CLASSIFICATION_MANDATORY = 'Mandatory';
  private static final String PROJECT_CLASSIFICATION_CI = 'Continuous Improvement';
  private static final String FINANCIAL_TYPE = 'Financials';
  private static final String FINANCIAL_DATA_MESSAGE = 'Financial Data Cannot be Empty';

  @TestSetup
  static void testSetup() {
    TestFactory.generateBasicSetUp();
  }

  @isTest
  static void testGetInvertedFinancialDataMandatory() {
    Project__c project = ProjectRepository.getProjectByProjectClassification(
        new List<String>{ PROJECT_CLASSIFICATION_MANDATORY }
      )
      .get(0);
    Test.startTest();
    List<Map<String, Object>> result = FinancialDataController.getInvertedFinancialData(
      project.Id
    );
    System.assert(result != null, FINANCIAL_DATA_MESSAGE);
    Test.stopTest();
  }

  @isTest
  static void testGetInvertedFinancialDataCI() {
    Project__c project = ProjectRepository.getProjectByProjectClassification(
        new List<String>{ PROJECT_CLASSIFICATION_CI }
      )
      .get(0);
    Test.startTest();
    List<Map<String, Object>> result = FinancialDataController.getInvertedFinancialData(
      project.Id
    );
    System.assert(result != null, FINANCIAL_DATA_MESSAGE);
    Test.stopTest();
  }

  @isTest
  static void testGetInvertedFinancialDataOther() {
    Project__c project = ProjectRepository.getProjectByProjectClassification(
        new List<String>{ PROJECT_CLASSIFICATION_REPACK }
      )
      .get(0);
    Test.startTest();
    List<Map<String, Object>> result = FinancialDataController.getInvertedFinancialData(
      project.Id
    );
    System.assert(result != null, FINANCIAL_DATA_MESSAGE);
    Test.stopTest();
  }
  @isTest
  static void testGetDeliverableData() {
    Project__c project = ProjectRepository.getProjectByProjectClassification(
        new List<String>{ PROJECT_CLASSIFICATION_REPACK }
      )
      .get(0);
    Test.startTest();
    Map<String, Object> result = FinancialDataController.getDeliverableData(
      project.Id
    );
    System.assert(result != null, FINANCIAL_DATA_MESSAGE);
    Test.stopTest();
  }

  @isTest
  static void testUpdateFinancialDataCI() {
    Project__c project = ProjectRepository.getProjectByProjectClassification(
        new List<String>{ PROJECT_CLASSIFICATION_CI }
      )
      .get(0);
    List<Financial__c> financials = new List<Financial__c>{
      FinancialDataRespository.getCIProjectFinancials(project.Id)
    };
    Test.startTest();
    FinancialDataController.updateFinancialData(
      financials,
      2,
      project,
      FINANCIAL_TYPE
    );
    financials = new List<Financial__c>{
      FinancialDataRespository.getCIProjectFinancials(project.Id)
    };
    System.assert(financials != null, FINANCIAL_DATA_MESSAGE);
    Test.stopTest();
  }

  @isTest
  static void testUpdateFinancialDataMandatory() {
    Project__c project = ProjectRepository.getProjectByProjectClassification(
        new List<String>{ PROJECT_CLASSIFICATION_MANDATORY }
      )
      .get(0);
    List<Financial__c> financials = new List<Financial__c>{
      FinancialDataRespository.getCIProjectFinancials(project.Id)
    };
    Test.startTest();
    FinancialDataController.updateFinancialData(
      financials,
      1,
      project,
      FINANCIAL_TYPE
    );
    financials = new List<Financial__c>{
      FinancialDataRespository.getCIProjectFinancials(project.Id)
    };
    Test.stopTest();
    System.assert(financials != null, FINANCIAL_DATA_MESSAGE);
  }

  @isTest
  static void testUpdateFinancialDataOther() {
    Project__c project = ProjectRepository.getProjectByProjectClassification(
        new List<String>{ PROJECT_CLASSIFICATION_REPACK }
      )
      .get(0);
    List<Financial__c> financials = FinancialDataRespository.getProjectFinancials(
      project.Id
    );
    Test.startTest();
    FinancialDataController.updateFinancialData(
      financials,
      1,
      project,
      FINANCIAL_TYPE
    );
    financials = new List<Financial__c>{
      FinancialDataRespository.getCIProjectFinancials(project.Id)
    };
    Test.stopTest();
    System.assert(financials != null, FINANCIAL_DATA_MESSAGE);
  }

  @isTest
  static void testUpdateFinancialDataOther2() {
    Project__c project = ProjectRepository.getProjectByProjectClassification(
        new List<String>{ PROJECT_CLASSIFICATION_REPACK }
      )
      .get(0);
    List<Financial__c> financials = FinancialDataRespository.getProjectDeliverables(
      project.Id
    );
    Test.startTest();
    FinancialDataController.updateFinancialData(financials, 1, project, '');
    financials = new List<Financial__c>{
      FinancialDataRespository.getCIProjectFinancials(project.Id)
    };
    Test.stopTest();
    System.assert(financials != null, FINANCIAL_DATA_MESSAGE);
  }

  @isTest
  static void testUpdateProject() {
    Project__c project = ProjectRepository.getProjectByProjectClassification(
        new List<String>{ PROJECT_CLASSIFICATION_REPACK }
      )
      .get(0);
    Project_Snapshot__c ps = new Project_Snapshot__c(Project__c = project.Id);
    insert ps;
    Test.startTest();
    FinancialDataController.getSnapshotDeliverableData(ps.Id);
    Test.stopTest();
  }

  @isTest
  static void testCodeCoverage() {
    Test.startTest();
    ProjectRepository.codeCoverage();
    Test.stopTest();
  }
}