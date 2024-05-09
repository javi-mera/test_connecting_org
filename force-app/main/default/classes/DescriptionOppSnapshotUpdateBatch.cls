/**
 * @author - Darya Rykhlik
 * @date - 09 Aug 2023
 * @description - The Batch class to update the Project_Snapshot__c.DescriptionAndOpportunity__c field
 */

public class DescriptionOppSnapshotUpdateBatch implements Database.Batchable<SObject>, Database.Stateful {
    /**
     * Method to collect records to be passed to the execute method
     * @param batchableContext - The parameter type of a batch job method
     * @return - List of records to be processed with a SOQL query
     */
    public Database.QueryLocator start(Database.BatchableContext batchableContext) {
        return Database.getQueryLocator(
            'SELECT Opportunity__c, DescriptionAndOpportunity__c\n' +
            'FROM Project_Snapshot__c\n' +
            'WHERE ProjectClassification__c = \'Fearless Bet\' \n' +
            'OR ProjectClassification__c = \'Brand Energizer\'\n' +
            'OR ProjectClassification__c = \'Business Enabler\''
        );
    }

    /**
     * Method to process each “batch” of data passed to the method
     * @param batchableContext - The parameter type of a batch job method
     * @param projectSnapshots - List of Project_Snapshot__c records
     */
    public void execute(Database.BatchableContext batchableContext, List<Project_Snapshot__c> projectSnapshots) {
        for (Project_Snapshot__c snapshot : projectSnapshots) {
            String description = '';
            if (snapshot.Opportunity__c != '' && snapshot.Opportunity__c != null) {
                description = snapshot.Opportunity__c;
                snapshot.DescriptionAndOpportunity__c = description;
                snapshot.Opportunity__c = '';
            }
        }
        update projectSnapshots;
    }
    /**
     * Method to execute post-processing operations
     * @param batchableContext - The parameter type of a batch job method
     */
    public void finish(Database.BatchableContext batchableContext) { }
}