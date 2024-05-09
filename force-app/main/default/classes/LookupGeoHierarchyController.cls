public with sharing class LookupGeoHierarchyController {

    private static final String LEAD_MARKET_TYPE = 'LeadMarket';
    private static final String DISTRIBUTION_CHANNEL_TYPE = 'DistributionChannel';
    private static final String HUB_TYPE = 'Hub';
    private static final String REGION_TYPE = 'Region';
    private static final String CLUSTER_TYPE = 'Cluster';
    private static final String TRADE_TYPE = 'Trade';
    private static final String BRAND_HOME = 'BrandHome';
    private static final String ADDITIONAL_REGION_TYPE = 'AdditionalRegion';
    private static final String ADDITIONAL_MARKET_TYPE =  'AdditionalMarket';
    private static final String ADDITIONAL_HUB_TYPE = 'AdditionalHub';
    private static final String ADDITIONAL_CLUSTER_TYPE = 'AdditionalCluster';
    private static final String GEO_OBJECT_TYPE = 'GeoHierarchy__c';
    private static final String PROJECT_OBJECT_TYPE = 'Project__c';
    private static final String MARKET_FIELD = 'Country__c';
    private static final String COUNTRY_DESCRIPTION_FIELD = 'CountryDescription__c';
    private static final String DC_FIELD = 'DC__c';
    private static final String HUB_FIELD = 'Hub__c';
    private static final String CLUSTER_FIELD = 'Cluster__c';
    private static final String TRADE_TYPE_FIELD = 'TradeType__c';
    private static final String BRAND_HOME_FIELD = 'BrandHome__c';
    private static final String REGION_FIELD = 'Region__c';
    private static final String CONTACT_ICON = 'standard:location';

    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> searchDistributionChannels(String searchTerm, List<String> selectedIds) {
        Schema.DescribeFieldResult field = GeoHierarchy__c.DC__c.getDescribe();
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        String contactIcon = CONTACT_ICON;

        for (Schema.PicklistEntry f : field.getPicklistValues()) {
            String label= f.getLabel();
            if (label.containsIgnoreCase(searchTerm)) {
                results.add(
                    new LookupSearchResult (
                        label,
                        'GeoHierarchy__c',
                        contactIcon,
                        label,
                        label,
                        label
                    )
                );
            }
        }
        return results;
    }

    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> searchAllDistributionChannels(List<String> selectedIds) {
        Schema.DescribeFieldResult field = GeoHierarchy__c.DC__c.getDescribe();
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        String contactIcon = CONTACT_ICON;
        List<String> picklistValues = new List<String>();
        for (Schema.PicklistEntry f : field.getPicklistValues()) {
            picklistValues.add(f.getLabel());
        }
        picklistValues.sort();

        for (String label: picklistValues) {
            if (!selectedIds.contains(label)) {
                results.add(
                    new LookupSearchResult (
                        label,
                        'GeoHierarchy__c',
                        contactIcon,
                        label,
                        label,
                        label
                    )
                );
            }
        }

        return results;
    }

//    @AuraEnabled
//    public static List<LookupSearchResult> searchRegions(String searchTerm, List<String> selectedIds) {
//        Set<String> searchResults = LookupGeoHierarchyRepository.getRegions(searchTerm);
//
//        List<LookupSearchResult> results = new List<LookupSearchResult>();
//        String icon = CONTACT_ICON;
//        for (String region: searchResults) {
//            if (!selectedIds.contains(region)) {
//                results.add(
//                    new LookupSearchResult(
//                        region,
//                        'GeoHierarchy__c',
//                        icon,
//                        region,
//                        '',
//                        region
//                    )
//                );
//            }
//        }
//        return results;
//    }

//    @AuraEnabled
//    public static List<LookupSearchResult> searchAllRegions(List<String> selectedIds) {
//        Set<String> searchResults = LookupGeoHierarchyRepository.getAllRegions();
//
//        List<LookupSearchResult> results = new List<LookupSearchResult>();
//        String icon = CONTACT_ICON;
//        for (String region: searchResults) {
//            if (!selectedIds.contains(region)) {
//                results.add(
//                    new LookupSearchResult(
//                        region,
//                        'GeoHierarchy__c',
//                        icon,
//                        region,
//                        '',
//                        region
//                    )
//                );
//            }
//        }
//        return results;
//    }

//    @AuraEnabled
//    public static List<LookupSearchResult> searchHubs(String searchTerm, List<String> selectedIds, List<String> selectedRegions) {
//        Set<String> searchResults = LookupGeoHierarchyRepository.getHubs(searchTerm, selectedRegions);
//
//        List<LookupSearchResult> results = new List<LookupSearchResult>();
//        String icon = CONTACT_ICON;
//        for (String hub: searchResults) {
//            if (!selectedIds.contains(hub)) {
//                results.add(
//                    new LookupSearchResult(
//                        hub,
//                        'GeoHierarchy__c',
//                        icon,
//                        hub,
//                        '',
//                        hub
//                    )
//                );
//            }
//        }
//        return results;
//    }

//    @AuraEnabled
//    public static List<LookupSearchResult> searchAllHubs(List<String> selectedIds, List<String> selectedRegions) {
//        Set<String> searchResults = LookupGeoHierarchyRepository.getAllHubs(selectedRegions);
//
//        List<LookupSearchResult> results = new List<LookupSearchResult>();
//        String icon = CONTACT_ICON;
//        for (String hub: searchResults) {
//            if (!selectedIds.contains(hub)) {
//                results.add(
//                    new LookupSearchResult(
//                        hub,
//                        'GeoHierarchy__c',
//                        icon,
//                        hub,
//                        '',
//                        hub
//                    )
//                );
//            }
//        }
//        return results;
//    }

//    @AuraEnabled
//    public static List<LookupSearchResult> searchClusters(String searchTerm, List<String> selectedIds, List<String> selectedHubs, List<String> selectedRegions) {
//        Set<String> searchResults = LookupGeoHierarchyRepository.getClusters(searchTerm, selectedHubs, selectedRegions);
//
//        List<LookupSearchResult> results = new List<LookupSearchResult>();
//        String icon = CONTACT_ICON;
//        for (String cluster: searchResults) {
//            if (!selectedIds.contains(cluster)) {
//                results.add(
//                    new LookupSearchResult(
//                        cluster,
//                        'GeoHierarchy__c',
//                        icon,
//                        cluster,
//                        '',
//                        cluster
//                    )
//                );
//            }
//        }
//        return results;
//    }

//    @AuraEnabled
//    public static List<LookupSearchResult> searchAllClusters(List<String> selectedIds,  List<String> selectedHubs, List<String> selectedRegions) {
//        Set<String> searchResults = LookupGeoHierarchyRepository.getAllClusters( selectedHubs, selectedRegions);
//        List<LookupSearchResult> results = new List<LookupSearchResult>();
//        String icon = CONTACT_ICON;
//        for (String cluster: searchResults) {
//            if (!selectedIds.contains(cluster)) {
//                results.add(
//                    new LookupSearchResult(
//                        cluster,
//                        'GeoHierarchy__c',
//                        icon,
//                        cluster,
//                        '',
//                        cluster
//                    )
//                );
//            }
//        }
//        return results;
//    }
    
    @AuraEnabled
    public static List<LookupSearchResult> searchMarkets(String searchTerm, List<String> selectedIds) {
        Set<String> searchResults = LookupGeoHierarchyRepository.getMarkets(searchTerm);

        List<LookupSearchResult> results = new List<LookupSearchResult>();
        String icon = CONTACT_ICON;
        for (String market: searchResults) {
            if (!selectedIds.contains(market)) {
                results.add(
                    new LookupSearchResult(
                        market,
                        'GeoHierarchy__c',
                        icon,
                        market,
                        '',
                        market
                    )
                );
            }
        }
        return results;
    } 

    @AuraEnabled
    public static List<LookupSearchResult> searchAllMarkets(List<String> selectedIds) {
        Set<String> searchResults = LookupGeoHierarchyRepository.getAllMarkets();
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        String icon = CONTACT_ICON;
        for (String market : searchResults) {
            if (!selectedIds.contains(market)) {
                results.add(
                        new LookupSearchResult(
                                market,
                                'GeoHierarchy__c',
                                icon,
                                market,
                                '',
                                market
                        )
                );
            }
        }
        return results;
    }

    @AuraEnabled
    public static List<LookupSearchResult> searchGeoHierarchyByMarket(String searchTerm) {
        List<GeoHierarchy__c> searchResults = LookupGeoHierarchyRepository.getGeoHierarchiesByMarket(searchTerm);

        List<LookupSearchResult> results = new List<LookupSearchResult>();
        String icon = CONTACT_ICON;
        String region = searchResults[0].Region__c;
        String hub = searchResults[0].HUB__c;
        String cluster = searchResults[0].Cluster__c;
        String distributionChannel = searchResults[0].DC__c;
        results.add(
            new LookupSearchResult(
                region,
                'GeoHierarchy__c',
                icon,
                hub,
                cluster,
                distributionChannel
            )
        );
        return results;
    }

    @AuraEnabled
    public static List<LookupSearchResult> searchAdditionalGeoHierarchyByMarkets(List<String> selectedMarkets) {
        List<GeoHierarchy__c> searchResults = LookupGeoHierarchyRepository.getAdditionalGeoHierarchiesByMarkets(selectedMarkets);

        List<LookupSearchResult> results = new List<LookupSearchResult>();
        for (Integer i = 0; i < searchResults.size(); i++) {
            if (!selectedMarkets.contains(searchResults[i].Country__c)) {
                results.add(
                    new LookupSearchResult(
                            searchResults[i].Region__c,
                        'GeoHierarchy__c',
                            CONTACT_ICON,
                            searchResults[i].HUB__c,
                            '',
                            searchResults[i].Cluster__c
                    )
                );
            }
        }
        return results;
    }

    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> searchBrandHomes(String searchTerm, List<String> selectedIds) {
        List<String> myPicklist = new List<String>();
        Schema.DescribeFieldResult field = Project__c.BrandHome__c.getDescribe();
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        for (Schema.PicklistEntry f : field.getPicklistValues()) {
            if (!selectedIds.contains(f.getLabel()) && f.getLabel().containsIgnoreCase(searchTerm)) {
                myPicklist.add(f.getLabel());
                results.add(
                    new LookupSearchResult(
                        f.getLabel(),
                        'Project__c',
                        CONTACT_ICON,
                        f.getLabel(),
                        '',
                        f.getLabel()
                    )
                );
            }
        }
        return results;
    }

    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> searchAllBrandHomes(List<String> selectedIds) {
        Schema.DescribeFieldResult field = Project__c.BrandHome__c.getDescribe();
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        List<String> tradeTypeValues = new List<String>();
        for (Schema.PicklistEntry f : field.getPicklistValues()) {
            tradeTypeValues.add(f.getLabel());
        }
        tradeTypeValues.sort();
        for (String label: tradeTypeValues){ 
            if (!selectedIds.contains(label)) {
                results.add(
                    new LookupSearchResult (
                        label,
                        'Project__c',
                        CONTACT_ICON,
                        label,
                        '',
                        label
                    )
                );
            }
        }
        return results;
    }

    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> searchTradeTypes(String searchTerm, List<String> selectedIds) {
        List<String> myPicklist = new List<String>();
        Schema.DescribeFieldResult field = Project__c.TradeType__c.getDescribe();
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        for (Schema.PicklistEntry f : field.getPicklistValues()) {
            if (!selectedIds.contains(f.getLabel()) && f.getLabel().containsIgnoreCase(searchTerm)) {
                myPicklist.add(f.getLabel());
                results.add(
                    new LookupSearchResult(
                        f.getLabel(),
                        'Project__c',
                        CONTACT_ICON,
                        f.getLabel(),
                        '',
                        f.getLabel()
                    )
                );
            }
        }
        return results;
    }

    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> searchAllTradeTypes(List<String> selectedIds) {
        Schema.DescribeFieldResult field = Project__c.TradeType__c.getDescribe();
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        List<String> tradeTypeValues = new List<String>();
        for (Schema.PicklistEntry f : field.getPicklistValues()) {
            tradeTypeValues.add(f.getLabel());
        }
        tradeTypeValues.sort();
        for (String label: tradeTypeValues){ 
            if (!selectedIds.contains(label)) {
                results.add(
                    new LookupSearchResult (
                        label,
                        'Project__c',
                        CONTACT_ICON,
                        label,
                        '',
                        label
                    )
                );
            }
        }
        return results;
    }

//    @InvocableMethod(label='Transform GeoHierarchies')
//    public static List<List<LookupSearchResult>> transformToLookupResult(List<FlowRequest> requests){
//        List<LookupSearchResult> results = new List<LookupSearchResult>();
//        FlowRequest request = requests.get(0);
//        if(request.type.equals(LEAD_MARKET_TYPE)) {
//            results = transformMarketField(request.project.LeadMarket__c, GEO_OBJECT_TYPE, MARKET_FIELD);
//        } else if(request.type.equals(DISTRIBUTION_CHANNEL_TYPE)) {
//            results = transformDistributionChannels(request.project.DC__c);
//        } else if(request.type.equals(REGION_TYPE)) {
//            results = searchValues(request.project.Region__c, GEO_OBJECT_TYPE, REGION_FIELD);
//        } else if(request.type.equals(HUB_TYPE)) {
//            results = searchValues(request.project.Hub__c, GEO_OBJECT_TYPE, HUB_FIELD);
//        } else if(request.type.equals(CLUSTER_TYPE)) {
//            results = searchValues(request.project.Cluster__c, GEO_OBJECT_TYPE, CLUSTER_FIELD);
//        } else if(request.type.equals(TRADE_TYPE)) {
//            results = searchPicklistField(TRADE_TYPE_FIELD, PROJECT_OBJECT_TYPE, request);
//        } else if(request.type.equals(BRAND_HOME)) {
//            results = searchValues(request.project.BrandHome__c, PROJECT_OBJECT_TYPE, BRAND_HOME_FIELD);
//        } else if(request.type.equals(ADDITIONAL_HUB_TYPE)) {
//            results = searchValues(request.project.AddAdditionalHubOrHubs__c, GEO_OBJECT_TYPE, HUB_FIELD);
//        } else if(request.type.equals(ADDITIONAL_CLUSTER_TYPE)) {
//            results = searchValues(request.project.AddAdditionalClusterOrClusters__c, GEO_OBJECT_TYPE, CLUSTER_FIELD);
//        } else if(request.type.equals(ADDITIONAL_MARKET_TYPE)) {
//            results = transformMarketField(request.project.AddAdditionalMarketOrMarkets__c, GEO_OBJECT_TYPE, MARKET_FIELD);
//        } else if(request.type.equals(ADDITIONAL_REGION_TYPE)) {
//            results = searchValues(request.project.AddAdditionalRegionOrRegions__c, GEO_OBJECT_TYPE, REGION_FIELD);
//        }
//        List<List<LookupSearchResult>> resultList = new List<List<LookupSearchResult>>();
//        Map<String, LookupSearchResult> mapResult = new Map<String, LookupSearchResult>();
//        for (LookupSearchResult result : results) {
//            mapResult.put(result.value, result);
//        }
//        resultList.add(mapResult.values());
//        return resultList;
//    }
//    private static List<LookupSearchResult> transformDistributionChannels(String projectDistributionChannelValues) {
//        List<LookupSearchResult> results = new List<LookupSearchResult>();
//        String icon = CONTACT_ICON;
//        if (!String.isBlank(projectDistributionChannelValues)) {
//            String[] parts = projectDistributionChannelValues.split(';');
//            for (String part: parts) {
//                if (!String.isBlank(part)) {
//                    results.add(
//                        new LookupSearchResult(
//                            part,
//                            GEO_OBJECT_TYPE,
//                            icon,
//                            part,
//                            '',
//                            part
//                        )
//                    );
//                }
//            }
//        }
//        return results;
//    }

//    private static List<LookupSearchResult> transformMarketField(String fieldValue, String objectType, String fieldName) {
//        List<LookupSearchResult> results = new List<LookupSearchResult>();
//        Set<String> countries = new Set<String>();
//        String contactIcon = CONTACT_ICON;
//        if (fieldValue != null) {
//            String[] parts = fieldValue.split(';');
//            list<String> countryCodes = new List<String>();
//            for (String part: parts) {
//                countryCodes.add(part);
//            }
//
//            List<GeoHierarchy__c> addMarkets = LookupGeoHierarchyRepository.getAllCountryDescriptions(countryCodes);
//            for (GeoHierarchy__c part: addMarkets) {
//                if (!countries.contains(part.CountryDescription__c)) {
//                    results.add(
//                        new LookupSearchResult(
//                            part.Country__c,
//                            objectType,
//                            contactIcon,
//                            part.CountryDescription__c,
//                            part.CountryDescription__c,
//                            part.Country__c
//                        )
//                    );
//                    countries.add(part.CountryDescription__c);
//                }
//            }
//        }
//        return results;
//    }

    
//    private static List<LookupSearchResult> searchValues(String fieldValue, String objectType, String fieldName) {
//        Schema.DescribeFieldResult field =  Schema.getGlobalDescribe().get(objectType).getDescribe().fields.getMap().get(fieldName).getDescribe();
//        List<LookupSearchResult> results = new List<LookupSearchResult>();
//        String contactIcon = CONTACT_ICON;
//        if (fieldValue != null) {
//            String[] parts = fieldValue.split(';');
//            for (String part: parts) {
//                for (Schema.PicklistEntry f : field.getPicklistValues()) {
//                    if (f.getLabel().equals((String)part)) {
//                        results.add(
//                            new LookupSearchResult(
//                                f.getLabel(),
//                                objectType,
//                                contactIcon,
//                                f.getLabel(),
//                                f.getLabel(),
//                                f.getLabel()
//                            )
//                        );
//                    }
//                }
//            }
//        }
//        return results;
//    }

//    private static List<LookupSearchResult> searchPicklistField(String fieldName, String objectType,FlowRequest request){
//        Schema.DescribeFieldResult field =  Schema.getGlobalDescribe().get(objectType).getDescribe().fields.getMap().get(fieldName).getDescribe();
//        List<LookupSearchResult> results = new List<LookupSearchResult>();
//        String contactIcon = CONTACT_ICON;
//        if(objectType.equals(GEO_OBJECT_TYPE)){
//            List<GeoHierarchy__c> products = request.products;
//            for(GeoHierarchy__c product : products){
//                for (Schema.PicklistEntry f : field.getPicklistValues()) {
//                    if (!String.isBlank((String)product.get(fieldName)) && f.getLabel().containsIgnoreCase((String)product.get(fieldName))) {
//                        results.add(
//                            new LookupSearchResult(
//                                f.getLabel(),
//                                objectType,
//                                contactIcon,
//                                f.getLabel(),
//                                f.getLabel(),
//                                f.getLabel()
//                            )
//                        );
//                    }
//
//                }
//            }
//        } else {
//            Project__c project = request.project;
//            for (Schema.PicklistEntry f : field.getPicklistValues()) {
//                if (!String.isBlank((String)project.get(fieldName)) && ((String)project.get(fieldName)).containsIgnoreCase(f.getLabel())) {
//                    results.add(
//                        new LookupSearchResult(
//                            f.getLabel(),
//                            objectType,
//                            contactIcon,
//                            f.getLabel(),
//                            f.getLabel(),
//                            f.getLabel()
//                        )
//                    );
//                }
//
//            }
//        }
//        return results;
//    }


//    public class FlowRequest{
//        @InvocableVariable
//        public List<GeoHierarchy__c> products;
//        @InvocableVariable
//        public String type;
//        @InvocableVariable
//        public Project__c project;
//    }

}