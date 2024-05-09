import {LightningElement, api} from 'lwc';
import {constants} from 'c/utils';
import {loadStyle} from 'lightning/platformResourceLoader';
import TIMINGS_DATATABLE_STYLESHEET from '@salesforce/resourceUrl/timingsDatatable';
import getTimingsMetadata from '@salesforce/apex/TimingsTableController.getTimingsMetadata';
import getProject from '@salesforce/apex/TimingsTableController.getProject';
import getProjectSnapshot from '@salesforce/apex/TimingsTableController.getProjectSnapshot';

const KEY_EVENT_COLUMN_LABEL = 'Key Project Events';
const KEY_EVENT_FIELD_NAME = 'KeyEvent';
const SUGGESTED_DATE_COLUMN_LABEL = 'Earliest Innovator Suggested Date (MM/DD/YYYY)';
const SUGGESTED_DATE_FIELD_NAME = 'RecommendedDate';
const PRIMO_DATE_COLUMN_LABEL = 'Primo Inputted Dates (MM/DD/YYYY)';
const PRIMO_DATE_FIELD_NAME = 'PLDate';
const PRIMO_DISPLAY_DATE_FIELD_NAME = 'PLDisplayDate';
const ON_OFF_TRACK_COLUMN_LABEL = 'Comments'; // previously was 'On Track / Off Track'
const ON_OFF_TRACK_FIELD_NAME = 'OnOffTrackMessage';

const columns = [
    {
        label: KEY_EVENT_COLUMN_LABEL,
        fieldName: KEY_EVENT_FIELD_NAME,
        wrapText: true,
        hideDefaultActions: true,
        initialWidth: 155,
        cellAttributes: {style: {fieldName: 'style'}}
    },
    {
        label: SUGGESTED_DATE_COLUMN_LABEL,
        fieldName: SUGGESTED_DATE_FIELD_NAME,
        wrapText: true,
        hideDefaultActions: true,
        initialWidth: 230,
        cellAttributes: {style: {fieldName: 'style'}}
    },
    {
        label: PRIMO_DATE_COLUMN_LABEL,
        fieldName: PRIMO_DATE_FIELD_NAME,
        wrapText: true,
        hideDefaultActions: true,
        editable: true,
        initialWidth: 200,
        // type: 'date',
        // typeAttributes: {
        //     day: "numeric",
        //     month: "numeric",
        //     year: "numeric"
        // },
        type: 'customDateTemplate',
        typeAttributes: {
            customDate: {fieldName: PRIMO_DATE_FIELD_NAME},
            displayDate: {fieldName: PRIMO_DISPLAY_DATE_FIELD_NAME},
            isPassed: false
        },
        cellAttributes:
            {
                class: {fieldName: 'styleClass'},
                // alignment: 'center',
            }
    },
    {
        label: ON_OFF_TRACK_COLUMN_LABEL,
        fieldName: ON_OFF_TRACK_FIELD_NAME,
        wrapText: true,
        hideDefaultActions: true,
        cellAttributes: {class: {fieldName: 'styleClass'}}
    },
];

const columnsSnapshot = [
    {
        label: KEY_EVENT_COLUMN_LABEL,
        fieldName: KEY_EVENT_FIELD_NAME,
        wrapText: true,
        hideDefaultActions: true,
        cellAttributes: {style: {fieldName: 'style'}}
    },
    {
        label: SUGGESTED_DATE_COLUMN_LABEL,
        fieldName: SUGGESTED_DATE_FIELD_NAME,
        wrapText: true,
        hideDefaultActions: true,
    },
    {
        label: PRIMO_DATE_COLUMN_LABEL,
        fieldName: PRIMO_DISPLAY_DATE_FIELD_NAME,
        wrapText: true,
        hideDefaultActions: true,
        // type: 'date-local',
        // typeAttributes: {
        //     day: "numeric",
        //     month: "numeric",
        //     year: "numeric"
        // },
    }
];

const PHASE_TO_NUMBER = {
    "Discover": 1,
    "Define": 2,
    "Design": 3,
    "Develop": 4,
    "Deploy": 5,
    "Diagnose": 6,
}

const ADD_DAYS = 'add';
const SUBTRACT_DAYS = 'subtract';
const PASSED_TEXT = 'Passed on: ';
const SUBMITTED_TEXT = 'Submitted on: ';
const APPROVED_TEXT = 'Approved on: ';
const SHIPPED_TEXT = 'Shipped on: ';
const ON_SHELF_TEXT = 'On Shelf on: ';
const COMPLETED_TEXT = 'Completed on: ';
const ON_TRACK = 'on';
const OFF_TRACK = 'off';
const ON_TRACK_TEXT = 'On Track';
const OFF_TRACK_TEXT = 'Off Track';
const DATE_IN_PAST_MSG = constants.CONST_TIMINGS_DATE_IN_PAST_LABEL;
const TOO_EARLY_MSG = constants.CONST_TIMINGS_WARNING_TOO_EARLY_LABEL;
const CUSTOMER_MEETING_MSG = constants.CONST_TIMINGS_WARNING_CUSTOMER_MEETING_LABEL;
const CUSTOMER_MEETING_GEO_MSG = constants.CONST_TIMINGS_WARNING_CUSTOMER_MEETING_GEO_LABEL;
export default class TimingsTable extends LightningElement {
    @api isFromFlow;
    @api projectPhase;
    @api projectClassification;
    @api projectClassificationSubtype;
    @api projectStatus;
    @api isIPCWithoutArtworkChange;
    @api isArtworkChange;
    @api isNewLiquid;
    @api isNewPrimaryPack;
    @api isSourcingChange;
    @api targetOpportunitySubmissionDate;
    @api targetBCASubmissionDate;
    @api targetBCVSubmissionDate;
    @api customerPresentationDate;
    @api targetCommercialSubmissionDate;
    @api targetProductionSubmissionDate;
    @api targetShipmentDate;
    @api targetOnShelfDate;
    @api targetPLRDate;
    @api opportunitySubmissionDate;
    @api BCASubmissionDate;
    @api BCAApprovalDate;
    @api BCVSubmissionDate;
    @api BCVApprovalDate;
    @api commercialSubmissionDate;
    @api commercialApprovalDate;
    @api productionSubmissionDate;
    @api actualOnShelfDate;
    @api actualShipmentDate;
    @api actualPLRDate;
    @api isProjectSubmitted;
    @api isPLRRequired;
    @api isProjectOnOffTrack;
    @api opportunityRecommendedDate;
    @api BCARecommendedDate;
    @api BCVRecommendedDate;
    @api customerMeetingRecommendedDate;
    @api commercialRecommendedDate;
    @api productionRecommendedDate;
    @api shipmentRecommendedDate;
    @api shelfRecommendedDate;
    @api PLRRecommendedDate;

