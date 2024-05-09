/**
 * @author - Darya Rykhlik
 * @date - 17 Oct 2023
 * @description - The class to test the PromoPackProjectRationaleUpdateBatch and PromoPackTaskListUpdateBatch logic
 */

@IsTest
private class PromoPackUpdatesBatchTest {
    private static final String PROMOTIONAL_PACK_CLASSIFICATION = 'Promotional Pack';
    private static final String OPPORTUNITY_TEXT = 'Test Opportunity Text';
    private static final String OPPORTUNITY_CONTEXT_TEXT = 'Test Opportunity Context Text';
    private static final String NECK_TAG_SUBTYPE = 'Neck Tag';
    private static final String BCA_DECISION_STEP = 'Business Case Ambition';
    private static final String ACTIVE_STATUS = 'Active';

    @TestSetup
    static void setup() {
        TestFactory.generateBasicSetUp();

        List<Project__c> projects = [
            SELECT TaskList__c, DecisionRequired__c, DecisionStep__c, ProjectClassification__c, ProjectClassificationSubtype__c,
                   Complexity__c, Opportunity__c, OpportunityContextConsumerRationale__c, ProjectRationale__c
            FROM Project__c
            WHERE ProjectClassification__c =: PROMOTIONAL_PACK_CLASSIFICATION
        ];

        for (Project__c project : projects) {
            project.Opportunity__c = OPPORTUNITY_TEXT;
            project.OpportunityContextConsumerRationale__c = OPPORTUNITY_CONTEXT_TEXT;
            project.ProjectClassificationSubtype__c = NECK_TAG_SUBTYPE;
            project.DecisionStep__c = BCA_DECISION_STEP;
            project.ProjectStatus__c = ACTIVE_STATUS;
        }
        update projects;
    }

    @IsTest
    static void updateProjectRationaleFieldTest(){
        Test.startTest();
        Database.executeBatch(new PromoPackProjectRationaleUpdateBatch());
        Test.stopTest();

        List<Project__c> projects = [
            SELECT Opportunity__c, OpportunityContextConsumerRationale__c, ProjectRationale__c
            FROM Project__c
            WHERE ProjectClassification__c =: PROMOTIONAL_PACK_CLASSIFICATION
        ];

        for (Project__c project : projects) {
            System.assertEquals(OPPORTUNITY_TEXT + '. ' + OPPORTUNITY_CONTEXT_TEXT, project.ProjectRationale__c);
        }
    }

    @IsTest
    static void updateTaskListTest(){
        Test.startTest();
        Database.executeBatch(new PromoPackTaskListUpdateBatch());
        Test.stopTest();

        List<Project__c> projects = [
            SELECT TaskList__c, DecisionRequired__c, DecisionStep__c, ProjectClassification__c, ProjectClassificationSubtype__c,
                   Complexity__c
            FROM Project__c
            WHERE ProjectClassification__c =: PROMOTIONAL_PACK_CLASSIFICATION
        ];

        List<Decision_Required__mdt> decisionRequiredList = DecisionRequiredMetadataUpdateRepository.getAllMetadata();

        for (Decision_Required__mdt dr : decisionRequiredList) {
            for (Project__c project : projects) {
                if(dr.DecisionStep__c == project.DecisionStep__c &&
                    project.ProjectClassification__c == dr.ProjectClassification__c &&
                    dr.Complexity__c == project.Complexity__c &&
                    (dr.ProjectClassificationSubtype__c == project.ProjectClassificationSubtype__c)) {
                    System.assertEquals(dr.TaskList__c.stripHtmlTags(), project.TaskList__c.stripHtmlTags());
                    System.assertEquals(dr.DecisionRequired__c.stripHtmlTags(), project.DecisionRequired__c.stripHtmlTags());
                }
            }
        }
    }
}