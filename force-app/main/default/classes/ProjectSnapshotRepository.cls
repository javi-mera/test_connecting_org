public with sharing class ProjectSnapshotRepository {

    public static Project_Snapshot__c getProjectSnapshot(Id projectSnapshotId) {
        return [
            SELECT ProjectPhase__c, ProjectClassificationSubType__c, ProjectClassification__c, FinancialThresholdNotMetComment__c, ProjectDevelopmentCostsToDate__c, Complexity__c
            FROM Project_Snapshot__c
            WHERE Id =: projectSnapshotId
        ];
    }

    @AuraEnabled
    public static List<Project_Snapshot__c> getProjectSnapshotInformation(Id snapshotId){
        return [
            SELECT Region__c, AddAdditionalRegionOrRegions__c, GeoExtensionProjectSubClassification__c
            FROM Project_Snapshot__c
            WHERE Id = :snapshotId
        ];
    }

}