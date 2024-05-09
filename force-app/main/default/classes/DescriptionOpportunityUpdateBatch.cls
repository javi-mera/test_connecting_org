/**
 * @author - Darya Rykhlik
 * @date - 08 Aug 2023
 * @description - The Batch class to update the Project__c.DescriptionAndOpportunity__c field
 */

public class DescriptionOpportunityUpdateBatch implements Database.Batchable<SObject>, Database.Stateful {
    /**
     * Method to collect records to be passed to the execute method
     * @param batchableContext - The parameter type of a batch job method
     * @return - List of records to be processed with a SOQL query
     */
    public Database.QueryLocator start(Database.BatchableContext batchableContext) {
        return Database.getQueryLocator(
            'SELECT Opportunity__c, DescriptionAndOpportunity__c\n' +
            'FROM Project__c\n' +
            'WHERE ProjectClassification__c = \'Fearless Bet\' \n' +
            'OR ProjectClassification__c = \'Brand Energizer\'\n' +
            'OR ProjectClassification__c = \'Business Enabler\''
        );
    }

    /**
     * Method to process each “batch” of data passed to the method
     * @param batchableContext - The parameter type of a batch job method
     * @param projects - List of Project__c records
     */
    public void execute(Database.BatchableContext batchableContext, List<Project__c> projects) {
        for (Project__c project : projects) {
            String description = '';
            if (project.Opportunity__c != '' && project.Opportunity__c != null) {
                description = project.Opportunity__c;
                project.DescriptionAndOpportunity__c = description;
                project.Opportunity__c = '';
            }
        }
        update projects;
    }
    /**
     * Method to execute post-processing operations
     * @param batchableContext - The parameter type of a batch job method
     */
    public void finish(Database.BatchableContext batchableContext) { }
}