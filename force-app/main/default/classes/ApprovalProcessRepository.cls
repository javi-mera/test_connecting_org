public with sharing class ApprovalProcessRepository {
    
    public static Project__c getProjectById(Id projectId) {
        return [SELECT Id, ApprovalProcessStatus__c, ProjectClassification__c, ProjectPhase__c, DecisionStep__c, SubmissionStatus__c,
                ArtworkChange__c, NewLiquid__c, SourcingChange__c, NewPrimaryPack__c, ProjectClassificationSubtype__c,
                Category__c, Brand__c, Subrand__c, Hub__c, Cluster__c, LeadMarket__c, DC__c, TradeType__c, EndOfProject__c
                FROM Project__c WHERE Id =: projectId];
    }

    public static List<Project__c> getProjectsByClassifications(List<String> classifications) {
        return [
            SELECT ApprovalProcessStatus__c, ProjectClassification__c, ProjectPhase__c, DecisionStep__c, SubmissionStatus__c,
            ArtworkChange__c, NewLiquid__c, SourcingChange__c, NewPrimaryPack__c, ProjectClassificationSubtype__c,
            Category__c, Brand__c, Subrand__c, Hub__c, Cluster__c, LeadMarket__c, DC__c, TradeType__c, EndOfProject__c,
            AdditionalApprover1__c, AdditionalApprover2__c, AdditionalApprover3__c, AdditionalApprover4__c, AdditionalApprover5__c, AdditionalApprover6__c, 
            AdditionalApprover7__c, AdditionalApprover8__c, AdditionalApprover9__c, AdditionalApprover10__c, ProjectNumberFormula__c, Name, Volume__c,
            VolumeComments__c, TargetCOGs__c, TargetOGsComments__c, Legal__c, LegalComments__c, TargetLiquidOrPackExecutionComments__c,
            TargetLiquidPackExecution__c, TargetTimeAtMarket__c, TargetTimeAtMarketComments__c, TargetOthers__c,
            TargetOtherComments__c, SummaryOfChangesFromBusinessCase__c, ProjectLeaderFormula__c, TargetOnShelfDateLeadRegion__c,
            ProjectLeader__c, ProjectManager__c, ProjectManagerFormula__c, IPCExtensionWithoutArtworkChange__c, Team__c, FinancialThresholdNotMetComment__c
            FROM Project__c
            WHERE ProjectClassification__c IN :classifications
        ];
    }

    public static EmailTemplate getTemplateByName(String name){
        return [Select Id,Subject,Description, HtmlValue,DeveloperName,Body from EmailTemplate where name = :name LIMIT 1];
    }
    public static List<User> getUsersByIds(Set<Id> userIds){
        return [Select Id, Email, Name From User WHERE Id IN :userIds];
    }

    public static Map<Id, User> getAllActiveUsers() {
        Map<Id, User> userMap = new Map<Id, User>([
            SELECT Email, Name, PendingProjectsToReassign__c, DelegatedApproverId
            FROM User
            WHERE IsActive = TRUE
        ]);

        return userMap;
    }

    public static Id getAdminUserId() {
        Id adminProfileId = [ SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
        Id adminUserId = [ SELECT Id FROM User WHERE ProfileId =: adminProfileId AND IsActive = TRUE LIMIT 1].Id;
        return adminUserId;
    }
}