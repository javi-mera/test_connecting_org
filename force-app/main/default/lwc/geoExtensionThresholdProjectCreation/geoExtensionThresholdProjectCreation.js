import {LightningElement, wire, api} from 'lwc';
import { constants } from 'c/utils';
import { loadStyle } from 'lightning/platformResourceLoader'
import styles from '@salesforce/resourceUrl/projectThresholdInfoBox';
import {publish, MessageContext, subscribe} from 'lightning/messageService';
import MESSAGE_CHANNEL from '@salesforce/messageChannel/helpTextChannel__c';

export default class GeoExtensionThresholdProjectCreation extends LightningElement {

    @wire(MessageContext)
    messageContext;

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

    async connectedCallback() {
        this.subscribeToMessageChannel();
        await loadStyle(this, styles);
    }

    get thresholdInfo() {
        return `A ${constants.CONST_GEOGRAPHICAL_EXTENSION_LABEL}`;
    }

    get geoThresholdIIcon() {
        return `${constants.CONST_GEOGRAPHICAL_EXTENSION_I_ICON_LABEL}`;
    }
}