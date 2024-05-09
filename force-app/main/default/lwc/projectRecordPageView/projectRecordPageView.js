import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import PROJECT_PHASE_FIELD from '@salesforce/schema/Project__c.ProjectPhase__c';
import PROJECT_CLASSIFICATION_FIELD from '@salesforce/schema/Project__c.ProjectClassification__c';
import PROJECT_CLASSIFICATION_SUBTYPE_FIELD from '@salesforce/schema/Project__c.ProjectClassificationSubtype__c';
import PROJECT_GEOEXTENSION_PROJECT_SUB_CLASSIFICATION_FIELD from '@salesforce/schema/Project__c.GeoExtensionProjectSubClassification__c';
import PROJECT_DECISION_STEP_FIELD from '@salesforce/schema/Project__c.DecisionStep__c';
import PROJECT_DECISION_STEP_STATUS_FIELD from '@salesforce/schema/Project__c.SubmissionStatus__c';
import PROJECT_STATUS_FIELD from '@salesforce/schema/Project__c.ProjectStatus__c';
import PROJECT_END_OF_DATE_FIELD from '@salesforce/schema/Project__c.EndOfProject__c';
import PROJECT_LEAD_REGION_ALIGNED_TO_PROJECT_FIELD from '@salesforce/schema/Project__c.LeadRegionAlignedtoProject__c';
import PROJECT_CONCEPT_VALIDATION_FIELD from '@salesforce/schema/Project__c.ActivationProfileTolerance__c';
import PROJECT_IS_SAME_MARKET_PROMOTIONAL_PACK_FIELD from '@salesforce/schema/Project__c.IsSameMarketPromotionalPack__c';
import PROJECT_LIMITED_EDITION_PACK_FIELD from '@salesforce/schema/Project__c.LimitedEditionPack__c';
import reject from '@salesforce/apex/CustomApprovalProcessControlsController.reject';

const PROJECT_STATUS_CANCELLED = 'Cancelled';
const CANCELLING_COMMENT = 'Project cancelled by Innovator Admin';

export default class ProjectRecordPageView extends LightningElement {
    
    @api recordId;
    
    @wire(getRecord, { recordId: '$recordId', fields: [PROJECT_PHASE_FIELD, PROJECT_STATUS_FIELD, PROJECT_DECISION_STEP_FIELD, PROJECT_DECISION_STEP_STATUS_FIELD, PROJECT_CLASSIFICATION_FIELD, PROJECT_CLASSIFICATION_SUBTYPE_FIELD]})
    project({ error, data }) {
        if (error) {
            console.error(error);
        } else if (data) {
            this.originalValueOfProjectPhase = data.fields.ProjectPhase__c.value;
            this.originalValueProjectStatus = data.fields.ProjectStatus__c.value;
        }
    }

    _fields = [
        PROJECT_CLASSIFICATION_FIELD,
        PROJECT_PHASE_FIELD,
        PROJECT_CLASSIFICATION_SUBTYPE_FIELD,
        PROJECT_LIMITED_EDITION_PACK_FIELD,
        PROJECT_GEOEXTENSION_PROJECT_SUB_CLASSIFICATION_FIELD,
        PROJECT_DECISION_STEP_FIELD,
        PROJECT_DECISION_STEP_STATUS_FIELD,
        PROJECT_STATUS_FIELD,
        PROJECT_CONCEPT_VALIDATION_FIELD,
        PROJECT_END_OF_DATE_FIELD,
        PROJECT_LEAD_REGION_ALIGNED_TO_PROJECT_FIELD,
        PROJECT_IS_SAME_MARKET_PROMOTIONAL_PACK_FIELD
    ];
    originalValueOfProjectPhase;
    originalValueProjectStatus;
    isSaving = false;

    onSubmitHandle(event) {
        this.isSaving = true;
        event.preventDefault();
        const project = {...event.detail.fields, AvoidSnapshotCreation__c: true };
        this.template.querySelector('lightning-record-form').submit(project);
        this.cancelPendingApprovals(event.detail.fields);
    }

    onSuccessHandle() {
        this.isSaving = false;
    }

    cancelPendingApprovals(fields) {
        const isCancellingPendingApprovalsNeeded = this.originalValueProjectStatus !== fields.ProjectStatus__c  && fields.ProjectStatus__c === PROJECT_STATUS_CANCELLED;
        if (isCancellingPendingApprovalsNeeded) { 
            reject({ projectId: this.recordId, comments: CANCELLING_COMMENT, reason: 'Other' }).then((response) => {
                this.hasApprovalsPending = response;
            }).catch((error) => {
                console.error(error);
            })
        }
    }

}