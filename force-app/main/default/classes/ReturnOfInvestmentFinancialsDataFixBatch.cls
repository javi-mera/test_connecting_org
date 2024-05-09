public with sharing class ReturnOfInvestmentFinancialsDataFixBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext batchableContext) {
        return Database.getQueryLocator('SELECT TotalNP__c, TotalCosts__c, ReturnOnInvestment__c,Project__c, Project__r.Name, Project__r.ProjectStatus__c, Project__r.ProjectPhase__c FROM Financial__c WHERE Project__r.ProjectClassification__c = \'Promotional Pack\' AND Project__r.ProjectStatus__c = \'Active\' AND IsFromProjectSnapshot__c = false');
    }

    public void execute(Database.BatchableContext batchableContext, List<Financial__c> financials) {
        for (Financial__c financial : financials) {
            if (financial.TotalNP__c != null && financial.TotalCosts__c != null && financial.TotalCosts__c != 0 && financial.TotalNP__c != 0) {
                financial.ReturnOnInvestment__c = (financial.TotalNP__c / -financial.TotalCosts__c) - 1;
            }
        }
        update financials;
    }

    public void finish(Database.BatchableContext batchableContext) {}

}