import { LightningElement, api } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import LIGHTNING_STATIC_RESOURCE_PATH from '@salesforce/resourceUrl/FileUploadStyles';
import {constants} from 'c/utils';

export default class CustomPathPhases extends LightningElement {
    @api phase;
    @api projectType;
    @api subType;
    @api isSameMarketPromotionalPack;

    connectedCallback(){
        loadStyle(this, LIGHTNING_STATIC_RESOURCE_PATH + '/global-header_css.css').then(() => {});
    }

    get isDiscoverVisible() {
        return this.projectType !== constants.CONST_BUSINESS_ENABLER_NAME &&
                this.projectType !== constants.CONST_GEO_EXTENSION_NAME &&
                this.projectType !== constants.CONST_PROMOTIONAL_PACK_NAME &&
                this.projectType !== constants.CONST_CI_NAME &&
                this.projectType !== constants.CONST_MANDATORY_NAME;
    }

    get isDefineVisible() {
        return true;
    }

    get isDesignVisible() {
        return this.subType !== constants.CONST_IPC_API_NAME &&
                this.subType !== constants.CONST_NECK_TAG_NAME &&
                this.subType !== constants.CONST_REPEATING_PROMOTIONAL_PACK_NAME &&
                this.isSameMarketPromotionalPack === false;
    }

    get isDevelopVisible() {
        return this.projectType !== constants.CONST_PROMOTIONAL_PACK_NAME &&
                this.subType !== constants.CONST_ARTWORK_CHANGE_API_NAME &&
                this.projectType !== constants.CONST_CI_NAME &&
                this.projectType !== constants.CONST_MANDATORY_NAME;
    }

    get isDeployVisible() {
        return this.subType !== constants.CONST_IPC_API_NAME;
    }

    get isDiagnoseVisible() {
        return true;
    }
}