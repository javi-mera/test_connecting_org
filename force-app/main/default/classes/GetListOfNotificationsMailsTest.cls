@IsTest
public class GetListOfNotificationsMailsTest {

    private static final String PROJECT_CLASSIFICATION_REPACK = 'Repack';

    @TestSetup
    static void testSetup(){
        TestFactory.generateBasicSetUp();
    }

    @IsTest
    static void getListOfNotifiactionEmailsTest() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{PROJECT_CLASSIFICATION_REPACK}).get(0);
        GetListOfNotificationMails.getListOfNotifiactionEmails(new List<Project__c> { project });
    }

}