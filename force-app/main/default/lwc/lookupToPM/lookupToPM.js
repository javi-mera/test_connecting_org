import {api, LightningElement, wire} from "lwc";
import apexSearchUser from "@salesforce/apex/LookupUserController.searchPMUsers";
import apexSearchAllUser from "@salesforce/apex/LookupUserController.searchAllPMUsers";
import { publish, subscribe, MessageContext } from "lightning/messageService";
import MESSAGE_CHANNEL from '@salesforce/messageChannel/helpTextChannel__c';

export default class LookupToPM extends LightningElement {
  @api initialSelectionProjectManager = [];
  @api currentPhase;
  @api selectedPM;
  @api projectClassification;
  @api projectSubType;

  @wire(MessageContext)
  messageContext;

  connectedCallback() {
    this.subscribeToMessageChannel();
  }

  subscribeToMessageChannel() {
    subscribe(this.messageContext, MESSAGE_CHANNEL, () => {
      this.template.querySelectorAll('c-lookup').forEach((currentElement, index) => {
        currentElement.getCustomHelpText();
      })
    })
  }

  @api
  handlePublishEvent() {
    publish(this.messageContext, MESSAGE_CHANNEL, null);
  }

  handleSearchProjectManager(event) {
    let lookup = this.template.querySelector("c-lookup");
    if (lookup.getSelection().length === 0) {
      apexSearchUser(event.detail)
        .then((results) => {
          lookup.setSearchResults(results);
        })
        .catch((error) => {
          console.error(error);
        });
    } else {
      lookup.unsetLoading();
      // eslint-disable-next-line no-alert
      alert("You can only select one Project Manager");
    }
  }

  handleSearchAllManagers() {
    let lookup = this.template.querySelector("c-lookup");
    if (lookup.getSelection().length === 0) {
      apexSearchAllUser()
        .then((results) => {
          lookup.setListOfObjects(results);
        })
        .catch((error) => {
          console.error(error);
        });
    }
  }

    @api validate() {
    let lookup = this.template.querySelector("c-lookup");
        let selection = lookup.getSelection();
        this.initialSelectionProjectManager =[];
        if (selection.length > 0) {
            this.initialSelectionProjectManager = selection;
            this.selectedPM = selection[0].id;
        }
       
    }

    get inputLabel() {
    return this.currentPhase !== 2 ||
      (this.currentPhase === 2 &&
        (this.projectClassification === "Continuous Improvement" ||
          this.projectClassification === "Mandatory"))
      ? "* Project Manager"
      : "Project Manager";
    }
}