    //values from the Record page
    @api isFromProjectRecordPage;
    @api recordId;

    @api isProjectSnapshot = false;

    data = [];
    columns;

    timingsMetadata = [];
    isLoading;

    isComplexProject = false;
    isGeoComplex = false;
    isGeoSimple = false;
    isSimpleRepack = false;
    isComplexRepack = false;
    isBusinessEnabler = false;
    opportunityRow = {};
    BCARow = {};
    BCVRow = {};
    customerMeetingRow = {};
    commercialRow = {};
    productionRow = {};
    shipmentRow = {};
    onShelfDateRow = {};
    PLRRow = {};

    opportunityWarning;
    BCAWarning;
    BCVWarning;
    customerMeetingWarning;
    commercialWarning;
    productionWarning;
    shipmentWarning;
    onShelfDateWarning;
    PLRWarning;

    daysFromOpportunity;
    daysFromBCA;
    daysFromBCV;
    daysToCustomerMeeting;
    daysFromCommercial;
    daysFromProduction;
    daysFromShipment;
    daysFromOnShelf;

    isOpportunityPassed = false;
    isBCAPassed = false;
    isBCASubmitted = false;
    isBCVPassed = false;
    isBCVSubmitted = false;
    isCommercialPassed = false;
    isCommercialSubmitted = false;
    isProductionPassed = false;
    isShipmentPassed = false;
    isOnShelfPassed = false;
    isPLRPassed = false;

    // variables to regulate the row color
    opportunityTracking;
    BCATracking;
    BCVTracking;
    customerMeetingTracking;
    commercialTracking;
    productionTracking;
    shipmentTracking;
    onShelfTracking;
    PLRTracking;

    renderedCallback() {
        loadStyle(this, TIMINGS_DATATABLE_STYLESHEET).then(() => {
            console.log('Loaded Successfully')
        }).catch(error => {
            console.error('Error in loading the colors:', error)
        })
    }

    connectedCallback() {
        this.isLoading = true;

        if (!this.isProjectSnapshot) {
            if (this.isFromProjectRecordPage) {
                getProject({projectId: this.recordId}).then((response) => {
                    if (response) {
                        this.projectPhase = response.ProjectPhase__c;
                        this.projectClassification = response.ProjectClassification__c;
                        this.projectClassificationSubtype = response.ProjectClassificationSubtype__c;
                        this.projectStatus = response.ProjectStatus__c;
                        this.targetOpportunitySubmissionDate = response.TargetOpportunitySubmissionDate__c;
                        this.targetBCASubmissionDate = response.TargetBCASubmissionDate__c;
                        this.targetBCVSubmissionDate = response.TargetBCVSubmissionDate__c;
                        this.customerPresentationDate = response.Estimated1stCustomerPresentationDate__c;
                        this.targetCommercialSubmissionDate = response.TargetCommercialSubmissionDate__c;
                        this.targetProductionSubmissionDate = response.TargetProductionSubmissionDate__c;
                        this.targetShipmentDate = response.TargetReadyShipmentDate__c;
                        this.targetOnShelfDate = response.TargetOnShelfDateLeadRegion__c;
                        this.targetPLRDate = response.TargetPLRDate__c;
                        this.opportunitySubmissionDate = response.OpportunitySubmissionDate__c;
                        this.BCASubmissionDate = response.BCASubmissionDate__c;
                        this.BCAApprovalDate = response.BCAApprovalDate__c;
                        this.BCVSubmissionDate = response.BCVSubmissionDate__c;
                        this.BCVApprovalDate = response.BCVApprovalDate__c;
                        this.commercialSubmissionDate = response.CommercialSubmissionDate__c;
                        this.commercialApprovalDate = response.CommercialApprovalDate__c;
                        this.productionSubmissionDate = response.ProductionSubmissionDate__c;
                        this.actualOnShelfDate = response.ActualOnShelfDate__c;
                        this.actualShipmentDate = response.ActualReadyShipmentDate__c;
                        this.actualPLRDate = response.ActualPLRDate__c;
                        this.isPLRRequired = response.IsThePostLaunchReviewRequired__c;
                        this.isIPCWithoutArtworkChange = response.IPCExtensionWithoutArtworkChange__c;
                        this.isArtworkChange = response.ArtworkChange__c;
                        this.isNewLiquid = response.NewLiquid__c;
                        this.isNewPrimaryPack = response.NewPrimaryPack__c;
                        this.isSourcingChange = response.SourcingChange__c;

                        let projectDecisionStepStatus = response.SubmissionStatus__c;
                        this.isProjectSubmitted = !projectDecisionStepStatus.toLowerCase().includes('yet') && projectDecisionStepStatus.toLowerCase().includes('submitted');

                        this.checkPhase();

                        if ((this.projectClassification === constants.CONST_GEO_EXTENSION_NAME || this.projectClassification === constants.CONST_REPACK_NAME) && (!this.isOpportunityPassed || !this.isBCAPassed)) {
                            this.projectClassificationSubtype = this.getProjectSubtype();
                        }

                        this.getTimingsMetadataAndPrepareTable();
                    }
                }).catch((error) => {
                    console.log('error');
                    console.error(error);
                })
            } else if (this.isFromFlow) {
                this.checkPhase();

                if ((this.projectClassification === constants.CONST_GEO_EXTENSION_NAME || this.projectClassification === constants.CONST_REPACK_NAME) && (!this.isOpportunityPassed || !this.isBCAPassed)) {
                    this.projectClassificationSubtype = this.getProjectSubtype();
                }

                this.getTimingsMetadataAndPrepareTable();
            }
        } else {
            getProjectSnapshot({projectSnapshotId: this.recordId}).then((snapshotResponse) => {
                if (snapshotResponse) {
                    this.projectPhase = snapshotResponse.ProjectPhase__c;
                    this.projectClassification = snapshotResponse.ProjectClassification__c;
                    this.projectClassificationSubtype = snapshotResponse.ProjectClassificationSubtype__c;
                    this.projectStatus = snapshotResponse.ProjectStatus__c;
                    this.targetOpportunitySubmissionDate = snapshotResponse.TargetOpportunitySubmissionDate__c;
                    this.targetBCASubmissionDate = snapshotResponse.TargetBCASubmissionDate__c;
                    this.targetBCVSubmissionDate = snapshotResponse.TargetBCVSubmissionDate__c;
                    this.customerPresentationDate = snapshotResponse.Estimated1stCustomerPresentationDate__c;
                    this.targetCommercialSubmissionDate = snapshotResponse.TargetCommercialSubmissionDate__c;
                    this.targetProductionSubmissionDate = snapshotResponse.TargetProductionSubmissionDate__c;
                    this.targetShipmentDate = snapshotResponse.TargetReadyShipmentDate__c;
                    this.targetOnShelfDate = snapshotResponse.TargetOnShelfDateLeadRegion__c;
                    this.targetPLRDate = snapshotResponse.TargetPLRDate__c;
                    this.opportunitySubmissionDate = snapshotResponse.OpportunitySubmissionDate__c;
                    this.BCASubmissionDate = snapshotResponse.BCASubmissionDate__c;
                    this.BCAApprovalDate = snapshotResponse.BCAApprovalDate__c;
                    this.BCVSubmissionDate = snapshotResponse.BCVSubmissionDate__c;
                    this.BCVApprovalDate = snapshotResponse.BCVApprovalDate__c;
                    this.commercialSubmissionDate = snapshotResponse.CommercialSubmissionDate__c;
                    this.commercialApprovalDate = snapshotResponse.CommercialApprovalDate__c;
                    this.productionSubmissionDate = snapshotResponse.ProductionSubmissionDate__c;
                    this.opportunityRecommendedDate = snapshotResponse.OpportunityRecommendedDate__c;
                    this.BCARecommendedDate = snapshotResponse.BCARecommendedDate__c;
                    this.BCVRecommendedDate = snapshotResponse.BCVRecommendedDate__c;
                    this.customerMeetingRecommendedDate = snapshotResponse.CustomerMeetingRecommendedDate__c;
                    this.commercialRecommendedDate = snapshotResponse.CommercialRecommendedDate__c;
                    this.productionRecommendedDate = snapshotResponse.ProductionRecommendedDate__c;
                    this.shipmentRecommendedDate = snapshotResponse.ShipmentRecommendedDate__c;
                    this.shelfRecommendedDate = snapshotResponse.OnShelfRecommendedDate__c;
                    this.PLRRecommendedDate = snapshotResponse.PLRRecommendedDate__c;
                    this.isIPCWithoutArtworkChange = snapshotResponse.IPCExtensionWithoutArtworkChange__c;
                    this.isArtworkChange = snapshotResponse.ArtworkChange__c;
                    this.isNewLiquid = snapshotResponse.NewLiquid__c;
                    this.isNewPrimaryPack = snapshotResponse.NewPrimaryPack__c;
                    this.isSourcingChange = snapshotResponse.SourcingChange__c;

                    this.checkPhase();

                    if ((this.projectClassification === constants.CONST_GEO_EXTENSION_NAME || this.projectClassification === constants.CONST_REPACK_NAME) && (!this.isOpportunityPassed || !this.isBCAPassed)) {
                        this.projectClassificationSubtype = this.getProjectSubtype();
                    }

                    this.columns = columnsSnapshot;
                    this.columns[0].cellAttributes.style = 'font-weight: 600;';
                    this.getProjectComplexity();

                    this.prepareRowsToDisplay();
                    this.setTableData();
                    this.isLoading = false;
                }
            }).catch((error) => {
                console.log('error');
                console.error(error);
            })
        }

        this.isLoading = false;
    }

