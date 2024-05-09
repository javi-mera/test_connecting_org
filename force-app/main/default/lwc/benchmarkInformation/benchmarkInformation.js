import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';
import { getRecord } from 'lightning/uiRecordApi';
import TRADEMARK_CURRENT_GP from '@salesforce/schema/Project__c.TrademarkCurrentGP__c';
import TRADEMARK_CURRENT_GM from '@salesforce/schema/Project__c.TrademarkCurrentGM__c';

const fields = [TRADEMARK_CURRENT_GP, TRADEMARK_CURRENT_GM];

export default class BenchmarkInformation extends LightningElement {
    @api recordId;
    @api readOnly;
    @api trademarkCurrentGP = null;
    @api trademarkCurrentGM = null;
    project;
    dataLoaded = false;

    @wire(getRecord, { recordId: '$recordId', fields })
    wiredRecord({ error, data }) {
        if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading project',
                    message,
                    variant: 'error',
                }),
            );
        } else if (data && !this.dataLoaded) {
            this.project = data;
            this.trademarkCurrentGP = this.project.fields.TrademarkCurrentGP__c.value;
            this.trademarkCurrentGM = this.project.fields.TrademarkCurrentGM__c.value;
            this.dataLoaded = true;
        }
    }

    connectedCallback() {
    }

    onChangeHandler(event) {
        event.target.reportValidity();
        if (event.target.checkValidity()) {
            this[event.currentTarget.dataset.field] = event.detail.value;
            this.updateProject();
        }
    }

    updateProject() {
        const recordFields = {
            Id: this.recordId,
            TrademarkCurrentGP__c: this.trademarkCurrentGP,
            TrademarkCurrentGM__c: this.trademarkCurrentGM
        };

        updateRecord({ fields: recordFields })
            .then((data) => {
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }

    get outsideClasses() {
        return this.readOnly ? 'slds-p-around_medium' : '';
    }
}