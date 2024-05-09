public with sharing class ProjectClassificationChangeRepository {

    /**
     * @description getAllNonHistoricalFinancialsForProject
     * @param  projectId projectId
     * @return           return all financials and deliverables that are not historical (link to a project snapshot) for a project
     */
    public static List<Financial__c> getAllNonHistoricalFinancialsForProject(Id projectId) {
        return [
            SELECT
                Id
            FROM
                Financial__c
            WHERE
                Project__c =: projectId AND ProjectSnapshot__c = NULL
        ];
    }

    public static List<Financial__c> getNonHistoricalFinancialsForProject(Id projectId) {
        return [
            SELECT
                Id
            FROM
                Financial__c
            WHERE
                Project__c =: projectId AND ProjectSnapshot__c = NULL AND RecordType.DeveloperName =: InnovatorConstants.FINANCIAL_DATA_RECORDTYPE
        ];
    }

    
    public static List<Financial__c> getNonHistoricalDeliverablesForProject(Id projectId) {
        return [
            SELECT
                Id
            FROM
                Financial__c
            WHERE
                Project__c =: projectId AND ProjectSnapshot__c = NULL AND RecordType.Name =: InnovatorConstants.DELIVERABLE_RECORDTYPE
        ];
    }

    public static List<Financial__c> getNonHistoricalSecondToFourthFinancialDataForProject(Id projectId) {
        return [
            SELECT
                Id
            FROM
                Financial__c
            WHERE
                Project__c =: projectId AND ProjectSnapshot__c = NULL AND RecordType.DeveloperName =: InnovatorConstants.FINANCIAL_DATA_RECORDTYPE AND
                (ActualFY__c = 2 OR ActualFY__c = 3 OR ActualFY__c = 4)
        ];
    }
}