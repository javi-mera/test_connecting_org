public class TimingsTableController {
    @AuraEnabled
    public static List<Timings__mdt> getTimingsMetadata(String projectClassification, String projectSubtype) {
        return [
            SELECT BCA__c, BCV__c, Commercial__c, CustomerMeeting__c, OnShelf__c, Opportunity__c, Production__c, Shipment__c
            FROM Timings__mdt
            WHERE ProjectClassification__c = :projectClassification
            AND ProjectClassificationSubtype__c = :projectSubtype
            LIMIT 1
        ];
    }

    @AuraEnabled
    public static Project__c getProject(String projectId) {
        return [
            SELECT ProjectPhase__c, ProjectClassification__c, ProjectClassificationSubtype__c, ProjectStatus__c,
                TargetOpportunitySubmissionDate__c, TargetBCASubmissionDate__c, TargetBCVSubmissionDate__c,
                Estimated1stCustomerPresentationDate__c, TargetCommercialSubmissionDate__c, TargetProductionSubmissionDate__c,
                TargetReadyShipmentDate__c, TargetOnShelfDateLeadRegion__c, TargetPLRDate__c, OpportunitySubmissionDate__c,
                BCASubmissionDate__c, BCAApprovalDate__c, BCVSubmissionDate__c, BCVApprovalDate__c, CommercialSubmissionDate__c, CommercialApprovalDate__c,
                ProductionSubmissionDate__c, SubmissionStatus__c, ActualOnShelfDate__c, ActualReadyShipmentDate__c, ActualPLRDate__c,
                IsThePostLaunchReviewRequired__c, OnOffTrack__c, IPCExtensionWithoutArtworkChange__c, ArtworkChange__c, NewLiquid__c,
                NewPrimaryPack__c, SourcingChange__c
            FROM Project__c
            WHERE Id = :projectId
        ];
    }

    @AuraEnabled
    public static Project_Snapshot__c getProjectSnapshot(String projectSnapshotId) {
        return [
            SELECT ProjectPhase__c, ProjectClassification__c, ProjectClassificationSubtype__c, ProjectStatus__c,
                TargetOpportunitySubmissionDate__c, TargetBCASubmissionDate__c, TargetBCVSubmissionDate__c,
                Estimated1stCustomerPresentationDate__c, TargetCommercialSubmissionDate__c, TargetProductionSubmissionDate__c,
                TargetReadyShipmentDate__c, TargetOnShelfDateLeadRegion__c, TargetPLRDate__c, OpportunitySubmissionDate__c,
                BCASubmissionDate__c, BCAApprovalDate__c, BCVSubmissionDate__c, BCVApprovalDate__c, CommercialSubmissionDate__c, CommercialApprovalDate__c,
                ProductionSubmissionDate__c, OpportunityRecommendedDate__c, BCARecommendedDate__c, BCVRecommendedDate__c,
                CommercialRecommendedDate__c, ProductionRecommendedDate__c, CustomerMeetingRecommendedDate__c, ShipmentRecommendedDate__c,
                OnShelfRecommendedDate__c, PLRRecommendedDate__c, IPCExtensionWithoutArtworkChange__c, ArtworkChange__c, NewLiquid__c,
                NewPrimaryPack__c, SourcingChange__c
            FROM Project_Snapshot__c
            WHERE Id = :projectSnapshotId
        ];
    }

    public static void checkProjectTimings(Project__c project) {
//        Date currentToday = System.today();
        Date currentToday = System.now().dateGmt();
        String onOffTrack = project.OnOffTrack__c;

        Date opportunityRecommendedDate = project.OpportunityRecommendedDate__c;
        Date BCARecommendedDate = project.BCARecommendedDate__c;
        Date BCVRecommendedDate = project.BCVRecommendedDate__c;
        Date customerMeetingRecommendedDate = project.CustomerMeetingRecommendedDate__c;
        Date commercialRecommendedDate = project.CommercialRecommendedDate__c;
        Date productionRecommendedDate = project.ProductionRecommendedDate__c;
        Date shipmentRecommendedDate = project.ShipmentRecommendedDate__c;
        Date shelfRecommendedDate = project.OnShelfRecommendedDate__c;
        Date PLRRecommendedDate = project.PLRRecommendedDate__c;

        Boolean isOpportunityPassed = InnovatorConstants.PROJECT_PHASE_TO_NUMBER.get(project.ProjectPhase__c) > InnovatorConstants.PROJECT_PHASE_TO_NUMBER.get(InnovatorConstants.DISCOVER_PHASE);
        Boolean isBCAPassed = InnovatorConstants.PROJECT_PHASE_TO_NUMBER.get(project.ProjectPhase__c) > InnovatorConstants.PROJECT_PHASE_TO_NUMBER.get(InnovatorConstants.DEFINE_PHASE);
        Boolean isBCVPassed = InnovatorConstants.PROJECT_PHASE_TO_NUMBER.get(project.ProjectPhase__c) > InnovatorConstants.PROJECT_PHASE_TO_NUMBER.get(InnovatorConstants.DESIGN_PHASE);
        Boolean isCommercialPassed = InnovatorConstants.PROJECT_PHASE_TO_NUMBER.get(project.ProjectPhase__c) > InnovatorConstants.PROJECT_PHASE_TO_NUMBER.get(InnovatorConstants.DEVELOP_PHASE);
        Boolean isProductionPassed = InnovatorConstants.PROJECT_PHASE_TO_NUMBER.get(project.ProjectPhase__c) > InnovatorConstants.PROJECT_PHASE_TO_NUMBER.get(InnovatorConstants.DEPLOY_PHASE);
        Boolean isOnShelfPassed = project.ActualOnShelfDate__c != null || project.ActualReadyShipmentDate__c != null;
        Boolean isPLRPassed = project.ActualPLRDate__c != null && project.ProjectStatus__c == InnovatorConstants.PROJECT_STATUS_COMPLETED;

        String projectClassificationSubtype = project.ProjectClassificationSubtype__c;

        if ((project.ProjectClassification__c == InnovatorConstants.GEO_EXTENSION || project.ProjectClassification__c == InnovatorConstants.REPACK) &&
            (project.ProjectPhase__c == InnovatorConstants.DISCOVER_PHASE || project.ProjectPhase__c == InnovatorConstants.DEFINE_PHASE)) {
            projectClassificationSubtype = getProjectSubtype(project);
        }

        Boolean isProjectSubmitted = !project.SubmissionStatus__c.toLowerCase().contains('yet') && project.SubmissionStatus__c.toLowerCase().contains('submitted');

        Boolean isBCASubmitted = !isBCAPassed && isProjectSubmitted;
        Boolean isBCVSubmitted = isBCAPassed && !isBCVPassed && isProjectSubmitted;
        Boolean isCommercialSubmitted = isBCAPassed && isBCVPassed && !isCommercialPassed && isProjectSubmitted;

        Boolean isSimpleRepack = project.ProjectClassification__c == InnovatorConstants.REPACK && projectClassificationSubtype == InnovatorConstants.ARTWORK_CHANGE_ONLY_SUBTYPE;
        Boolean isComplexProject = project.ProjectClassification__c == InnovatorConstants.FEARLESS_BET || project.ProjectClassification__c == InnovatorConstants.BRAND_ENERGIZER ||
            (project.ProjectClassification__c == InnovatorConstants.REPACK && projectClassificationSubtype == InnovatorConstants.PRIMARY_PACK_CHANGE_SUBTYPE);
        Boolean isComplexRepack = project.ProjectClassification__c == InnovatorConstants.REPACK && projectClassificationSubtype == InnovatorConstants.PRIMARY_PACK_CHANGE_SUBTYPE;
        Boolean isGeoComplex = project.ProjectClassification__c == InnovatorConstants.GEO_EXTENSION && projectClassificationSubtype == InnovatorConstants.LIQUID_PACK_CHANGE_SUBTYPE;
        Boolean isGeoSimple = project.ProjectClassification__c == InnovatorConstants.GEO_EXTENSION && projectClassificationSubtype == InnovatorConstants.IPC_SUBTYPE_API;
        Boolean isBusinessEnabler = project.ProjectClassification__c == InnovatorConstants.BUSINESS_ENABLER;


        List<Timings__mdt> timingsRecords = getTimingsMetadata(project.ProjectClassification__c, projectClassificationSubtype);

        Decimal daysFromOpportunity;
        Decimal daysFromBCA;
        Decimal daysFromBCV;
        Decimal daysToCustomerMeeting;
        Decimal daysFromCommercial;
        Decimal daysFromProduction;
        Decimal daysFromShipment;
        Decimal daysFromOnShelf;

        if (!timingsRecords.isEmpty()) {
            Timings__mdt timingsMetadata = timingsRecords[0];
            daysFromOpportunity = timingsMetadata.Opportunity__c != null ? (timingsMetadata.Opportunity__c == 12 ? 365 : timingsMetadata.Opportunity__c * 30) : null;
            daysFromBCA = timingsMetadata.BCA__c != null ? (timingsMetadata.BCA__c == 12 ? 365 : timingsMetadata.BCA__c * 30) : null;
            daysFromBCV = timingsMetadata.BCV__c != null ? (timingsMetadata.BCV__c == 12 ? 365 : timingsMetadata.BCV__c * 30) : null;
            daysToCustomerMeeting = timingsMetadata.CustomerMeeting__c != null ? (timingsMetadata.CustomerMeeting__c == 12 ? 365 : timingsMetadata.CustomerMeeting__c * 30) : null;
            daysFromCommercial = timingsMetadata.Commercial__c != null ? (timingsMetadata.Commercial__c == 12 ? 365 : timingsMetadata.Commercial__c * 30) : null;
            daysFromProduction = timingsMetadata.Production__c != null ? (timingsMetadata.Production__c == 12 ? 365 : timingsMetadata.Production__c * 30) : null;
            daysFromShipment = timingsMetadata.Shipment__c != null ? (timingsMetadata.Shipment__c == 12 ? 365 : timingsMetadata.Shipment__c * 30) : null;
            daysFromOnShelf = timingsMetadata.OnShelf__c != null ? (timingsMetadata.OnShelf__c == 12 ? 365 : timingsMetadata.OnShelf__c * 30) : null;
        }

        //calculation section
        if ((isComplexProject || isSimpleRepack) && !isOpportunityPassed) {
            opportunityRecommendedDate = currentToday;
            BCARecommendedDate = opportunityRecommendedDate?.addDays(Integer.valueOf(daysFromOpportunity));
        } else if ((isComplexProject || isSimpleRepack) && isOpportunityPassed) {
            BCARecommendedDate = !isBCAPassed && !isProjectSubmitted ? project.OpportunitySubmissionDate__c?.addDays(Integer.valueOf(daysFromOpportunity)) : null;
        } else if ((isBusinessEnabler || isGeoComplex || isGeoSimple) && !isBCAPassed && !isProjectSubmitted) {
            BCARecommendedDate = currentToday.addDays(7);
        }

        if (isGeoSimple) {
            customerMeetingRecommendedDate = isBCAPassed ? project.BCAApprovalDate__c?.addDays(Integer.valueOf(daysToCustomerMeeting)) : (isBCASubmitted ? project.BCASubmissionDate__c?.addDays(Integer.valueOf(daysToCustomerMeeting)) : BCARecommendedDate?.addDays(Integer.valueOf(daysToCustomerMeeting)));
            commercialRecommendedDate = isBCAPassed ? project.BCAApprovalDate__c?.addDays(Integer.valueOf(daysFromBCA)) : (isBCASubmitted ? project.BCASubmissionDate__c?.addDays(Integer.valueOf(daysFromBCA)) : BCARecommendedDate?.addDays(Integer.valueOf(daysFromBCA)));
            shipmentRecommendedDate = isCommercialPassed ? project.CommercialApprovalDate__c?.addDays(Integer.valueOf(daysFromCommercial)) : (isCommercialSubmitted ? project.CommercialSubmissionDate__c?.addDays(Integer.valueOf(daysFromCommercial)) : commercialRecommendedDate?.addDays(Integer.valueOf(daysFromCommercial)));
            shelfRecommendedDate = shipmentRecommendedDate?.addDays(Integer.valueOf(daysFromShipment));
        } else {
            if (!isGeoComplex) {
                BCVRecommendedDate = isBCAPassed ? project.BCAApprovalDate__c?.addDays(Integer.valueOf(daysFromBCA)) : (isBCASubmitted ? project.BCASubmissionDate__c?.addDays(Integer.valueOf(daysFromBCA)) : BCARecommendedDate?.addDays(Integer.valueOf(daysFromBCA)));
                customerMeetingRecommendedDate = isBCVPassed ? project.BCVApprovalDate__c?.addDays(Integer.valueOf(daysToCustomerMeeting)) : (isBCVSubmitted ? project.BCVSubmissionDate__c?.addDays(Integer.valueOf(daysToCustomerMeeting)) : BCVRecommendedDate?.addDays(Integer.valueOf(daysToCustomerMeeting)));
            } else {
                customerMeetingRecommendedDate = isBCAPassed ? project.BCAApprovalDate__c?.addDays(Integer.valueOf(daysToCustomerMeeting)) : (isBCASubmitted ? project.BCASubmissionDate__c?.addDays(Integer.valueOf(daysToCustomerMeeting)) : BCARecommendedDate?.addDays(Integer.valueOf(daysToCustomerMeeting)));
            }

            if (isSimpleRepack) {
                productionRecommendedDate = isBCVPassed ? project.BCVApprovalDate__c?.addDays(Integer.valueOf(daysFromBCV)) : (isBCAPassed && isProjectSubmitted ? project.BCVSubmissionDate__c?.addDays(Integer.valueOf(daysFromBCV)) : BCVRecommendedDate?.addDays(Integer.valueOf(daysFromBCV)));
            } else {
                if (isComplexRepack) {
                    commercialRecommendedDate = isBCVPassed ? project.BCVApprovalDate__c?.addDays(Integer.valueOf(daysFromBCV)) : (isBCVSubmitted ? project.BCVSubmissionDate__c?.addDays(Integer.valueOf(daysFromBCV)) : BCVRecommendedDate?.addDays(Integer.valueOf(daysFromBCV)));
                    productionRecommendedDate = isCommercialPassed ? project.CommercialSubmissionDate__c?.addDays(Integer.valueOf(daysFromCommercial)) : commercialRecommendedDate?.addDays(Integer.valueOf(daysFromCommercial));
                } else {
                    if (isGeoComplex) {
                        commercialRecommendedDate = isBCAPassed ? project.BCAApprovalDate__c?.addDays(Integer.valueOf(daysFromBCA)) : (isBCASubmitted ? project.BCASubmissionDate__c?.addDays(Integer.valueOf(daysFromBCA)) : BCARecommendedDate?.addDays(Integer.valueOf(daysFromBCA)));
                    } else {
                        commercialRecommendedDate = isBCVPassed ? project.BCVApprovalDate__c?.addDays(Integer.valueOf(daysFromBCV)) : (isBCVSubmitted ? project.BCVSubmissionDate__c?.addDays(Integer.valueOf(daysFromBCV)) : BCVRecommendedDate?.addDays(Integer.valueOf(daysFromBCV)));
                    }
                    productionRecommendedDate = isCommercialPassed ? project.CommercialApprovalDate__c?.addDays(Integer.valueOf(daysFromCommercial)) : (isCommercialSubmitted ? project.CommercialSubmissionDate__c?.addDays(Integer.valueOf(daysFromCommercial)) : commercialRecommendedDate?.addDays(Integer.valueOf(daysFromCommercial)));
                }
            }

            shipmentRecommendedDate = isProductionPassed ? project.ProductionSubmissionDate__c?.addDays(Integer.valueOf(daysFromProduction)) : productionRecommendedDate?.addDays(Integer.valueOf(daysFromProduction));
            shelfRecommendedDate = shipmentRecommendedDate?.addDays(Integer.valueOf(daysFromShipment));
            PLRRecommendedDate = isOnShelfPassed ? project.ActualOnShelfDate__c?.addDays(Integer.valueOf(daysFromOnShelf)) : shelfRecommendedDate?.addDays(Integer.valueOf(daysFromOnShelf));
        }


        Boolean isTargetDateInPast = project.TargetBCASubmissionDate__c < currentToday ||
            project.TargetBCVSubmissionDate__c < currentToday || project.TargetCommercialSubmissionDate__c < currentToday ||
            project.TargetProductionSubmissionDate__c < currentToday || project.TargetPLRDate__c < currentToday;

        Boolean isRecommendedDateAfterTargetDate =
            (!isBCAPassed && !isProjectSubmitted && (isComplexProject || isSimpleRepack) && BCARecommendedDate > project.TargetBCASubmissionDate__c) ||
            (!isBCAPassed && isProjectSubmitted && BCVRecommendedDate > project.TargetBCVSubmissionDate__c) ||
            (isBCAPassed && !isBCVPassed && !isProjectSubmitted && BCVRecommendedDate > project.TargetBCVSubmissionDate__c) ||
                (!isCommercialPassed && !isCommercialSubmitted && commercialRecommendedDate > project.TargetCommercialSubmissionDate__c) ||

//                (isBCAPassed && isBCVPassed && !isCommercialPassed && !isProjectSubmitted && commercialRecommendedDate > project.TargetCommercialSubmissionDate__c) ||
//            (!isCommercialPassed && commercialRecommendedDate > project.TargetCommercialSubmissionDate__c) ||

                (!isCommercialPassed && !isCommercialSubmitted && !isSimpleRepack && customerMeetingRecommendedDate > project.Estimated1stCustomerPresentationDate__c) ||
//            (!isCommercialPassed && !isSimpleRepack && customerMeetingRecommendedDate > project.Estimated1stCustomerPresentationDate__c) ||
            (!isProductionPassed && productionRecommendedDate > project.TargetProductionSubmissionDate__c) ||
            (!isProductionPassed && isSimpleRepack && customerMeetingRecommendedDate > project.Estimated1stCustomerPresentationDate__c) ||
            (!isOnShelfPassed && (shipmentRecommendedDate > project.TargetReadyShipmentDate__c || shelfRecommendedDate > project.TargetOnShelfDateLeadRegion__c)) ||
            (!isPLRPassed && PLRRecommendedDate > project.TargetPLRDate__c);

//        System.debug('1 ' + (!isBCAPassed && !isProjectSubmitted && (isComplexProject || isSimpleRepack) && BCARecommendedDate > project.TargetBCASubmissionDate__c));
//        System.debug('2 ' + (!isBCAPassed && isProjectSubmitted && BCVRecommendedDate > project.TargetBCVSubmissionDate__c));
//        System.debug('3 ' + (isBCAPassed && !isBCVPassed && !isProjectSubmitted && BCVRecommendedDate > project.TargetBCVSubmissionDate__c));
//        System.debug('4 ' + (!isCommercialPassed && !isCommercialSubmitted && commercialRecommendedDate > project.TargetCommercialSubmissionDate__c));
//
//        System.debug('5 ' + (!isCommercialPassed && !isCommercialSubmitted && !isSimpleRepack && customerMeetingRecommendedDate > project.Estimated1stCustomerPresentationDate__c));
//        System.debug('6 ' + (!isProductionPassed && productionRecommendedDate > project.TargetProductionSubmissionDate__c));
//        System.debug('7 ' + (!isProductionPassed && isSimpleRepack && customerMeetingRecommendedDate > project.Estimated1stCustomerPresentationDate__c));
//        System.debug('8 ' + (!isOnShelfPassed && (shipmentRecommendedDate > project.TargetReadyShipmentDate__c || shelfRecommendedDate > project.TargetOnShelfDateLeadRegion__c)) );
//        System.debug('9 ' + (!isPLRPassed && PLRRecommendedDate > project.TargetPLRDate__c));
//
//        System.debug('shipmentRecommendedDate > project.TargetReadyShipmentDate__c ' + shipmentRecommendedDate + ' ' + project.TargetReadyShipmentDate__c + ' ' + (shipmentRecommendedDate > project.TargetReadyShipmentDate__c));
//        System.debug('shelfRecommendedDate > project.TargetOnShelfDateLeadRegion__c '  + shelfRecommendedDate + ' ' + project.TargetOnShelfDateLeadRegion__c + ' ' + (shelfRecommendedDate > project.TargetOnShelfDateLeadRegion__c));

        Boolean isCustomerMeetingDateBeforePreviousStep =
            ((isGeoSimple || isGeoComplex) && !isCommercialPassed &&
                (!isBCAPassed && !isProjectSubmitted && customerMeetingRecommendedDate < project.TargetBCASubmissionDate__c) ||
                (!isBCAPassed && isProjectSubmitted && customerMeetingRecommendedDate < project.BCASubmissionDate__c) ||
                (isBCAPassed && customerMeetingRecommendedDate < project.BCAApprovalDate__c)) ||
            (!isGeoSimple && !isGeoComplex && (
                ((!isBCAPassed || (isBCAPassed && !isBCVPassed && !isProjectSubmitted)) && customerMeetingRecommendedDate < project.TargetBCVSubmissionDate__c) ||
                    (isBCVSubmitted && !isBCVPassed && customerMeetingRecommendedDate < project.BCVSubmissionDate__c) ||
                    (isBCVPassed && customerMeetingRecommendedDate < project.BCVApprovalDate__c)
                ) &&
                (
                    (isSimpleRepack && !isProductionPassed) ||
                        (!isSimpleRepack && !isCommercialPassed)));

//        System.debug('isTargetDateInPast ' + isTargetDateInPast);
//        System.debug('isRecommendedDateAfterTargetDate ' + isRecommendedDateAfterTargetDate);
//        System.debug('isCustomerMeetingDateBeforePreviousStep ' + isCustomerMeetingDateBeforePreviousStep);
        if (isTargetDateInPast || isRecommendedDateAfterTargetDate || isCustomerMeetingDateBeforePreviousStep) {
            onOffTrack = InnovatorConstants.OFF_TRACK;
        } else {
            onOffTrack = InnovatorConstants.ON_TRACK;
        }
//todo check the phase and do not update the value
        project.OnOffTrack__c = onOffTrack;
        project.OpportunityRecommendedDate__c = isOpportunityPassed ? project.OpportunityRecommendedDate__c : opportunityRecommendedDate;
        project.BCARecommendedDate__c = isBCAPassed || isBCASubmitted ? project.BCARecommendedDate__c : BCARecommendedDate;
        project.BCVRecommendedDate__c = isBCVPassed || isBCVSubmitted ? project.BCVRecommendedDate__c : BCVRecommendedDate;
        project.CustomerMeetingRecommendedDate__c = customerMeetingRecommendedDate;
        project.CommercialRecommendedDate__c = isCommercialPassed || isCommercialSubmitted ? project.CommercialRecommendedDate__c : commercialRecommendedDate;
        project.ProductionRecommendedDate__c = isProductionPassed ? project.ProductionRecommendedDate__c : productionRecommendedDate;
        project.ShipmentRecommendedDate__c = isOnShelfPassed ? project.ShipmentRecommendedDate__c : shipmentRecommendedDate;
        project.OnShelfRecommendedDate__c = isOnShelfPassed ? project.OnShelfRecommendedDate__c : shelfRecommendedDate;
        project.PLRRecommendedDate__c = isPLRPassed ? project.PLRRecommendedDate__c : PLRRecommendedDate;

//        System.debug(project.OpportunityRecommendedDate__c);
//        System.debug(project.BCARecommendedDate__c);
//        System.debug(project.BCVRecommendedDate__c);
//        System.debug(project.CustomerMeetingRecommendedDate__c);
//        System.debug(project.CommercialRecommendedDate__c);
//        System.debug(project.ProductionRecommendedDate__c);
//        System.debug(project.ShipmentRecommendedDate__c);
//        System.debug(project.OnShelfRecommendedDate__c);
//        System.debug(project.PLRRecommendedDate__c);


//        return onOffTrack;
    }


    public static String getProjectSubtype(Project__c project) {
        String projectClassificationSubtype;
        if (project.ProjectClassification__c == InnovatorConstants.GEO_EXTENSION) {
            Boolean isIPCSubtype = ((project.IPCExtensionWithoutArtworkChange__c || project.ArtworkChange__c) &&
                !project.NewLiquid__c && !project.NewPrimaryPack__c && !project.SourcingChange__c);
            projectClassificationSubtype = isIPCSubtype ? InnovatorConstants.IPC_SUBTYPE_API : InnovatorConstants.LIQUID_PACK_CHANGE_SUBTYPE;
        } else if (project.ProjectClassification__c == InnovatorConstants.REPACK) {
            Boolean isArtworkChangeSubtype = !project.NewPrimaryPack__c && project.ArtworkChange__c;
            projectClassificationSubtype = isArtworkChangeSubtype ? InnovatorConstants.ARTWORK_CHANGE_ONLY_SUBTYPE : InnovatorConstants.PRIMARY_PACK_CHANGE_SUBTYPE;
        }
        return projectClassificationSubtype;
    }
}