import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDeliverableData from '@salesforce/apex/FinancialDataController.getDeliverableData';
import getSnapshotDeliverableData from '@salesforce/apex/FinancialDataController.getSnapshotDeliverableData';
import updateFinancialData from '@salesforce/apex/FinancialDataController.updateFinancialData';
import updateFinancialsList from '@salesforce/apex/FinancialDataController.updateFinancialsList';
import { loadStyle } from 'lightning/platformResourceLoader';
import FINANCIAL_DATA_TABLE_STYLESHEET from '@salesforce/resourceUrl/FinancialDataTable';
import { constants } from 'c/utils';
import { subscribe, MessageContext } from 'lightning/messageService';
import FINANCIALS_UPDATED_CHANNEL from '@salesforce/messageChannel/financialsMessageChannel__c';
const MIN_NUMBER_ALLOWED = 0;
const MAX_NUMBER_ALLOWED = 999999999;
const PHASE_TO_NUMBER = {
    'Discover': 1,
    'Define': 2,
    'Design': 3,
    'Develop': 4,
    'Deploy': 5,
    'Diagnose': 6
};

const PHASE_NUMBER_TO_FIELD_NAMES = {
    2: [constants.CONST_BUSINESS_CASE_AMBITION_API_FIELD_NAME],
    3: [constants.CONST_BUSINESS_CASE_VALIDATION_API_FIELD_NAME],
    4: [constants.CONST_COMMERCIAL_MILESTONE_API_FIELD_NAME],
    5: [constants.CONST_PRODUCTION_MILESTONE_API_FIELD_NAME]
};

const LABEL_TO_ROW_NUMBER = {
    [constants.SIZE_OF_PRIZE_DELIVERABLE] : 1,
    [constants.INVESTMENT_REQUIRED_DELIVERABLE] : 2,
    [constants.YEAR_ONE_GP_DELIVERABLE] : 3,
    [constants.YEAR_TWO_GP_DELIVERABLE] : 4,
    [constants.PROJECT_AVERAGE_GM] : 5
};

const PHASE_NUMBER_TO_FIELD_NAMES_TO_REMOVE = {
    2: '',
    3: [constants.CONST_BUSINESS_CASE_AMBITION_API_FIELD_NAME],
    4: [constants.CONST_BUSINESS_CASE_AMBITION_API_FIELD_NAME, constants.CONST_BUSINESS_CASE_VALIDATION_API_FIELD_NAME],
    5: [constants.CONST_BUSINESS_CASE_AMBITION_API_FIELD_NAME, constants.CONST_BUSINESS_CASE_VALIDATION_API_FIELD_NAME, constants.CONST_COMMERCIAL_MILESTONE_API_FIELD_NAME]
};

export default class DeliverablesComponent extends LightningElement {
    @track columns;
    @api recordId;
    @api objectApiName;
    @api objectName;
    @api phase;
    @api projectType;
    @api subType;
    @api isAdminUser = false;
    isCssLoaded = false
    data;

    @wire(MessageContext)
    messageContext;
    subscribeToMessageChannel() {
        this.subscription = subscribe(
            this.messageContext,
            FINANCIALS_UPDATED_CHANNEL,
            (message) => this.handleMessageFromFinancials(message)
        );
    }

