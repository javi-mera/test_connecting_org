import {api, LightningElement, wire} from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import MESSAGE_CHANNEL from '@salesforce/messageChannel/helpTextChannel__c';

const INFO_TEXT_LABEL = 'Please highlight any critical deviations from what has been aligned at the Business Case Ambition.';

export default class RichText extends LightningElement {
    @api text;
    @api label = '*Summary of Changes from the Business Case Ambition';
    @api richText;
    infotext = INFO_TEXT_LABEL;
    @wire(MessageContext)
    messageContext;

    formats = ['font', 'size', 'bold', 'italic', 'underline',
        'strike', 'list', 'indent', 'align', 'link',
        'image', 'clean', 'table', 'header', 'color','background','code','code-block','script','blockquote','direction'];
    
    connectedCallback() {
        if (this.text != undefined) {
            this.richText = this.text
        } else {
            this.richText = '';
        }
    }

    handleHideHelpText() {
        publish(this.messageContext, MESSAGE_CHANNEL, null);
    }

    handleTextChange(event) {
        this.richText = event.target.value;
    }

    @api validate() {
        this.text = this.richText;
    }
}