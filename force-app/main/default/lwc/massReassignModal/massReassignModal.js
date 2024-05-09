import LightningModal from 'lightning/modal';
import { api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import userId from "@salesforce/user/Id";
import massReassign from '@salesforce/apex/CustomApprovalProcessControlsController.massReassign';

export default class MassReassignModal extends LightningModal {
    @api projects;
    @track selectedProjects = [];
    changed = false;
    connectedCallback() {}

    get fillDisabled() {
        return this.selectedProjects.length === 0;
    }

    handleReassign() {
        const delegate = this.template.querySelector(`c-lookup-to-delegate`);
        const projectDelegations = [];
        for (const project of this.projects) {
            projectDelegations.push({ projectId: project.relatedToUrl.split('/')[3], newUserId: delegate.getSelection()[0].id, oldUserId: userId, comments: null })
        }
        if (projectDelegations.length > 0) {
            massReassign({projectDelegations})
                .then(() => {
                    const toastEvent = new ShowToastEvent({ title: 'Success', message: 'Successfuly redelegate projects', variant: 'success' });
                    this.dispatchEvent(toastEvent);
                    this.close('Success');
                }).catch((error) => {
                    console.log(JSON.stringify(error));
                });
        } else {
            const toastEvent = new ShowToastEvent({ title: 'Warning', message: 'Please select to whom You want to delegate project approvals.', variant: 'warning' });
            this.dispatchEvent(toastEvent);
        }
    }

}