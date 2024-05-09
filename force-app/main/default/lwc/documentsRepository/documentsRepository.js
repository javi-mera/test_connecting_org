import { LightningElement } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import DOC_REPO_CSS from '@salesforce/resourceUrl/DocumentsRepository';
import {constants} from 'c/utils';

export default class DocumentsRepository extends LightningElement {

    title = constants.CONST_HOME_PAGE_DOC_REPO_TITLE_INFO;
    oneMarketingInfo = constants.CONST_HOME_PAGE_ONE_MARKET_INFO;
    trainingInfo = constants.CONST_HOME_PAGE_TRAINING_INFO;
    developmentDocumentsInfo = constants.CONST_HOME_PAGE_DEVELOPMENT_DOCUMENTS_INFO;
    governanceInfo = constants.CONST_HOME_PAGE_GOVERNANCE_INFO;
    submissionCalendarInfo = constants.CONST_HOME_PAGE_SUBMISSION_CALENDAR_INFO;
    connectedCallback() {
        Promise.all([loadStyle(this, DOC_REPO_CSS)]);
    }
}