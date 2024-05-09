/**
 * Test class for the InvocableUpdateProjectStatus and RestUpdateProjectController classes
 * @author      Darya Rykhlik
 * @date        29-08-2023
 */
@IsTest
public class InvocableUpdateProjectStatusTest {

    private static final String PROJECT_CLASSIFICATION_REPACK = 'Repack';
    private static final String STATUS_CHANGE_REASON = 'Status is changed';
    private static final String PROJECT_STATUS_ON_HOLD = 'On hold';
    private static final String PROJECT_STATUS_CANCELLED = 'Cancelled';
    private static final String SUPER_USER = 'Super User';
    private static final String PROJECT_LEADER = 'Project Leader';
    private static final String USER_NAME = 'Tom Smith';

    @TestSetup
    static void testSetup() {
        TestFactory.generateBasicSetUp();
    }

    @IsTest
    static void statusChangeByPL_Test() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{PROJECT_CLASSIFICATION_REPACK}).get(0);

        InvocableUpdateProjectStatus.InputVariables inputVariables = new InvocableUpdateProjectStatus.InputVariables();
        inputVariables.projectId = project.Id;
        inputVariables.reasonForStatusChange = STATUS_CHANGE_REASON;
        inputVariables.projectStatus = PROJECT_STATUS_ON_HOLD;
        inputVariables.userProfileName = PROJECT_LEADER;
        inputVariables.userName = USER_NAME;

        Test.setMock(HttpCalloutMock.class, new RestServiceMock());

        Test.startTest();
        RestService.init();
        List<String> results = InvocableUpdateProjectStatus.updateProjectStatus(new List<InvocableUpdateProjectStatus.InputVariables>{ inputVariables });
        Test.stopTest();
        System.assertEquals('200', results[0]);

        RestUpdateProjectController.updateProjectStatus(inputVariables.projectId, inputVariables.projectStatus, null,
            inputVariables.reasonForStatusChange, inputVariables.userProfileName, inputVariables.userName);

        Project__c updatedProject = [
            SELECT ProjectStatus__c, JustificationForProjectStatusChange__c
            FROM Project__c
            WHERE Id = :inputVariables.projectId
            LIMIT 1
        ];

        System.assertEquals(PROJECT_STATUS_ON_HOLD, updatedProject.ProjectStatus__c);
        System.assertEquals(STATUS_CHANGE_REASON, updatedProject.JustificationForProjectStatusChange__c);
    }
}