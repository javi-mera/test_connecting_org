/**
 * @author - Darya Rykhlik
 * @date - 08 Aug 2023
 * @description - The class to test the DescriptionOpportunityUpdateBatch and DescriptionOppSnapshotUpdateBatch logic
 */

@IsTest
public class DescriptionOpportunityUpdateBatchTest {

    private static final String FEARLESS_BET_CLASSIFICATION = 'Fearless Bet';
    private static final String BRAND_ENERGIZER_CLASSIFICATION = 'Brand Energizer';
    private static final String BUSINESS_ENABLER_CLASSIFICATION = 'Business Enabler';
    private static final String DESCRIPTION_OPPORTUNITY_TEXT = 'Test Description';

    @TestSetup
    static void setup() {
        TestFactory.generateBasicSetUp();

        List<Project__c> projects = [
            SELECT Opportunity__c, DescriptionAndOpportunity__c
            FROM Project__c
            WHERE ProjectClassification__c =: FEARLESS_BET_CLASSIFICATION
            OR ProjectClassification__c =: BRAND_ENERGIZER_CLASSIFICATION
            OR ProjectClassification__c =: BUSINESS_ENABLER_CLASSIFICATION
        ];

        for (Project__c project : projects) {
            project.Opportunity__c = DESCRIPTION_OPPORTUNITY_TEXT;
        }
        update projects;

        List<Project_Snapshot__c> snapshots = new List<Project_Snapshot__c>();
        Id projectId = projects[0].Id;
        for (Integer i = 0; i < 50; i++) {
            Project_Snapshot__c snapshot = new Project_Snapshot__c(
                Project__c = projectId,
                ProjectClassification__c = FEARLESS_BET_CLASSIFICATION,
                Opportunity__c = DESCRIPTION_OPPORTUNITY_TEXT
            );
            snapshots.add(snapshot);
        }
        insert snapshots;
    }

    @IsTest
    static void updateDescriptionOpportunityFieldTest(){
        Test.startTest();
        Database.executeBatch(new DescriptionOpportunityUpdateBatch());
        Test.stopTest();

        List<Project__c> projects = [
            SELECT Opportunity__c, DescriptionAndOpportunity__c
            FROM Project__c
            WHERE ProjectClassification__c =: FEARLESS_BET_CLASSIFICATION
            OR ProjectClassification__c =: BRAND_ENERGIZER_CLASSIFICATION
            OR ProjectClassification__c =: BUSINESS_ENABLER_CLASSIFICATION
        ];

        for (Project__c project : projects) {
            System.assertEquals(null, project.Opportunity__c);
            System.assertEquals(DESCRIPTION_OPPORTUNITY_TEXT, project.DescriptionAndOpportunity__c);
        }
    }

    @IsTest
    static void updateDescriptionOpportunitySnapshotFieldTest(){
        Test.startTest();
        Database.executeBatch(new DescriptionOppSnapshotUpdateBatch());
        Test.stopTest();

        List<Project_Snapshot__c> snapshots = [
            SELECT Opportunity__c, DescriptionAndOpportunity__c
            FROM Project_Snapshot__c
            WHERE ProjectClassification__c =: FEARLESS_BET_CLASSIFICATION
            OR ProjectClassification__c =: BRAND_ENERGIZER_CLASSIFICATION
            OR ProjectClassification__c =: BUSINESS_ENABLER_CLASSIFICATION
        ];

        for (Project_Snapshot__c snapshot : snapshots) {
            System.assertEquals(null, snapshot.Opportunity__c);
            System.assertEquals(DESCRIPTION_OPPORTUNITY_TEXT, snapshot.DescriptionAndOpportunity__c);
        }
    }
}