    getProjectSubtype() {
        let projectClassificationSubtype;
        if (this.projectClassification === constants.CONST_GEO_EXTENSION_NAME) {
            let isIPCSubtype = ((this.isIPCWithoutArtworkChange || this.isArtworkChange) && !this.isNewLiquid && !this.isNewPrimaryPack && !this.isSourcingChange);
            projectClassificationSubtype = isIPCSubtype ? constants.CONST_IPC_API_NAME : constants.CONST_LIQUID_PACK_CHANGE_SUBTYPE_NAME;
        } else if (this.projectClassification === constants.CONST_REPACK_NAME) {
            let isArtworkChangeSubtype = !this.isNewPrimaryPack && this.isArtworkChange;
            projectClassificationSubtype = isArtworkChangeSubtype ? constants.CONST_ARTWORK_CHANGE_ONLY_API_NAME : constants.CONST_PRIMARY_PACK_CHANGE_NAME;
        }
        return projectClassificationSubtype;
    }

    getTimingsMetadataAndPrepareTable() {
        getTimingsMetadata({
            projectClassification: this.projectClassification,
            projectSubtype: this.projectClassificationSubtype
        }).then((metadataResponse) => {
            if (metadataResponse) {
                this.columns = columns;
                this.columns[3].cellAttributes.class = 'slds-text-color_error';
                this.columns[0].cellAttributes.style = 'font-weight: 600;';
                this.columns[1].cellAttributes.style = 'background: rgba(243, 243, 243, 0.5);';
                // this.columns[2].cellAttributes.class = 'slds-text-align_center';
                this.timingsMetadata = metadataResponse[0];
                this.setRecommendedDays();
                this.getProjectComplexity();
                this.prepareValuesToDisplay();
                this.setWarningMessages();
                this.prepareRowsToDisplay();
                this.setTableData();

                this.isLoading = false;
            }
        }).catch((error) => {
            console.log('error');
            console.error(error);
        })
    }

    checkPhase() {
        this.isOpportunityPassed = PHASE_TO_NUMBER[this.projectPhase] > PHASE_TO_NUMBER[constants.CONST_DISCOVER_PHASE];
        this.isBCAPassed = PHASE_TO_NUMBER[this.projectPhase] > PHASE_TO_NUMBER[constants.CONST_DEFINE_PHASE];
        this.isBCVPassed = PHASE_TO_NUMBER[this.projectPhase] > PHASE_TO_NUMBER[constants.CONST_DESIGN_PHASE];
        this.isCommercialPassed = PHASE_TO_NUMBER[this.projectPhase] > PHASE_TO_NUMBER[constants.CONST_DEVELOP_PHASE];
        this.isProductionPassed = PHASE_TO_NUMBER[this.projectPhase] > PHASE_TO_NUMBER[constants.CONST_DEPLOY_PHASE];
        this.isShipmentPassed = !this.isEmpty(this.actualShipmentDate) || !this.isEmpty(this.actualOnShelfDate);
        this.isOnShelfPassed = !this.isEmpty(this.actualOnShelfDate) || !this.isEmpty(this.actualShipmentDate);
        this.isPLRPassed = !this.isEmpty(this.actualPLRDate);

        this.isBCASubmitted = !this.isBCAPassed && this.isProjectSubmitted;
        this.isBCVSubmitted = this.isBCAPassed && !this.isBCVPassed && this.isProjectSubmitted;
        this.isCommercialSubmitted = this.isBCAPassed && this.isBCVPassed && !this.isCommercialPassed && this.isProjectSubmitted;
    }

