/**
 * @author - Darya Rykhlik
 * @date - 13 Oct 2023
 * @description - The Batch class to update the Task List and Approvals Required fields
 */

public class PromoPackTaskListUpdateBatch implements Database.Batchable<SObject>, Database.Stateful {
    /**
     * Method to collect records to be passed to the execute method
     * @param batchableContext - The parameter type of a batch job method
     * @return - List of records to be processed with a SOQL query
     */
    public Database.QueryLocator start(Database.BatchableContext batchableContext) {
        return Database.getQueryLocator(
            'SELECT TaskList__c, DecisionRequired__c, DecisionStep__c, ProjectClassification__c, ProjectClassificationSubtype__c, Complexity__c\n' +
            'FROM Project__c\n' +
            'WHERE ProjectClassification__c = \'Promotional Pack\'\n' +
            'AND (ProjectStatus__c = \'Active\'\n' +
            'OR ProjectStatus__c = \'On hold\')'
        );
    }

    /**
     * Method to process each “batch” of data passed to the method
     * @param batchableContext - The parameter type of a batch job method
     * @param projects - List of Project records
     */
    public void execute(Database.BatchableContext batchableContext, List<Project__c> projects) {
        List<Decision_Required__mdt> decisionRequiredList = DecisionRequiredMetadataUpdateRepository.getAllMetadata();
        List<Project__c> projectsToUpdate = new List<Project__c>();
        for (Decision_Required__mdt dr : decisionRequiredList) {
            for (Project__c project : projects) {
                String projectSubtype = project.ProjectClassificationSubtype__c == InnovatorConstants.LIMITED_EDITION_PACK_SUBTYPE ||
                                        project.ProjectClassificationSubtype__c == InnovatorConstants.VALUE_ADDED_PACK_SUBTYPE ?
                                        'Pack Change' : project.ProjectClassificationSubtype__c;
                if(dr.DecisionStep__c == project.DecisionStep__c &&
                    project.ProjectClassification__c == dr.ProjectClassification__c &&
                    dr.Complexity__c == project.Complexity__c &&
                    (dr.ProjectClassificationSubtype__c == projectSubtype ||
                        (dr.ProjectClassificationSubtype__c == null &&
                            (project.DecisionStep__c == InnovatorConstants.DECISION_STEP_PRODUCTION || project.DecisionStep__c == InnovatorConstants.DECISION_STEP_PLR)
                        )
                    )
                ){
                    project.TaskList__c = dr.TaskList__c;
                    project.DecisionRequired__c = dr.DecisionRequired__c;
                    projectsToUpdate.add(project);
                }
            }
        }

        update projectsToUpdate;
    }
    /**
     * Method to execute post-processing operations
     * @param batchableContext - The parameter type of a batch job method
     */
    public void finish(Database.BatchableContext batchableContext) { }
}