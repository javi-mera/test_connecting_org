/**
 * @author - Darya Rykhlik
 * @date - 27 Mar 2024
 * @description - The Batch class to update the TeamMember field
 */
//todo later
public class ProjectTeamMembersUpdateBatch implements Database.Batchable<SObject>, Database.Stateful {
    /**
     * Method to collect records to be passed to the execute method
     * @param batchableContext - The parameter type of a batch job method
     * @return - List of records to be processed with a SOQL query
     */
    public Database.QueryLocator start(Database.BatchableContext batchableContext) {
        return Database.getQueryLocator(
            'SELECT Opportunity__c, OpportunityContextConsumerRationale__c, ProjectRationale__c\n' +
                'FROM Project__c\n' +
                'WHERE ProjectClassification__c = \'Promotional Pack\''
        );
    }

    /**
     * Method to process each “batch” of data passed to the method
     * @param batchableContext - The parameter type of a batch job method
     * @param projects - List of Project records
     */
    public void execute(Database.BatchableContext batchableContext, List<Project__c> projects) {
        for (Project__c project : projects) {
            String rationale = project.Opportunity__c == null ? '' : project.Opportunity__c;
            String opportunityContext = project.OpportunityContextConsumerRationale__c == null ? '' : project.OpportunityContextConsumerRationale__c;
            if (project.Opportunity__c != null) {
                if (!project.Opportunity__c.endsWith('.')) {
                    rationale += '. ';
                } else {
                    rationale += ' ';
                }
            }
            project.ProjectRationale__c = rationale + opportunityContext;
        }
        update projects;
    }
    /**
     * Method to execute post-processing operations
     * @param batchableContext - The parameter type of a batch job method
     */
    public void finish(Database.BatchableContext batchableContext) { }
}