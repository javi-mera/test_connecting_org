import { LightningElement } from 'lwc';
import getMetadata from '@salesforce/apex/DecisionRequiredMetadataUpdateService.getAllMetadata';
import updateMetadata from '@salesforce/apex/DecisionRequiredMetadataUpdateService.updateCustomMetadata';

const actions = [
    { label: 'Edit', name: 'edit' },
];
const columns = [
    { label: 'Label', fieldName: 'Label' },
    { label: 'Complexity', fieldName: 'Complexity__c'},
    { label: 'Decision Step', fieldName: 'DecisionStep__c'},
    { label: 'Project Classification', fieldName: 'ProjectClassification__c'},
    { label: 'Task List', fieldName: 'TaskList__c', type: 'richText'},
    { label: 'Approvals Required', fieldName: 'DecisionRequired__c', type: 'richText'},
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
];
export default class MetadataTable extends LightningElement {
    data = [];
    columns = columns;
    metadataToUpdate;
    taskList = '';
    decisionRequired = '';
    showModal = false;
    connectedCallback() {
        getMetadata({}).then((response) => {
            this.data = response;
        }).catch((error) => {
            console.log('error');
            console.error(error);
        })
    }
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'edit':
                this.edit(row);
                break;
            default:
        }
    }
    edit(row) {
        this.metadataToUpdate  = row;
        this.taskList = this.metadataToUpdate.TaskList__c;
        this.decisionRequired = this.metadataToUpdate.DecisionRequired__c;
        this.showModal = true;
    }
    handleTaskListChange(event) {
        this.taskList = event.target.value;
    }
    handleDecisionRequiredChange(event){
        this.decisionRequired = event.target.value;
    }
    handleSave(){
        if(this.metadataToUpdate){
            this.metadataToUpdate.TaskList__c = this.taskList;
            this.metadataToUpdate.DecisionRequired__c = this.decisionRequired;
            updateMetadata({label: this.metadataToUpdate.Label,taskListToUpdate:this.metadataToUpdate.TaskList__c,decisionRequiredToUpdate: this.metadataToUpdate.DecisionRequired__c}).then((response) => {
                console.log('response: '+response);
                this.data = this.data.slice();
                this.taskList = '';
                this.hideModalBox();
            }).catch((error) => {
                console.log('error');
                console.error(error);
            });
        }
    }
    hideModalBox() {  
        this.showModal = false;
    }
}