@IsTest
public with sharing class BMCBatchDataFixTest {


    @TestSetup
    static void setup() {
        TestFactory.generateBasicSetUp();
    }
    
    @IsTest
    static void updateBMCAndMarketClassificationsTest(){
        Test.startTest();
        Database.executeBatch(new BMCBatchDataFix());
        Test.stopTest();
    }

}