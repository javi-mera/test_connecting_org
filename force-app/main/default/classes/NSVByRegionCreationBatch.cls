/**
 * @author - Darya Rykhlik
 * @date - 10 Apr 2024
 * @description - The Batch class to create Regional NSV Financials
 */

public class NSVByRegionCreationBatch implements Database.Batchable<SObject>, Database.Stateful {
    /**
         * Method to collect records to be passed to the execute method
         * @param batchableContext - The parameter type of a batch job method
         * @return - List of records to be processed with a SOQL query
         */
    public Database.QueryLocator start(Database.BatchableContext batchableContext) {
        return Database.getQueryLocator(
            'SELECT Region__c, AddAdditionalRegionOrRegions__c\n' +
            'FROM Project__c\n' +
            'WHERE (ProjectClassification__c = \'Fearless Bet\'\n' +
            'OR ProjectClassification__c = \'Business Enabler\'\n' +
            'OR ProjectClassification__c = \'Brand Energizer\'\n' +
            'OR (ProjectClassification__c = \'Geographical Extension\' AND GeoExtensionProjectSubClassification__c != \'Other Geo Extension\'))\n' +
            'AND (ProjectStatus__c = \'Draft\'\n' +
            '    OR ProjectStatus__c = \'Active\'\n' +
            '    OR ProjectStatus__c = \'On Hold\')\n' +
            'AND ProjectPhase__c != \'Diagnose\''
        );
    }

    /**
     * Method to process each “batch” of data passed to the method
     * @param batchableContext - The parameter type of a batch job method
     * @param projects - List of Project__c records
     */
    public void execute(Database.BatchableContext batchableContext, List<Project__c> projects) {
        if (!projects.isEmpty()) {
            Map<Id, Set<String>> newRegionsByProjectIdMap = new Map<Id, Set<String>>();
            List<Financial__c> financialsToCreate = new List<Financial__c>();
            for (Project__c project : projects) {
                if (String.isNotBlank(project.Region__c) || String.isNotBlank(project.AddAdditionalRegionOrRegions__c)) {
                    Set<String> regionsToAdd = NSVByRegionController.getRegionsSet(project.Region__c, project.AddAdditionalRegionOrRegions__c);
                    newRegionsByProjectIdMap.put(project.Id, regionsToAdd);
                }
            }

            if (!newRegionsByProjectIdMap.isEmpty()) {
                Id recordTypeId = Schema.SObjectType.Financial__c.getRecordTypeInfosByName().get(InnovatorConstants.REGIONAL_NSV_RECORDTYPE).getRecordTypeId();
                for (Id projectId : newRegionsByProjectIdMap.keySet()) {

                    for (String region : newRegionsByProjectIdMap.get(projectId)) {
                        Financial__c newFinancial = new Financial__c(
                            Project__c = projectId,
                            Region__c = region,
                            RecordTypeId = recordTypeId
                        );
                        financialsToCreate.add(newFinancial);
                    }
                }

                if (!financialsToCreate.isEmpty()) {
                    insert financialsToCreate;
                }
            }
        }
    }
    /**
     * Method to execute post-processing operations
     * @param batchableContext - The parameter type of a batch job method
     */
    public void finish(Database.BatchableContext batchableContext) { }
}