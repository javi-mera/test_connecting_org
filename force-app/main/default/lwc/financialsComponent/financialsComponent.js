/* eslint-disable guard-for-in */
/* eslint-disable @lwc/lwc/no-api-reassignments */
import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getInvertedFinancialData from '@salesforce/apex/FinancialDataController.getInvertedFinancialData';
import getInvertedSnapshotFinancialData from '@salesforce/apex/FinancialDataController.getInvertedSnapshotFinancialData';
import updateFinancialData from '@salesforce/apex/FinancialDataController.updateFinancialData';
import getProjectInformation from '@salesforce/apex/ProjectRepository.getProject';
import getSnapshotInformation from '@salesforce/apex/ProjectSnapshotRepository.getProjectSnapshotInformation';
import { loadStyle } from 'lightning/platformResourceLoader';
import FINANCIAL_DATA_TABLE_STYLESHEET from '@salesforce/resourceUrl/FinancialDataTable';
import { constants } from 'c/utils';
import { publish, MessageContext } from 'lightning/messageService';
import FINANCIALS_UPDATED_CHANNEL from '@salesforce/messageChannel/financialsMessageChannel__c';

const MIN_NUMBER_ALLOWED = 0;
const MAX_NUMBER_ALLOWED = 999999999;
const CI_PROJECT = "CI";
const MANDATORY_PROJECT = "Mandatory";
const COGS_DECREASE_LABEL = "*COGS Decrease vs. Current";
const COGS_NO_CHANGE_LABEL = "*COGS No Change vs. Current";
const COGS_INCREASE_LABEL = "*COGS Increase vs. Current";
const ERROR_MESSAGE = "Value you want to update is out of bounds. [Minimum: 0, Maximum: 999,999,999]";
const POSITIVE_VALUE_ERROR_MESSAGE = "Value you want to update must be negative";
const PERCENTAGE_ERROR_MESSAGE = "Value you want to update is out of bounds. [Minimum: 0, Maximum: 99.9]";
const PROMOTIONAL_PACK = 'Promotional Pack';
const WRITE_OFF_LABEL_PROMO_PACK = '*One Off Write Off Costs ($)';
const TOTAL_NSV_LABEL_PROMO_PACK = '*Total NSV ($)';
const COGS_LABEL_PROMO_PACK = '*COGs (including MOQ Write Off Costs) ($)';
const AP_LABEL_PROMO_PACK = '*A&P ($)';
const GM_LABEL_PROMO_PACK = '*GM%';
const STRUCTURE_COSTS_LABEL_PROMO_PACK = '*Structure Costs ($)';
const TOTAL_COSTS_LABEL_PROMO_PACK = '*Total Investment ($)';
const INCREMENTAL_DBC_LABEL_PROMO_PACK = '*Incremental DBC';
const RETURN_ON_INVESTMENT_LABEL_PROMO_PACK = 'Return on Investment (Incremental DBC ($) / - Total Investment ($) - 1)';
const Y1_LABEL = 'Year 1 (first full 12 months)';
const Y2_LABEL = 'Y2';
const Y3_LABEL = 'Y3';
const Y4_LABEL = 'Y4';
const Y5_LABEL = 'Y5';
const FIELD_NAME_LABEL = 'fieldName';
const YEAR_ONE_BCA_LABEL = 'Year 1 (first full 12 months) (BCA)';
const YEAR_ONE_BCV_LABEL = 'Year 1 (first full 12 months) (BCV)';
const YEAR_ONE_PRODUCTION_LABEL = 'Year 1 (first full 12 months) (Production M/S)';

const LABEL_TO_FIELD = {
    "*Actual Fiscal Year": "ActualFY__c",
    [constants.VOLUME_9L_CASES]: "Volume__c",
    "*Volume (9L case)": "Volume__c",
    "*Total NSV (K USD)": "TotalNSV__c",
    "*NSV (9L Case)": "NSV__c",
    [constants.NSV]: "NSV__c",
    "*Total COGS (K USD)": "TotalCOGs__c",
    "*Total GP (K USD)": "TotalGP__c",
    [constants.GROSS_PROFIT]: "TotalGP__c",
    [constants.AP]: "AP__c",
    "*RSP (RC per bottle)": "RSP__c",
    [constants.NSV_AMBITION]: "NSVAmbition__c"
}

const LABEL_TO_FIELD_CI = {
    "*Volume (9L case)": "Volume__c",
    "NSV Change (if any) ($/9L CS)": "NSV__c",
    "*COGS Decrease vs. Current": "COGSDecreaseCurrent__c",
    "*COGS Impact ($/9L CS) *COGS Increase vs. Current": "COGSIncreaseCurrent__c",
    "*COGS No Change vs. Current": "COGSNoChangeCurrent__c",
    "*Total COGS impact (1 year) (K USD)": "TotalCOGs__c",
    "*Total CAPEX (K USD)": "TotalCAPEX__c",
    "*Total Tooling (K USD)": "TotalTooling__c",
    "*Total Write-Offs (K USD)": "TotalWriteOffs__c",
    "*Total Other One-off costs (K USD)": "TotalOtherOneOffCosts__c",
    "*Total working Capital Impact (K USD)": "TotalWorkingCapitalImpact__c",
    "*Payback Time (Years)": "PaybackTime__c"
}

