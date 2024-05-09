import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { constants } from 'c/utils';

const PROJECT_CLASSIFICATION_TO_INFO_MAP = {
    'Fearless Bet': `${constants.CONST_FEARLESS_BET_LABEL}`,
    'Brand Energizer': `${constants.CONST_BRAND_ENERGIZER_LABEL}`,
    'Business Enabler': `${constants.CONST_BUSINESS_ENABLER_LABEL}`,
    'Geographical Extension': `a ${constants.CONST_GEOGRAPHICAL_EXTENSION_LABEL}`,
    'Promotional Pack': `${constants.CONST_PROMOTIONAL_PACK_LABEL}`,
    'Repack': `${constants.CONST_REPACK_LABEL}`
}

const PROJECT_CLASSIFICATIONS = [
    'Fearless Bet',
    'Brand Energizer',
    'Business Enabler',
    'Geographical Extension',
    'Promotional Pack',
    'Repack'
];

const fields = [
    constants.CONST_PROJECT_CLASSIFICATION,
    constants.CONST_PROJECT_CLASSIFICATION_SUBTYPE,
    constants.CONST_PROJECT_PHASE
];

export default class ProjectThresholdInfoBox extends LightningElement {
    @api recordId;
    @api isTimings;
    @api timingsProjectClassification;
    @api showVAPWarningMessage = false;

    timingsInfo = constants.CONST_TIMINGS_INFO_LABEL;
    dateFormatInfo = constants.CONST_TIMINGS_DATE_FORMAT_INFO_LABEL;
    vapWarningMessage = constants.CONST_VAP_EXPECTED_PRICE_WARNING_MESSAGE_LABEL;
    timingsWarning;

    @wire(getRecord, { recordId: '$recordId', fields })
    project;

    get projectClassification() {
        const value = getFieldValue(this.project.data, constants.CONST_PROJECT_CLASSIFICATION);
        return value;
    }

    get projectClassificationSubtype() {
        const value = getFieldValue(this.project.data, constants.CONST_PROJECT_CLASSIFICATION_SUBTYPE);
        return value;
    }

    get isCorrectProjectClassification() {
        return !this.isTimings && PROJECT_CLASSIFICATIONS.includes(this.projectClassification);
    }

    get thresholdInfo() {
        return this.isCorrectProjectClassification ? PROJECT_CLASSIFICATION_TO_INFO_MAP[this.projectClassification] : null
    }

    get projectPhase() {
        const value = getFieldValue(this.project.data, constants.CONST_PROJECT_PHASE);
        return value;
    }

    get isPromoPackRepeatOrLimitedOrValueAddedPack() {
        return this.showVAPWarningMessage && this.projectClassification === constants.CONST_PROMOTIONAL_PACK_NAME && (this.projectClassificationSubtype === constants.CONST_REPEATING_PROMOTIONAL_PACK_NAME || this.projectClassificationSubtype === constants.CONST_LIMITED_EDITION_PACK || this.projectClassificationSubtype === constants.CONST_VALUE_ADDED_PACK);
    }

    get isTimingsWarningNeeded() {
        this.timingsWarning = this.timingsProjectClassification === constants.CONST_GEO_EXTENSION_NAME ? constants.CONST_TIMINGS_WARNING_GEO_LABEL : constants.CONST_TIMINGS_WARNING_REPACK_LABEL;
        return this.isTimings && (this.projectPhase === constants.CONST_DISCOVER_PHASE || this.projectPhase === constants.CONST_DEFINE_PHASE) &&
            (this.projectClassification === constants.CONST_REPACK_NAME || this.projectClassification === constants.CONST_GEO_EXTENSION_NAME);
    }

}