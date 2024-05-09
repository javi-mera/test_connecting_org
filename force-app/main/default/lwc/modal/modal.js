import { LightningElement, api } from 'lwc';
const COLS_MULTISELECT = [  
    {
        label:'Select All',
        fieldName:'title',
        type:'text'
    }
];  
const COLS = [  
    {
        label:'Name',
        fieldName:'title',
        type:'text'
    }
]; 

const COLS_ORIGINAL_PROJECT = [
    {
        label:'Name',
        fieldName:'title',
        type:'text',
        wrapText: true
    },
    {
        label:'Project Number',
        fieldName:'subtitle',
        type:'text'
    },
    {
        label:'Project Description',
        fieldName:'value',
        type:'text',
        wrapText: true
    }
];

export default class Modal extends LightningElement {
    @api label;
    @api list = [];
    @api preSelectedRows=[];
    @api isOriginalProject;
    cols = COLS;
    multiselect_cols = COLS_MULTISELECT; 
    originalProjectCols = COLS_ORIGINAL_PROJECT;
    firstTime = true;
    get isLoading() {
        return !this.list.length > 0;
    }
    
    get isProjectLeader() {
        return (this.label === "* Project Leader"  || this.label === "Lead Region" || this.label === "Lead Hub" ||
            this.label === "Lead Cluster" || this.label === "Lead Market" || this.label === "* Project Manager" ||
            this.label === "Project Manager" || this.label === "Original Project" || this.label === "* Original Project" ||
            this.label === "User for Reassignment" || this.label === "Pending Approver");
    }
    
    hideModalBox(){
        this.dispatchEvent(new CustomEvent('hidemodal'));
    }

    handleSave(){
        let selectedRecords = this.template.querySelector("lightning-datatable").getSelectedRows(); 
        if(selectedRecords.length > 0 ) {
            if (this.preSelectedRows.length > 0) {
                for (const preSelectedRow of this.preSelectedRows){
                    selectedRecords = this.removeValue(selectedRecords, preSelectedRow);
                }
            }
            this.dispatchEvent(new CustomEvent('savelist', 
                {
                    detail: {
                        selectedItems: selectedRecords
                    }
                }
            ));
        }
        this.dispatchEvent(new CustomEvent('hidemodal'));
    }

    renderedCallback(){
        if(this.list.length > 0 && this.firstTime){
            for (const preSelectedRow of this.preSelectedRows){
                this.list = this.removeValue(this.list, preSelectedRow);
            }
            this.firstTime = false;
        }
    }

    removeValue(selectedRecords, removeValue) {
        selectedRecords = selectedRecords.filter(value => value.id !== removeValue.id);
        return selectedRecords;
    }
}