const LABEL_TO_FIELD_MANDATORY = {
    "*Volume (9L case)": "Volume__c",
    "NSV Change (if any) ($/9L CS)": "NSV__c",
    "*COGS Decrease vs. Current": "COGSDecreaseCurrent__c",
    "*COGS Impact ($/9L CS) *COGS Increase vs. Current": "COGSIncreaseCurrent__c",
    "*COGS No Change vs. Current": "COGSNoChangeCurrent__c",
    "*Total COGS impact (1 year) (K USD)": "TotalCOGs__c",
    "*Total CAPEX (K USD)": "TotalCAPEX__c",
    "*Total Tooling (K USD)": "TotalTooling__c",
    "*Total Write-Offs (K USD)": "TotalWriteOffs__c",
    "*Total Other One-off costs (K USD)": "TotalOtherOneOffCosts__c"
}

//Field Name to Row number for Promotional Pack Financials
const TOTAL_NSV_ROW_NUMBER = 2;
const COGS_ROW_NUMBER = 4;
const AP_ROW_NUMBER = 5;
const NET_PROFIT_ROW_NUMBER = 6;
const STRUCTURE_COSTS_ROW_NUMBER = 8;
const TOTAL_INVESTMENT_ROW_NUMBER = 9;
const INCREMENTAL_DBC_ROW_NUMBER = 10;
const RETURN_ON_INVESTMENT_ROW_NUMBER = 11;

const LABEL_TO_FIELD_PROMOTIONAL_PACK = {
    "*Volume (9L cases)": "Volume__c",
    "*One Off Write Off Costs ($)": "TotalWriteOffs__c",
    "*Total NSV ($)": "TotalNSV__c",
    "*Incremental NSV ($)": "IncrementalNSV__c",
    "*COGs (including MOQ Write Off Costs) ($)": "TotalCOGs__c",
    "*A&P ($)": "AP__c",
    "Net Profit ($) (Total NSV - COGs – A&P – Structure Costs)": "TotalNP__c",
    "*GM%": "GM__c",
    "*Structure Costs ($)": "StructuralCosts__c",
    [TOTAL_COSTS_LABEL_PROMO_PACK]: "TotalCosts__c",
    [INCREMENTAL_DBC_LABEL_PROMO_PACK]: "IncrementalDBC__c",
    [RETURN_ON_INVESTMENT_LABEL_PROMO_PACK]: "ReturnOnInvestment__c"
}

const FIVE_YEAR_TABLE_INDEX_TO_FIELD = {
    0: "Volume",
    1: "NSV",
    2: "Gross Profit",
    3: "A&P"
}

const TWO_YEAR_TABLE_INDEX_TO_FIELD = {
    0: "NSV Ambition"
}

const PROJECT_CLASSIFICATION_TO_NSV_THRESHOLD = {
    'Fearless Bet': 1_000_000,
    'Brand Energizer': 3_000_000,
    'Business Enabler': 3_000_000,
    'Geographical Extension - Simple': 500_000,
    'Geographical Extension': 2_000_000,
    'Promotional Pack': 500_000
};

const FINANCIALS_AND_DELIVERABLES_CLASSIFICATIONS = [
    constants.CONST_FEARLESS_BET_NAME,
    constants.CONST_BRAND_ENERGIZER_NAME,
    constants.CONST_BUSINESS_ENABLER_NAME,
    constants.CONST_GEO_EXTENSION_NAME
];

export default class FinancialsComponent extends LightningElement {
    @api recordId;
    @api phase;
    @api objectApiName;
    @api justificationForFinancialThresholdNotMet;
    @api financialThresholdNotMet = false;
    @api projectDevelopmentCostsToDate;
    @api complexity;
    @api isAdmin;
    @api leadRegion;
    @api additionalRegions;
    @api isFromProjectRecordPage;
    @api isFromProjectSnapshotRecordPage;
    @api geoSubtype;
    @track data = [];
    @track columns = [];
    isCssLoaded = false
    financials = [];
    size = 0;
    projectType = '';
    additionalRows = [];
    _isReadOnly = false;
    financialsNsv;

    @wire(MessageContext)
    messageContext;
    connectedCallback() {
        if (this.objectApiName === 'Project_Snapshot__c') {
            getInvertedSnapshotFinancialData({ projectSnapshotId: this.recordId }).then((response) => {
                this.setFinancialData(response, false);
            }).catch((error) => {
                console.error(error);
            })
        } else {
            getInvertedFinancialData({ projectId: this.recordId }).then((response) => {
                this.setFinancialData(response, this.objectApiName === undefined);
            }).catch((error) => {
                console.error(error);
            })
        }

        if (this.isFromProjectRecordPage) {
            getProjectInformation({ projectId: this.recordId }).then((response) => {
                if (response) {
                    this.leadRegion = response.Region__c;
                    this.additionalRegions = response.AddAdditionalRegionOrRegions__c;
                    this.geoSubtype = response.GeoExtensionProjectSubClassification__c;
                }
            }).catch((error) => {
                console.error(error);
            })
        } else if (this.isFromProjectSnapshotRecordPage) {
            getSnapshotInformation({ snapshotId: this.recordId }).then((snapshotResponse) => {
                if (snapshotResponse) {
                    this.leadRegion = snapshotResponse[0].Region__c;
                    this.additionalRegions = snapshotResponse[0].AddAdditionalRegionOrRegions__c;
                    this.geoSubtype = snapshotResponse[0].GeoExtensionProjectSubClassification__c;
                }
            }).catch((error) => {
                console.error(error);
            })
        }
    }

