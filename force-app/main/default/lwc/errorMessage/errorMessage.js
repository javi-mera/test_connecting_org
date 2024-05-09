/* eslint-disable @lwc/lwc/no-api-reassignments */
import { api, LightningElement } from 'lwc';
import {constants} from 'c/utils';
const classificationsWhichRequiredLegalApproval = ["Fearless Bet", "Brand Energizer", "Business Enabler", "Repack", "Geographical Extension"];
const classificationsWithDescriptionAndOpportunity = ["Fearless Bet", "Brand Energizer", "Business Enabler"];
const LegalRegulatoryApprovalRequiredError = "Legal/IP and Regulatory Approval Required";

export default class ErrorMessage extends LightningElement {

    @api ProjectObject;
    @api isNSVContributionEmpty = false;
    @api missingFields = [];
    @api criticalKPIs = false;
    @api criticalConsumerKPIs = false;


    connectedCallback() {
        //COMMON FIELDS
        this.ProjectObject = JSON.parse(JSON.stringify(this.ProjectObject));
        if (this.ProjectObject.ProjectLeader__c == null) {
            this.missingFields.push("Project Leader");
        }
        if (this.ProjectObject.TargetOnShelfDateLeadRegion__c == null) {
            this.missingFields.push("Target on Shelf Date Lead Hub");
        }
        if (this.ProjectObject.Category__c == null) {
            this.missingFields.push("Category");
        }
        if (this.ProjectObject.Brand__c == null) {
            this.missingFields.push("Brand");
        }
        if (this.ProjectObject.Subrand__c == null) {
            this.missingFields.push("Sub Brand");
        }
        if (this.ProjectObject.Region__c == null) {
            this.missingFields.push("Lead Region");
        }
        if (this.ProjectObject.Hub__c == null) {
            this.missingFields.push("Lead Hub");
        }
        if (this.ProjectObject.Cluster__c == null) {
            this.missingFields.push("Lead Cluster");
        }
        if (this.ProjectObject.DC__c == null) {
            this.missingFields.push("Distribution Channel(s)");
        }
        if (this.ProjectObject.TradeType__c == null) {
            this.missingFields.push("Trade Type(s)");
        }
        if (this.ProjectObject.ProjectClassification__c !== "Mandatory" && this.ProjectObject.ProjectClassification__c !== "Continuous Improvement") {
            if ((this.ProjectObject.ProjectClassification__c === "Geographical Extension" && this.ProjectObject.ProjectPhase__c !== "Discover") || this.ProjectObject.ProjectClassification__c !== "Geographical Extension") {
                if (this.ProjectObject.FinancialThresholdsNotMet__c === true && this.ProjectObject.FinancialThresholdNotMetComment__c === null) {
                    this.missingFields.push("Ensure Threshold is Met or the Justification field is populated");
                }
            }
        }
        if (!this.ProjectObject.BoardAlignmentToThisProject__c && this.ProjectObject.NotReceivedBoardApprovalComment__c === null && (this.ProjectObject.ProjectClassification__c === 'Fearless Bet' || this.ProjectObject.ProjectClassification__c === 'Brand Energizer' || this.ProjectObject.ProjectClassification__c === 'Repack' || this.ProjectObject.ProjectClassification__c === 'Business Enabler')) {
            this.missingFields.push("Please confirm the project is aligned with Bacardi Board, or complete the comments box with information as requested");
        }
        if (this.ProjectObject.ProjectPhase__c === "Discover") {
            this.mandatoryFieldsDiscover();
        } else if (this.ProjectObject.ProjectPhase__c === "Define") {
            this.mandatoryFieldsDefine();
        } else if (this.ProjectObject.ProjectPhase__c === "Design"){
            this.mandatoryFieldsDesign();
        } else if (this.ProjectObject.ProjectPhase__c === "Develop") {
            this.mandatoryFieldsDevelop();
        } else if (this.ProjectObject.ProjectPhase__c === "Deploy") {
            this.mandatoryFieldsDeploy();
        }
    }

