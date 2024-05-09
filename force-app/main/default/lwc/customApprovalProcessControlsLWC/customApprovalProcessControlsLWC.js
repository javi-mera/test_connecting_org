import { LightningElement, api, track, wire } from 'lwc';
import recallApprovalProcess from '@salesforce/apex/CustomApprovalProcessControlsController.recallApprovalProcess';
import approve from '@salesforce/apex/CustomApprovalProcessControlsController.approve';
import reject from '@salesforce/apex/CustomApprovalProcessControlsController.reject';
import reassign from '@salesforce/apex/CustomApprovalProcessControlsController.reassign';
import canEdit from '@salesforce/apex/CustomApprovalProcessControlsController.canEdit';
import canSubmitForApproval from '@salesforce/apex/CustomApprovalProcessControlsController.canSubmit';
import canComplete from '@salesforce/apex/CustomApprovalProcessControlsController.canComplete';
import canChangeProjectStatus from '@salesforce/apex/CustomApprovalProcessControlsController.canChangeProjectStatus';
import hasApprovalsPending from '@salesforce/apex/CustomApprovalProcessControlsController.hasApprovalsPending';
import isProjectSubmitted from '@salesforce/apex/CustomApprovalProcessControlsController.isProjectSubmitted';
import currentUserIsOCSupplyChainForProject from '@salesforce/apex/CustomApprovalProcessControlsController.currentUserIsOCSupplyChainForProject';
import addApprovers from '@salesforce/apex/CustomApprovalProcessControlsController.addApprovers';
import canAddApprovers from '@salesforce/apex/CustomApprovalProcessControlsController.canAddApprovers';
import getPendingApproversToReassign from '@salesforce/apex/CustomApprovalProcessControlsController.getPendingApproversToReassign';
import getRejectionReasonPicklistValues from '@salesforce/apex/CustomApprovalProcessControlsController.getRejectionReasonPicklistValues';
import FLOW_MODAL_FIX from '@salesforce/resourceUrl/FlowModalFix';

