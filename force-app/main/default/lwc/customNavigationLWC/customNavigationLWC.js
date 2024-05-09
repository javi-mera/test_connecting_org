import { LightningElement, api, wire } from 'lwc';
import { FlowNavigationBackEvent,FlowNavigationNextEvent } from "lightning/flowSupport";
import { publish, MessageContext } from 'lightning/messageService';
import messageChannel from '@salesforce/messageChannel/messageChannel__c';
import {NavigationMixin} from "lightning/navigation";

export default class CustomNavigationLWC extends NavigationMixin(LightningElement) {
    AVAILABLE_ACTIONS = ["BACK","NEXT"];
    @api isCreation; 
    @api recordId;
    @api navigateTo;
    @api isCloseClicked;
    @api isPPMUser;
    @wire(MessageContext)
    messageContext;

    handleNext() {
      if (this.AVAILABLE_ACTIONS.find((action) => action === "NEXT")) {
          console.log('in next')
        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);
      }
    }
    handleClose() {
      if (this.AVAILABLE_ACTIONS.find((action) => action === "NEXT")) {
        this.isCloseClicked = true;
        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);
          if (this.isPPMUser) {
              this.handlePPMClose();
          }
      }
    }
    handleBack() {
      if (this.AVAILABLE_ACTIONS.find((action) => action === "BACK")) {
          if(this.navigateTo){
              const payload = {phase : this.navigateTo, projectId : this.recordId};
              publish(this.messageContext, messageChannel, payload);
          }else{
              const navigateBackEvent = new FlowNavigationBackEvent();
              this.dispatchEvent(navigateBackEvent);
          }
      }
    }

    handlePPMClose() {
        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                objectApiName: "Project__c",
                actionName: "view",
                recordId: this.recordId
            }
        });
        // if (this.AVAILABLE_ACTIONS.find((action) => action === "NEXT")) {
        //     console.log('in PPM Save')
        //     const navigateNextEvent = new FlowNavigationNextEvent();
        //     this.dispatchEvent(navigateNextEvent);
        // }
    }

    // handlePPMSave() {
    //     if (this.AVAILABLE_ACTIONS.find((action) => action === "NEXT")) {
    //         console.log('in PPM Save')
    //         const navigateNextEvent = new FlowNavigationNextEvent();
    //         this.dispatchEvent(navigateNextEvent);
    //     }
    // }
}