    mandatoryFieldsDiscover() {
        this.opportunityOrDescriptionAndOpportunityCheck();

        if (this.ProjectObject.OpportunityContextConsumerRationale__c == null) {
            this.missingFields.push("Consumer Opportunity Context and rationale");
        }
        if (!this.ProjectObject.LeadRegionAlignedtoProject__c) {
            this.missingFields.push("Lead region aligned to project");
        }

        if (this.ProjectObject.ProjectClassification__c !== "Repack") {
            if (!this.ProjectObject.FirstFiscalYearFilled__c) {
                this.missingFields.push("Missing First Fiscal Year Project Financials");
            }
            if (!this.ProjectObject.FifthFiscalYearFilled__c) {
                this.missingFields.push("Missing Fifth Fiscal Year Project Financials");
            }
        }

        if ((this.ProjectObject.BMCClassification__c === 'Air' || this.ProjectObject.BMCClassification__c === 'Sand' || this.ProjectObject.BMCClassification__c === 'Pebble') && this.ProjectObject.BMCComment__c == null) {
            this.missingFields.push("Please add justification why this project is required (in Geography tab), as it is not for a Priority Brand Market Combination (BMC).");
        }
    }

    mandatoryFieldsDefine() {
        if (this.ProjectObject.TargetReadyShipmentDate__c == null) {
            this.missingFields.push("Target Ready Shipment Date (Lead Hub)");
        }
        if (this.ProjectObject.Flavour__c == null) {
            this.missingFields.push("Flavour");
        }
        if (this.ProjectObject.Size__c == null) {
            this.missingFields.push("Size");
        }
        if (this.ProjectObject.ABVAlcoholByVolume__c == null) {
            this.missingFields.push("ABV (%)");
        }
        if (this.ProjectObject.LeadMarket__c == null) {
            this.missingFields.push("Lead Market");
        }
        if (['Air', 'Sand', 'Pebble'].includes(this.ProjectObject.BMCClassification__c) && this.ProjectObject.BMCComment__c === null) {
            this.missingFields.push('Please enter your recommendation to approvers as to why the project should progress considering it is not a priority BMC (i.e. it is a Pebble, Sand or Air BMC).');
        }

        const notCIorMandatory = this.ProjectObject.ProjectClassification__c !== "Mandatory" && this.ProjectObject.ProjectClassification__c !== "Continuous Improvement";

        if (notCIorMandatory && this.ProjectObject.ProjectClassification__c !== 'Promotional Pack') {
            if (this.ProjectObject.OpportunityContextConsumerRationale__c == null) {
                this.missingFields.push("Consumer Opportunity Context and rationale");
            }
            this.opportunityOrDescriptionAndOpportunityCheck();
        }

        if (notCIorMandatory) {
            if (this.ProjectObject.Estimated1stCustomerPresentationDate__c == null) {
                this.missingFields.push("Estimated 1st customer presentation date");
            }
            if (!this.ProjectObject.ProjectDevelopmentDocument__c) {
                this.missingFields.push("Attachment missing - Project's PPT Development Document");
            }
            if (!this.ProjectObject.ProjectPL__c) {
                this.missingFields.push("Attachment missing - Project's Excel P&L");
            }
        }

        if (this.ProjectObject.ProjectClassification__c === "Fearless Bet" || this.ProjectObject.ProjectClassification__c === "Brand Energizer" || this.ProjectObject.ProjectClassification__c === "Business Enabler") {
            if (!this.ProjectObject.LeadRegionAlignedtoProject__c) {
                this.missingFields.push("Lead region aligned to project");
            }
            this.financialsFiscalYearsFilledIn();
            if (!this.ProjectObject.BusinessCaseAmbitionFilled__c && this.ProjectObject.ProjectPhase__c === "Define") {
                this.missingFields.push("Missing rows in BCA Financial Success Criteria");
            }
            if ((this.ProjectObject.ProjectClassification__c === "Fearless Bet" || this.ProjectObject.ProjectClassification__c === "Brand Energizer") && this.ProjectObject.ComercialTolerancesOutsideThreshold__c && !this.ProjectObject.BypassComercialTolerances__c) {
                this.criticalConsumerKPIs = true;
            }
        } else if (this.ProjectObject.ProjectClassification__c === "Repack") {
            if (!this.ProjectObject.LeadRegionAlignedtoProject__c) {
                this.missingFields.push("Lead region aligned to project");
            }
            if (!this.ProjectObject.BusinessCaseAmbitionFilled__c && this.ProjectObject.ProjectPhase__c === "Define") {
                this.missingFields.push("Missing rows in BCA Financial Success Criteria");
            }
        } else if (this.ProjectObject.ProjectClassification__c === "Geographical Extension" ) {
            if (!this.ProjectObject.NoOriginalProject__c && (this.ProjectObject.OriginalProject__c === null || this.ProjectObject.OriginalProject__c === '')) {
                this.missingFields.push("Original Project");
            }
            if (!this.ProjectObject.LeadRegionAlignedtoProject__c) {
                this.missingFields.push("Lead region aligned to project");
            }
            if (this.ProjectObject.GeoExtensionProjectSubClassification__c == null) {
                this.missingFields.push("Geo Extension Project Sub Classification");
            }
            if (this.ProjectObject.GeoExtensionProjectSubClassification__c === "Innovation Geo Extension") {
                this.financialsFiscalYearsFilledIn();
                if (!this.ProjectObject.BusinessCaseAmbitionFilled__c && this.ProjectObject.ProjectPhase__c === "Define") {
                    this.missingFields.push("Missing rows in BCA Financial Success Criteria");
                }
            }
        } else if (this.ProjectObject.ProjectClassification__c === "Promotional Pack") {
            if (this.ProjectObject.ProjectDescription__c == null) {
                this.missingFields.push("Project Description");
            }
            if (this.ProjectObject.ProjectRationale__c == null) {
                this.missingFields.push("What is the Project/Activity Rationale?");
            }
            if (this.ProjectObject.ProjectClassificationSubtype__c == null) {
                this.missingFields.push("Project Classification Subtype");
            }

            if (this.ProjectObject.ProjectPhase__c === "Define") {
                if (!this.ProjectObject.BusinessCaseAmbitionFilled__c) {
                    this.missingFields.push("Missing rows in BCA Financial Success Criteria");
                } else if (!this.ProjectObject.BypassFinancialTolerances__c) {
                    this.promoPacksFinancialThresholdsCheck();
                }
            }
            if (this.ProjectObject.ProjectPhase__c === "Design" && this.ProjectObject.Complexity__c === "Medium") {
                if (!this.ProjectObject.BusinessCaseValidationFilled__c) {
                    this.missingFields.push("Missing rows in BCV Financial Success Criteria");
                } else if (!this.ProjectObject.BypassFinancialTolerances__c) {
                    this.promoPacksFinancialThresholdsCheck();
                }
            }
            if (this.ProjectObject.ProjectPhase__c === "Deploy") {
                if (!this.ProjectObject.ProductionMilestone__c) {
                    this.missingFields.push("Missing rows in Production Financial Success Criteria");
                } else if (!this.ProjectObject.BypassFinancialTolerances__c) {
                    this.promoPacksFinancialThresholdsCheck();
                }
            }
            if (this.ProjectObject.ProjectClassificationSubtype__c === 'Limited Edition Pack') {
                if (this.ProjectObject.LimitedEditionPack__c == null) {
                    this.missingFields.push("Limited Edition Pack");
                }
            }
            if (this.ProjectObject.ProjectClassificationSubtype__c === 'Limited Edition Pack' || this.ProjectObject.ProjectClassificationSubtype__c === 'Value Added Pack') {
                if (this.ProjectObject.SecondaryPackDetails__c === 'Other' && this.ProjectObject.OtherSecondaryPackDescription__c == null) {
                    this.missingFields.push("Other Secondary Pack Details");
                }
            }
        } else if (this.ProjectObject.ProjectClassification__c === "Mandatory" || this.ProjectObject.ProjectClassification__c === "Continuous Improvement") {
            if (this.ProjectObject.ProjectDescription__c == null) {
                this.missingFields.push("Project Description");
            }
            if (!this.ProjectObject.FirstFiscalYearFilled__c) {
                this.missingFields.push("Missing rows in the Project Financials");
            }
        }

        if (this.ProjectObject.ProjectClassification__c === "Fearless Bet" || this.ProjectObject.ProjectClassification__c === "Brand Energizer"  || this.ProjectObject.ProjectClassification__c === "Business Enabler" || this.ProjectObject.ProjectClassification__c === "Repack"  || (this.ProjectObject.ProjectClassification__c === "Geographical Extension" && this.ProjectObject.GeoExtensionProjectSubClassification__c === "Innovation Geo Extension")) {
            if (this.ProjectObject.TrademarkCurrentGM__c == null) {
                this.missingFields.push("Trademark's Current GM% in lead region");
            }
            if (this.ProjectObject.TrademarkCurrentGP__c == null) {
                this.missingFields.push("Trademark's Current $GP per 9L case in lead region");
            }
        }
        if (this.ProjectObject.SustainabilityImpact__c === true && !this.ProjectObject.GoodChoices__c && !this.ProjectObject.GoodFootprint__c && !this.ProjectObject.GoodFutures__c && !this.ProjectObject.GoodSources__c) {
            this.missingFields.push('Please select at least one Good Spirited Priorities in which the impact is')
        }
        if (this.ProjectObject.DesignToValueProject__c === true && this.ProjectObject.DesignToValueProjectComment__c === null) {
            this.missingFields.push('Please fill in Design to Value Project Comment');
        }

        if (this.ProjectObject.ProjectPhase__c === constants.CONST_DEFINE_PHASE &&
            this.ProjectObject.ProjectClassification__c === constants.CONST_PROMOTIONAL_PACK_NAME &&
            this.ProjectObject.Complexity__c === constants.CONST_LOW_COMPLEXITY &&
            !this.ProjectObject.HasPLConfirmedChecklist__c) {
            this.missingFields.push('Please review the Checklist tab and confirm you will take care of all the tasks');
        }

        let isOtherGeoExtensionSubtype = this.ProjectObject.ProjectClassification__c === constants.CONST_GEO_EXTENSION_NAME &&
            this.ProjectObject.GeoExtensionProjectSubClassification__c === 'Other Geo Extension';
        if ([constants.CONST_FEARLESS_BET_NAME, constants.CONST_BRAND_ENERGIZER_NAME, constants.CONST_BUSINESS_ENABLER_NAME, constants.CONST_GEO_EXTENSION_NAME].includes(this.ProjectObject.ProjectClassification__c) &&
            (this.ProjectObject.NSVByRegionTotalPercentage__c !== 100 || this.isNSVContributionEmpty === true) &&
        !isOtherGeoExtensionSubtype) {
            this.missingFields.push('Missing NSV By Regions');
        }
    }

