@IsTest
public with sharing class OnHoldCounterServiceTest {
  @TestSetup
  static void makeData() {
    TestFactory.generateBasicSetUp();
  }

  @IsTest
  static void setProjectToOnHoldTest() {
    Project__c oldProject = ProjectRepository.getProjectByProjectClassification(
        new List<String>{ 'Continuous Improvement' }
      )
      .get(0);
    Project__c newProject = oldProject.clone(false, false, false, false);
    newProject.ProjectStatus__c = InnovatorConstants.PROJECT_STATUS_ON_HOLD;
    OnHoldCounterService.setOnHoldRelatedFields(oldProject, newProject);
    Assert.isTrue(newProject.OnHoldStartDate__c != null);
  }

  @IsTest
  static void setProjectToActiveTest() {
    Project__c oldProject = ProjectRepository.getProjectByProjectClassification(
        new List<String>{ 'Continuous Improvement' }
      )
      .get(0);
    Project__c newProject = oldProject.clone(false, false, false, false);
    oldProject.ProjectStatus__c = InnovatorConstants.PROJECT_STATUS_ON_HOLD;
    OnHoldCounterService.setOnHoldRelatedFields(oldProject, newProject);
    Assert.isTrue(newProject.OnHoldStartDate__c == null);
  }
}