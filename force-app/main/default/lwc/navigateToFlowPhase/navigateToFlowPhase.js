import { LightningElement, wire, api  } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import messageChannel from '@salesforce/messageChannel/messageChannel__c';

export default class NavigateToFlowPhase extends LightningElement {
    @api projectId;
    @api phase;
    @wire(MessageContext)
    messageContext;
    connectedCallback(){
        console.log('in Navigate to Flow Phase')
        console.log(this.phase);
        const payload = {phase : this.phase, projectId : this.projectId};
        publish(this.messageContext, messageChannel, payload)
    }
}