    mandatoryFieldsDesign() {
        if (this.ProjectObject.SummaryOfChangesFromBusinessCase__c == null) {
            this.missingFields.push("Summary of Changes from the Business Case Ambition");
        }
        if (this.ProjectObject.ProjectManager__c == null) {
            this.missingFields.push("Project Manager");
        }
        this.mandatoryFieldsDefine();
        if (this.ProjectObject.ProjectClassification__c === "Fearless Bet" || this.ProjectObject.ProjectClassification__c === "Brand Energizer" || this.ProjectObject.ProjectClassification__c === "Business Enabler" || this.ProjectObject.ProjectClassification__c === "Repack" || (this.ProjectObject.ProjectClassification__c === "Geographical Extension" && this.ProjectObject.GeoExtensionProjectSubClassification__c === "Innovation Geo Extension")) {
            if (!this.ProjectObject.BusinessCaseValidationFilled__c && this.ProjectObject.ProjectPhase__c === "Design") {
                this.missingFields.push("Missing rows in BCV Financial Success Criteria");
            } else if (this.ProjectObject.FinancialTolerancesOutsideThreshold__c && !this.ProjectObject.BypassFinancialTolerances__c && this.ProjectObject.ProjectPhase__c === "Design") {
                this.criticalKPIs = true;
            }

            if (this.ProjectObject.ProjectClassification__c === "Fearless Bet" || this.ProjectObject.ProjectClassification__c === "Brand Energizer") {
                if (this.ProjectObject.ComercialTolerancesOutsideThreshold__c && !this.ProjectObject.BypassComercialTolerances__c) {
                    this.criticalConsumerKPIs = true;
                }
                if (this.ProjectObject.ProjectPhase__c === "Design") {
                    if (this.ProjectObject.ActivationProfileTolerance__c == null) {
                        this.missingFields.push("Concept Validation");
                    } else if (this.ProjectObject.ActivationProfileTolerance__c === 'No Concept Validation research completed' ||
                        this.ProjectObject.ActivationProfileTolerance__c.startsWith('Stop')) {
                        if (this.ProjectObject.BypassComercialTolerances__c === false) {
                            this.missingFields.push("Confirm Approval for No or Stopped Concept Validation Research");
                            this.missingFields.push("Summary for No or Stopped Concept Validation Research");
                        } else if (this.ProjectObject.NoOrStoppedConceptValidationSummary__c == null ||
                            this.ProjectObject.NoOrStoppedConceptValidationSummary__c === '') {
                            this.missingFields.push("Summary for No or Stopped Concept Validation Research");
                        }
                    }
                }
            }
        }
        if (classificationsWhichRequiredLegalApproval.includes(this.ProjectObject.ProjectClassification__c) && !this.ProjectObject.LegalAndRegulatoryAlignedToProject__c) {
            this.missingFields.push(LegalRegulatoryApprovalRequiredError);
        }
        if (this.ProjectObject.ProjectPhase__c === constants.CONST_DESIGN_PHASE &&
            this.ProjectObject.ProjectClassification__c === constants.CONST_PROMOTIONAL_PACK_NAME &&
            this.ProjectObject.Complexity__c === constants.CONST_MEDIUM_COMPLEXITY &&
            (!this.ProjectObject.IsPackDevelopmentManagerContacted__c || !this.ProjectObject.IsApprovedByLegalAndRegPrimos__c ||
                (this.ProjectObject.IsGiftBoxException__c && (this.ProjectObject.GiftBoxExceptionComment__c === null ||
                    this.ProjectObject.GiftBoxExceptionComment__c === '')))) {
            this.missingFields.push('Please review the Checklist tab and confirm you will take care of all the tasks');
        }
    }
    mandatoryFieldsDevelop() {
        this.mandatoryFieldsDesign();

        if (this.ProjectObject.ProjectClassification__c === "Fearless Bet" || this.ProjectObject.ProjectClassification__c === "Brand Energizer" || this.ProjectObject.ProjectClassification__c === "Business Enabler" || this.ProjectObject.ProjectClassification__c === "Repack" || (this.ProjectObject.ProjectClassification__c === "Geographical Extension" && this.ProjectObject.GeoExtensionProjectSubClassification__c === "Innovation Geo Extension")) {
            if (!this.ProjectObject.CommercialMilestoneFilled__c && this.ProjectObject.ProjectPhase__c === "Develop") {
                this.missingFields.push("Missing rows in Commercial Financial Success Criteria");
            } else if (this.ProjectObject.FinancialTolerancesOutsideThreshold__c && !this.ProjectObject.BypassFinancialTolerances__c) {
                this.criticalKPIs = true;
            }
        }
    }