    handleMessageFromFinancials(message) {
        let projectPhase = this.phase;
        let rowNumber;
        let isGeoExtension = this.projectType === constants.CONST_GEO_EXTENSION_NAME;
        let isLowGeoExtension = isGeoExtension && this.subType === constants.CONST_IPC_API_NAME;
        if (this.phase === 6) {
            if (isLowGeoExtension) {
                projectPhase = 4;
            } else {
                projectPhase = 5;
            }
        }
        let fieldName = PHASE_NUMBER_TO_FIELD_NAMES[projectPhase];
        let financialsToUpdate = [];

        if (message.isCopyPaste) {
            financialsToUpdate.push(this.removeKeyFromArray(this.getFinancialsArray(isGeoExtension, isLowGeoExtension, this.data[2].Id, message.Y1GP), projectPhase));
            financialsToUpdate.push(this.removeKeyFromArray(this.getFinancialsArray(isGeoExtension, isLowGeoExtension, this.data[3].Id, message.Y2GP), projectPhase));

            console.log('financialsToUpdate ' + JSON.stringify(financialsToUpdate))
        } else {
            rowNumber = message.label === 'Y1GP' ? 2 : 3;
            let recordId = this.data[rowNumber].Id;

            financialsToUpdate.push(this.removeKeyFromArray(this.getFinancialsArray(isGeoExtension, isLowGeoExtension, recordId, message.value), projectPhase));
        }

        /*if (message.isCopyPaste) {
            if (this.phase === 2) {
                financialsToUpdate.push(this.getFinancialsArray(isGeoExtension, isLowGeoExtension, this.data[2].Id, message.Y1GP));
                financialsToUpdate.push(this.getFinancialsArray(isGeoExtension, isLowGeoExtension, this.data[3].Id, message.Y2GP));
            } else {
                financialsToUpdate.push({
                    Id: this.data[2].Id,
                    [fieldName]: message.Y1GP
                });
                financialsToUpdate.push({
                    Id: this.data[3].Id,
                    [fieldName]: message.Y2GP
                });
            }
        } else {
            rowNumber = message.label === 'Y1GP' ? 2 : 3;
            let recordId = this.data[rowNumber].Id;

            if (this.phase === 2) {
                financialsToUpdate.push(this.getFinancialsArray(isGeoExtension, isLowGeoExtension, recordId, message.value));
            } else {
                financialsToUpdate.push({
                    Id: recordId,
                    [fieldName]: message.value
                });
            }
        }*/

        updateFinancialsList({financials: financialsToUpdate}).then(() => {
            this.getDeliverablesData(true, message.isCopyPaste, rowNumber, fieldName);
        });
    }

    removeKeyFromArray(array, phaseNumber) {
        return array = Object.keys(array).filter(objKey =>
            !PHASE_NUMBER_TO_FIELD_NAMES_TO_REMOVE[phaseNumber].includes(objKey)).reduce((newObj, key) =>
            {
                newObj[key] = array[key];
                return newObj;
            }, {}
        );
    }

    getFinancialsArray(isGeoExtension, isLowGeoExtension, recordId, value) {
        let array = {
            Id: recordId,
            [constants.CONST_BUSINESS_CASE_AMBITION_API_FIELD_NAME]: value,
            [constants.CONST_BUSINESS_CASE_VALIDATION_API_FIELD_NAME]: value,
            [constants.CONST_COMMERCIAL_MILESTONE_API_FIELD_NAME]: value,
            [constants.CONST_PRODUCTION_MILESTONE_API_FIELD_NAME]: value
        };

        if (isGeoExtension) {
            if (isLowGeoExtension) {
                array = Object.keys(array).filter(objKey =>
                    objKey !== constants.CONST_BUSINESS_CASE_VALIDATION_API_FIELD_NAME && objKey !== constants.CONST_PRODUCTION_MILESTONE_API_FIELD_NAME).reduce((newObj, key) =>
                    {
                        newObj[key] = array[key];
                        return newObj;
                    }, {}
                );
            } else {
                array = Object.keys(array).filter(objKey =>
                    objKey !== constants.CONST_BUSINESS_CASE_VALIDATION_API_FIELD_NAME).reduce((newObj, key) =>
                    {
                        newObj[key] = array[key];
                        return newObj;
                    }, {}
                );
            }
        }

        return array;




        // if (isGeoExtension) {
        //     if (isLowGeoExtension) {
        //         return {
        //             Id: recordId,
        //             [constants.CONST_BUSINESS_CASE_AMBITION_API_FIELD_NAME]: value,
        //             [constants.CONST_COMMERCIAL_MILESTONE_API_FIELD_NAME]: value
        //         };
        //     } else {
        //         return {
        //             Id: recordId,
        //             [constants.CONST_BUSINESS_CASE_AMBITION_API_FIELD_NAME]: value,
        //             [constants.CONST_COMMERCIAL_MILESTONE_API_FIELD_NAME]: value,
        //             [constants.CONST_PRODUCTION_MILESTONE_API_FIELD_NAME]: value
        //         };
        //     }
        // } else {
        //     return {
        //         Id: recordId,
        //         [constants.CONST_BUSINESS_CASE_AMBITION_API_FIELD_NAME]: value,
        //         [constants.CONST_BUSINESS_CASE_VALIDATION_API_FIELD_NAME]: value,
        //         [constants.CONST_COMMERCIAL_MILESTONE_API_FIELD_NAME]: value,
        //         [constants.CONST_PRODUCTION_MILESTONE_API_FIELD_NAME]: value
        //     };
        // }
    }

