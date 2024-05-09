/**
 * @author - Darya Rykhlik
 * @date - 09 Feb 2023
 * @description - The class to test the FinancialsLabelUpdateBatch logic
 * @update - 27 Mar 2024
 */

@IsTest
public class FinancialsLabelUpdateBatchTest {

    final static Integer RECORDS_AMOUNT = 120;

    @TestSetup
    static void setup() {
        Id projectLeaderProfileId = [ SELECT Id FROM Profile WHERE Name = 'Project Leader' LIMIT 1 ].Id;
        Id projectManagerProfileId = [ SELECT Id FROM Profile WHERE Name = 'Project Manager' LIMIT 1 ].Id;

        User projectManager = TestFactory.newUser('Project Manager 1', projectManagerProfileId, true);
        User projectLeader = TestFactory.newUser('Project Leader 1', projectLeaderProfileId, true);

        CustomTeams__Teams__c team = TestFactory.newCustomTeam('Team', true);

        Project__c project = TestFactory.newProject('Test', 'Business Enabler', 'Define',
                                                    projectLeader, projectManager, team, true);

        Id deliverableRecordTypeId = [ SELECT Id, Name FROM RecordType  WHERE Name = 'Deliverable' ].Id;

        List<Financial__c> financials = new List<Financial__c>();
        for (Integer i = 0; i < RECORDS_AMOUNT; i++) {
            financials.add(TestFactory.newDeliverable(project.Id, deliverableRecordTypeId, false));
        }

        for (Integer i = 0; i < financials.size() / 2; i++) {
            if(Math.mod(i, 2) == 0){
                financials[i].Label__c = FinancialsLabelUpdateBatch.sizeOfPrizeLabel;
            } else {
                financials[i].Label__c = FinancialsLabelUpdateBatch.investmentRequiredLabel;
            }
        }

        for (Integer i = 60; i < financials.size(); i++) {
            if(Math.mod(i, 2) == 0){
                financials[i].Label__c = FinancialsLabelUpdateBatch.yearOneGPLabel;
            } else {
                financials[i].Label__c = FinancialsLabelUpdateBatch.ongoingStructuralProfitability;
            }
        }

        insert financials;
    }

    @IsTest
    static void updateFinancialLabelTest(){
        Test.startTest();
        Database.executeBatch(new FinancialsLabelUpdateBatch());
        Test.stopTest();

        Integer sizeOfPrizeLabelCount = 0;
        Integer investmentRequiredLabelCount = 0;
        Integer yearOneGPLabelCount = 0;
        Integer ongoingStructuralProfitabilityCount = 0;

        for (Financial__c financial : [ SELECT Label__c FROM Financial__c ]) {
            if (financial.Label__c == FinancialsLabelUpdateBatch.newSizeOfPrizeLabel) {
                Assert.areEqual(FinancialsLabelUpdateBatch.newSizeOfPrizeLabel, financial.Label__c);
                sizeOfPrizeLabelCount++;
            } else if (financial.Label__c == FinancialsLabelUpdateBatch.newInvestmentRequiredLabel) {
                Assert.areEqual(FinancialsLabelUpdateBatch.newInvestmentRequiredLabel, financial.Label__c);
                investmentRequiredLabelCount++;
            } else if (financial.Label__c == FinancialsLabelUpdateBatch.newYearOneGPLabel) {
                Assert.areEqual(FinancialsLabelUpdateBatch.newYearOneGPLabel, financial.Label__c);
                yearOneGPLabelCount++;
            } else if (financial.Label__c == FinancialsLabelUpdateBatch.newOngoingStructuralProfitability) {
                Assert.areEqual(FinancialsLabelUpdateBatch.newOngoingStructuralProfitability, financial.Label__c);
                ongoingStructuralProfitabilityCount++;
            }
        }

        Assert.areEqual(RECORDS_AMOUNT / 4, sizeOfPrizeLabelCount);
        Assert.areEqual(RECORDS_AMOUNT / 4, investmentRequiredLabelCount);
        Assert.areEqual(RECORDS_AMOUNT / 4, yearOneGPLabelCount);
        Assert.areEqual(RECORDS_AMOUNT / 4, ongoingStructuralProfitabilityCount);
    }
}