import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import USER_ID from '@salesforce/user/Id';
import USER_DELEGATED_APPROVER_ID from '@salesforce/schema/User.DelegatedApproverId';
import USER_START from '@salesforce/schema/User.Start__c';
import USER_END from '@salesforce/schema/User.End__c';
import getItemsToApprove from '@salesforce/apex/ItemsToApproveController.getItemsToApprove';
import DeletgateOOOApprovalModal from 'c/delegateOOOApprovalModal';

export default class ItemsToApprove extends LightningElement {
    @api recordId;
    _columns = [
        { label: 'Project Name', fieldName: 'relatedToUrl', type: 'url', typeAttributes: { label: { fieldName: 'relatedTo' } } },
        { label: 'Decision Step Status', fieldName: 'decisionStepStatus' },
        { label: 'Submitted By', fieldName: 'submittedByUrl', type: 'url', typeAttributes: { label: { fieldName: 'submittedBy' } } },
        { label: 'Date Submitted', fieldName: 'dateSubmitted', type: 'date', sortable: true, typeAttributes: { month: '2-digit', day: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' } }
    ];
    _data = [];
    @track _selectedRows = [];

    @wire(getRecord, { recordId: USER_ID, fields: [ USER_DELEGATED_APPROVER_ID, USER_START, USER_END ]})
    user;
    
    connectedCallback() {
        getItemsToApprove()
            .then((response) => {
                this._data = response;
            }).catch((error) => {
                console.error(error);
            })
    }

    get hasItemsToApprove() {
        return this._data.length > 0;
    }

    get hideComponent() {
        return !this.hasItemsToApprove;
    }

    openDelegateOOOApprovalModal() {
        DeletgateOOOApprovalModal.open({
            label: 'Delegate OOO Approval',
            hasItemsToApprove: this.hasItemsToApprove,
            userId: USER_ID
            }).then(() => {
                refreshApex(this.user);
        }).finally(() => {
                getItemsToApprove()
                    .then((response) => {
                        this._data = response;
                    }).catch((error) => {
                        console.error(error);
            });
        });
    }
    
}