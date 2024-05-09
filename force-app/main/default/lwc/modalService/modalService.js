import { LightningElement, api } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import { refreshApex } from '@salesforce/apex';
import MODAL_SERVICE_JS from '@salesforce/resourceUrl/ModalService';
import DeletgateOOOApprovalModal from 'c/delegateOOOApprovalModal';

export default class ModalService extends LightningElement {

    @api recordId;

    connectedCallback() {
        Promise.all([loadScript(this, MODAL_SERVICE_JS)])
    }

    @api
    showModal() {
        DeletgateOOOApprovalModal.open({
            label: 'Delegate OOO Approval',
            hasItemsToApprove: [],
            userId: this.recordId
        }).then(() => {
            refreshApex(this.user);
        })
    }
}