    setFinancialData(response, editable) {
        const lastResponseIndex = response.length - 1;
        const penultimateResponseIndex = response.length - 2;
        this.phase = response[lastResponseIndex].phase;
        this.complexity = response[lastResponseIndex].complexity;
        try {
            this.projectType = response[lastResponseIndex].projectType;
            this.columns = [];
            if (this.projectType === CI_PROJECT || this.projectType === MANDATORY_PROJECT) {
                this.columns.push({ label: '', fieldName: 'fieldLabel', editable: false, hideLabel: true, hideDefaultActions: true });
                this.columns.push({ label: '', fieldName: FIELD_NAME_LABEL, editable: false, hideLabel: true, hideDefaultActions: true });
            } else if (this.projectType === PROMOTIONAL_PACK) {
                this.columns.push({ label: '', fieldName: FIELD_NAME_LABEL, editable: false, wrapText: true, cellAttributes: { class: { fieldName: 'styleClass' } } });
            } else {
                this.columns.push({ label: '', fieldName: FIELD_NAME_LABEL, editable: false, wrapText: true, hideDefaultActions: true });
            }
            this.size = response[lastResponseIndex].size;
            this.justificationForFinancialThresholdNotMet = response[lastResponseIndex].financialThresholdNotMetComment;
            if (this.size === 0) {
                this.data = []
            }
                if (this.projectType !== PROMOTIONAL_PACK) {
                    if (this.size === 1) {
                        this.columns.push(...[
                            { label: Y1_LABEL, fieldName: 'fieldValue2', editable, type: 'number', hideDefaultActions: true}
                        ]);
                        this.financials = [{
                            Id: response[penultimateResponseIndex].fieldValue2
                        }];
                    } else if (this.size === 2) {
                        this.columns.push(...[
                            { label: Y1_LABEL, fieldName: 'fieldValue2', editable, type: 'number', hideDefaultActions: true },
                            { label: Y5_LABEL, fieldName: 'fieldValue3', editable, type: 'number', hideDefaultActions: true },
                        ]);
                        this.financials = [{
                            Id: response[penultimateResponseIndex].fieldValue2,
                            NSVAmbition__c: response[0].fieldValue2 !== undefined ? response[0].fieldValue2 : null
                        },{
                            Id: response[penultimateResponseIndex].fieldValue3,
                            NSVAmbition__c: response[0].fieldValue3 !== undefined ? response[0].fieldValue3 : null
                        }];
                        this.checkNSV();
                    } else if (this.size === 5) {
                        this.columns.push(...[
                            { label: Y1_LABEL, fieldName: 'fieldValue2', editable, type: 'number', hideDefaultActions: true },
                            { label: Y2_LABEL, fieldName: 'fieldValue3', editable, type: 'number', hideDefaultActions: true },
                            { label: Y3_LABEL, fieldName: 'fieldValue4', editable, type: 'number', hideDefaultActions: true },
                            { label: Y4_LABEL, fieldName: 'fieldValue5', editable, type: 'number', hideDefaultActions: true },
                            { label: Y5_LABEL, fieldName: 'fieldValue6', editable, type: 'number', hideDefaultActions: true },
                        ]);
                        this.financials = [{
                            Id: response[penultimateResponseIndex].fieldValue2,
                            NSV__c: response[1].fieldValue2 !== undefined ? response[1].fieldValue2 : null
                        },{
                            Id: response[penultimateResponseIndex].fieldValue3,
                            NSV__c: response[1].fieldValue3 !== undefined ? response[1].fieldValue3 : null
                        },{
                            Id: response[penultimateResponseIndex].fieldValue4,
                            NSV__c: response[1].fieldValue4 !== undefined ? response[1].fieldValue4 : null
                        },{
                            Id: response[penultimateResponseIndex].fieldValue5,
                            NSV__c: response[1].fieldValue5 !== undefined ? response[1].fieldValue5 : null
                        },{
                            Id: response[penultimateResponseIndex].fieldValue6,
                            NSV__c: response[1].fieldValue6 !== undefined ? response[1].fieldValue6 : null
                        }];
                        this.checkNSV();
                    }
                } else {
                    if (this.size === 1) {
                        this.columns.push(...[
                            { label: YEAR_ONE_BCA_LABEL, fieldName: 'fieldValue2', editable, type: 'number', cellAttributes: { class: { fieldName: 'styleClass' } } }
                        ]);
                        this.financials = [{
                            Id: response[penultimateResponseIndex].fieldValue2
                        }];
                    } else if (this.size === 2 && this.complexity === 'Low') {
                        this.columns.push(...[
                            { label: YEAR_ONE_BCA_LABEL, fieldName: 'fieldValue2', editable: false, type: 'number', cellAttributes: { class: { fieldName: 'styleClass' } } },
                            { label: YEAR_ONE_PRODUCTION_LABEL, fieldName: 'fieldValue3', editable, type: 'number', cellAttributes: { class: { fieldName: 'lastStyleClass' } } },
                        ]);
                        if (this.isAdmin) {
                            this.columns[1].editable = true;
                        }
                        if (this.phase === 6 && !this.isAdmin) {
                            this.columns[2].editable = false;
                            this._isReadOnly = true;
                        }
                        this.financials = [{
                            Id: response[penultimateResponseIndex].fieldValue2,
                        },{
                            Id: response[penultimateResponseIndex].fieldValue3,
                        }];
                        this.checkNSV();
                    } else if (this.size === 2 && this.complexity === 'Medium') {
                        this.columns.push(...[
                            { label: YEAR_ONE_BCA_LABEL, fieldName: 'fieldValue2', editable: false, type: 'number', cellAttributes: { class: { fieldName: 'styleClass' } } },
                            { label: YEAR_ONE_BCV_LABEL, fieldName: 'fieldValue3', editable, type: 'number', cellAttributes: { class: { fieldName: 'lastStyleClass' } } },
                        ]);
                        if (this.isAdmin) {
                            this.columns[1].editable = true;
                        }
                        this.financials = [{
                            Id: response[penultimateResponseIndex].fieldValue2,
                        },{
                            Id: response[penultimateResponseIndex].fieldValue3,
                        }];
                        this.checkNSV();
                    } else if (this.size === 3) {
                        this.columns.push(...[
                            { label: YEAR_ONE_BCA_LABEL, fieldName: 'fieldValue2', editable: false, type: 'number', cellAttributes: { class: { fieldName: 'styleClass' } } },
                            { label: YEAR_ONE_BCV_LABEL, fieldName: 'fieldValue3', editable: false, type: 'number', cellAttributes: { class: { fieldName: 'styleClass' } } },
                            { label: YEAR_ONE_PRODUCTION_LABEL, fieldName: 'fieldValue4', editable, type: 'number', initialWidth: 215, cellAttributes: { class: { fieldName: 'lastStyleClass' } }},
                        ]);
                        if (this.isAdmin) {
                            this.columns[1].editable = true;
                            this.columns[2].editable = true;
                        }
                        if (this.phase === 6 && !this.isAdmin) {
                            this.columns[3].editable = false;
                            this._isReadOnly = true;
                        }
                        this.financials = [{
                            Id: response[penultimateResponseIndex].fieldValue2,
                        },{
                            Id: response[penultimateResponseIndex].fieldValue3,
                        },{
                            Id: response[penultimateResponseIndex].fieldValue4,
                        }];
                        this.checkNSV();
                    }
                    response.map(record => {
                        if (response.indexOf(record) !== lastResponseIndex) {
                        const label = record.fieldName;
                            const isPercentage = label.includes(`GM%`);
                            record.styleClass = isPercentage ? 'percentage' : '';
                            record.lastStyleClass = isPercentage ? 'percentage' : '';
                        }
                        return record;
                    });
                }

                this.additionalRows.push(response[lastResponseIndex]);
                this.additionalRows.push(response[penultimateResponseIndex]);
                response.pop();
                response.pop();
                this.data = response;
        } catch(error) {
            console.error(error);
        }
    }

