public with sharing class LookupGeoHierarchyRepository {

    public static Set<String> getRegions(String searchTerm) {
        searchTerm += '%';
        List<GeoHierarchy__c> listOfRegions = [SELECT Id, Name, Region__c FROM GeoHierarchy__c WHERE  Region__c LIKE :searchTerm ORDER BY Region__c ASC];
        Set<String> results = new Set<String>();
        for(GeoHierarchy__c record: listOfRegions) {
            results.add(record.Region__c);
        }
        return results;
    }

    public static Set<String> getAllRegions() {
        List<GeoHierarchy__c> listOfRegions = [SELECT Id, Name, Region__c FROM GeoHierarchy__c  ORDER BY Region__c ASC];
        Set<String> results = new Set<String>();
        for(GeoHierarchy__c record: listOfRegions) {
            results.add(record.Region__c);
        }
        return results;
    }

    public static Set<String> getHubs(String searchTerm, List<String> selectedRegions) {
        searchTerm += '%';
        List<GeoHierarchy__c> listOfHubs = [SELECT Id, Name, Hub__c FROM GeoHierarchy__c WHERE  Hub__c LIKE :searchTerm AND Region__c IN :selectedRegions ORDER BY Hub__c ASC];
        Set<String> results = new Set<String>();
        for(GeoHierarchy__c record: listOfHubs) {
            results.add(record.Hub__c);
        }
        return results;
    }

    public static Set<String> getAllHubs(List<String> selectedRegions) {
        List<GeoHierarchy__c> listOfHubs = [SELECT Id, Name, Hub__c FROM GeoHierarchy__c WHERE Region__c IN :selectedRegions ORDER BY Hub__c ASC];
        Set<String> results = new Set<String>();
        for(GeoHierarchy__c record: listOfHubs) {
            results.add(record.Hub__c);
        }
        return results;
    }

    public static Set<String> getClusters(String searchTerm, List<String> selectedHubs, List<String> selectedRegions) {
        searchTerm += '%';
        List<GeoHierarchy__c> listOfClusters = [SELECT Id, Name, Cluster__c FROM GeoHierarchy__c WHERE  Hub__c IN :selectedHubs AND Cluster__c LIKE :searchTerm AND Region__c IN :selectedRegions ORDER BY Cluster__c ASC];
        Set<String> results = new Set<String>();
        for(GeoHierarchy__c record: listOfClusters) {
            results.add(record.Cluster__c);
        }
        return results;
        
    }

    public static Set<String> getAllClusters(List<String> selectedHubs, List<String> selectedRegions) {
        List<GeoHierarchy__c> listOfClusters = [SELECT Id, Name, Cluster__c FROM GeoHierarchy__c WHERE  Hub__c IN :selectedHubs AND Region__c IN :selectedRegions ORDER BY Cluster__c ASC];
        Set<String> results = new Set<String>();
        for(GeoHierarchy__c record: listOfClusters) {
            results.add(record.Cluster__c);
        }
        return results;
    }


    public static Set<String> getMarkets(String searchTerm) {
        searchTerm += '%';
        List<GeoHierarchy__c> listOfMarkets = [
            SELECT Name, Country__c, CountryDescription__c
            FROM GeoHierarchy__c WHERE CountryDescription__c LIKE :searchTerm
            ORDER BY CountryDescription__c ASC
        ];
        Set<String> results = new Set<String>();
        for(GeoHierarchy__c record: listOfMarkets) {
            results.add(record.CountryDescription__c);
        }
        return results;
    }

    public static Set<String> getAllMarkets() {
        List<GeoHierarchy__c> listOfMarkets = [
            SELECT Name, Country__c, CountryDescription__c
            FROM GeoHierarchy__c
            ORDER BY CountryDescription__c ASC
        ];
        Set<String> results = new Set<String>();
        for(GeoHierarchy__c record: listOfMarkets) {
            results.add(record.CountryDescription__c);
        }
        return results;
    }

    public static List<GeoHierarchy__c> getGeoHierarchiesByMarket(String searchTerm) {
        searchTerm += '%';
        List<GeoHierarchy__c> listOfRecords = [
            SELECT Name, Country__c, CountryDescription__c, Region__c, HUB__c, Cluster__c, DC__c
            FROM GeoHierarchy__c
            WHERE CountryDescription__c LIKE :searchTerm
            ORDER BY CountryDescription__c ASC
            LIMIT 1
        ];
        return listOfRecords;
    }

    public static List<GeoHierarchy__c> getAdditionalGeoHierarchiesByMarkets(List<String> markets) {
        List<GeoHierarchy__c> listOfRecords = [
                SELECT Name, Country__c, CountryDescription__c, Region__c, HUB__c, Cluster__c, DC__c
                FROM GeoHierarchy__c
                WHERE CountryDescription__c IN :markets
                ORDER BY CountryDescription__c ASC
        ];
        return listOfRecords;
    }

    public static List<GeoHierarchy__c> getAllCountryDescriptions(List<String> countryCodes) {
        return [SELECT CountryDescription__c, Country__c FROM GeoHierarchy__c WHERE  CountryDescription__c IN :countryCodes ];   
    }

    public static List<AggregateResult> getGroupedGeoHierarchiesByRegion(String region) {
        return [SELECT Region__c, HUB__c FROM GeoHierarchy__c WHERE Region__c =: region GROUP BY Region__c, HUB__c];
    }

    public static List<AggregateResult> getGroupedGeoHierarchiesByRegions(List<String> regions) {
        return [SELECT Region__c, HUB__c FROM GeoHierarchy__c WHERE Region__c IN: regions GROUP BY Region__c, HUB__c];
    }
}