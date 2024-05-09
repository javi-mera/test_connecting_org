import { LightningElement, api } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import APPROVAL_HISTORY_CSS from '@salesforce/resourceUrl/ApprovalHistory';

const SUBMITTED_STATUS = 'Submitted';

export default class ApprovalHistory extends LightningElement {

    @api recordId;

    _columns = [{
        label: 'Step Name',
        fieldName: 'stepNameUrl',
        type: 'url',
        typeAttributes: { label: { fieldName: 'stepName' } },
        cellAttributes: { class: { fieldName: 'classes' } }
    }, {
        label: 'Date',
        fieldName: 'date',
        type: 'date',
        cellAttributes: { class: { fieldName: 'classes' } }
    }, {
        label: 'Status',
        fieldName: 'status',
        cellAttributes: { class: { fieldName: 'classes' } }
    }, {
        label: 'Submitted by / Assigned to',
        fieldName: 'submittedBy',
        cellAttributes: { class: { fieldName: 'classes' } }
    }, {
        label: 'Actual Approver',
        fieldName: 'actualApprover',
        cellAttributes: { class: { fieldName: 'classes' } }
    }, {
        label: 'Comment',
        fieldName: 'comment',
        cellAttributes: { class: { fieldName: 'classes' } }
    }];

    _data = [{  
        stepName: 'Production Milestone',
        date: '1997-07-01',
        status: 'Approved',
        submittedBy: 'Approver 1 name',
        acutalApprover: 'Approver 1 name',
        comment: 'Test',
        stepNameUrl: 'test'
    },{  
        stepName: 'Production Milestone',
        date: '1997-07-01',
        status: 'Submitted',
        submittedBy: 'Approver 1 name',
        acutalApprover: 'Approver 1 name',
        comment: 'Test',
        stepNameUrl: 'test'
    },{  
        stepName: 'Commercial Milestone',
        date: '1997-07-01',
        status: 'Approved',
        submittedBy: 'Approver 1 name',
        acutalApprover: 'Approver 1 name',
        comment: 'Test',
        stepNameUrl: 'test'
    },{  
        stepName: 'Commercial Milestone',
        date: '1997-07-01',
        status: 'Submitted',
        submittedBy: 'Approver 1 name',
        acutalApprover: 'Approver 1 name',
        comment: 'Test',
        stepNameUrl: 'test'
    },{  
        stepName: 'Business Case Validation Decision Step',
        date: '1997-07-01',
        status: 'Approved',
        submittedBy: 'Approver 1 name',
        acutalApprover: 'Approver 1 name',
        comment: 'Test',
        stepNameUrl: 'test'
    },{  
        stepName: 'Business Case Validation Decision Step',
        date: '1997-07-01',
        status: 'Submitted',
        submittedBy: 'Approver 1 name',
        acutalApprover: 'Approver 1 name',
        comment: 'Test',
        stepNameUrl: 'test'
    },{  
        stepName: 'Business Case Ambition Decision Step',
        date: '1997-07-01',
        status: 'Approved',
        submittedBy: 'Approver 1 name',
        acutalApprover: 'Approver 1 name',
        comment: 'Test',
        stepNameUrl: 'test'
    },{  
        stepName: 'Business Case Ambition Decision Step',
        date: '1997-07-01',
        status: 'Submitted',
        submittedBy: 'Approver 1 name',
        acutalApprover: 'Approver 1 name',
        comment: 'Test',
        stepNameUrl: 'test'
    },{  
        stepName: 'Opportunity Milestone',
        date: '1997-07-01',
        status: 'Approved',
        submittedBy: 'Approver 1 name',
        acutalApprover: 'Approver 1 name',
        comment: 'Test',
        stepNameUrl: 'test'
    },{  
        stepName: 'Opportunity Milestone',
        date: '1997-07-01',
        status: 'Submitted',
        submittedBy: 'Approver 1 name',
        acutalApprover: 'Approver 1 name',
        comment: 'Test',
        stepNameUrl: 'test'
    }];

    connectedCallback() {
        Promise.all([loadStyle(this, APPROVAL_HISTORY_CSS)]);
        this.prepareApprovalData();
    }

    prepareApprovalData() {
        for (const approval of this._data) {
            if (approval.status === SUBMITTED_STATUS) {
                approval.classes = 'approval_bottom-border'
            }
        }
    }

}