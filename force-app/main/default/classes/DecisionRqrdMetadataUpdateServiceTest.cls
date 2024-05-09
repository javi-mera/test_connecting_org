@isTest
public with sharing class DecisionRqrdMetadataUpdateServiceTest {
    @isTest static void testUpdateMetadataCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new RestServiceMock());
        Test.startTest();
        String response = DecisionRequiredMetadataUpdateService.updateCustomMetadata('test','test','test');
        Test.stopTest();
        System.assertNotEquals(null, response);
    }
    @isTest static void testUpdateMetadata() {
        List<Decision_Required__mdt> metadataList = DecisionRequiredMetadataUpdateService.getAllMetadata();
        Test.startTest();
        String response = DecisionRequiredMetadataUpdateService.updateMetadata(metadataList.get(0).label,metadataList.get(0).TaskList__c,metadataList.get(0).DecisionRequired__c);
        Test.stopTest();
        System.assertEquals(DecisionRequiredMetadataUpdateService.SUCCESS_MSG, response);
    }
    @isTest static void testUpdateMetadataNotFound() {
        Test.startTest();
        String response = DecisionRequiredMetadataUpdateService.updateMetadata('test','test','test');
        Test.stopTest();
        System.assertEquals(DecisionRequiredMetadataUpdateService.NOT_FOUND_MSG, response);
    }
    @isTest static void testGetAllMetadata() {
        Test.startTest();
        List<Decision_Required__mdt> response = DecisionRequiredMetadataUpdateService.getAllMetadata();
        Test.stopTest();
        //TOTAL AMOUNT OF METADATA FROM EXCEL -> 50 records
        Assert.isTrue(response.size() > 0, 'There\'s no Metadata');
    }

}