    setRecommendedDays() {
        this.daysFromOpportunity = this.timingsMetadata?.Opportunity__c === 12 ? 365 : this.timingsMetadata?.Opportunity__c * 30;
        this.daysFromBCA = this.timingsMetadata?.BCA__c === 12 ? 365 : this.timingsMetadata?.BCA__c * 30;
        this.daysFromBCV = this.timingsMetadata?.BCV__c === 12 ? 365 : this.timingsMetadata?.BCV__c * 30;
        this.daysToCustomerMeeting = this.timingsMetadata?.CustomerMeeting__c === 12 ? 365 : this.timingsMetadata?.CustomerMeeting__c * 30;
        this.daysFromCommercial = this.timingsMetadata?.Commercial__c === 12 ? 365 : this.timingsMetadata?.Commercial__c * 30;
        this.daysFromProduction = this.timingsMetadata?.Production__c === 12 ? 365 : this.timingsMetadata?.Production__c * 30;
        this.daysFromShipment = this.timingsMetadata?.Shipment__c === 12 ? 365 : this.timingsMetadata?.Shipment__c * 30;
        this.daysFromOnShelf = this.timingsMetadata?.OnShelf__c === 12 ? 365 : this.timingsMetadata?.OnShelf__c * 30;
    }

    getProjectComplexity() {
        this.isSimpleRepack = this.projectClassification === constants.CONST_REPACK_NAME && this.projectClassificationSubtype === constants.CONST_ARTWORK_CHANGE_ONLY_API_NAME;
        // FB, Brand Energizer, Repack complex
        this.isComplexProject = this.projectClassification === constants.CONST_FEARLESS_BET_NAME || this.projectClassification === constants.CONST_BRAND_ENERGIZER_NAME ||
            (this.projectClassification === constants.CONST_REPACK_NAME && this.projectClassificationSubtype === constants.CONST_PRIMARY_PACK_CHANGE_NAME);
        this.isComplexRepack = this.projectClassification === constants.CONST_REPACK_NAME && this.projectClassificationSubtype === constants.CONST_PRIMARY_PACK_CHANGE_NAME;
        this.isGeoComplex = this.projectClassification === constants.CONST_GEO_EXTENSION_NAME && this.projectClassificationSubtype === constants.CONST_LIQUID_PACK_CHANGE_SUBTYPE_NAME;
        this.isGeoSimple = this.projectClassification === constants.CONST_GEO_EXTENSION_NAME && this.projectClassificationSubtype === constants.CONST_IPC_API_NAME;
        this.isBusinessEnabler = this.projectClassification === constants.CONST_BUSINESS_ENABLER_NAME;
    }

    prepareValuesToDisplay() {
        let currentDate = this.calculateDate(new Date());
        console.log("opp: " + this.opportunityRecommendedDate);
        // console.log("bca: " + this.BCARecommendedDate);
        // let opportunityRecommendedDateTemp = this.calculateDate(this.opportunityRecommendedDate); //todo check later
        if (!this.isGeoSimple) {
            if ((this.isComplexProject || this.isSimpleRepack) && !this.isOpportunityPassed) {
                this.opportunityRecommendedDate = currentDate;
                this.BCARecommendedDate = this.calculateDate(this.opportunityRecommendedDate, this.daysFromOpportunity, ADD_DAYS);
            } else if ((this.isComplexProject || this.isSimpleRepack) && this.isOpportunityPassed) {
                // this.opportunityRecommendedDate = opportunityRecommendedDateTemp;
                this.BCARecommendedDate = this.calculateDate(this.opportunitySubmissionDate, this.daysFromOpportunity, ADD_DAYS);
            } else if ((this.isBusinessEnabler || this.isGeoComplex) && !this.isBCAPassed && !this.isProjectSubmitted) {
                this.BCARecommendedDate = this.calculateDate(currentDate, 7, ADD_DAYS);
            }

            if (!this.isGeoComplex) {
                this.BCVRecommendedDate = this.calculateDate(this.isBCAPassed ? this.BCAApprovalDate : (this.isBCASubmitted ? this.BCASubmissionDate : this.BCARecommendedDate), this.daysFromBCA, ADD_DAYS);
                this.customerMeetingRecommendedDate = this.calculateDate(this.isBCVPassed ? this.BCVApprovalDate : (this.isBCVSubmitted ? this.BCVSubmissionDate : this.BCVRecommendedDate), this.daysToCustomerMeeting, ADD_DAYS);
            } else {
                this.customerMeetingRecommendedDate = this.calculateDate(this.isBCAPassed ? this.BCAApprovalDate : (this.isBCASubmitted ? this.BCASubmissionDate : this.BCARecommendedDate), this.daysToCustomerMeeting, ADD_DAYS);
                console.log('this.customerMeetingRecommendedDate ' + this.customerMeetingRecommendedDate)
            }

            if (this.isSimpleRepack) {
                this.productionRecommendedDate = this.calculateDate(this.isBCVPassed ? this.BCVApprovalDate : (this.isBCVSubmitted ? this.BCVSubmissionDate : this.BCVRecommendedDate), this.daysFromBCV, ADD_DAYS);
            } else {
                if (this.isComplexRepack) {
                    this.commercialRecommendedDate = this.calculateDate(this.isBCVPassed ? this.BCVApprovalDate : (this.isBCVSubmitted ? this.BCVSubmissionDate : this.BCVRecommendedDate), this.daysFromBCV, ADD_DAYS);
                    this.productionRecommendedDate = this.calculateDate(this.isCommercialPassed ? this.commercialSubmissionDate : this.commercialRecommendedDate, this.daysFromCommercial, ADD_DAYS);
                } else {
                    if (this.isGeoComplex) {
                        this.commercialRecommendedDate = this.calculateDate(this.isBCAPassed ? this.BCAApprovalDate : (this.isBCASubmitted ? this.BCASubmissionDate : this.BCARecommendedDate), this.daysFromBCA, ADD_DAYS);
                    } else {
                        this.commercialRecommendedDate = this.calculateDate(this.isBCVPassed ? this.BCVApprovalDate : (this.isBCVSubmitted ? this.BCVSubmissionDate : this.BCVRecommendedDate), this.daysFromBCV, ADD_DAYS);
                    }
                    this.productionRecommendedDate = this.calculateDate(this.isCommercialPassed ? this.commercialApprovalDate : (this.isCommercialSubmitted ? this.commercialSubmissionDate : this.commercialRecommendedDate), this.daysFromCommercial, ADD_DAYS);
                }
            }

            this.shipmentRecommendedDate = this.calculateDate(this.isProductionPassed ? this.productionSubmissionDate : this.productionRecommendedDate, this.daysFromProduction, ADD_DAYS);
            this.shelfRecommendedDate = this.calculateDate(this.shipmentRecommendedDate, this.daysFromShipment, ADD_DAYS);
            this.PLRRecommendedDate = this.calculateDate(this.isOnShelfPassed ? this.actualOnShelfDate : this.shelfRecommendedDate, this.daysFromOnShelf, ADD_DAYS);

        } else { //for Geo Simple
            if (!this.isBCAPassed && !this.isProjectSubmitted) {
                this.BCARecommendedDate = this.calculateDate(currentDate, 7, ADD_DAYS);
            }

            this.customerMeetingRecommendedDate = this.calculateDate(this.isBCAPassed ? this.BCAApprovalDate : (this.isBCASubmitted ? this.BCASubmissionDate : this.BCARecommendedDate), this.daysToCustomerMeeting, ADD_DAYS);
            this.commercialRecommendedDate = this.calculateDate(this.isBCAPassed ? this.BCAApprovalDate : (this.isBCASubmitted ? this.BCASubmissionDate : this.BCARecommendedDate), this.daysFromBCA, ADD_DAYS);
            this.shipmentRecommendedDate = this.calculateDate(this.isCommercialPassed ? this.commercialApprovalDate : (this.isCommercialSubmitted ? this.commercialSubmissionDate : this.commercialRecommendedDate), this.daysFromCommercial, ADD_DAYS);
            this.shelfRecommendedDate = this.calculateDate(this.shipmentRecommendedDate, this.daysFromShipment, ADD_DAYS);

            // if (!this.isBCAPassed && !this.isProjectSubmitted) {
            //     // this.BCARecommendedDate = this.calculateDate(currentDate, 7, ADD_DAYS);
            //     this.customerMeetingRecommendedDate = this.calculateDate(this.BCARecommendedDate, this.daysToCustomerMeeting, ADD_DAYS);
            //     this.commercialRecommendedDate = this.calculateDate(this.BCARecommendedDate, this.daysFromBCA, ADD_DAYS);
            //     this.shipmentRecommendedDate = this.calculateDate(this.commercialRecommendedDate, this.daysFromCommercial, ADD_DAYS);
            // } else {
            //
            // }
        }
        console.log('opportunityRecommendedDate ' + this.opportunityRecommendedDate);
        // console.log('BCARecommendedDate ' + this.BCARecommendedDate);
        // console.log('BCVRecommendedDate ' + this.BCVRecommendedDate);
        // console.log('customerMeetingRecommendedDate ' + this.customerMeetingRecommendedDate);
        // console.log('commercialRecommendedDate ' + this.commercialRecommendedDate);
        // console.log('productionRecommendedDate ' + this.productionRecommendedDate);
        // console.log('shipmentRecommendedDate ' + this.shipmentRecommendedDate);
        // console.log('shelfRecommendedDate ' + this.shelfRecommendedDate);
        // console.log('PLRRecommendedDate ' + this.PLRRecommendedDate);
    }

