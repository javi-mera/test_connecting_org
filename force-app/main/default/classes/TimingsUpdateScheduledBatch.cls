/**
 * @author - Darya Rykhlik
 * @date - 22 Apr 2024
 * @description - The Batch class to update Timings recommended dates when Project is in 1st phase
 */

public class TimingsUpdateScheduledBatch implements Database.Batchable<SObject>, Database.Stateful {
    /**
         * Method to collect records to be passed to the execute method
         * @param batchableContext - The parameter type of a batch job method
         * @return - List of records to be processed with a SOQL query
         */
    public Database.QueryLocator start(Database.BatchableContext batchableContext) {
        return Database.getQueryLocator(
            'SELECT OnOffTrack__c, OpportunityRecommendedDate__c, BCARecommendedDate__c, ' +
                'BCVRecommendedDate__c, CustomerMeetingRecommendedDate__c, CommercialRecommendedDate__c, ' +
                'ProductionRecommendedDate__c, ShipmentRecommendedDate__c, OnShelfRecommendedDate__c, ' +
                'PLRRecommendedDate__c, ProjectPhase__c, ActualOnShelfDate__c, ActualReadyShipmentDate__c, ' +
                'ActualPLRDate__c, ProjectStatus__c, ProjectClassificationSubtype__c, ProjectClassification__c, ' +
                'SubmissionStatus__c, OpportunitySubmissionDate__c, BCAApprovalDate__c, BCASubmissionDate__c, ' +
                'BCVSubmissionDate__c, BCVApprovalDate__c, CommercialSubmissionDate__c, CommercialApprovalDate__c, ' +
                'ProductionSubmissionDate__c, TargetBCASubmissionDate__c, TargetBCVSubmissionDate__c, TargetProductionSubmissionDate__c, ' +
                'TargetCommercialSubmissionDate__c, TargetPLRDate__c, Estimated1stCustomerPresentationDate__c, TargetReadyShipmentDate__c, ' +
                'TargetOnShelfDateLeadRegion__c, IPCExtensionWithoutArtworkChange__c, ArtworkChange__c, NewLiquid__c, NewPrimaryPack__c,' +
                'SourcingChange__c\n' +
                'FROM Project__c\n' +
                'WHERE AreTimingsAvailable__c = TRUE\n' +
                'AND (((ProjectClassification__c = \'Fearless Bet\'\n' +
                'OR ProjectClassification__c = \'Brand Energizer\'\n' +
                'OR ProjectClassification__c = \'Repack\')\n' +
                'AND ProjectStatus__c = \'Draft\'\n' +
                'AND ProjectPhase__c = \'Discover\')\n' +
                'OR ((ProjectClassification__c = \'Geographical Extension\'\n' +
                'OR ProjectClassification__c = \'Business Enabler\')\n' +
                'AND (ProjectStatus__c = \'Draft\' OR ProjectStatus__c = \'Active\')\n' +
                'AND ProjectPhase__c = \'Define\'\n' +
                'AND SubmissionStatus__c != \'Business Case Ambition Submitted\'))'
        );
    }

    /**
     * Method to process each “batch” of data passed to the method
     * @param batchableContext - The parameter type of a batch job method
     * @param projects - List of Project__c records
     */
    public void execute(Database.BatchableContext batchableContext, List<Project__c> projects) {
        if (!projects.isEmpty()) {
            List<Project__c> projectsToUpdate = new List<Project__c>();
            for (Project__c project : projects) {
                TimingsTableController.checkProjectTimings(project);
                projectsToUpdate.add(project);
            }
            if (!projectsToUpdate.isEmpty()) {
                update projectsToUpdate;
            }
        }
    }
    /**
     * Method to execute post-processing operations
     * @param batchableContext - The parameter type of a batch job method
     */
    public void finish(Database.BatchableContext batchableContext) { }
}