    renderedCallback(){ 
        if (this.isCssLoaded) return
        this.isCssLoaded = true
        loadStyle(this, FINANCIAL_DATA_TABLE_STYLESHEET).then(() => {
            console.log('Loaded Successfully')
        }).catch(error => { 
            console.error('Error in loading the colors:', error)
        })
    }

    isFinancialEmpty(value) {
        return value === 0 || value === null || value === '' || value === undefined;
    }

    calculateDeliverablesGrossProfit(volume, grossProfit) {
        return grossProfit / volume;
    }

    onCellChangeHandle(event) {
        const draftValue = event.detail.draftValues[0];
        const fieldKey = Object.keys(draftValue)[0];
        const row = draftValue.id.split('-')[1];
        const lastValue = Number(this.data[row][fieldKey]);
        const newValue = draftValue.fieldValue2 == '' || draftValue.fieldValue3 == '' ||
        draftValue.fieldValue4 == '' || draftValue.fieldValue5 == '' || draftValue.fieldValue6 == '' ? null : Number(draftValue[fieldKey]);
        this.data[row][fieldKey] = newValue;

        // console.log('row ' + row);
        // console.log('fieldKey ' + fieldKey);

        //for NSV Y1 change
        if (row === '1' && fieldKey === 'fieldValue2' && this.phase !== 1) {
            this.financialsNsv = draftValue.fieldValue2;
            this.template.querySelector("c-nsv-by-region-table").handleNSVChange(this.financialsNsv, false);
        }
        
        //for deliverables formula
        if (FINANCIALS_AND_DELIVERABLES_CLASSIFICATIONS.includes(this.projectType) && this.phase !== 1) {
            let volumeValue = 0;
            let grossProfitValue = 0;
            let deliverablesGrossProfit = 0;
            let fieldLabel;

            if (row === '0') {
                if (fieldKey === 'fieldValue2') { //Y1 Volume
                    fieldLabel = 'Y1GP';
                    volumeValue = Number(draftValue.fieldValue2);
                    grossProfitValue = this.data[2]['fieldValue2'];
                } else if (fieldKey === 'fieldValue3') { //Y2 Volume
                    fieldLabel = 'Y2GP';
                    volumeValue = Number(draftValue.fieldValue3);
                    grossProfitValue = this.data[2]['fieldValue3'];
                }
            } else if (row === '2') {
                if (fieldKey === 'fieldValue2') { //Y1 GP
                    fieldLabel = 'Y1GP';
                    grossProfitValue = Number(draftValue.fieldValue2);
                    volumeValue = this.data[0]['fieldValue2'];
                } else if (fieldKey === 'fieldValue3') { //Y2 GP
                    fieldLabel = 'Y2GP';
                    grossProfitValue = Number(draftValue.fieldValue3);
                    volumeValue = this.data[0]['fieldValue3'];
                }
            }

            if (this.isFinancialEmpty(volumeValue) || this.isFinancialEmpty(grossProfitValue)) {
                deliverablesGrossProfit = 0;
            } else {
                deliverablesGrossProfit = this.calculateDeliverablesGrossProfit(volumeValue, grossProfitValue);
            }

            if ((row === '0' || row === '2') && (fieldKey === 'fieldValue2' || fieldKey === 'fieldValue3')) {
                const payload = {
                    isCopyPaste: false,
                    label: fieldLabel,
                    value: deliverablesGrossProfit
                };
                publish(this.messageContext, FINANCIALS_UPDATED_CHANNEL, payload);
            }
        }

        if (this.projectType === PROMOTIONAL_PACK && (newValue > 0 || newValue < -MAX_NUMBER_ALLOWED) && (this.data[row].fieldName === WRITE_OFF_LABEL_PROMO_PACK || this.data[row].fieldName === COGS_LABEL_PROMO_PACK || this.data[row].fieldName === AP_LABEL_PROMO_PACK || this.data[row].fieldName === STRUCTURE_COSTS_LABEL_PROMO_PACK)) {
            this.template.querySelector("lightning-datatable").draftValues = [];
            this.data[row][fieldKey] = lastValue;
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: POSITIVE_VALUE_ERROR_MESSAGE,
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
        }

        if (this.projectType === CI_PROJECT || this.projectType === MANDATORY_PROJECT) {
            let rowsToChange = [];
            for (let [index, element] of this.data.entries()) {
                if (element.fieldName === COGS_DECREASE_LABEL ||
                    element.fieldName === COGS_NO_CHANGE_LABEL ||
                    element.fieldName === COGS_INCREASE_LABEL) {
                    rowsToChange.push(index);
                }
            }
            if (rowsToChange.includes(Number(row))) {
                this.data.push(this.additionalRows[1]);
                this.data.push(this.additionalRows[0]);
                rowsToChange = rowsToChange.filter((item) => item !== Number(row));
                for (const rowToChange of rowsToChange) {
                    this.data[rowToChange][fieldKey] = 0;
                }
                this.setFinancialData(JSON.parse(JSON.stringify(this.data)), true);
            }
        } else if (this.projectType === PROMOTIONAL_PACK) {
            const rowsToChange = [];
            for (const [index, element] of this.data.entries()) {
                if ([WRITE_OFF_LABEL_PROMO_PACK, TOTAL_NSV_LABEL_PROMO_PACK, COGS_LABEL_PROMO_PACK, AP_LABEL_PROMO_PACK, STRUCTURE_COSTS_LABEL_PROMO_PACK, INCREMENTAL_DBC_LABEL_PROMO_PACK, TOTAL_COSTS_LABEL_PROMO_PACK].includes(element.fieldName)) {
                    rowsToChange.push(index);
                }
            }
            if (rowsToChange.includes(Number(row))) {
                this.data = this.promoPackCalculation(this.data, fieldKey);
            }
        }
        if (((newValue < MIN_NUMBER_ALLOWED || newValue > MAX_NUMBER_ALLOWED) && this.data[row].fieldName !== GM_LABEL_PROMO_PACK && this.projectType !== PROMOTIONAL_PACK) || ((newValue < MIN_NUMBER_ALLOWED || newValue > 99.9) && this.data[row].fieldName === GM_LABEL_PROMO_PACK)) {
            this.template.querySelector("lightning-datatable").draftValues = [];
            this.data[row][fieldKey] = lastValue;
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: this.data[row].fieldName === GM_LABEL_PROMO_PACK ? PERCENTAGE_ERROR_MESSAGE : ERROR_MESSAGE,
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
        } else {
            if (this.projectType === PROMOTIONAL_PACK) {
                this.setColorForRows(fieldKey);
            }
            this.updateFinancials();
        }
    }