    setWarningMessages() {
        this.opportunityWarning = this.isDateInPast(this.targetOpportunitySubmissionDate) ? DATE_IN_PAST_MSG : (this.compareDates(this.opportunityRecommendedDate, this.targetOpportunitySubmissionDate) ? TOO_EARLY_MSG : '');

        if (this.isComplexProject || this.isSimpleRepack) {
            this.BCAWarning = this.isDateInPast(this.targetBCASubmissionDate) ? DATE_IN_PAST_MSG : (this.compareDates(this.BCARecommendedDate, this.targetBCASubmissionDate) ? TOO_EARLY_MSG : '');
        } else {
            this.BCAWarning = this.isDateInPast(this.targetBCASubmissionDate) ? DATE_IN_PAST_MSG : '';
        }

        if (!this.isGeoSimple) {
            if (!this.isGeoComplex) {
                this.BCVWarning = this.isDateInPast(this.targetBCVSubmissionDate) ? DATE_IN_PAST_MSG : (this.compareDates(this.BCVRecommendedDate, this.targetBCVSubmissionDate) ? TOO_EARLY_MSG : '');
            }
            this.productionWarning = this.isDateInPast(this.targetProductionSubmissionDate) ? DATE_IN_PAST_MSG : (this.compareDates(this.productionRecommendedDate, this.targetProductionSubmissionDate) ? TOO_EARLY_MSG : '');
            this.PLRWarning = this.isDateInPast(this.targetPLRDate) ? DATE_IN_PAST_MSG : (this.compareDates(this.PLRRecommendedDate, this.targetPLRDate) ? TOO_EARLY_MSG : '');
        }

        if (this.isGeoSimple || this.isGeoComplex) {
            if (!this.isBCAPassed && !this.isProjectSubmitted) {
                this.customerMeetingWarning = this.compareDates(this.targetBCASubmissionDate, this.customerMeetingRecommendedDate) ? CUSTOMER_MEETING_GEO_MSG : (this.compareDates(this.customerMeetingRecommendedDate, this.customerPresentationDate) ? TOO_EARLY_MSG : '');
            } else {
                this.customerMeetingWarning = this.compareDates(this.isBCASubmitted ? this.BCASubmissionDate : this.BCAApprovalDate, this.customerMeetingRecommendedDate) ? CUSTOMER_MEETING_GEO_MSG : (this.compareDates(this.customerMeetingRecommendedDate, this.customerPresentationDate) ? TOO_EARLY_MSG : '');
            }
        } else {
            this.customerMeetingWarning = this.compareDates(this.isBCVSubmitted ? this.BCVSubmissionDate :
                (this.isBCVPassed ? this.BCVApprovalDate : this.targetBCVSubmissionDate), this.customerMeetingRecommendedDate) ? CUSTOMER_MEETING_MSG : (this.compareDates(this.customerMeetingRecommendedDate, this.customerPresentationDate) ? TOO_EARLY_MSG : '');
        }

        if (!this.isSimpleRepack) {
            this.commercialWarning = this.isDateInPast(this.targetCommercialSubmissionDate) ? DATE_IN_PAST_MSG : (this.compareDates(this.commercialRecommendedDate, this.targetCommercialSubmissionDate) ? TOO_EARLY_MSG : '');
        }

        this.shipmentWarning = this.compareDates(this.shipmentRecommendedDate, this.targetShipmentDate) ? TOO_EARLY_MSG : '';
        this.onShelfDateWarning = this.compareDates(this.shelfRecommendedDate, this.targetOnShelfDate) ? TOO_EARLY_MSG : '';

        //setting the row colour
        this.opportunityTracking = this.setTrackingValue(this.opportunityRecommendedDate, this.targetOpportunitySubmissionDate, this.opportunityWarning);
        this.BCATracking = this.setTrackingValue(this.BCARecommendedDate, this.targetBCASubmissionDate, this.BCAWarning);
        this.BCVTracking = this.setTrackingValue(this.BCVRecommendedDate, this.targetBCVSubmissionDate, this.BCVWarning);


        if (this.isGeoSimple || this.isGeoComplex) {
            this.customerMeetingTracking = this.setTrackingValue(this.customerMeetingRecommendedDate, !this.isBCAPassed && !this.isProjectSubmitted ? this.targetBCASubmissionDate : (this.isBCASubmitted ? this.BCASubmissionDate : this.BCAApprovalDate), this.customerMeetingWarning);
        } else {
            this.customerMeetingTracking = this.setTrackingValue(this.customerMeetingRecommendedDate, this.isBCVPassed ? this.BCVApprovalDate : (this.isBCVSubmitted ? this.BCVSubmissionDate : this.targetBCVSubmissionDate), this.customerMeetingWarning);
        }

        if (this.customerMeetingTracking !== OFF_TRACK) {
            this.customerMeetingTracking = this.setTrackingValue(this.customerMeetingRecommendedDate, this.customerPresentationDate, this.customerMeetingWarning);
        }

        this.commercialTracking = this.setTrackingValue(this.commercialRecommendedDate, this.targetCommercialSubmissionDate, this.commercialWarning);
        this.productionTracking = this.setTrackingValue(this.productionRecommendedDate, this.targetProductionSubmissionDate, this.productionWarning);
        this.shipmentTracking = this.setTrackingValue(this.shipmentRecommendedDate, this.targetShipmentDate, this.shipmentWarning);
        this.onShelfTracking = this.setTrackingValue(this.shelfRecommendedDate, this.targetOnShelfDate, this.onShelfDateWarning);
        this.PLRTracking = this.setTrackingValue(this.PLRRecommendedDate, this.targetPLRDate, this.PLRWarning);

        if ((!this.isOpportunityPassed && this.opportunityTracking === OFF_TRACK) ||
            (!this.isBCAPassed && this.BCATracking === OFF_TRACK) ||
            (!this.isBCVPassed && this.BCVTracking === OFF_TRACK) ||
            (!this.isCommercialPassed && this.commercialTracking === OFF_TRACK) ||
            (!this.isCommercialPassed && this.customerMeetingTracking === OFF_TRACK && !this.isSimpleRepack) ||
            (!this.isProductionPassed && this.productionTracking === OFF_TRACK) ||
            (!this.isProductionPassed && this.customerMeetingTracking === OFF_TRACK && this.isSimpleRepack) ||
            (!this.isShipmentPassed && this.shipmentTracking === OFF_TRACK) ||
            (!this.isOnShelfPassed && this.onShelfTracking === OFF_TRACK) ||
            (!this.isPLRPassed && this.PLRTracking === OFF_TRACK)) {
            this.isProjectOnOffTrack = OFF_TRACK_TEXT;
        } else {
            this.isProjectOnOffTrack = this.projectStatus === constants.CONST_COMPLETED_STATUS ? '' : ON_TRACK_TEXT;
        }

    }

