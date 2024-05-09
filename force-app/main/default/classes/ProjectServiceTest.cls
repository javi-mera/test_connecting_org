@isTest
public class ProjectServiceTest {
  @TestSetup
  static void makeData() {
    TestFactory.generateBasicSetUp();
  }

  @isTest
  static void testUpdateFinancialFilledFields() {
    Project__c project = ProjectRepository.getProjectByProjectClassification(
        new List<String>{ 'Continuous Improvement' }
      )
      .get(0);
    List<Financial__c> financials = new List<Financial__c>{
      FinancialDataRespository.getCIProjectFinancials(project.Id)
    };
    for (Financial__c financial : financials) {
      financial.TotalGP__c = 200;
      financial.AP__c = 20;
    }
    ProjectService.updateFinancialFilledFields(financials, 2, project);

    Assert.areEqual(
      false,
      [SELECT SecondFiscalYearFilled__c FROM Project__c WHERE ID = :project.Id]
      .SecondFiscalYearFilled__c
    );
    Id recordTypeId = Schema.SObjectType.Financial__c.getRecordTypeInfosByDeveloperName()
      .get('FinancialData')
      .getRecordTypeId();
    financials.add(TestFactory.newFinancial(project.Id, recordTypeId, true));
    financials[0].NSVAmbition__c = 100;
    financials[1].NSVAmbition__c = 100;
    ProjectService.updateFinancialFilledFields(financials, 1, project);
    update project;
    Assert.areEqual(
      true,
      [SELECT FifthFiscalYearFilled__c FROM Project__c WHERE ID = :project.Id]
      .FifthFiscalYearFilled__c
    );
  }

  @isTest
  static void testUpdateCriticalKPIFields() {
    Project__c project = ProjectRepository.getProjectByProjectClassification(
        new List<String>{ 'Continuous Improvement' }
      )
      .get(0);
    List<Financial__c> financials = new List<Financial__c>{
      FinancialDataRespository.getCIProjectFinancials(project.Id)
    };
    financials[0].BCAValue__c = null;
    financials[0].BCVVAlue__c = null;
    financials[0].CMValue__c = null;
    financials[0].PMValue__c = null;
    Test.startTest();
    ProjectService.updateCriticalKPIFields(financials, 2, project);
    Test.stopTest();
    Assert.areEqual(
      false,
      [
        SELECT CommercialMilestoneFilled__c
        FROM Project__c
        WHERE ID = :project.Id
      ]
      .CommercialMilestoneFilled__c
    );
  }

  @isTest
  static void testUpdateFinancialFirstYearFilled() {
    Project__c project = ProjectRepository.getProjectByProjectClassification(
        new List<String>{ 'Continuous Improvement' }
      )
      .get(0);
    List<Financial__c> financials = new List<Financial__c>{
      FinancialDataRespository.getCIProjectFinancials(project.Id)
    };
    financials[0].Volume__c = 100;
    financials[0].COGSDecreaseCurrent__c = 100;
    financials[0].COGSIncreaseCurrent__c = 100;
    financials[0].COGSNoChangeCurrent__c = 100;
    financials[0].TotalCOGs__c = 100;
    financials[0].TotalCAPEX__c = 100;
    financials[0].TotalTooling__c = 100;
    financials[0].TotalWriteOffs__c = 100;
    financials[0].TotalOtherOneOffCosts__c = 100;

    ProjectService.updateFinancialFirstYearFilled(
      financials[0],
      project,
      'Mandatory'
    );
    update project;
    Assert.areEqual(
      true,
      [
        SELECT Id, FirstFiscalYearFilled__c
        FROM Project__c
        WHERE ID = :project.Id
      ]
      .FirstFiscalYearFilled__c
    );
    project.FirstFiscalYearFilled__c = false;
    update project;

    financials[0].TotalWorkingCapitalImpact__c = 100;
    financials[0].PaybackTime__c = 100;

    ProjectService.updateFinancialFirstYearFilled(
      financials[0],
      project,
      'test'
    );
    update project;
    Assert.areEqual(
      true,
      [
        SELECT Id, FirstFiscalYearFilled__c
        FROM Project__c
        WHERE ID = :project.Id
      ]
      .FirstFiscalYearFilled__c
    );
  }
}