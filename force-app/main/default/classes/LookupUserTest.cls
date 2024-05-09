@isTest
public with sharing class LookupUserTest {

    private static final String PROJECT_MANAGER = 'ProjectManager';
    private static final String PROJECT_LEADER = 'ProjectLeader';
    @TestSetup
    static void testSetup(){
        TestFactory.generateBasicSetUp();
    }
    @isTest
    static void testLookupSearchUsers(){
        List<LookupSearchResult> users = LookupUserController.searchAllUsers();
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = users.get(0).getId();
        Test.setFixedSearchResults(fixedSearchResults);
        Test.startTest();
        List<LookupSearchResult> result = LookupUserController.searchUsers(users.get(0).getTitle(), new List<String>());
        Test.stopTest();
    }
    @isTest
    static void testLookupSearchPMUsers(){
        List<LookupSearchResult> users = LookupUserController.searchAllUsers();
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = users.get(0).getId();
        Test.setFixedSearchResults(fixedSearchResults);
        Test.startTest();
        List<LookupSearchResult> result = LookupUserController.searchPMUsers(users.get(0).getSObjectType(), new List<String>());
        Test.stopTest();
    }
    @isTest
    static void testLookupSearchAllUsers(){
        Test.startTest();
        List<LookupSearchResult> result = LookupUserController.searchAllUsers();
        Test.stopTest();
    }
    @isTest
    static void testLookupSearchAllPMUsers(){
        Test.startTest();
        List<LookupSearchResult> result = LookupUserController.searchAllPMUsers();
        Test.stopTest();
    }
    @isTest
    static void testTransformUser(){
        List<LookupSearchResult> users = LookupUserController.searchAllUsers();
        Test.startTest();
        LookupUserController.transformPLUser(users.get(0).getId());
        Test.stopTest();
    }
    @isTest
    static void testGetUserProfile(){
        Test.startTest();
        LookupUserController.getUserProfile();
        Test.stopTest();
    }
    @isTest
    static void testTransformToLookupResult(){
        List<LookupSearchResult> pmUsers = LookupUserController.searchAllPMUsers();
        List<LookupUserController.FlowRequest> requests = new List<LookupUserController.FlowRequest>();
        LookupUserController.FlowRequest request = new LookupUserController.FlowRequest();
        request.type = PROJECT_MANAGER;
        request.userId = pmUsers.get(0).getId();
        request.userName = pmUsers.get(0).getValue();
        requests.add(request);
        Test.startTest();
        LookupUserController.transformToLookupResult(requests);
        Test.stopTest();
    }
}