import { loadStyle } from 'lightning/platformResourceLoader';
import { getRecord, getFieldValue, getRecordNotifyChange, updateRecord, notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import ADDITONAL_APPROVER1_FIELD from '@salesforce/schema/Project__c.AdditionalApprover1__c';
import ADDITONAL_APPROVER2_FIELD from '@salesforce/schema/Project__c.AdditionalApprover2__c';
import ADDITONAL_APPROVER3_FIELD from '@salesforce/schema/Project__c.AdditionalApprover3__c';
import ADDITONAL_APPROVER4_FIELD from '@salesforce/schema/Project__c.AdditionalApprover4__c';
import ADDITONAL_APPROVER5_FIELD from '@salesforce/schema/Project__c.AdditionalApprover5__c';
import ADDITONAL_APPROVER6_FIELD from '@salesforce/schema/Project__c.AdditionalApprover6__c';
import ADDITONAL_APPROVER7_FIELD from '@salesforce/schema/Project__c.AdditionalApprover7__c';
import ADDITONAL_APPROVER8_FIELD from '@salesforce/schema/Project__c.AdditionalApprover8__c';
import ADDITONAL_APPROVER9_FIELD from '@salesforce/schema/Project__c.AdditionalApprover9__c';
import ADDITONAL_APPROVER10_FIELD from '@salesforce/schema/Project__c.AdditionalApprover10__c';
import PROJECT_PHASE_FIELD from '@salesforce/schema/Project__c.ProjectPhase__c';
import IS_MULTI_REGION_FIELD from '@salesforce/schema/Project__c.IsMultiRegion__c';

const fields = [ADDITONAL_APPROVER1_FIELD, ADDITONAL_APPROVER2_FIELD, ADDITONAL_APPROVER3_FIELD, PROJECT_PHASE_FIELD, IS_MULTI_REGION_FIELD];

export default class CustomApprovalProcessControlsLWC extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApiName;

    additionalApprover1Field = ADDITONAL_APPROVER1_FIELD;
    additionalApprover2Field = ADDITONAL_APPROVER2_FIELD;
    additionalApprover3Field = ADDITONAL_APPROVER3_FIELD;
    additionalApprover4Field = ADDITONAL_APPROVER4_FIELD;
    additionalApprover5Field = ADDITONAL_APPROVER5_FIELD;
    additionalApprover6Field = ADDITONAL_APPROVER6_FIELD;
    additionalApprover7Field = ADDITONAL_APPROVER7_FIELD;
    additionalApprover8Field = ADDITONAL_APPROVER8_FIELD;
    additionalApprover9Field = ADDITONAL_APPROVER9_FIELD;
    additionalApprover10Field = ADDITONAL_APPROVER10_FIELD;

    @track hasApprovalsPending = false;
    @track isShowModal = false;
    modalTitle = 'Approve Project';
    isShowModalApprove = false;
    isShowModalReject = false;
    isShowModalRework = false;
    isShowModalReassign = false;
    isShowReassignApproverSelector = false;
    isShowModalSubmit = false;
    showOCSupplyChainWarning = false;
    @track showAddApproversButton = false;
    @track isSubmitFlowVisible = false;
    @track showEditButton = false;
    @track canSubmit = false;
    @track showModalSubmit = false;
    @track showLoading = false;
    @track showCompleteButton = false;
    @track showModalComplete = false;
    @track showModalAddApprovers = false;
    @track showAddApproversSpinner = false;
    @track showChangeProjectStatusButton = false;
    @track showModalProjectStatusChange = false;
    @track isProjectStatusChangeFlowVisible = false;
    @track comments = '';
    @track isProjectSubmitted = false;
    selectedUserId;
    selectedApprover1Id = '';
    selectedApprover2Id = '';
    selectedApprover3Id = '';
    selectedApprover4Id = '';
    selectedApprover5Id = '';
    selectedApprover6Id = '';
    selectedApprover7Id = '';
    selectedApprover8Id = '';
    selectedApprover9Id = '';
    selectedApprover10Id = '';
    selectedApprovers = [];
    pendingApprovers = [];
    reassignApproverId = null;
    _rejectOption = '';
    _rejectOptions = [];

    @wire(getRecord, { recordId: '$recordId', fields })
    project;

    connectedCallback(){
        Promise.all([loadStyle(this,  FLOW_MODAL_FIX)]);

        hasApprovalsPending({ projectId: this.recordId }).then((response) => {
            this.hasApprovalsPending = response;
        }).catch((error) => {
            console.error(error);
        })

        canEdit({ projectId: this.recordId }).then((response) => {
            this.showEditButton = response;
        }).catch((error) => {
            console.error(error);
        })

        canSubmitForApproval({ projectId: this.recordId }).then((response) => {
            this.canSubmit = response;
        }).catch((error) => {
            console.error(error);
        })

        canComplete({ projectId: this.recordId }).then((response) => {
            this.showCompleteButton = response;
        }).catch((error) => {
            console.error(error);
        })

        canChangeProjectStatus({ projectId: this.recordId }).then((response) => {
            this.showChangeProjectStatusButton = response;
        }).catch((error) => {
            console.error(error);
        })

        isProjectSubmitted({ projectId: this.recordId }).then((response) => {
            this.isProjectSubmitted = response;
        }).catch((error) => {
            console.error(error);
        })

        currentUserIsOCSupplyChainForProject({ projectId: this.recordId }).then((response) => {
            this.showOCSupplyChainWarning = response;
        }).catch((error) => {
            console.error(error);
        })

        canAddApprovers().then((response) => {
            this.showAddApproversButton = response;
        }).catch((error) => {
            console.error(error);
        })

        getPendingApproversToReassign({ projectId: this.recordId }).then((response) => {
            if (response && response.length > 0) {
                const approversTemp = response.map((user) => {
                    const approverPicklist = {
                        value: user.Id,
                        label: user.Name
                    }
                    return approverPicklist;
                });
                this.pendingApprovers = approversTemp;
                this.reassignApproverId = this.pendingApprovers[0].value;
                this.isShowReassignApproverSelector = true;
            }
        }).catch((error) => {
            console.error(error);
        })

        getRejectionReasonPicklistValues()
            .then((response) => {
                this._rejectOptions = response;
            }).catch((error) => {
            console.error(error);
        })
    }

    renderedCallback() { 
        this.selectedApprover1Id = this.approverField1;
        this.selectedApprover2Id = this.approverField2;
        this.selectedApprover3Id = this.approverField3;
        this.selectedApprover4Id = this.approverField4;
        this.selectedApprover5Id = this.approverField5;
        this.selectedApprover6Id = this.approverField6;
        this.selectedApprover7Id = this.approverField7;
        this.selectedApprover8Id = this.approverField8;
        this.selectedApprover9Id = this.approverField9;
        this.selectedApprover10Id = this.approverField10;
    }

    showModalBox() {  
        this.comments = '';
        this.isShowModal = true;
    }

    hideModalBox() {  
        this.isShowModal = false;
        this._rejectOption = '';
        this.comments = '';
    }

    showModalBoxComplete() {  
        this.showModalComplete = true;
        this.isCompleteFlowVisible = true;
    }

    hideModalBoxComplete() {  
        this.showModalComplete = false;
        this.isCompleteFlowVisible = false;
    }

    showModalBoxProjectStatusChange() {
        this.showModalProjectStatusChange = true;
        this.isProjectStatusChangeFlowVisible = true;
    }

    hideModalBoxProjectStatusChange() {
        this.showModalProjectStatusChange = false;
        this.isProjectStatusChangeFlowVisible = false;
    }

    showModalBoxSubmit() {
        this.showModalSubmit = true;
        this.isShowModal = false;
        this.isSubmitFlowVisible = true;
    }

    hideModalBoxSubmit() {  
        this.showModalSubmit = false;
        this.isSubmitFlowVisible = false;
    }

    handleApprove(event) {
        this.isShowModalApprove = true;
        this.isShowModalReject = false;
        this.isShowModalRework = false;
        this.isShowModalReassign = false;
        this.modalTitle = 'Approve Project';
        this.comments = '';
        this.showModalBox();
    }

    handleReject() {
        this.isShowModalApprove = false;
        this.isShowModalReject = true;
        this.isShowModalRework = false;
        this.isShowModalReassign = false;
        this.modalTitle = 'Reject Project';
        this.comments = '';
        this.showModalBox();
    }

    handleRework() {
        this.isShowModalApprove = false;
        this.isShowModalReject = false;
        this.isShowModalRework = true;
        this.isShowModalReassign = false;
        this.modalTitle = 'Rework Request';
        this.comments = '';
        this.showModalBox();
    }

    handleReassign() {
        this.isShowModalApprove = false;
        this.isShowModalReject = false;
        this.isShowModalRework = false;
        this.isShowModalReassign = true;
        this.modalTitle = 'Reassign Approval Request';
        this.comments = '';
        this.showModalBox();
    }

    handleReassignSelectorChange(event) {
        this.reassignApproverId = event.target.value;
    }

    handleAddApprovers() {
        this.showModalAddApprovers = true;
    }

    hideModalBoxAddApprovers () {
        this.showModalAddApprovers = false;
    }

    handleComments(event) {
        this.comments = event.target.value;
    }

    handleUserSelection(event) {
        this.selectedUserId = event.target.value;
    }

    handleApprover1Selection (event) {
        this.selectedApprover1Id = event.target.value;
    }

    handleApprover2Selection (event) {
        this.selectedApprover2Id = event.target.value;
    }

    handleApprover3Selection (event) {
        this.selectedApprover3Id = event.target.value;
    }

    handleApprover4Selection (event) {
        this.selectedApprover4Id = event.target.value;
    }

    handleApprover5Selection (event) {
        this.selectedApprover5Id = event.target.value;
    }

    handleApprover6Selection (event) {
        this.selectedApprover6Id = event.target.value;
    }

    handleApprover7Selection (event) {
        this.selectedApprover7Id = event.target.value;
    }

    handleApprover8Selection (event) {
        this.selectedApprover8Id = event.target.value;
    }

    handleApprover9Selection (event) {
        this.selectedApprover9Id = event.target.value;
    }

    handleApprover10Selection (event) {
        this.selectedApprover10Id = event.target.value;
    }

    handleAcceptRework(event) {
        this.showLoading = true;
        recallApprovalProcess({ projectId: this.recordId, comment: this.comments }).then((response) => {
            this.showLoading = false;
            this.hasApprovalsPending = false;
            this.hideModalBox();
            this.updateRecordView(this.recordId);
            this.navigateToViewRecord();
        }).catch((error) => {
            this.showLoading = false;
            console.error(error);
            this.showErrorToast('Error requesting for a rework',error.body.message);
        })
    }

    handleAcceptApprove() {
        this.showLoading = true;
        approve({ projectId: this.recordId, comments : this.comments }).then((response) => {
            this.showLoading = false;
            this.hasApprovalsPending = response;
            this.hideModalBox();
            this.updateRecordView(this.recordId);
            this.navigateToViewRecord();
        }).catch((error) => {
            this.showLoading = false;
            console.error(error);
            this.showErrorToast('Error approving record',error.body.message);
        })
    }

    handleAcceptReject() {
        this.showLoading = true;
        let comments = `${this._rejectOption}`;
        if (this._rejectOption === 'Other' || (this.comments !== null && this.comments !== '')) {
            comments += `: ${this.comments}`;
        }
        reject({ projectId: this.recordId, comments, reason: this._rejectOption }).then((response) => {
            this.showLoading = false;
            this.hasApprovalsPending = response;
            this.hideModalBox();
            this.updateRecordView(this.recordId);
            this.navigateToViewRecord();
        }).catch((error) => {
            this.showLoading = false;
            console.error(error);
            this.showErrorToast('Error rejecting record',error.body.message);
        })
    }

    handleAcceptReassign() {
        this.showLoading = true;
        reassign({ projectId: this.recordId, newUserId : this.selectedUserId , oldUserId : this.reassignApproverId , comments : this.comments }).then((response) => {
            this.showLoading = false;
            this.hideModalBox();
            this.updateRecordView(this.recordId);
            this.navigateToViewRecord();
        }).catch((error) => {
            this.showLoading = false;
            console.error(error);
            this.showErrorToast('Error reassigning approver',error.body.message);
        })
    }

    handleSubmit() {
        this.isShowModalApprove = false;
        this.isShowModalReject = false;
        this.isShowModalRework = false;
        this.isShowModalReassign = false;
        this.isShowModalSubmit = true;
        this.modalTitle = 'Submit Project';
        this.comments = '';
        this.showModalBox();
    }

    handleEdit() {
        this.navigateToEditRecord();
    }

    handleComplete() {
        this.showModalBoxComplete();
    }

    handleProjectStatusChange() {
        this.showModalBoxProjectStatusChange();
    }

    handleStatusChangeSubmit(event) {
        if (event.detail.status === 'FINISHED_SCREEN') {
            this.hideModalBoxSubmit();
            if (this.isMultiRegion && (this.projectPhase === 'Discover' || this.projectPhase === 'Develop' || this.projectPhase === 'Deploy')) {
                setTimeout(() => {
                    this.updateRecordView(this.recordId);
                    getRecordNotifyChange([{recordId: this.recordId}]);
                    this.navigateToViewRecord();
                }, 3000)
            } else {
                this.updateRecordView(this.recordId);
                getRecordNotifyChange([{recordId: this.recordId}]);
                this.navigateToViewRecord();
            }
        }
    }

    handleStatusChangeComplete(event) {
        if (event.detail.status === 'FINISHED') {
            // set behavior after a finished flow interview
            this.hideModalBoxComplete();
            this.navigateToEditRecord();
        }
    }

    handleFlowStatusChangeProjectStatus(event) {
        if (event.detail.status === 'FINISHED') {
            // set behavior after a finished flow interview
            this.hideModalBoxProjectStatusChange();
            notifyRecordUpdateAvailable([{recordId: this.recordId}]);
            this.navigateToViewRecord();
        }
    }

    handleSaveAdditionalApprover() {
        this.showAddApproversSpinner = true;
        this.selectedApprovers.push(this.selectedApprover1Id);
        this.selectedApprovers.push(this.selectedApprover2Id);
        this.selectedApprovers.push(this.selectedApprover3Id);
        this.selectedApprovers.push(this.selectedApprover4Id);
        this.selectedApprovers.push(this.selectedApprover5Id);
        this.selectedApprovers.push(this.selectedApprover6Id);
        this.selectedApprovers.push(this.selectedApprover7Id);
        this.selectedApprovers.push(this.selectedApprover8Id);
        this.selectedApprovers.push(this.selectedApprover9Id);
        this.selectedApprovers.push(this.selectedApprover10Id);
        addApprovers({ projectId: this.recordId, approverIds : this.selectedApprovers}).then((response) => {
            this.showLoading = false;
            this.showAddApproversSpinner = false;
            this.showSuccessToast('Additional approvers updated successfully', '');
            
            this.updateRecordView(this.recordId);
            this.navigateToViewRecord();
        }).catch((error) => {
            this.showLoading = false;
            console.error(error);
            this.showErrorToast('Error adding additional approvers record',error.body.message);
        })
    }

    handleSuccessAddRecord() {
        this.showAddApproversSpinner = false;
        this.showSuccessToast('Additional approvers updated successfully', '');
    }

    updateRecordView(recordId) {
        updateRecord({fields: { Id: recordId }});
    }

    navigateToEditRecord() {
        const config = {
            type: "standard__recordPage",
            attributes: {
                recordId: this.recordId,
                objectApiName: "Project__c",
                actionName: "edit"
            }
        };
        this[NavigationMixin.Navigate](config);
    }

    navigateToViewRecord() {
        const config = {
            type: "standard__recordPage",
            attributes: {
                recordId: this.recordId,
                objectApiName: "Project__c",
                actionName: "view"
            }
        };
        this[NavigationMixin.Navigate](config);
    }

    showErrorToast(errortitle, error) {
        const evt = new ShowToastEvent({
            title: errortitle,
            message: error,
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    showSuccessToast(titleMessage, textMessage) {
        const evt = new ShowToastEvent({
            title: titleMessage,
            message: textMessage,
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
    
    get inputVariables() {
        return [
            {
                name : "recordId",
                type : "String",
                value: this.recordId
            }
        ];
    }

    get inputVariablesSubmit() {
        return [
            {
                name : "recordId",
                type : "String",
                value: this.recordId
            },
            {
                name : "comment",
                type : "String",
                value: this.comments
            }
        ];
    }

    get inputVariablesChangeProjectStatus() {
        return [
            {
                name : "recordId",
                type : "String",
                value: this.recordId
            },
            {
                name : "isProjectSubmitted",
                type : "Boolean",
                value: this.isProjectSubmitted
            }
        ];
    }

    get showBackdrop() {
        return this.isShowModal || this.showModalSubmit || this.showModalComplete || this.showModalAddApprovers || this.showModalProjectStatusChange;
    }

    get approverField1() {
        return getFieldValue(this.project.data, ADDITONAL_APPROVER1_FIELD);
    }

    get approverField2() {
        return getFieldValue(this.project.data, ADDITONAL_APPROVER2_FIELD);
    }

    get approverField3() {
        return getFieldValue(this.project.data, ADDITONAL_APPROVER3_FIELD);
    }

    get approverField4() {
        return getFieldValue(this.project.data, ADDITONAL_APPROVER4_FIELD);
    }

    get approverField5() {
        return getFieldValue(this.project.data, ADDITONAL_APPROVER5_FIELD);
    }

    get approverField6() {
        return getFieldValue(this.project.data, ADDITONAL_APPROVER6_FIELD);
    }

    get approverField7() {
        return getFieldValue(this.project.data, ADDITONAL_APPROVER7_FIELD);
    }

    get approverField8() {
        return getFieldValue(this.project.data, ADDITONAL_APPROVER8_FIELD);
    }

    get approverField9() {
        return getFieldValue(this.project.data, ADDITONAL_APPROVER9_FIELD);
    }

    get approverField10() {
        return getFieldValue(this.project.data, ADDITONAL_APPROVER10_FIELD);
    }

    get projectPhase() {
        return getFieldValue(this.project.data, PROJECT_PHASE_FIELD);
    }

    get isMultiRegion() {
        return getFieldValue(this.project.data, IS_MULTI_REGION_FIELD);
    }

    get disableButtonIfNoComments () {
        return ((this.comments === null || this.comments === '') && !this.isShowModalReject) || ((this._rejectOption === '' || this._rejectOption === 'Other') && (this.comments === null || this.comments === ''));
    }

    get showAddApprovers () {
        return this.hasApprovalsPending && this.showAddApproversButton;
    }

    get commentsRequired() {
        return (this.isShowModalReject && this._rejectOption === 'Other') || this.isShowModalRework;
    }

    get showRejectOptions() {
        return this.isShowModalReject;
    }

    get commentLabel() {
        return !this.isShowModalReject ? 'Comments' : 'Please, describe the reason';
    }

    handleRejectOptionChange(event) {
        this._rejectOption = event.detail.value;
    }

}