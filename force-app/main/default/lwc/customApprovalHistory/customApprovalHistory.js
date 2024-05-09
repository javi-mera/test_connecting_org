import { LightningElement,api } from 'lwc';
import getApprovalHistory from '@salesforce/apex/ApprovalHistoryController.getApprovalHistory';
import setApproversRoles from '@salesforce/apex/ApprovalHistoryController.setApproversRoles';
import { loadStyle } from 'lightning/platformResourceLoader';
import APPROVAL_HISTORY_CSS from '@salesforce/resourceUrl/ApprovalHistory';
import { subscribe } from 'lightning/empApi';
import { constants } from 'c/utils';

const INITIAL_WIDTH_STEP_NAME = 170;
const INITIAL_WIDTH_CREATED_DATE = 140;
const INITIAL_WIDTH_APPROVERS = 142;
const INITIAL_WIDTH_ROLES = 153;
const INITIAL_WIDTH_STATUS = 85;
const INITIAL_WIDTH_COMMENT = 144;
const columns = [
    {
        label: 'Step Name',
        fieldName: 'stepUrl',
        type: 'url',
        initialWidth: INITIAL_WIDTH_STEP_NAME,
        wrapText: true,
        typeAttributes: { label: { fieldName: 'stepName' }, target: '_blank' },
        cellAttributes: { class: { fieldName: 'classes' } }
    },
    {
        label: 'Date',
        fieldName: 'createdDate',
        type: "date",
        initialWidth: INITIAL_WIDTH_CREATED_DATE,
        cellAttributes: { class: { fieldName: 'classes' } },
        typeAttributes: {
            day: "numeric",
            month: "numeric",
            year: "numeric",
            hour: "2-digit",
            minute: "2-digit",
            timeZone : "Europe/Madrid"
        }
    }, 
    {
        label: 'Status',
        fieldName: 'status',
        initialWidth: INITIAL_WIDTH_STATUS,
        cellAttributes: { class: { fieldName: 'classes' } }
    }, 
    {
        label: 'Submitted By/Assigned To',
        fieldName: 'originalActorName',
        initialWidth: INITIAL_WIDTH_APPROVERS,
        wrapText: true,
        cellAttributes: { class: { fieldName: 'classes' } }
    },
    {
        label: 'Actual Approver',
        fieldName: 'actualApproverName',
        initialWidth: INITIAL_WIDTH_APPROVERS,
        wrapText: true,
        cellAttributes: { class: { fieldName: 'classes' } }
    },
    {
        label: 'Assigned Approver\'s Role',
        fieldName: 'assignedApproverRole',
        initialWidth: INITIAL_WIDTH_ROLES,
        wrapText: true,
        cellAttributes: { class: { fieldName: 'classes' } }
    },
    {
        label: 'Comment',
        fieldName: 'comment',
        initialWidth: INITIAL_WIDTH_COMMENT,
        wrapText: true,
        cellAttributes: { class: { fieldName: 'classes' } }
    }
];
const SUBMITTED_STATUS = 'Submitted';
const STARTED_STATUS = 'Started';
const APPROVAL_HISTORY = 'Approval History';

export default class CustomApprovalHistory extends LightningElement {

    @api recordId;
    isLoading = true;
    customApprovalHistory;
    columns = columns;
    totalCount = 0;
    subscription = {};
    governanceHighlightText = constants.CONST_APPROVAL_HISTORY_HIGHLIGHT;
    connectedCallback() {
        Promise.all([loadStyle(this, APPROVAL_HISTORY_CSS)]);
        this.prepareApprovalData();
        this.subscribePlatformEvent();
    }

    subscribePlatformEvent(){
        const messageCallback = function (response) {
            this.prepareApprovalData();
        };
        subscribe('Custom_Approval_History__e', -1, messageCallback).then((response) => {
            this.subscription = response;
        });
    }

    prepareApprovalData() {
        getApprovalHistory({
            id: this.recordId
        }).then(result => {
            console.log('result')
            this.prepareApproversRoles(result);
        }).catch(error => {
            console.error(error);
        });
    }

    prepareApproversRoles(history) {
        setApproversRoles({
            approvalHistories: history,
            projectId: this.recordId
        }).then(result => {
            console.log('result 2: ', JSON.stringify(result))
            this.customApprovalHistory = result;
            this.totalCount = result.length;
            for (const approval of this.customApprovalHistory) {
                if (approval.status === SUBMITTED_STATUS || approval.status === STARTED_STATUS) {
                    approval.classes = 'approval_bottom-border'
                }
            }
            this.isLoading = false;
        }).catch(error => {
            console.error(error);
        });
    }

    get approvalTitle() {
        return APPROVAL_HISTORY+'('+this.totalCount+')';
    }

}