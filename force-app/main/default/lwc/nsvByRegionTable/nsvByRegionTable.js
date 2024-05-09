import {api, LightningElement} from 'lwc';
import getRegionalNSVFinancials from '@salesforce/apex/FinancialDataRespository.getRegionalNSVFinancialsByProjectId';
import getSnapshotRegionalNSVFinancials from '@salesforce/apex/FinancialDataRespository.getRegionalNSVFinancialsBySnapshotId';
import getFinancialsNSVYearOne from '@salesforce/apex/NSVByRegionController.getFinancialsNSV';
import updateFinancialsNSVByRegion from '@salesforce/apex/NSVByRegionController.updateFinancialsNSVByRegion';
import NSV_BY_REGIONS_DATATABLE_STYLESHEET from '@salesforce/resourceUrl/nsvByRegionsDatatable';
import {loadStyle} from "lightning/platformResourceLoader";
import { updateRecord } from 'lightning/uiRecordApi';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import {constants} from 'c/utils';

const PERCENTAGE_ERROR_MESSAGE = 'Value must be less than 100';
const REGION_LABEL = 'Region';
const REGION_FIELD = 'Region__c';
const NSV_CONTRIBUTION_LABEL = 'Project\'s first 12 months $NSV';
const NSV_CONTRIBUTION_FIELD = 'ContributionToTotalNSV__c';
const NSV_AMOUNT_LABEL = 'Amount of NSV ($K)';
const NSV_AMOUNT_FIELD = 'AmountOfNSV__c';
const NSV_BY_REGION_TOTAL_PERCENTAGE_FIELD = 'NSVByRegionTotalPercentage__c';
const ID_FIELD = 'Id';

const columns = [
    {
        label: REGION_LABEL,
        fieldName: REGION_FIELD,
        wrapText: true,
        hideDefaultActions: true
    },
    {
        label: NSV_CONTRIBUTION_LABEL,
        fieldName: NSV_CONTRIBUTION_FIELD,
        wrapText: true,
        hideDefaultActions: true,
        editable: true,
        cellAttributes: {
            class: 'percentage margin-right',
            alignment: 'right'
        },
    },
    {
        label: NSV_AMOUNT_LABEL,
        fieldName: NSV_AMOUNT_FIELD,
        type: 'number',
        typeAttributes: {
            step: '0.01'
        },
        cellAttributes: {
            class: 'margin-right'
        },
        wrapText: true,
        hideDefaultActions: true
    }
];
export default class NsvByRegionTable extends LightningElement {
    @api recordId;
    @api financialsNsv;
    @api isFromProjectRecordPage;
    @api isFromProjectSnapshotRecordPage;

    data = [];
    columns = columns;
    isLoading;
    totalPercentage = 0;
    totalPercentageClass;
    helpText = constants.CONST_NSV_BY_REGIONS_HELP_TEXT;


    renderedCallback() {
        loadStyle(this, NSV_BY_REGIONS_DATATABLE_STYLESHEET).then(() => {
            console.log('Loaded Successfully')
        }).catch(error => {
            console.error('Error in loading the colors:', error)
        })
    }

    connectedCallback() {
        this.isLoading = true;
        if (!this.isFromProjectSnapshotRecordPage) {
            this.getNSVByRegionFinancials(false);
        } else {
            getSnapshotRegionalNSVFinancials({snapshotId: this.recordId}).then((response)=> {
                if (response) {
                    this.data = response;
                    this.calculateTotalPercentage(this.data, false);
                    this.isLoading = false;
                }
            }).catch((error) => {
                console.error(error);
            });
        }

    }

    getNSVByRegionFinancials(isTotalPercentageUpdateNeeded) {
        getRegionalNSVFinancials({projectId: this.recordId}).then((response) => {
            if (response) {
                this.data = response;
                this.calculateTotalPercentage(this.data, isTotalPercentageUpdateNeeded);
                this.isLoading = false;
            }
        }).catch((error) => {
            console.error(error);
        })
    }