    isDateInPast(date) {
        return !this.isEmpty(date) && new Date(date).setHours(0, 0, 0, 0) < new Date().setHours(0, 0, 0, 0);
    }

    // the function checks if date1 is after date2
    compareDates(date1, date2) {
        return !this.isEmpty(date1) && !this.isEmpty(date2) && new Date(date1).setHours(0, 0, 0, 0) > new Date(date2).setHours(0, 0, 0, 0);
    }

    isEmpty(value) {
        return value === undefined || value === null || value === '';
    }

    setTrackingValue(recommendedDate, targetDate, warning) {
        return !this.isEmpty(recommendedDate) && !this.isEmpty(targetDate) && this.isEmpty(warning) ? ON_TRACK : (!this.isEmpty(warning) ? OFF_TRACK : '');
    }

    prepareRowsToDisplay() {
        this.opportunityRow = {
            KeyEvent: constants.CONST_OPPORTUNITY_MILESTONE_DESCRIPTION,
            RecommendedDate: this.isOpportunityPassed ? PASSED_TEXT + this.formatDate(this.opportunitySubmissionDate) : this.formatDate(this.opportunityRecommendedDate),
            PLDate: this.isOpportunityPassed ? this.opportunitySubmissionDate : this.targetOpportunitySubmissionDate,
            PLDisplayDate: this.isOpportunityPassed ? PASSED_TEXT + this.formatDate(this.opportunitySubmissionDate) : this.formatDate(this.targetOpportunitySubmissionDate),
            OnOffTrackMessage: this.isOpportunityPassed ? '' : this.opportunityWarning,
        };

        if (this.isBCASubmitted) {
            this.BCARow = {
                KeyEvent: constants.CONST_BCA_SHORT_NAME,
                RecommendedDate: SUBMITTED_TEXT + this.formatDate(this.BCASubmissionDate),
                PLDate: this.BCASubmissionDate,
                PLDisplayDate: SUBMITTED_TEXT + this.formatDate(this.BCASubmissionDate),
                OnOffTrackMessage: '',
            };
        } else {
            this.BCARow = {
                KeyEvent: constants.CONST_BCA_SHORT_NAME,
                RecommendedDate: this.isBCAPassed ? APPROVED_TEXT + this.formatDate(this.BCAApprovalDate) : this.formatDate(this.BCARecommendedDate),
                PLDate: this.isBCAPassed ? this.BCAApprovalDate : this.targetBCASubmissionDate,
                PLDisplayDate: this.isBCAPassed ? APPROVED_TEXT + this.formatDate(this.BCAApprovalDate) : this.formatDate(this.targetBCASubmissionDate),
                OnOffTrackMessage: this.isBCAPassed ? '' : this.BCAWarning,
            };
        }

        if (!this.isGeoSimple && !this.isGeoComplex) {
            if (this.isBCVSubmitted) {
                this.BCVRow = {
                    KeyEvent: constants.CONST_BCV_SHORT_NAME,
                    RecommendedDate: SUBMITTED_TEXT + this.formatDate(this.BCVSubmissionDate),
                    PLDate: this.BCVSubmissionDate,
                    PLDisplayDate: SUBMITTED_TEXT + this.formatDate(this.BCVSubmissionDate),
                    OnOffTrackMessage: '',
                };
            } else {
                this.BCVRow = {
                    KeyEvent: constants.CONST_BCV_SHORT_NAME,
                    RecommendedDate: this.isBCVPassed ? APPROVED_TEXT + this.formatDate(this.BCVApprovalDate) : this.formatDate(this.BCVRecommendedDate),
                    PLDate: this.isBCVPassed ? this.BCVApprovalDate : this.targetBCVSubmissionDate,
                    PLDisplayDate: this.isBCVPassed ? APPROVED_TEXT + this.formatDate(this.BCVApprovalDate) : this.formatDate(this.targetBCVSubmissionDate),
                    OnOffTrackMessage: this.isBCVPassed ? '' : this.BCVWarning,
                };
            }
        }

        if (this.isSimpleRepack) {
            this.customerMeetingRow = {
                KeyEvent: constants.CONST_CUSTOMER_MEETING_DESCRIPTION,
                RecommendedDate: this.formatDate(this.customerMeetingRecommendedDate),
                PLDate: this.customerPresentationDate,
                PLDisplayDate: this.formatDate(this.customerPresentationDate),
                OnOffTrackMessage: this.isProductionPassed ? '' : this.customerMeetingWarning,
            };
        } else {
            this.customerMeetingRow = {
                KeyEvent: constants.CONST_CUSTOMER_MEETING_DESCRIPTION,
                RecommendedDate: this.formatDate(this.customerMeetingRecommendedDate),
                PLDate: this.customerPresentationDate,
                PLDisplayDate: this.formatDate(this.customerPresentationDate),
                OnOffTrackMessage: this.isCommercialPassed || (!this.isComplexRepack && this.isCommercialSubmitted) ? '' : this.customerMeetingWarning,
            };
        }

        if (this.isComplexRepack) {
            this.commercialRow = {
                KeyEvent: constants.CONST_COMMERCIAL_MILESTONE_DESCRIPTION,
                RecommendedDate: this.isCommercialPassed ? PASSED_TEXT + this.formatDate(this.commercialSubmissionDate) : this.formatDate(this.commercialRecommendedDate),
                PLDate: this.isCommercialPassed ? this.commercialSubmissionDate : this.targetCommercialSubmissionDate,
                PLDisplayDate: this.isCommercialPassed ? PASSED_TEXT + this.formatDate(this.commercialSubmissionDate) : this.formatDate(this.targetCommercialSubmissionDate),
                OnOffTrackMessage: this.isCommercialPassed ? '' : this.commercialWarning,
            };
        } else {
            if (this.isCommercialSubmitted) {
                this.commercialRow = {
                    KeyEvent: constants.CONST_COMMERCIAL_MILESTONE_DESCRIPTION,
                    RecommendedDate: SUBMITTED_TEXT + this.formatDate(this.commercialSubmissionDate),
                    PLDate: this.commercialSubmissionDate,
                    PLDisplayDate: SUBMITTED_TEXT + this.formatDate(this.commercialSubmissionDate),
                    OnOffTrackMessage: '',
                };
            } else {
                this.commercialRow = {
                    KeyEvent: constants.CONST_COMMERCIAL_MILESTONE_DESCRIPTION,
                    RecommendedDate: this.isCommercialPassed ? APPROVED_TEXT + this.formatDate(this.commercialApprovalDate) : this.formatDate(this.commercialRecommendedDate),
                    PLDate: this.isCommercialPassed ? this.commercialApprovalDate : this.targetCommercialSubmissionDate,
                    PLDisplayDate: this.isCommercialPassed ? APPROVED_TEXT + this.formatDate(this.commercialApprovalDate) : this.formatDate(this.targetCommercialSubmissionDate),
                    OnOffTrackMessage: this.isCommercialPassed ? '' : this.commercialWarning,
                };
            }
        }

        this.productionRow = {
            KeyEvent: constants.CONST_PRODUCTION_MILESTONE_DESCRIPTION,
            RecommendedDate: this.isProductionPassed ? PASSED_TEXT + this.formatDate(this.productionSubmissionDate) : this.formatDate(this.productionRecommendedDate),
            PLDate: this.isProductionPassed ? this.productionSubmissionDate : this.targetProductionSubmissionDate,
            PLDisplayDate: this.isProductionPassed ? PASSED_TEXT + this.formatDate(this.productionSubmissionDate) : this.formatDate(this.targetProductionSubmissionDate),
            OnOffTrackMessage: this.isProductionPassed ? '' : this.productionWarning,
        };

        this.shipmentRow = {
            KeyEvent: constants.CONST_SHIPMENT_DESCRIPTION,
            RecommendedDate: this.isShipmentPassed && !this.isEmpty(this.actualShipmentDate) ? SHIPPED_TEXT + this.formatDate(this.actualShipmentDate) : this.formatDate(this.shipmentRecommendedDate),
            PLDate: this.isShipmentPassed && !this.isEmpty(this.actualShipmentDate) ? this.actualShipmentDate : this.targetShipmentDate,
            PLDisplayDate: this.isShipmentPassed && !this.isEmpty(this.actualShipmentDate) ? SHIPPED_TEXT + this.formatDate(this.actualShipmentDate) : this.formatDate(this.targetShipmentDate),
            OnOffTrackMessage: this.isShipmentPassed ? '' : this.shipmentWarning,
        };

        this.onShelfDateRow = {
            KeyEvent: constants.CONST_ON_SHELF_DATE_DESCRIPTION,
            RecommendedDate: this.isOnShelfPassed && !this.isEmpty(this.actualOnShelfDate) ? ON_SHELF_TEXT + this.formatDate(this.actualOnShelfDate) : this.formatDate(this.shelfRecommendedDate),
            PLDate: this.isOnShelfPassed && !this.isEmpty(this.actualOnShelfDate) ? this.actualOnShelfDate : this.targetOnShelfDate,
            PLDisplayDate: this.isOnShelfPassed && !this.isEmpty(this.actualOnShelfDate) ? ON_SHELF_TEXT + this.formatDate(this.actualOnShelfDate) : this.formatDate(this.targetOnShelfDate),
            OnOffTrackMessage: this.isOnShelfPassed ? '' : this.onShelfDateWarning,
        };

        this.PLRRow = {
            KeyEvent: constants.CONST_POST_LAUNCH_REVIEW_DESCRIPTION,
            RecommendedDate: this.isPLRPassed ? COMPLETED_TEXT + this.formatDate(this.actualPLRDate) : this.formatDate(this.PLRRecommendedDate),
            PLDate: this.isPLRPassed ? this.actualPLRDate : this.targetPLRDate,
            PLDisplayDate: this.isPLRPassed ? COMPLETED_TEXT + this.formatDate(this.actualPLRDate) : this.formatDate(this.targetPLRDate),
            OnOffTrackMessage: this.isPLRPassed ? '' : this.PLRWarning,
        };
    }

