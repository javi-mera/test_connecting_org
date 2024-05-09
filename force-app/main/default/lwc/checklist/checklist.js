import {api, LightningElement, wire} from 'lwc';
import {constants} from 'c/utils';
import MESSAGE_CHANNEL from '@salesforce/messageChannel/helpTextChannel__c';
import {MessageContext, publish, subscribe} from "lightning/messageService";

export default class Checklist extends LightningElement {
    @api isFromRecordPage;
    @api projectClassification;
    @api projectClassificationSubtype;
    @api projectComplexity;
    @api projectPhase;
    @api isPackDevelopmentManagerContacted;
    @api isApprovedByLegalAndRegPrimos;
    @api isGiftBoxException;
    @api giftBoxExceptionComment;
    @api hasPLConfirmedChecklist;

    packDevManagerPoint = constants.CONST_PACK_DEV_MANAGER_POINT_LABEL;
    packDevManagerConfirmation = constants.CONST_PACK_DEV_MANAGER_CONFIRMATION_LABEL;
    innovationSupplyCommunityLink = constants.CONST_INNOVATION_SUPPLY_COMMUNITY_LINK_LABEL;
    legalRegulatoryApprovalsConfirmation = constants.CONST_LEGAL_REGULATORY_APPROVAL_CONFIRMATION_LABEL;
    legalAndRegsPrimosLink = constants.CONST_LEGAL_AND_REGS_PRIMOS_LINK_LABEL;
    lowPromoPackBCAIntro = constants.CONST_LOW_PROMO_PACK_BCA_INTRO_LABEL;
    mediumPromoPackBCAIntro = constants.CONST_MEDIUM_PROMO_PACK_BCA_INTRO_LABEL;
    mediumPromoPackBCVIntro = constants.CONST_MEDIUM_PROMO_PACK_BCV_INTRO_LABEL;
    mediumPromoPackProductionIntro = constants.CONST_MEDIUM_PROMO_PACK_PRODUCTION_INTRO_LABEL;
    giftBoxPoint = constants.CONST_GIFTBOX_POINT_LABEL;
    giftBoxException = constants.CONST_GIFTBOX_EXCEPTION_LABEL;
    lowPromoPackConfirmation = constants.CONST_LOW_PROMO_PACK_CONFIRMATION_LABEL;
    lowPromoPackProductionIntro = constants.CONST_LOW_PROMO_PACK_PRODUCTION_INTRO_LABEL;

    introTextStyle;

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        this.subscribeToMessageChannel();
        this.introTextStyle = this.isFromRecordPage ? "slds-m-bottom_small margin-top" : "slds-m-bottom_small";
    }

    subscribeToMessageChannel() {
        subscribe(this.messageContext, MESSAGE_CHANNEL, () => {
            this.template.querySelectorAll('c-custom-help-text').forEach((currentElement, index) => {
                currentElement.handleClose();
            })
        });
    }

    @api
    handleHideHelpText() {
        publish(this.messageContext, MESSAGE_CHANNEL, null);
    }

    handleInputOnChange(event) {
        let fieldLabel = event.target.id?.substring(0, event.target.id?.indexOf('-'));
        console.log('fieldLabel ' , fieldLabel)
        if (fieldLabel === 'isPackDevManagerContacted') {
            this.isPackDevelopmentManagerContacted = event.target.checked;
        } else if (fieldLabel === 'isApprovedByLegalRegPrimos') {
            this.isApprovedByLegalAndRegPrimos = event.target.checked;
        } else if (fieldLabel === 'isGiftBoxException') {
            this.isGiftBoxException = event.target.checked;
            this.giftBoxExceptionComment = !this.isGiftBoxException ? '' : this.giftBoxExceptionComment;
        } else if (fieldLabel === 'giftBoxExceptionComment') {
            this.giftBoxExceptionComment = event.target.value;
        } else if (fieldLabel === 'PLConfirmation') {
            this.hasPLConfirmedChecklist = event.target.checked;
        }

        const sendValuesToParentEvent = new CustomEvent("valueschange", {
            detail: {
                isPackDevelopmentManagerContacted: this.isPackDevelopmentManagerContacted,
                isApprovedByLegalAndRegPrimos: this.isApprovedByLegalAndRegPrimos,
                isGiftBoxException: this.isGiftBoxException,
                giftBoxExceptionComment: this.giftBoxExceptionComment,
                hasPLConfirmedChecklist: this.hasPLConfirmedChecklist,
            }
        });

        this.dispatchEvent(sendValuesToParentEvent);
    }

    get isNotDesignPhase() {
        return this.projectPhase !== constants.CONST_DESIGN_PHASE;
    }

    get isRecordPageOrNotDefinePhase() {
        return this.projectPhase !== constants.CONST_DEFINE_PHASE || this.isFromRecordPage;
    }

    get isRecordPageOrNotDesignPhase() {
        return this.projectPhase !== constants.CONST_DESIGN_PHASE || this.isFromRecordPage;
    }

    get isPromoPackDefineOrLow() {
        return this.projectClassification === constants.CONST_PROMOTIONAL_PACK_NAME &&
            (this.projectPhase === constants.CONST_DEFINE_PHASE || this.projectComplexity === constants.CONST_LOW_COMPLEXITY);
    }

    get isMediumPromoPackNotDefine() {
        return this.projectClassification === constants.CONST_PROMOTIONAL_PACK_NAME &&
            this.projectComplexity === constants.CONST_MEDIUM_COMPLEXITY &&
            this.projectPhase !== constants.CONST_DEFINE_PHASE;
    }

    get isLowComplexity() {
        return this.projectComplexity === constants.CONST_LOW_COMPLEXITY;
    }

    get isLowPromoPackNotDefine() {
        return this.projectClassification === constants.CONST_PROMOTIONAL_PACK_NAME &&
            this.projectComplexity === constants.CONST_LOW_COMPLEXITY &&
            this.projectPhase !== constants.CONST_DEFINE_PHASE;
    }

    get isLowPromoPackDefine() {
        return this.projectClassification === constants.CONST_PROMOTIONAL_PACK_NAME &&
            this.projectComplexity === constants.CONST_LOW_COMPLEXITY &&
            this.projectPhase === constants.CONST_DEFINE_PHASE;
    }

    get isMediumComplexity() {
        return this.projectComplexity === constants.CONST_MEDIUM_COMPLEXITY;
    }

    get isPromoPackNeckTag() {
        return this.projectClassification === constants.CONST_PROMOTIONAL_PACK_NAME &&
            this.projectClassificationSubtype === constants.CONST_NECK_TAG_NAME;
    }

    get legalRegulatoryApprovalsPoint() {
        return this.projectComplexity === constants.CONST_LOW_COMPLEXITY ? constants.CONST_LEGAL_REGULATORY_APPROVAL_LOW_POINT_LABEL : constants.CONST_LEGAL_REGULATORY_APPROVAL_MEDIUM_POINT_LABEL;
    }
}