    promoPackCalculation(financialsData, fieldKey) {
        // Net Profit = Total NSV + COGs + A&P + Structure Costs
        this.data[NET_PROFIT_ROW_NUMBER][fieldKey] = this.data[TOTAL_NSV_ROW_NUMBER][fieldKey] + this.data[COGS_ROW_NUMBER][fieldKey] + this.data[AP_ROW_NUMBER][fieldKey] + this.data[STRUCTURE_COSTS_ROW_NUMBER][fieldKey];
        // Return on Investment = Net Profit / Total Costs
        this.data[RETURN_ON_INVESTMENT_ROW_NUMBER][fieldKey] = (this.data[INCREMENTAL_DBC_ROW_NUMBER][fieldKey] / -this.data[TOTAL_INVESTMENT_ROW_NUMBER][fieldKey]) - 1;
        return financialsData;
    }

    setColorForRows(fieldKey) {
        this.recalculateColorForRow(this.data[2], this.data[2][fieldKey], fieldKey, 'percentage', TOTAL_NSV_LABEL_PROMO_PACK);
        this.recalculateColorForRow(this.data[9], this.data[9][fieldKey], fieldKey, 'percentage', TOTAL_COSTS_LABEL_PROMO_PACK);
        this.recalculateColorForRow(this.data[11], this.data[11][fieldKey], fieldKey, 'above zero', RETURN_ON_INVESTMENT_LABEL_PROMO_PACK);
    }
    recalculateColorForRow(rowData, newValue, fieldKey, type, fieldName) {
        let isValueWithinTolerance = true;
        if (typeof fieldKey === 'string' && fieldKey !== 'fieldValue2' && type === 'percentage') {
            if (fieldName === TOTAL_NSV_LABEL_PROMO_PACK && rowData.fieldValue2 !== undefined) {
                isValueWithinTolerance = (newValue > (rowData.fieldValue2 * 0.8) && (newValue < (rowData.fieldValue2 * 1.2)));
            } else if (fieldName === TOTAL_COSTS_LABEL_PROMO_PACK && rowData.fieldValue2 !== undefined) {
                isValueWithinTolerance = (newValue < (rowData.fieldValue2 * 0.8) && (newValue > (rowData.fieldValue2 * 1.2)));
            }
        } else if (((typeof fieldKey === 'string' && (fieldKey === 'fieldValue3' || fieldKey === 'fieldValue4')) && type === 'above zero') && rowData.fieldValue2 !== undefined) {
            const newValueRounded = Math.round(newValue * 1e3) / 1e3;
            isValueWithinTolerance = (newValue > 0) && (newValueRounded < rowData.fieldValue2 || newValueRounded === rowData.fieldValue2);
        }
        rowData.isWithinTolerance = isValueWithinTolerance;
        rowData.lastStyleClass = isValueWithinTolerance ? 'slds-text-color_success' : 'slds-text-color_error';
    }