    setTableData() {
        if (this.isComplexProject) {
            if (this.projectStatus === constants.CONST_COMPLETED_STATUS && !this.isPLRRequired) {
                //PLR is not required
                this.data = [this.opportunityRow, this.BCARow, this.BCVRow, this.customerMeetingRow, this.commercialRow, this.productionRow, this.shipmentRow, this.onShelfDateRow];
            } else {
                this.data = [this.opportunityRow, this.BCARow, this.BCVRow, this.customerMeetingRow, this.commercialRow, this.productionRow, this.shipmentRow, this.onShelfDateRow, this.PLRRow];
            }
        } else if (this.isGeoComplex) {
            if (this.projectStatus === constants.CONST_COMPLETED_STATUS && !this.isPLRRequired) {
                //PLR is not required
                this.data = [this.BCARow, this.customerMeetingRow, this.commercialRow, this.productionRow, this.shipmentRow, this.onShelfDateRow];
            } else {
                this.data = [this.BCARow, this.customerMeetingRow, this.commercialRow, this.productionRow, this.shipmentRow, this.onShelfDateRow, this.PLRRow];
            }
        } else if (this.isGeoSimple) {
            this.data = [this.BCARow, this.customerMeetingRow, this.commercialRow, this.shipmentRow, this.onShelfDateRow];
        } else if (this.isBusinessEnabler) {
            if (this.projectStatus === constants.CONST_COMPLETED_STATUS && !this.isPLRRequired) {
                this.data = [this.BCARow, this.BCVRow, this.customerMeetingRow, this.commercialRow, this.productionRow, this.shipmentRow, this.onShelfDateRow];
            } else {
                this.data = [this.BCARow, this.BCVRow, this.customerMeetingRow, this.commercialRow, this.productionRow, this.shipmentRow, this.onShelfDateRow, this.PLRRow];
            }
        } else if (this.isSimpleRepack) {
            if (this.projectStatus === constants.CONST_COMPLETED_STATUS && !this.isPLRRequired) {
                //PLR is not required
                this.data = [this.opportunityRow, this.BCARow, this.BCVRow, this.customerMeetingRow, this.productionRow, this.shipmentRow, this.onShelfDateRow];
            } else {
                this.data = [this.opportunityRow, this.BCARow, this.BCVRow, this.customerMeetingRow, this.productionRow, this.shipmentRow, this.onShelfDateRow, this.PLRRow];
            }
        }
    }

