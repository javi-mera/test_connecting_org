public with sharing class DecisionRequiredMetadataUpdateRepository {
    public static List<Decision_Required__mdt> getAllMetadata(){
        return [
            SELECT Label, Complexity__c, DecisionStep__c, ProjectClassification__c, TaskList__c, DecisionRequired__c,
                   DeveloperName, ProjectClassificationSubtype__c
            FROM Decision_Required__mdt
            ORDER BY ProjectClassification__c, Complexity__c, DecisionStep__c
        ];
    }
}