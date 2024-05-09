import {LightningElement, api} from 'lwc';
import getProject from '@salesforce/apex/ProjectRepository.getProject';

export default class ChecklistComponent extends LightningElement {
    @api isFromFlow;
    @api isFromRecordPage;
    @api recordId;
    @api projectClassification;
    @api projectClassificationSubtype;
    @api projectComplexity;
    @api projectPhase;
    @api isPackDevelopmentManagerContacted;
    @api isApprovedByLegalAndRegPrimos;
    @api isGiftBoxException;
    @api giftBoxExceptionComment;
    @api hasPLConfirmedChecklist;

    connectedCallback() {
        if (!this.isFromRecordPage) {
            return;
        } else {
            getProject({projectId: this.recordId}).then((response) => {
                if (response) {
                    this.projectClassification = response.ProjectClassification__c;
                    this.projectClassificationSubtype = response.ProjectClassificationSubtype__c;
                    this.projectComplexity = response.Complexity__c;
                    this.projectPhase = response.ProjectPhase__c;
                    this.isPackDevelopmentManagerContacted = response.IsPackDevelopmentManagerContacted__c;
                    this.isApprovedByLegalAndRegPrimos = response.IsApprovedByLegalAndRegPrimos__c;
                    this.isGiftBoxException = response.IsGiftBoxException__c;
                    this.giftBoxExceptionComment = response.GiftBoxExceptionComment__c;
                    this.hasPLConfirmedChecklist = response.HasPLConfirmedChecklist__c;
                }
            }).catch((error) => {
                console.error(error);
            })
        }
    }

    handleValuesChange(event) {
        this.isPackDevelopmentManagerContacted = event.detail?.isPackDevelopmentManagerContacted;
        this.isApprovedByLegalAndRegPrimos = event.detail?.isApprovedByLegalAndRegPrimos;
        this.isGiftBoxException = event.detail?.isGiftBoxException;
        this.giftBoxExceptionComment = event.detail?.giftBoxExceptionComment;
        this.hasPLConfirmedChecklist = event.detail?.hasPLConfirmedChecklist;
    }
}