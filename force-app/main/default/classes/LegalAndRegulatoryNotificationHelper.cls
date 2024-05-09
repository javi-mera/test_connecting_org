public with sharing class LegalAndRegulatoryNotificationHelper {

    public static Map<String, BrandLegalAndRegulatoryPrimo__mdt> mapBrandLegalAndRegulatoryPrimos(List<BrandLegalAndRegulatoryPrimo__mdt> brandLegalAndRegulatoryPrimos) {
        Map<String, BrandLegalAndRegulatoryPrimo__mdt> result = new Map<String, BrandLegalAndRegulatoryPrimo__mdt>();
        if (brandLegalAndRegulatoryPrimos.size() > 0) {
            for (BrandLegalAndRegulatoryPrimo__mdt brandLegalAndRegulatoryPrimo : brandLegalAndRegulatoryPrimos) {
                result.put(brandLegalAndRegulatoryPrimo.Brand__c, brandLegalAndRegulatoryPrimo);
            }
        }
        return result;
    }

}