    connectedCallback() {
        this.subscribeToMessageChannel();
        this.getDeliverablesData();
    }

    getDeliverablesData(isFormula, isCopyPaste, rowNumber, fieldName) {
        if (this.objectName !== constants.CONST_PROJECT_SNAPSHOT) {
            getDeliverableData({ projectId: this.recordId }).then((response) => {
                this.prepareData(response);
                if (isFormula) {
                    if (isCopyPaste) {
                        this.recalculateColorForRow(this.data[2], this.data[2][fieldName]);
                        this.recalculateColorForRow(this.data[3], this.data[3][fieldName]);
                    } else {
                        this.recalculateColorForRow(this.data[rowNumber], this.data[rowNumber][fieldName]);
                    }
                }
                this.columns[this.columns.length - 1].editable = true;
                if (this.objectApiName !== undefined && !this.isAdminUser) {
                    for (const column of this.columns) {
                        column.editable = false;
                    }
                } else if (this.isAdminUser) {
                    for (const [index, column] of this.columns.entries()) {
                        if (index !== 0) {
                            column.editable = true;
                        }
                    }
                }
            }).catch((error) => {
                console.error(error);
            })
        } else {
            getSnapshotDeliverableData({ projectSnapshotId: this.recordId }).then((response) => {
                this.prepareData(response);
            }).catch((error) => {
                console.error(error);
            })
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

    compare( a, b ) {
        if (LABEL_TO_ROW_NUMBER[a.Label__c?.replace("*", "")] < LABEL_TO_ROW_NUMBER[b.Label__c?.replace("*", "")]){
            return -1;
        }
        if (LABEL_TO_ROW_NUMBER[a.Label__c?.replace("*", "")] > LABEL_TO_ROW_NUMBER[b.Label__c?.replace("*", "")]){
            return 1;
        }
        return 0;
    }
    prepareData(response) {
        let draftData = response.deliverables;
        this.data = draftData.sort(this.compare);
        this.phase = PHASE_TO_NUMBER[response.phase];
        this.projectType = response.type;
        this.subType = response.subType;

        this.data = this.data.map((record) => {
            let label = record.Label__c;
            const isPercentage = label.includes(`Project's average GM% (Year 1 - Year 5)`);
            console.log('Label: ' + label, 'Is Percentage: ' + isPercentage);
            
            record.styleClass = isPercentage ? 'percentage' : '';
            record.lastStyleClass = isPercentage ? 'percentage' : '';
            if (label.includes("*")) {
                return {...record, [constants.CONST_LABEL_API_FIELD_NAME]: label}
            }
            return {...record, [constants.CONST_LABEL_API_FIELD_NAME]: '*' + label}
        });

        this.columns = [
            { label: '', fieldName: constants.CONST_LABEL_API_FIELD_NAME, editable: false, wrapText : true, sortable: false, cellAttributes: { class: { fieldName: 'styleClass' } } },
            { label: 'BCA', fieldName: constants.CONST_BUSINESS_CASE_AMBITION_API_FIELD_NAME, type: 'number', editable: false, wrapText: true, cellAttributes: { class: { fieldName: 'lastStyleClass' } } },
        ];
        if (this.phase >= 3 && this.projectType !== constants.CONST_GEO_EXTENSION_NAME) {
            this.columns[this.columns.length - 1].cellAttributes.class.fieldName = 'styleClass';
            this.columns.push({ label: 'BCV', fieldName: constants.CONST_BUSINESS_CASE_VALIDATION_API_FIELD_NAME, type: 'number', editable: false, wrapText : true, cellAttributes: { class: { fieldName: 'lastStyleClass' } } })
        }
        if (this.phase >= 4 && this.subType !== constants.CONST_ARTWORK_CHANGE_ONLY_API_NAME) {
            this.columns[this.columns.length - 1].cellAttributes.class.fieldName = 'styleClass';
            this.columns.push({ label: 'Commercial', fieldName: constants.CONST_COMMERCIAL_MILESTONE_API_FIELD_NAME, type: 'number', editable: false, wrapText: true, cellAttributes: { class: { fieldName: 'lastStyleClass' } }});
        }
        if (this.phase >= 5 && this.subType !== constants.CONST_IPC_API_NAME) {
            this.columns[this.columns.length - 1].cellAttributes.class.fieldName = 'styleClass';
            this.columns.push({ label: 'Production', fieldName: constants.CONST_PRODUCTION_MILESTONE_API_FIELD_NAME, type: 'number', editable: false, wrapText: true, cellAttributes: { class: { fieldName: 'lastStyleClass' } }});
        }
    }

    onCellChangeHandle(event) {
        const draftValue = event.detail.draftValues[0];
        const fieldKey = Object.keys(event.detail.draftValues[0])[0];
        const row = event.detail.draftValues[0].id.split('-')[1];
        const dataRow = this.data[row];
        const lastValue = Number(this.data[row][fieldKey]);
        const newValue = draftValue.BCAValue__c == '' || draftValue.BCVValue__c == '' ||
        draftValue.CMValue__c == '' || draftValue.PMValue__c == '' ? null : Number(draftValue[fieldKey]);
        this.data[row][fieldKey] = newValue;

        console.log('row ' + row);
        console.log('fieldKey ' + fieldKey);
        console.log('dataRow ' + dataRow.Label__c);

        if ((newValue < MIN_NUMBER_ALLOWED || newValue > MAX_NUMBER_ALLOWED) && dataRow.Label__c.includes(`Project's average GM% (Year 1 - Year 5)`)) {
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: constants.CONST_VALUE_OUT_OF_BOUNDS_FINANCIALS_ERROR,
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
            this.data[row][fieldKey] = lastValue;
        } else if (dataRow.Label__c.includes(`Project's average GM% (Year 1 - Year 5)`) && (newValue < 0 || newValue > 99.9)) {
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: constants.CONST_VALUE_OUT_OF_BOUNDS_PERCENTAGE_ERROR,
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
            this.data[row][fieldKey] = lastValue;
        } else if (dataRow.Label__c.includes(`Project's average GM% (Year 1 - Year 5)`) && newValue != null && newValue.toString().includes('.') && newValue.toString().split('.')[1].length > 1) {
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: constants.CONST_VALUE_OUT_OF_FLOATING_POINT_ERROR,
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
            this.data[row][fieldKey] = lastValue;
        } else {
            const project = { Id: this.recordId, ProjectClassification__c: this.projectType };
            updateFinancialData({ financials: this.data, phase: this.phase, project, type: constants.CONST_DELIVERABLE_TYPE }).catch((error) => {
                const toastEvent = new ShowToastEvent({
                    title: 'Error',
                    message: JSON.stringify(error.body),
                    variant: 'error'
                });
                this.dispatchEvent(toastEvent);
            })
            this.recalculateColorForRow(this.data[row], this.data[row][fieldKey]);
        }
    }

    recalculateColorForRow(rowData, newValue) {
        const isValueWithinTolerance = newValue >= (rowData.BCAValue__c * (rowData.LatestTolerance__c/100.0));
        const isPercentage = rowData.Label__c.includes(`Project's average GM% (Year 1 - Year 5)`);
        rowData.lastStyleClass = isValueWithinTolerance ? 'slds-text-color_success' : 'slds-text-color_error';
        rowData.styleClass = isPercentage ? 'percentage' : '';
        rowData.lastStyleClass += isPercentage ? ' percentage' : '';
    }

    pasteData(event) {
        navigator.clipboard.readText().then((response) => {
            const splittedLines = response.split('\r\n').filter((line) => line.split('\t').join('') !== '');
            const column = splittedLines[0];
            const lastColumnFieldName = this.columns[this.columns.length - 1].fieldName;
            const financials = [];
            for (const dataItem of this.data) { 
                financials.push(dataItem);
            }
            if (column === 'BCA') {
                if (this.columns[this.columns.length - 1].editable) {
                    for (let index = 0; index < financials.length; index++) {
                        financials[index][constants.CONST_BUSINESS_CASE_AMBITION_API_FIELD_NAME] = parseInt(splittedLines[index + 1]);
                    }
                } else {
                    const toastEvent = new ShowToastEvent({
                        title: 'Error',
                        message: constants.CONST_TRYING_TO_UPDATE_BCA_PASTE_ERROR,
                        variant: 'error'
                    });
                    this.dispatchEvent(toastEvent);
                }
            } else if (column === 'Update') {
                for (let index = 1; index < splittedLines.length; index++) {
                    financials[index][lastColumnFieldName] = parseInt(splittedLines[index + 1]);
                }
            }
            let validData = this.checkFinancialLimits(financials);
            if (validData) {
                this.data = financials;
                const project = { Id: this.recordId, ProjectClassification__c: this.projectType };
                updateFinancialData({ financials: this.data, phase: this.phase, project, type: constants.CONST_DELIVERABLE_TYPE }).catch((error) => {
                    const toastEvent = new ShowToastEvent({
                        title: 'Error',
                        message: JSON.stringify(error.body),
                        variant: 'error'
                    });
                    this.dispatchEvent(toastEvent);
                })
            }
        });
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
                if (item != constants.CONST_LABEL_API_FIELD_NAME && (financialItem[item] < MIN_NUMBER_ALLOWED || financialItem[item] > MAX_NUMBER_ALLOWED)) {
                    financialYearErrors[this.fieldValueToYear(item)].push(`Field: ${financialItem['fieldName']} Value: ${financialItem[item]}\n`)
                }
            }
        }
        let message = '';
        for (const financialYear in financialYearErrors) {
            message += financialYearErrors[financialYear].join('');
        }
        if (message != '') { 
            message += '\n' + constants.CONST_VALUE_OUT_OF_BOUNDS_FINANCIALS_ERROR
            valid = false;
            this.dispatchEvent(new ShowToastEvent({
                title: 'Financial Value Error',
                message,
                variant: 'error'
            }));
        }
        return valid;
    }

    get phaseDescription() {
        if (this.phase == 2) {
            return constants.CONST_BUSINESS_CASE_AMBITION_DESCRIPTION;
        } else if (this.phase == 3) {
            return constants.CONST_BUSINESS_CASE_VALIDATION_DESCRIPTION;
        } else if (this.phase == 4) {
            return constants.CONST_COMMERCIAL_MILESTONE_DESCRIPTION;
        } else if (this.phase == 5) {
            return constants.CONST_PRODUCTION_MILESTONE_DESCRIPTION;
        }
    }

    get showTitle() {
        return this.objectApiName == undefined && this.objectName !== constants.CONST_PROJECT_SNAPSHOT;
    }

    get outsideClasses() {
        return this.objectApiName !== undefined ? 'slds-p-around_medium' : '';
    }

    get borderTableClasses() {
        return  this.objectApiName !== undefined ? '' : 'slds-border_left slds-border_right slds-border_top slds-border_bottom'
    }

}