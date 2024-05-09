import {LightningElement, api, wire} from 'lwc';
import NAME_HELP_TEXT_LABEL from '@salesforce/label/c.Project_Name_Info_Text';
import NAME_PLACEHOLDER_LABEL from '@salesforce/label/c.Project_Name_Placeholder';
import {publish, MessageContext, subscribe} from 'lightning/messageService';
import MESSAGE_CHANNEL from '@salesforce/messageChannel/helpTextChannel__c';

export default class ProjectNameInput extends LightningElement {
    label = ' Name';
    infotext = NAME_HELP_TEXT_LABEL;
    placeholder = NAME_PLACEHOLDER_LABEL;
    @api projectName;
    @api selectedProjectName;

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        this.subscribeToMessageChannel();
        this.selectedProjectName = this.projectName;
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

    onProjectNameChange(event) {
        this.selectedProjectName = event.currentTarget.value;
    }
}