import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { constants } from 'c/utils';
import PROJECT_DEVELOPMENT_COSTS_TO_DATE from '@salesforce/schema/Project__c.ProjectDevelopmentCostsToDate__c';
import PROJECT_SNAPSHOT_DEVELOPMENT_COSTS_TO_DATE from '@salesforce/schema/Project_Snapshot__c.ProjectDevelopmentCostsToDate__c';

const fields = [ PROJECT_DEVELOPMENT_COSTS_TO_DATE ];

export default class ProjectDevelopmentCosts extends LightningElement {
    @api recordId;
    projectDevelopmentCostsToDate;
    labels = {
        projectDevelopmentCostsLabel: constants.CONST_PROJECT_DEVELOPMENT_COSTS_TO_DATE_HELP_TEXT
    }

    @wire(getRecord, { recordId: '$recordId', fields })
    project({ data, error }) {
        if (data) {
            this.projectDevelopmentCostsToDate = data.fields.ProjectDevelopmentCostsToDate__c.value;
        } else if (error) {
            console.error(JSON.stringify(error));
        }
    }

    @wire(getRecord, { recordId: '$recordId', fields: [PROJECT_SNAPSHOT_DEVELOPMENT_COSTS_TO_DATE] })
    projectSnapshot({ data, error }) {
        if (data) {
            this.projectDevelopmentCostsToDate = data.fields.ProjectDevelopmentCostsToDate__c.value;
        } else if (error) {
            console.error(JSON.stringify(error));
        }
    }
}