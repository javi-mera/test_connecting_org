public with sharing class LegalAndRegulatoryNotifiactionRepository {

    public static List<BrandLegalAndRegulatoryPrimo__mdt> getBrandLegalAndRegulatoryPrimos(List<String> brands) {
        return [
            SELECT
                Brand__c,
                LegalPrimoEmail__c,
                RegulatoryPrimoEmail__c,
                LegalPrimoName__c,
                RegulatoryPrimoName__c
            FROM
                BrandLegalAndRegulatoryPrimo__mdt
            WHERE
                Brand__c IN: brands
        ];
    }

}