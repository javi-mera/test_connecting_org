@isTest
public with sharing class AutoApprovalTriggerHandlerTest {
    
    @TestSetup
    static void testSetup() {
      TestFactory.generateBasicSetUp();
    }

    @IsTest
    static void firePlatformEvent() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(
            new List<String>{ InnovatorConstants.REPACK }
          ).get(0);
        AutoApproval__e event = new AutoApproval__e(Project__c = project.Id, Comment__c = 'dummy comment');
        Test.startTest();
        EventBus.publish(event);
        Test.stopTest();
    }

}