    mandatoryFieldsDeploy() {
        this.mandatoryFieldsDesign();
        if (this.ProjectObject.ProjectClassification__c === "Fearless Bet" || this.ProjectObject.ProjectClassification__c === "Brand Energizer" || this.ProjectObject.ProjectClassification__c === "Business Enabler" || this.ProjectObject.ProjectClassification__c === "Repack" || (this.ProjectObject.ProjectClassification__c === "Geographical Extension" && this.ProjectObject.GeoExtensionProjectSubClassification__c === "Innovation Geo Extension")) {
            if (!this.ProjectObject.ProductionMilestone__c && this.ProjectObject.ProjectPhase__c === "Deploy") {
                this.missingFields.push("Missing rows in Production Financial Success Criteria");
            } else if (this.ProjectObject.FinancialTolerancesOutsideThreshold__c && !this.ProjectObject.BypassFinancialTolerances__c) {
                this.criticalKPIs = true;
            }
        }
    }

    opportunityOrDescriptionAndOpportunityCheck() {
        if (classificationsWithDescriptionAndOpportunity.includes(this.ProjectObject.ProjectClassification__c)) {
            if (this.ProjectObject.DescriptionAndOpportunity__c == null) {
                this.missingFields.push("Project Description & Consumer Opportunity");
            }
        } else {
            if (this.ProjectObject.Opportunity__c == null) {
                this.missingFields.push("What is the Consumer Opportunity");
            }
        }
    }

