@isTest
public with sharing class LookupGeoHierarchyTest {
    private static final String LEAD_MARKET_TYPE = 'LeadMarket';
    private static final String DISTRIBUTION_CHANNEL_TYPE = 'DistributionChannel';
    private static final String HUB_TYPE = 'Hub';
    private static final String REGION_TYPE = 'Region';
    private static final String CLUSTER_TYPE = 'Cluster';
    private static final String TRADE_TYPE = 'Trade';
    private static final String ADDITIONAL_REGION_TYPE = 'AdditionalRegion';
    private static final String ADDITIONAL_MARKET_TYPE =  'AdditionalMarket';
    private static final String ADDITIONAL_HUB_TYPE = 'AdditionalHub';
    private static final String ADDITIONAL_CLUSTER_TYPE = 'AdditionalCluster';
    private static final String GEO_COUNTRY = 'India';
    private static final String GEO_DC = 'Domestic';
    private static final String GEO_TRADE_MARKET = 'On-Trade';
    private static final String PROJECT_CLASSIFICATION_REPACK = 'Repack';
    @TestSetup
    static void testSetup(){
        TestFactory.generateBasicSetUp();
    }
    @isTest
    static void testSearchDistributionChannels(){
        Test.startTest();
        List<LookupSearchResult> result = LookupGeoHierarchyController.searchDistributionChannels(GEO_DC,new List<String>());
        Test.stopTest();
        system.assertEquals(1,result.size(),'Checking the number of distribution channels is 1 as expected');
    }
    @isTest
    static void testsearchAllDistributionChannels(){
        Test.startTest();
        List<LookupSearchResult> result = LookupGeoHierarchyController.searchAllDistributionChannels(new List<String>());
        Test.stopTest();
        system.assertEquals(2, result.size(),'Checking the number of distribution channels is 2 as there\'s 2 picklist values');
    }
//    @isTest
//    static void testSearchRegions(){
//        Test.startTest();
//        List<LookupSearchResult> result = LookupGeoHierarchyController.searchRegions(GEO_REGION,new List<String>());
//        Test.stopTest();
//        system.assertEquals(1,result.size(),'Checking the number of regions is 1 as expected');
//    }
//    @isTest
//    static void testSearchAllRegions(){
//        Test.startTest();
//        List<LookupSearchResult> result = LookupGeoHierarchyController.searchAllRegions(new List<String>());
//        Test.stopTest();
//        system.assertEquals(1,result.size(),'Checking the number of regions is 1 as expected');
//    }
//    @isTest
//    static void testSearchHubs(){
//        Test.startTest();
//        List<LookupSearchResult> result = LookupGeoHierarchyController.searchHubs(GEO_HUB,new List<String>(),new List<String>{GEO_REGION});
//        Test.stopTest();
//        system.assertEquals(1,result.size(),'Checking the number of hubs is 1 as expected');
//    }
//    @isTest
//    static void testSearchAllHubs(){
//        Test.startTest();
//        List<LookupSearchResult> result = LookupGeoHierarchyController.searchAllHubs(new List<String>(),new List<String>{GEO_REGION});
//        Test.stopTest();
//        system.assertEquals(1,result.size(),'Checking the number of hubs is 1 as expected');
//    }
//    @isTest
//    static void testSearchClusters(){
//        Test.startTest();
//        List<LookupSearchResult> result = LookupGeoHierarchyController.searchClusters(GEO_CLUSTER,new List<String>(),new List<String>{GEO_HUB},new List<String>{GEO_REGION});
//        Test.stopTest();
//        system.assertEquals(1,result.size(),'Checking the number of clusters is 1 as expected');
//    }
//    @isTest
//    static void testSearchAllClusters(){
//        Test.startTest();
//        List<LookupSearchResult> result = LookupGeoHierarchyController.searchAllClusters(new List<String>(),new List<String>{GEO_HUB},new List<String>{GEO_REGION});
//        Test.stopTest();
//        system.assertEquals(1,result.size(),'Checking the number of clusters is 1 as expected');
//    }
    @isTest
    static void testSearchGeoHierarchyByMarket(){
        Test.startTest();
        List<LookupSearchResult> result = LookupGeoHierarchyController.searchGeoHierarchyByMarket(GEO_COUNTRY);
        Test.stopTest();
        system.assertEquals(1,result.size(),'Checking the number of markets is 1 as expected');
    }
    @isTest
    static void testSearchAdditionalGeoHierarchyByMarkets(){
        Test.startTest();
        List<LookupSearchResult> result = LookupGeoHierarchyController.searchAdditionalGeoHierarchyByMarkets(new List<String>{GEO_COUNTRY});
        Test.stopTest();
        system.assertEquals(1,result.size(),'Checking the number of markets is 1 as expected');
    }
    @isTest
    static void testSearchAllMarkets(){
        Test.startTest();
        List<LookupSearchResult> result = LookupGeoHierarchyController.searchAllMarkets(new List<String>());
        Test.stopTest();
        system.assertEquals(1,result.size(),'Checking the number of markets is 1 as expected');
    }
    @isTest
    static void testSearchMarkets(){
        Test.startTest();
        List<LookupSearchResult> result = LookupGeoHierarchyController.searchMarkets(GEO_COUNTRY,new List<String>());
        Test.stopTest();
        system.assertEquals(1,result.size(),'Checking the number of markets is 1 as expected');
    }
    @isTest
    static void testSearchTradeTypes(){
        Test.startTest();
        List<LookupSearchResult> result = LookupGeoHierarchyController.searchTradeTypes(GEO_TRADE_MARKET,new List<String>());
        Test.stopTest();
        system.assertEquals(1,result.size(),'Checking the number of trade types is 1 as expected');
    }
    @isTest
    static void testSearchAllTradeTypes(){
        Test.startTest();
        List<LookupSearchResult> result = LookupGeoHierarchyController.searchAllTradeTypes(new List<String>());
        Test.stopTest();
        system.assertEquals(5,result.size(),'Checking the number of trade types is 5 as expected');
    }
//    @isTest
//    static void testTransformToLookupResult(){
//        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{PROJECT_CLASSIFICATION_REPACK}).get(0);
//        List<LookupGeoHierarchyController.FlowRequest> requests = new List<LookupGeoHierarchyController.FlowRequest>();
//
//        LookupGeoHierarchyController.FlowRequest request1 = new LookupGeoHierarchyController.FlowRequest();
//        request1.project = project;
//        request1.type = LEAD_MARKET_TYPE;
//        requests.add(request1);
//
//        LookupGeoHierarchyController.FlowRequest request2 = new LookupGeoHierarchyController.FlowRequest();
//        request2.project = project;
//        request2.type = DISTRIBUTION_CHANNEL_TYPE;
//        requests.add(request2);
//
//        LookupGeoHierarchyController.FlowRequest request3 = new LookupGeoHierarchyController.FlowRequest();
//        request3.project = project;
//        request3.type = REGION_TYPE;
//        requests.add(request3);
//
//        LookupGeoHierarchyController.FlowRequest request4 = new LookupGeoHierarchyController.FlowRequest();
//        request4.project = project;
//        request4.type = HUB_TYPE;
//        requests.add(request4);
//
//        LookupGeoHierarchyController.FlowRequest request5 = new LookupGeoHierarchyController.FlowRequest();
//        request5.project = project;
//        request5.type = CLUSTER_TYPE;
//        requests.add(request5);
//
//        LookupGeoHierarchyController.FlowRequest request6 = new LookupGeoHierarchyController.FlowRequest();
//        request6.project = project;
//        request6.type = TRADE_TYPE;
//        requests.add(request6);
//
//        LookupGeoHierarchyController.FlowRequest request7 = new LookupGeoHierarchyController.FlowRequest();
//        request7.project = project;
//        request7.type = ADDITIONAL_HUB_TYPE;
//        requests.add(request7);
//
//        LookupGeoHierarchyController.FlowRequest request8 = new LookupGeoHierarchyController.FlowRequest();
//        request8.project = project;
//        request8.type = ADDITIONAL_CLUSTER_TYPE;
//        requests.add(request8);
//
//        LookupGeoHierarchyController.FlowRequest request9 = new LookupGeoHierarchyController.FlowRequest();
//        request9.project = project;
//        request9.type = ADDITIONAL_MARKET_TYPE;
//        requests.add(request9);
//
//        LookupGeoHierarchyController.FlowRequest request10 = new LookupGeoHierarchyController.FlowRequest();
//        request10.project = project;
//        request10.type = ADDITIONAL_REGION_TYPE;
//        requests.add(request10);
//
//        Test.startTest();
//        for(LookupGeoHierarchyController.FlowRequest request : requests){
//            List<LookupGeoHierarchyController.FlowRequest> oneItemRequest = new List<LookupGeoHierarchyController.FlowRequest>{request};
//            LookupGeoHierarchyController.transformToLookupResult(oneItemRequest);
//        }
//        Test.stopTest();
//    }
    @isTest
    static void testSearchBrandHomes(){
        Schema.DescribeFieldResult fieldResult = Project__c.BrandHome__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        Test.startTest();
        List<LookupSearchResult> result = LookupGeoHierarchyController.searchBrandHomes(picklistValues[0].label, new List<String>());
        Test.stopTest();
        system.assertEquals(1,result.size(),'Checking the number of brand homes is 1 as expected');
    }
    @isTest
    static void testSearchAllBrandHomes(){
        Test.startTest();
        List<LookupSearchResult> result = LookupGeoHierarchyController.searchAllBrandHomes(new List<String>());
        Test.stopTest();
        Schema.DescribeFieldResult fieldResult = Project__c.BrandHome__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        system.assertEquals(picklistValues.size(), result.size(), 'Checking the number of brand homes based on all values existing in the BrandHome__c field');
    }
}