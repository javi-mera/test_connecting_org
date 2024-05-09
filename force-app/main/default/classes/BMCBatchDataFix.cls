public with sharing class BMCBatchDataFix implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext batchableContext) {
        return Database.getQueryLocator('SELECT Id, BMCClassification__c, AddAdditionalMarketOrMarkets__c, MarketClassification__c, Brand__c, Category__c, LeadMarket__c FROM Project__c WHERE MarketClassification__c = null AND BMCClassification__c = null');
    }

    public void execute(Database.BatchableContext batchableContext, List<Project__c> projects) {
        for (Project__c project : projects) {
            BMCMatrixService.setBMC(project);
        }
        update projects;
    }

    public void finish(Database.BatchableContext batchableContext) {}
}