    calculateDate(date, days, action) {
        // console.log('date initial ' + date)
        let newDate = new Date(date);
        //correct version
        let draftDate = new Date(Date.UTC(newDate.getUTCFullYear(), newDate.getUTCMonth(),
            newDate.getUTCDate(), newDate.getUTCHours(),
            newDate.getUTCMinutes(), newDate.getUTCSeconds()));
        // draftDate.setMinutes(draftDate.getMinutes() - draftDate.getTimezoneOffset());
        // console.log('draftDate 1 ' + draftDate)
        // let newDraftDate = Date.UTC(draftDate.getUTCFullYear(), draftDate.getUTCMonth(),
        //     draftDate.getUTCDate(), draftDate.getUTCHours(),
        //     draftDate.getUTCMinutes(), draftDate.getUTCSeconds())
        // console.log('draftDate 1.1 ' + new Date(newDraftDate))
        if (action === ADD_DAYS) {
            draftDate.setDate(draftDate.getDate() + days);
            // console.log('add ' + days)
        } else if (action === SUBTRACT_DAYS) {
            draftDate.setDate(draftDate.getDate() - days);
            // console.log('minus ' + days)
        }
        console.log('draftDate 2 ' + draftDate)
        return draftDate;
    }

    formatDate(date) {
        let result;
        if (!this.isEmpty(date)) {
            let draftDate = new Date(date);
            result = (draftDate.getMonth() + 1) + "/" + draftDate.getDate() + "/" + draftDate.getFullYear();
        }
        return result;
    }

    onCellChange(event) {
        const draftValueMap = event.detail.draftValues[0];
        const draftPLDate = !this.isEmpty(draftValueMap[PRIMO_DATE_FIELD_NAME]) ? draftValueMap[PRIMO_DATE_FIELD_NAME] : null;
        const row = draftValueMap.id.split('-')[1]; //find the row
        this.data[row][PRIMO_DATE_FIELD_NAME] = draftPLDate; //set new value to edit
        this.data[row][PRIMO_DISPLAY_DATE_FIELD_NAME] = this.formatDate(draftPLDate); //set new value to display in the table
        const keyEventName = this.data[row].KeyEvent; // Key Event name

        // assigning of values to pass to the flow
        if (keyEventName === constants.CONST_OPPORTUNITY_MILESTONE_DESCRIPTION) {
            this.targetOpportunitySubmissionDate = draftPLDate;
        } else if (keyEventName === constants.CONST_BCA_SHORT_NAME) {
            this.targetBCASubmissionDate = draftPLDate;
        } else if (keyEventName === constants.CONST_BCV_SHORT_NAME) {
            this.targetBCVSubmissionDate = draftPLDate;
        } else if (keyEventName === constants.CONST_COMMERCIAL_MILESTONE_DESCRIPTION) {
            console.log('1 this.targetCommercialSubmissionDate ' + this.targetCommercialSubmissionDate)
            this.targetCommercialSubmissionDate = draftPLDate;
            console.log('2 this.targetCommercialSubmissionDate ' + this.targetCommercialSubmissionDate)
        } else if (keyEventName === constants.CONST_PRODUCTION_MILESTONE_DESCRIPTION) {
            this.targetProductionSubmissionDate = draftPLDate;
        } else if (keyEventName === constants.CONST_POST_LAUNCH_REVIEW_DESCRIPTION) {
            this.targetPLRDate = draftPLDate;
        }

        this.resetWarningMessage(keyEventName, row);
    }

    resetWarningMessage(keyEventName, row) {
        this.setWarningMessages();

        if (keyEventName === constants.CONST_OPPORTUNITY_MILESTONE_DESCRIPTION) {
            this.data[row][ON_OFF_TRACK_FIELD_NAME] = this.opportunityWarning;
        } else if (keyEventName === constants.CONST_BCA_SHORT_NAME) {
            this.data[row][ON_OFF_TRACK_FIELD_NAME] = this.BCAWarning;
            if (this.isGeoSimple || this.isGeoComplex) { //todo check with Geo Complex
                this.data[parseInt(row, 10) + 1][ON_OFF_TRACK_FIELD_NAME] = this.customerMeetingWarning;
            }
        } else if (keyEventName === constants.CONST_BCV_SHORT_NAME) {
            this.data[row][ON_OFF_TRACK_FIELD_NAME] = this.BCVWarning;
            this.data[parseInt(row, 10) + 1][ON_OFF_TRACK_FIELD_NAME] = this.customerMeetingWarning;
        } else if (keyEventName === constants.CONST_COMMERCIAL_MILESTONE_DESCRIPTION) {
            this.data[row][ON_OFF_TRACK_FIELD_NAME] = this.commercialWarning;
        } else if (keyEventName === constants.CONST_PRODUCTION_MILESTONE_DESCRIPTION) {
            this.data[row][ON_OFF_TRACK_FIELD_NAME] = this.productionWarning;
        } else if (keyEventName === constants.CONST_POST_LAUNCH_REVIEW_DESCRIPTION) {
            this.data[row][ON_OFF_TRACK_FIELD_NAME] = this.PLRWarning;
        }
    }
}