    calculateTotalPercentage(data, isTotalPercentageUpdateNeeded) {
        this.totalPercentage = 0;
        data.forEach(record => {
            this.totalPercentage += record.ContributionToTotalNSV__c === null || record.ContributionToTotalNSV__c === undefined ? 0 : record.ContributionToTotalNSV__c;
        });
        this.totalPercentage = isNaN(this.totalPercentage) || this.totalPercentage === undefined || this.totalPercentage === null ? 0 : this.totalPercentage;
        this.totalPercentageClass = this.totalPercentage > 100 || this.totalPercentage < 100 ? 'totalPercentageStyle' : 'totalPercentageStyleGreen';
        //update project
        if (isTotalPercentageUpdateNeeded) {

            const fields = {};
            fields[ID_FIELD] = this.recordId;
            fields[NSV_BY_REGION_TOTAL_PERCENTAGE_FIELD] = this.totalPercentage;

            const recordInput = { fields };

            updateRecord(recordInput).then(() => {

            });
        }
    }

    onCellChange(event) {
        const draftValueMap = event.detail.draftValues[0];
        const contributionToTotalNSV = draftValueMap.ContributionToTotalNSV__c;
        const row = draftValueMap.id.split('-')[1]; //find the row
        const financialsId = this.data[row].Id;

        if (contributionToTotalNSV > 100) {
            this.showToast('Error', PERCENTAGE_ERROR_MESSAGE, 'error');
        } else {
            if (contributionToTotalNSV === null || contributionToTotalNSV === '' || contributionToTotalNSV === 0) {
                this.updateFinancialsNSV(financialsId, contributionToTotalNSV, 0);
            } else {
                getFinancialsNSVYearOne({projectId: this.recordId}).then((nsvYearOne) => {
                    if (nsvYearOne) {
                        if (nsvYearOne === 0) {
                            this.updateFinancialsNSV(financialsId, contributionToTotalNSV, 0);
                        } else {
                            let contribution = this.calculateNSVAmount(nsvYearOne, contributionToTotalNSV);
                            this.updateFinancialsNSV(financialsId, contributionToTotalNSV, contribution);
                        }
                    } else {
                        this.updateFinancialsNSV(financialsId, contributionToTotalNSV, 0);
                        this.calculateTotalPercentage(this.data, true);
                    }
                }).catch((error) => {
                    console.error(error);
                })
            }
        }
    }

    calculateNSVAmount(nsvYearOne, percentage) {
        return nsvYearOne * (percentage / 100);
    }

    updateFinancialsNSV(financialsId, contributionToTotalNSV, amountOfNSV) {
        const fields = {};
        fields[ID_FIELD] = financialsId;
        fields[NSV_CONTRIBUTION_FIELD] = contributionToTotalNSV;
        fields[NSV_AMOUNT_FIELD] = amountOfNSV;

        const recordInput = { fields };

        updateRecord(recordInput).then(() => {
            this.getNSVByRegionFinancials(true);
        });
    }

    @api
    handleNSVChange(nsvValue) {
        let financialsToUpdate = [];

        this.data.forEach(record => {
            if (record.ContributionToTotalNSV__c !== null && record.ContributionToTotalNSV__c !== 0) {
                if (nsvValue === null || nsvValue === '' || nsvValue === 0) {
                    financialsToUpdate.push({
                        Id: record.Id,
                        AmountOfNSV__c: 0
                    });
                } else {
                    let totalAmount = this.calculateNSVAmount(nsvValue, record.ContributionToTotalNSV__c);
                    financialsToUpdate.push({
                        Id: record.Id,
                        AmountOfNSV__c: totalAmount
                    });
                }
            }
        });

        updateFinancialsNSVByRegion({financials: financialsToUpdate}).then(() => {
            this.getNSVByRegionFinancials(false);
        });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
}