    updateFinancials() {
        const mappedData = this.data.map((value) => {
            const remappedData = {};
            for (let i = 0; i < this.financials.length; i++) {
                const financialValue = value[`fieldValue` + (i + 2)];
                let keyValue = '';
                if (value.fieldLabel !== undefined && value.fieldLabel !== '') {
                    keyValue += `${value.fieldLabel} `;
                }
                keyValue += `${value.fieldName}|${i}`;
                remappedData[keyValue] = financialValue;
            }
            return remappedData;
        });
        if (this.size === 1) {
            if (this.projectType === 'CI') {
                for (const mappedDataRow of mappedData) {
                    for (const mappedDataCol of Object.keys(mappedDataRow)) {
                        const splittedCol = mappedDataCol.split('|');
                        this.financials[splittedCol[1]][LABEL_TO_FIELD_CI[splittedCol[0]]] = mappedDataRow[mappedDataCol]; 
                    }
                }
            } else if (this.projectType !== PROMOTIONAL_PACK) {
                for (const mappedDataRow of mappedData) {
                    for (const mappedDataCol of Object.keys(mappedDataRow)) {
                        const splittedCol = mappedDataCol.split('|');
                        this.financials[splittedCol[1]][LABEL_TO_FIELD_MANDATORY[splittedCol[0]]] = mappedDataRow[mappedDataCol]; 
                    }
                }
            }
        } else if (this.projectType !== PROMOTIONAL_PACK) {
            for (const mappedDataRow of mappedData) {
                for (const mappedDataCol of Object.keys(mappedDataRow)) {
                    const splittedCol = mappedDataCol.split('|');
                    this.financials[splittedCol[1]][LABEL_TO_FIELD[splittedCol[0]]] = mappedDataRow[mappedDataCol]; 
                }
            }
        } 
        if (this.projectType === PROMOTIONAL_PACK) {
            for (const mappedDataRow of mappedData) {
                for (const mappedDataCol of Object.keys(mappedDataRow)) {
                    const splittedCol = mappedDataCol.split('|');
                    this.financials[splittedCol[1]][LABEL_TO_FIELD_PROMOTIONAL_PACK[splittedCol[0]]] = mappedDataRow[mappedDataCol]; 
                }
            }
        }
        if (this.checkFinancialLimits(this.financials)) {
            this.checkNSV();
            const projectClassification = this.projectType === 'CI' ? 'Continuous Improvement' : this.projectType;
            const project = {
                Id: this.recordId,
                ProjectClassification__c: projectClassification
            };
            if (this.projectType === PROMOTIONAL_PACK) {
                project.NSVThresholdMet__c = !!this.data[2].isWithinTolerance;
                project.ReturnOnInvestmentThresholdMet__c = !!this.data[11].isWithinTolerance;
                project.TotalCostsThresholdMet__c = !!this.data[9].isWithinTolerance;
                project.Complexity__c = this.complexity;
            }
            updateFinancialData({ financials: this.financials, phase: this.phase, project, type: 'Financials' })
            .catch((error) => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error',
                    message: JSON.stringify(error.body),
                    variant: 'error'
                }));
                console.error(error);
            })
        }
    }

    checkNSV() {
        if (this.phase === 1) {
            const nsvAmbition = this.financials[0].NSVAmbition__c;
            if (nsvAmbition !== null && (PROJECT_CLASSIFICATION_TO_NSV_THRESHOLD[this.projectType] / 1000) > nsvAmbition) {
                this.financialThresholdNotMet = true;
            } else {
                this.financialThresholdNotMet = false;
            }
        } else {
            const nsv = this.financials[0].NSV__c;
            if (nsv !== null && (PROJECT_CLASSIFICATION_TO_NSV_THRESHOLD[this.projectType] / 1000) > nsv) {
                this.financialThresholdNotMet = true;
            } else {
                this.financialThresholdNotMet = false;
            }
        }
    }

    pasteData() {
        navigator.clipboard.readText().then((response) => {
            if (response == null || response === '') {
                return
            }
            const splittedLines = response.split('\r\n').filter((line) => line.split('\t').join('') !== '');
            const hasY1 = response.includes(Y1_LABEL);
            const newSplittedLines = [];
            for (const splittedLine of splittedLines) {
                const resplittedLine = splittedLine.split('\t').filter((line) => line !== '');
                newSplittedLines.push(resplittedLine);
            }
            if (this.projectType !== PROMOTIONAL_PACK) {
                const type = newSplittedLines[0].includes('Year 1') ? 'With Headers' : 'Without Headers';
                const clipboardMetadata = this.clipboardMetadata(newSplittedLines);
                const fields = clipboardMetadata.subType === 'FIVE_YEAR' ? FIVE_YEAR_TABLE_INDEX_TO_FIELD : TWO_YEAR_TABLE_INDEX_TO_FIELD;
                const financialData = {};
                if (type === 'With Headers') {
                    for (let i = 0; i < newSplittedLines.length; i++) {
                        if (i === 0) {
                            continue;
                        }
                        let currentField = '';
                        currentField = FIVE_YEAR_TABLE_INDEX_TO_FIELD[i - 1];
                        for (let j = 0; j < newSplittedLines[i].length - 2; j++) {
                            const year = newSplittedLines[0][j].split(' ')[1];
                            this.fillFinancialData(financialData, year, newSplittedLines, currentField, i, j);
                        }
                    }
                } else if (type === 'Without Headers') {
                    for (let i = 0; i < newSplittedLines.length; i++) {
                        let currentField = fields[i];
                        for (let j = 0; j < newSplittedLines[i].length; j++) {
                            const year = j + 1;
                            this.fillFinancialData(financialData, year, newSplittedLines, currentField, i, j);
                        }
                    }
                }

                const financials = [];
                for (const dataItem of this.data) {
                    financials.push(dataItem);
                }
                const financialDataKeys = Object.keys(financialData);
                for (const financial of financials) {
                    let fieldName = financial.fieldName.split('(')[0];
                    fieldName = fieldName.trimEnd();
                    fieldName = fieldName.replace('*', '');
                    for (let j = 2; j < financialDataKeys.length + 2; j++) {
                        const currentKey = financialDataKeys[j - 2];
                        financial[`fieldValue${j}`] = parseInt(financialData[currentKey][fieldName], 10);
                    }
                }
                const validData = this.checkFinancialLimits(financials);
                if (validData) {
                    this.data = financials;
                    this.updateFinancials();
                }
            } else {
                let financials = [];
                for (const dataItem of this.data) {
                    financials.push(dataItem);
                }
                for (let i = 0; i < newSplittedLines.length; i++) {
                    const index = !hasY1 ? i : i -1;
                    const currentLine = newSplittedLines[i];
                    let value = currentLine[currentLine.length - 1].replaceAll(' ', '');
                    if (value.includes(',') && i !== newSplittedLines.length - 1) {
                        value = value.replaceAll(',', '');
                    }
                    if (value.includes('\'')) {
                        value = value.replaceAll('\'', '');
                    }
                    if (value.includes('(')) {
                        value = '-' + value.replace('(', '').replace(')','');
                    } else if (value.includes(Y1_LABEL)) {
                        continue;
                    }

                    //if user pastes positive values they're transformed to negative ones
                    if ([1, 4, 5, 8].includes(i) && !value.includes('-')) {
                        value = '-' + value;
                    }
                    if (i === newSplittedLines.length - 1) {
                        if (value.includes(',')) {
                            value = value.replaceAll(',', '.');
                }
                        financials[index][`fieldValue${this.size + 1}`] = parseFloat(value);
                    } else {
                        financials[index][`fieldValue${this.size + 1}`] = parseFloat(value);
                    }
                }

                //recalculation
                let fieldKey = `fieldValue${this.size + 1}`;
                financials = this.promoPackCalculation(financials, fieldKey);
                this.setColorForRows(this.data, fieldKey);

                const validData = this.checkFinancialLimits(financials);
                if (validData) {
                    this.data = financials;
                    this.updateFinancials();
                }
            }

            //NSV By Region recalculation
            if (this.showNSVByRegions) {
                this.template.querySelector("c-nsv-by-region-table").handleNSVChange(this.data[1]?.fieldValue2);
            }

            if (FINANCIALS_AND_DELIVERABLES_CLASSIFICATIONS.includes(this.projectType) && this.phase !== 1) {
                let volumeY1Value = 0;
                let volumeY2Value = 0;
                let grossProfitY1Value = 0;
                let grossProfitY2Value = 0;
                let deliverablesGPY1 = 0;
                let deliverablesGPY2 = 0;

                volumeY1Value = this.data[0]['fieldValue2'];
                volumeY2Value = this.data[0]['fieldValue3'];
                grossProfitY1Value = this.data[2]['fieldValue2'];
                grossProfitY2Value = this.data[2]['fieldValue3'];

                if (this.isFinancialEmpty(volumeY1Value) || this.isFinancialEmpty(grossProfitY1Value)) {
                    deliverablesGPY1 = 0;
                } else {
                    deliverablesGPY1 = this.calculateDeliverablesGrossProfit(volumeY1Value, grossProfitY1Value);
                }

                if (this.isFinancialEmpty(volumeY2Value) || this.isFinancialEmpty(grossProfitY2Value)) {
                    deliverablesGPY2 = 0;
                } else {
                    deliverablesGPY2 = this.calculateDeliverablesGrossProfit(volumeY2Value, grossProfitY2Value);
                }

                const payload = {
                    isCopyPaste: true,
                    Y1GP: deliverablesGPY1,
                    Y2GP: deliverablesGPY2
                };
                publish(this.messageContext, FINANCIALS_UPDATED_CHANNEL, payload);
            }
        });
    }

    fillFinancialData(financialData, year, newSplittedLines, currentField, i, j) {
        if (financialData[year] === undefined) {
            financialData[year] = {};
        }
        let value = newSplittedLines[i][j];
        if (value.includes(',')) {
            value = value.replaceAll(',','');
        }
        if (value.includes('(')) {
            value = value.replace('(','').replace(')','');
            value = `-${value}`;
        }
        financialData[year][currentField] = value;
    }

    clipboardMetadata(clipboardData) {
        const isFiveYearData = clipboardData.length === 4 && clipboardData[0].length === 5;
        const isTwoYearData = clipboardData.length === 1 && clipboardData[0].length === 2;
        const isTwoYear = (isTwoYearData ? 'TWO_YEAR' : 'INVALID')
        return { 
            valid: isFiveYearData || isTwoYearData, 
            subType: isFiveYearData ? 'FIVE_YEAR' : isTwoYear 
        };
    }

    checkFinancialLimits(financials) {
        let valid = true;
        const financialYearErrors = {
            1: [],
            2: [],
            3: [],
            4: [],
            5: []
        };
        for (const financialItem of financials) {
            for (const item in financialItem) {
                if (this.projectType !== PROMOTIONAL_PACK  && item.includes('fieldValue') && ((financialItem[item] < MIN_NUMBER_ALLOWED || financialItem[item] > MAX_NUMBER_ALLOWED) && financialItem.fieldName !== '*GM%' && this.projectType !== PROMOTIONAL_PACK) || ((financialItem[item] < MIN_NUMBER_ALLOWED || financialItem[item] > 99.9) && financialItem.fieldName === '*GM%')) {
                    financialYearErrors[this.fieldValueToYear(item)].push(`- Year: ${this.fieldValueToYear(item)} Field: ${financialItem.fieldName} Value: ${financialItem[item]}\n`)
                } else if (this.projectType === PROMOTIONAL_PACK && item.includes('fieldValue') && (financialItem[item] > 0 || financialItem[item] < -MAX_NUMBER_ALLOWED) && (financialItem.fieldName === WRITE_OFF_LABEL_PROMO_PACK || financialItem.fieldName === COGS_LABEL_PROMO_PACK || financialItem.fieldName === AP_LABEL_PROMO_PACK || financialItem.fieldName === STRUCTURE_COSTS_LABEL_PROMO_PACK) && financialItem.fieldName !== RETURN_ON_INVESTMENT_LABEL_PROMO_PACK) {
                    financialYearErrors[this.fieldValueToYear(item)].push(`- Year: ${this.fieldValueToYear(item)} Field: ${financialItem.fieldName} Value: ${financialItem[item]}\n`)
                }
            }
        }
        let message = '';
        for (const financialYear in financialYearErrors) {
            message += financialYearErrors[financialYear].join('');
        }
        if (message !== '') { 
            message += '\n' + ERROR_MESSAGE;
            valid = false;
            this.dispatchEvent(new ShowToastEvent({
                title: 'Financial Value Error',
                message,
                variant: 'error'
            }));
        }
        return valid;
    }

    fieldValueToYear(text) {
        return parseInt(text.replace('fieldValue', ''), 10) - 1;
    }

    get hasCopyAndPaste() {
        return this.projectType !== CI_PROJECT && this.projectType !== MANDATORY_PROJECT && this.objectApiName === undefined;
    }

    get showTitle() {
        return this.objectApiName === undefined;
    }
    
    get outsideClasses() {
        return this.objectApiName !== undefined ? 'slds-var-p-around_medium' : 'slds-var-m-around_medium slds-border_left slds-border_right slds-border_top slds-border_bottom';
    }

    get isReadOnly() {
        return this.objectApiName !== undefined || this._isReadOnly ? true : false;
    }

    get isPromotionalPack() {
        return this.projectType === PROMOTIONAL_PACK;
    }

    get showJustificationForFinancialThresholdNotMet() {
        return this.financialThresholdNotMet;
    }

    get disabledJustificationForFinancialThresholdNotMet() {
        return this.isReadOnly;
    }

    get thresholdNotMetLabel() {
        const label = this.projectType === 'Geographical Extension' ? `${constants.CONST_GEOGRAPHICAL_EXTENSION_FINANCIAL_THRESHOLD_NOT_MET_LABEL}` : `${constants.CONST_FINANCIAL_THRESHOLD_NOT_MET_DEFAULT_LABEL}`;
        return label;
    }

    get showNSVByRegions() {
        return this.phase !== 1 && ((this.leadRegion !== null && this.leadRegion !== '' && this.leadRegion !== undefined) ||
            (this.additionalRegions !== null && this.additionalRegions !== '' && this.additionalRegions !== undefined)) &&
            (this.projectType === constants.CONST_FEARLESS_BET_NAME || this.projectType === constants.CONST_BRAND_ENERGIZER_NAME ||
            this.projectType === constants.CONST_BUSINESS_ENABLER_NAME ||
                (this.projectType === constants.CONST_GEO_EXTENSION_NAME && this.geoSubtype !== 'Other Geo Extension'));
    }

    handleJustificationChange(event) {
        this.justificationForFinancialThresholdNotMet = event.detail.value;
    }
}