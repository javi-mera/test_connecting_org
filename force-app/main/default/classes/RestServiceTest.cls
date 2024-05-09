@isTest
public with sharing class RestServiceTest {

    @isTest static void testAuthCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new RestServiceMock());
        Test.startTest();
        RestService.init();
        String accessToken = RestService.getAccessToken();
        Test.stopTest();
        System.assertEquals('asdf', accessToken);
    }
    @isTest static void testPutCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new RestServiceMock());
        Test.startTest();
        RestService.init();
        String body = '{"example":"test"}';
        HttpResponse res =  RestService.put(body,'test');
        Test.stopTest();
        System.assertEquals(200, res.getStatusCode());
    }
    @isTest static void testPostCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new RestServiceMock());
        Test.startTest();
        RestService.init();
        String body = '{"example":"test"}';
        HttpResponse res = RestService.post(body,'test');
        Test.stopTest();
        System.assertEquals(200, res.getStatusCode());
    }
    @isTest static void testGetEndpoints() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new RestServiceMock());
        Test.startTest();
        RestService.init();
        String reassignEndpoint = RestService.getReassignCommentEndpoint();
        String recallEndpoint = RestService.getRecallEndpoint();
        String updateApprovalHistoryEndpoint = RestService.getUpdateApprovalHistoryEndpoint();
        String updateMetadataEndpoint = RestService.getUpdateMetadataEndpoint();
        String updateProjectStatusEndpoint = RestService.getUpdateProjectEndpoint();
        Test.stopTest();
        System.assertEquals(RestService.orgURL+RestService.REST_PRE_ENDPOINT+RestService.RECALL_ENDPOINT, recallEndpoint);
        System.assertEquals(RestService.orgURL+RestService.REST_PRE_ENDPOINT+RestService.REASSIGN_COMMENT_ENDPOINT, reassignEndpoint);
        System.assertEquals(RestService.orgURL+RestService.REST_PRE_ENDPOINT+RestService.UPDATE_APPROVAL_HISTORY_ENDPOINT, updateApprovalHistoryEndpoint);
        System.assertEquals(RestService.orgURL+RestService.REST_PRE_ENDPOINT+RestService.UPDATE_METADATA_ENDPOINT, updateMetadataEndpoint);
        System.assertEquals(RestService.orgURL+RestService.REST_PRE_ENDPOINT+RestService.UPDATE_PROJECT_ENDPOINT, updateProjectStatusEndpoint);
    }
}