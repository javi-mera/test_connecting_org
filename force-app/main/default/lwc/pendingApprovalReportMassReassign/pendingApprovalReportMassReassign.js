import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getItemsToApprove from '@salesforce/apex/PendingApprovalReportReassignController.getItemsToApprove';
import getAllPendingApprovers from '@salesforce/apex/PendingApprovalReportReassignController.getAllPendingApprovers';
import getPendingApproversByName from '@salesforce/apex/PendingApprovalReportReassignController.getPendingApproversByName';
import massReassign from '@salesforce/apex/CustomApprovalProcessControlsController.massReassign';

export default class PendingApprovalReportMassReassign extends LightningElement {
    
    modalOpen = false;
    pendingApprovers = [];
    _loading = false;
    _saving = false;
    _columns = [
        { label: 'Project Name', fieldName: 'relatedToUrl', type: 'url', typeAttributes: { label: { fieldName: 'relatedTo' } } },
        { label: 'Decision Step Status', fieldName: 'decisionStepStatus' },
        { label: 'Submitted By', fieldName: 'submittedByUrl', type: 'url', typeAttributes: { label: { fieldName: 'submittedBy' } } },
        { label: 'Date Submitted', fieldName: 'dateSubmitted', type: 'date', sortable: true, typeAttributes: { month: '2-digit', day: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' } }
    ];
    @track
    _data = [];
    _selectedRows = [];
    _selectedApprover = null;

    get hasApprovals() {
        return this._data.length > 0;
    }

    get disableReassign() {
        return this._selectedApprover == null && this._selectedRows.length === 0;
    }

    openModal() {
        this.modalOpen = true;
    }
    
    closeModal() {
        this.modalOpen = false;
    }

    onRowSelectionHandle(event) {
        this._selectedRows = event.detail.selectedRows;
    }
    
    handleReassign() {
        this._saving = true;
        const delegate = this.template.querySelector(`c-lookup-to-delegate`);
        const projectDelegations = [];
        for (const project of this._selectedRows) {
            projectDelegations.push({ projectId: project.relatedToUrl.split('/')[3], newUserId: delegate.getSelection()[0].id, oldUserId: this._selectedApprover, comments: null })
        }
        if (projectDelegations.length > 0) {
            massReassign({projectDelegations})
                .then(() => {
                    this._saving = false;
                    const toastEvent = new ShowToastEvent({ title: 'Success', message: 'Projects redelegated successfully', variant: 'success' });
                    this.dispatchEvent(toastEvent);
                    this.modalOpen = false;
                    window.location.reload();
                }).catch((error) => {
                    this._saving = false;
                    console.log(JSON.stringify(error));
                });
        } else {
            const toastEvent = new ShowToastEvent({ title: 'Warning', message: 'Please select to whom you want to delegate project approvals.', variant: 'warning' });
            this.dispatchEvent(toastEvent);
        }
    }

    handleSearchApprovers(event) {
        const lookup =  this.template.querySelector('c-lookup');
        if (lookup.getSelection().length === 0) {
            getPendingApproversByName(event.detail)
                .then((results) => {
                    const sortedResults = results.sort((a, b) => {
                        if (a.title < b.title) {
                          return -1;
                        }
                        if (a.title > b.title) {
                          return 1;
                        }
                        return 0;
                    });
                    lookup.setSearchResults(sortedResults);
                }).catch((error) => {
                    console.log(error);
                });
        } else {
            lookup.unsetLoading();
        }
        
    }

    handleSearchAllApprovers() {
        const lookup =  this.template.querySelector('c-lookup');
        if (lookup.getSelection().length === 0) {
            getAllPendingApprovers()
                .then((results) => {
                    const sortedResults = results.sort((a, b) => {
                        if (a.title < b.title) {
                          return -1;
                        }
                        if (a.title > b.title) {
                          return 1;
                        }
                        return 0;
                    });
                    lookup.setListOfObjects(sortedResults);
                }).catch((error) => {
                    console.log(error);
                });
        }
    }

    handleSelectionChange(event) {
        this._loading = true;
        if (event.detail.selectedIds[0] != null) {
            this._selectedApprover = event.detail.selectedIds[0];
            getItemsToApprove({ userId: event.detail.selectedIds[0] })
                .then((response) => {
                    this._data = response;
                    this._loading = false;
                })
        }
    }

    handleRemoveUser() {
        this._data = [];
    }

}