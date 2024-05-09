@IsTest
public class ReturnOfInvestmentFinancialsDataFixTest {

    @TestSetup
    static void makeData() {
        TestFactory.generateBasicSetUp();
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{ InnovatorConstants.PROMOTIONAL_PACK }).get(0);
        Financial__c financial = new Financial__c(Project__c = project.Id);
        insert financial;
    }

    @IsTest
    static void recaculateReturnOnInvestment() {
        ReturnOfInvestmentFinancialsDataFixBatch batch = new ReturnOfInvestmentFinancialsDataFixBatch();
        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();
    }

}