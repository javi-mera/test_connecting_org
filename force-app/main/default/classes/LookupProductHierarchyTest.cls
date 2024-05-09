@IsTest
public with sharing class LookupProductHierarchyTest {
    private static final String CATEGORY_TYPE = 'Category';
    private static final String BRAND_TYPE = 'Brand';
    private static final String SUBBRAND_TYPE = 'SubBrand';
    private static final String FLAVOUR_TYPE = 'Flavour';
    private static final String SIZE_TYPE = 'Size';
    private static final String PRODUCT_NEW = 'New';
    private static final String NEW_HIERARCHY_TYPE = 'NEW';
    private static final String PROJECT_CLASSIFICATION_REPACK = 'Repack';
    private static final String RESULT_NOT_EMPTY = 'Result is not Empty';

    @TestSetup
    static void testSetup(){
        TestFactory.generateBasicSetUp();
    }

    @IsTest
    static void testSearchCategories(){
        List<LookupSearchResult> categories = LookupProductHierarchyController.searchAllCategories();
        Id[] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = categories.get(0).getId();
        Test.setFixedSearchResults(fixedSearchResults);
        Test.startTest();
        List<LookupSearchResult> result = LookupProductHierarchyController.searchCategories(categories.get(0).getValue(),new List<String>());
        Test.stopTest();
        System.assertNotEquals(0, result.size(), RESULT_NOT_EMPTY);
    }

    @IsTest
    static void testsearchAllCategories(){
        Test.startTest();
        List<LookupSearchResult> result = LookupProductHierarchyController.searchAllCategories();
        Test.stopTest();
        system.assertEquals(1, result.size(), 'Checking the number of categories is 1 as inserted in the test setup');
    }

    @IsTest
    static void testSearchBrands(){
        List<LookupSearchResult> brands = LookupProductHierarchyController.searchAllBrands(new List<String>{NEW_HIERARCHY_TYPE});
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = brands.get(0).getId();
        Test.setFixedSearchResults(fixedSearchResults);
        Test.startTest();
        List<LookupSearchResult> result = LookupProductHierarchyController.searchBrands(brands.get(0).getSubtitle(),new List<String>(),new List<String>{NEW_HIERARCHY_TYPE});
        Test.stopTest();
        System.assertNotEquals(0, result.size(), RESULT_NOT_EMPTY);
    }

    @IsTest
    static void testSearchAllBrands(){
        Test.startTest();
        List<LookupSearchResult> result = LookupProductHierarchyController.searchAllBrands(new List<String>{NEW_HIERARCHY_TYPE});
        Test.stopTest();
        system.assertEquals(1, result.size(), 'Checking the number of brands is 1 as inserted in the test setup');
    }

    @IsTest
    static void testSearchSubBrands(){
        List<LookupSearchResult> subbrands = LookupProductHierarchyController.searchAllSubBrands(new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE});
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = subbrands.get(0).getId();
        Test.setFixedSearchResults(fixedSearchResults);
        Test.startTest();
        List<LookupSearchResult> result = LookupProductHierarchyController.searchSubBrands(subbrands.get(0).getIcon(),new List<String>(),new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE});
        Test.stopTest();
        System.assertNotEquals(0, result.size(), RESULT_NOT_EMPTY);
    }

    @IsTest
    static void testSearchAllSubBrands(){
        Test.startTest();
        List<LookupSearchResult> result = LookupProductHierarchyController.searchAllSubBrands(new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE});
        Test.stopTest();
        system.assertEquals(1, result.size(), 'Checking the number of sub brands is 1 as inserted in the test setup');
    }

    @IsTest
    static void testSearchFlavours(){
        List<LookupSearchResult> flavours = LookupProductHierarchyController.searchAllFlavours(new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE});
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = flavours.get(0).getId();
        Test.setFixedSearchResults(fixedSearchResults);
        Test.startTest();
        List<LookupSearchResult> result = LookupProductHierarchyController.searchFlavours(NEW_HIERARCHY_TYPE,new List<String>(),new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE});
        Test.stopTest();
        System.assertNotEquals(0, result.size(), RESULT_NOT_EMPTY);
    }

    @IsTest
    static void testSearchAllFlavours(){
        Test.startTest();
        List<LookupSearchResult> result = LookupProductHierarchyController.searchAllFlavours(new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE});
        Test.stopTest();
        system.assertEquals(1, result.size(), 'Checking the number of flavours is 1 as inserted in the test setup');
    }

    @IsTest
    static void testSearchSizes(){
        List<LookupSearchResult> sizes = LookupProductHierarchyController.searchAllSizes(new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE});
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = sizes.get(0).getId();
        Test.setFixedSearchResults(fixedSearchResults);
        Test.startTest();
        List<LookupSearchResult> result = LookupProductHierarchyController.searchSizes(NEW_HIERARCHY_TYPE,new List<String>(),new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE});
        Test.stopTest();
        System.assertNotEquals(0, result.size(), RESULT_NOT_EMPTY);
    }

    @IsTest
    static void testSearchAllSizes(){
        Test.startTest();
        List<LookupSearchResult> result = LookupProductHierarchyController.searchAllSizes(new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE});
        Test.stopTest();
        system.assertEquals(1,result.size(),'Checking the number of sizes is 1 as inserted in the test setup');
    }

    @IsTest
    static void testTransformToLookupResult(){
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{PROJECT_CLASSIFICATION_REPACK}).get(0);
        List<LookupProductHierarchyController.FlowRequest> requests = new List<LookupProductHierarchyController.FlowRequest>();

        LookupProductHierarchyController.FlowRequest request1 = new LookupProductHierarchyController.FlowRequest();
        request1.projectId = project.Id;
        request1.type = CATEGORY_TYPE;
        requests.add(request1);

        LookupProductHierarchyController.FlowRequest request2 = new LookupProductHierarchyController.FlowRequest();
        request2.projectId = project.Id;
        request2.type = BRAND_TYPE;
        requests.add(request2);

        LookupProductHierarchyController.FlowRequest request3 = new LookupProductHierarchyController.FlowRequest();
        request3.projectId = project.Id;
        request3.type = SUBBRAND_TYPE;
        requests.add(request3);

        LookupProductHierarchyController.FlowRequest request4 = new LookupProductHierarchyController.FlowRequest();
        request4.projectId = project.Id;
        request4.type = FLAVOUR_TYPE;
        requests.add(request4);

        LookupProductHierarchyController.FlowRequest request5 = new LookupProductHierarchyController.FlowRequest();
        request5.projectId = project.Id;
        request5.type = SIZE_TYPE;
        requests.add(request5);

        LookupProductHierarchyController.FlowRequest request6 = new LookupProductHierarchyController.FlowRequest();
        request6.projectId = project.Id;
        request6.type = CATEGORY_TYPE;
        requests.add(request6);

        LookupProductHierarchyController.FlowRequest request7 = new LookupProductHierarchyController.FlowRequest();
        request7.projectId = project.Id;
        request7.type = BRAND_TYPE;
        requests.add(request7);

        LookupProductHierarchyController.FlowRequest request8 = new LookupProductHierarchyController.FlowRequest();
        request8.projectId = project.Id;
        request8.type = SUBBRAND_TYPE;
        requests.add(request8);

        LookupProductHierarchyController.FlowRequest request9 = new LookupProductHierarchyController.FlowRequest();
        request9.projectId = project.Id;
        request9.type = FLAVOUR_TYPE;
        requests.add(request9);

        LookupProductHierarchyController.FlowRequest request10 = new LookupProductHierarchyController.FlowRequest();
        request10.projectId = project.Id;
        request10.type = SIZE_TYPE;
        requests.add(request10);

        Test.startTest();
        for(LookupProductHierarchyController.FlowRequest request : requests){
            List<LookupProductHierarchyController.FlowRequest> oneItemRequest = new List<LookupProductHierarchyController.FlowRequest>{request};
            LookupProductHierarchyController.transformToLookupResult(oneItemRequest);
        }
        Test.stopTest();
    }

    @IsTest
    static void testGenerateProductHierarchyRecords(){
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{PROJECT_CLASSIFICATION_REPACK}).get(0);
        List<LookupSearchResult> categories = LookupProductHierarchyController.searchAllCategories();
        List<LookupSearchResult> brands = LookupProductHierarchyController.searchAllBrands(new List<String>{NEW_HIERARCHY_TYPE});
        List<LookupSearchResult> subbrands = LookupProductHierarchyController.searchAllSubBrands(new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE});
        List<LookupSearchResult> flavours = LookupProductHierarchyController.searchAllFlavours(new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE});
        List<LookupSearchResult> sizes = LookupProductHierarchyController.searchAllSizes(new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE},new List<String>{NEW_HIERARCHY_TYPE});
        List<LookupProductHierarchyService.FlowLookups> lookups = new List<LookupProductHierarchyService.FlowLookups>();
        LookupProductHierarchyService.FlowLookups lookup = new LookupProductHierarchyService.FlowLookups();
        lookup.categories = categories;
        lookup.brands = brands;
        lookup.subbrands = subbrands;
        lookup.sizes = sizes;
        lookup.flavours = flavours;
        lookup.projectId = project.Id;
        lookups.add(lookup);
        Test.startTest();
        LookupProductHierarchyService.generateProductHierarchyRecords(lookups);
        Test.stopTest();
    }
}