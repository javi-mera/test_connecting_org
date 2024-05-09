/**
 * @author - Darya Rykhlik
 * @date - 09 Feb 2023
 * @description - The Batch class to update the names of the Financial__c.Label__c
 * @update - 27 Mar 2024
 */

public class FinancialsLabelUpdateBatch implements Database.Batchable<SObject>, Database.Stateful {
    public final static String sizeOfPrizeLabel = 'Cumulative Size of Prize (Incremental $K Year 1 - Year 5)';
    public final static String newSizeOfPrizeLabel = 'Cumulative Size of Prize (Incremental NSV $000 USD Year 1 - Year 5)';
    public final static String investmentRequiredLabel = 'Investment required (A&P $K) (Year 1) - Enter figure as a positive number, no minus symbol.';
    public final static String newInvestmentRequiredLabel = 'A&P investment required in Year 1 ($000 USD). Enter as a positive number, no minus symbol';
    public final static String yearOneGPLabel = 'Year 1 Gross Profit ($GP per 9L case) (Year 1 - to include 1-off costs like listing fees)';
    public final static String newYearOneGPLabel = 'Year 1 Gross Profit ($GP per 9L case). Include one off costs like listing fees';
    public final static String ongoingStructuralProfitability = 'Ongoing (Yr 2) Structural Profitability ($GP per 9L case) (Year 2 - to compare going financials)';
    public final static String newOngoingStructuralProfitability = 'Year 2 Structural Profitability ($GP per 9L case) Year 2 is used to compare ongoing financial performance';

    /**
     * Method to collect records to be passed to the execute method
     * @param batchableContext - The parameter type of a batch job method
     * @return - List of records to be processed with a SOQL query
     */
    public Database.QueryLocator start(Database.BatchableContext batchableContext) {
        return Database.getQueryLocator(
            'SELECT Label__c ' +
            'FROM Financial__c ' +
            'WHERE Label__c = \'' + sizeOfPrizeLabel + '\' ' +
            'OR Label__c = \'*' + sizeOfPrizeLabel + '\' ' +
            'OR Label__c = \'' + investmentRequiredLabel + '\' ' +
            'OR Label__c = \'*' + investmentRequiredLabel + '\' ' +
            'OR Label__c = \'' + yearOneGPLabel + '\' ' +
            'OR Label__c = \'*' + yearOneGPLabel + '\' ' +
            'OR Label__c = \'' + ongoingStructuralProfitability + '\' ' +
            'OR Label__c = \'*' + ongoingStructuralProfitability + '\''
        );
    }

    /**
     * Method to process each “batch” of data passed to the method
     * @param batchableContext - The parameter type of a batch job method
     * @param financials - List of Financial__c records
     */
    public void execute(Database.BatchableContext batchableContext, List<Financial__c> financials) {
        for (Financial__c financial : financials) {
            if (financial.Label__c == sizeOfPrizeLabel || financial.Label__c == '*' + sizeOfPrizeLabel) {
                financial.Label__c = newSizeOfPrizeLabel;
            } else if (financial.Label__c == investmentRequiredLabel || financial.Label__c == '*' + investmentRequiredLabel) {
                financial.Label__c = newInvestmentRequiredLabel;
            } else if (financial.Label__c == yearOneGPLabel || financial.Label__c == '*' + yearOneGPLabel) {
                financial.Label__c = newYearOneGPLabel;
            } else if (financial.Label__c == ongoingStructuralProfitability || financial.Label__c == '*' + ongoingStructuralProfitability) {
                financial.Label__c = newOngoingStructuralProfitability;
            }
        }
        update financials;
    }
    /**
     * Method to execute post-processing operations
     * @param batchableContext - The parameter type of a batch job method
     */
    public void finish(Database.BatchableContext batchableContext) { }
}