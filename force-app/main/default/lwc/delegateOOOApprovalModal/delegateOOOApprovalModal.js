import LightningModal from 'lightning/modal';
import { api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadStyle } from 'lightning/platformResourceLoader';
import DELEGATE_OOO_APPROVAL_CSS from '@salesforce/resourceUrl/DelegateOOOApprovalModal';
import updateDelegateWithDate from '@salesforce/apex/DelegateOOOApprovalModalController.updateDelegateWithDate';
import USER_DELEGATED_APPROVER_ID from '@salesforce/schema/User.DelegatedApproverId';
import USER_START from '@salesforce/schema/User.Start__c';
import USER_END from '@salesforce/schema/User.End__c';
import getUserById from '@salesforce/apex/UserRepository.getUserById';
import getItemsToApprove from '@salesforce/apex/ItemsToApproveController.getItemsToApprove';
import massReassign from '@salesforce/apex/CustomApprovalProcessControlsController.massReassign';

export default class DelegateOOOApprovalModal extends LightningModal {

    start = null;
    end = null;
    error = false;
    showConfirmationScreen = false;
    delegateFutureApprovals = false;
    delegateExisitingPendingApprovals = false;
    reassignAllProjects = false;
    reassignSomeProjects = false;
    @api hasItemsToApprove
    @api userId = null;
    @api delegateFutureOnly = false;
    _data = [];
    _columns = [
        { label: 'Project Name', fieldName: 'relatedToUrl', type: 'url', typeAttributes: { label: { fieldName: 'relatedTo' } } },
        { label: 'Decision Step Status', fieldName: 'decisionStepStatus' },
        { label: 'Submitted By', fieldName: 'submittedByUrl', type: 'url', typeAttributes: { label: { fieldName: 'submittedBy' } } },
        { label: 'Date Submitted', fieldName: 'dateSubmitted', type: 'date', sortable: true, typeAttributes: { month: '2-digit', day: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' } }
    ];
    _selectedRows = [];
    _delegatedApproverId = null;

    @wire(getRecord, { recordId: '$userId', fields: [ USER_DELEGATED_APPROVER_ID, USER_START, USER_END ]})
    user({ data, error}) {
        if (data) {
            this.start = getFieldValue(data, USER_START);
            this.end = getFieldValue(data, USER_END);
            this._delegatedApproverId = getFieldValue(data, USER_DELEGATED_APPROVER_ID);
            if (this._delegatedApproverId != null) {
                getUserById({ id: this._delegatedApproverId  })
                    .then((response) => {
                        this.template.querySelector(`c-lookup-to-delegate[data-approver="future"]`).setSelection({
                            id: this._delegatedApproverId ,
                            title: response.Name,
                            sObjectType: 'User',
                            icon: 'standard:user',
                            subtitle: response.Name
                        });
                    }).catch((errorMessage) => {
                        console.log(JSON.stringify(errorMessage));
                    })
            }
        } else if (error) {
            console.log(error);
        }
    }

    connectedCallback() {
        Promise.all([loadStyle(this, DELEGATE_OOO_APPROVAL_CSS)]);
        getItemsToApprove()
            .then((response) => {
                this._data = response;
            }).catch((error) => {
                console.error(error);
            });
    }

    onInputDateChange(event) {
        const field = event.currentTarget.dataset.field;
        this[field] = event.detail.value;  
        const startDate = this.template.querySelector('lightning-input[data-field="end"]');
        if (field === 'end' && this.start != null && new Date(this.start) > new Date(this.end)) {
            startDate.setCustomValidity('End Date cannot be before Start Date');
            this.error = true; 
        } else if (field === 'end' && this.start != null) {
            startDate.setCustomValidity('');
            this.error = false;
        }
        startDate.reportValidity();
    }


    handleDelegate() {
        if (this.delegateFutureApprovals || this.delegateFutureOnly) {
            const lookupToDelegate = this.template.querySelector(`c-lookup-to-delegate[data-approver="future"]`);
            if (lookupToDelegate.getSelection().length > 0) {
                const delegate = lookupToDelegate.getSelection()[0].id;
        updateDelegateWithDate({ user: { Id: this.userId, DelegatedApproverId: delegate, Start__c: this.start, End__c: this.end }})
            .then(() => {
                        if (!this.delegateExisitingPendingApprovals) {
                            this.close('Success');
                        }
                    });
            } else {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Approver is not selected',
                        message: 'Please choose delegated approver.',
                        variant: 'error',
                        mode: 'pester'
                    })
                );
            }
        }
        if (this.delegateExisitingPendingApprovals) {
            if (this.reassignAllProjects) {
                const lookupToDelegate = this.template.querySelector(`c-lookup-to-delegate[data-approver="future"]`);
                if (lookupToDelegate.getSelection().length > 0) {
                    const delegate = lookupToDelegate.getSelection()[0].id;
                    const projectDelegations = [];
                    for (const project of this._data) {
                        projectDelegations.push({ projectId: project.relatedToUrl.split('/')[3], newUserId: delegate, oldUserId: this.userId, comments: null })
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
                    }
                } else {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Approver is not selected',
                            message: 'Please choose delegated approver.',
                            variant: 'error'
                        })
                    );
                }
            }
            if (this.reassignSomeProjects) {
                if (this._selectedRows.length > 0) {
                    const lookupToDelegate = this.template.querySelector(`c-lookup-to-delegate[data-approver="existing"]`);
                    if (lookupToDelegate.getSelection().length > 0) {
                        const delegate = lookupToDelegate.getSelection()[0].id;
                        const projectDelegations = [];
                        for (const project of this._selectedRows) {
                            projectDelegations.push({ projectId: project.relatedToUrl.split('/')[3], newUserId: delegate, oldUserId: this.userId, comments: null })
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
                        }
                } else {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Approver is not selected',
                                message: 'Please choose delegated approver.',
                                variant: 'error'
                            })
                        );
                    }
                } else {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Projects to reassign are not selected',
                            message: 'Please select projects to reassign.',
                            variant: 'error'
                        })
                    );
                }
            }
        }
    }

    handleClose() {
        this.close('Success');
    }

    get minimumDate() {
        return new Date().toISOString().slice(0, 10);
    }

    get disableDelegate() {
        return ((!this.delegateFutureApprovals && !this.delegateFutureOnly) || this.start === null || this.end === null) && (!this.delegateExisitingPendingApprovals && (!this.reassignAllProjects || (!this.reassignSomeProjects && this._selectedRows.length === 0)));
    }

    get disableReassignAllProjects() {
        return ((this._delegatedApproverId === null && !this.delegateFutureApprovals) || this.reassignSomeProjects);
    }

    get hasPendingApprovals() {
        return this._data.length > 0;
    }

    handleDelegateFutureApprovalsCheckbox() {
        this.delegateFutureApprovals = !this.delegateFutureApprovals;
    }

    handleDelegateExisitingPendingApprovalsCheckbox() {
        this.delegateExisitingPendingApprovals = !this.delegateExisitingPendingApprovals;
        if (!this.delegateExisitingPendingApprovals) {
            this.reassignAllProjects = false;
            this.reassignSomeProjects = false;
        }
    }

    handleReassignAllProjectsCheckbox() {
        this.reassignAllProjects = !this.reassignAllProjects;
    }

    onRowSelectionHandle(event) {
        this._selectedRows = event.detail.selectedRows;
    }

    handleReassignSomeProjectsCheckbox() {
        this.reassignSomeProjects = !this.reassignSomeProjects;
    }

}