    promoPacksFinancialThresholdsCheck() {
        if (!this.ProjectObject.NSVThresholdMet__c || !this.ProjectObject.TotalCostsThresholdMet__c) {
            this.missingFields.push("Because the total NSV or total Costs has increased or decreased by +20% vs. BCA values, this project requires approval from all Approvers, which Innovator will manage for you automatically when you submit. ​");
        }
        if (!this.ProjectObject.ReturnOnInvestmentThresholdMet__c) {
            this.missingFields.push("Because the RoI value is either below 1 OR it has decreased below the BCA value, this project requires approval from all Approvers. Please attach their approval email in the attachments tab in Innovator, for the project to progress at this current RoI value. Please then tick this box to confirm they have approved, to be able to submit this project. ​");
        }
    }

    financialsFiscalYearsFilledIn() {
        if (!this.ProjectObject.FirstFiscalYearFilled__c) {
            this.missingFields.push("Missing rows in First Fiscal Year Project Financials");
        }
        if (!this.ProjectObject.SecondFiscalYearFilled__c) {
            this.missingFields.push("Missing rows in Second Fiscal Year Project Financials");
        }
        if (!this.ProjectObject.ThirdFiscalYearFilled__c) {
            this.missingFields.push("Missing rows in Third Fiscal Year Project Financials");
        }
        if (!this.ProjectObject.FourthFiscalYearFilled__c) {
            this.missingFields.push("Missing rows in Fourth Fiscal Year Project Financials");
        }
        if (!this.ProjectObject.FifthFiscalYearFilled__c) {
            this.missingFields.push("Missing rows in Fifth Fiscal Year Project Financials");
        }
    }

}