/* eslint-disable @lwc/lwc/no-api-reassignments */
import {LightningElement, api, wire} from "lwc";
import { loadStyle } from "lightning/platformResourceLoader";
import LIGHTNING_STATIC_RESOURCE_PATH from "@salesforce/resourceUrl/FileUploadStyles";
import { FlowNavigationNextEvent } from "lightning/flowSupport";
import {getRecord} from "lightning/uiRecordApi";
import SAME_MARKET_PROMOTIONAL_PACK_SUBTYPE from '@salesforce/schema/Project__c.IsSameMarketPromotionalPack__c';
import ARE_TIMINGS_AVAILABLE from '@salesforce/schema/Project__c.AreTimingsAvailable__c';

export default class CustomPathLWC extends LightningElement {
  @api current;
  @api phase;
  @api showPhases;
  @api showStages;
  @api showAll;
  @api showPath;
  @api projectType;
  @api projectId;
  @api phaseClicked;
  @api geoExtensionSubType;
  @api subType;
  @api isAdmin;

  isSameMarketPromotionalPack;
  areTimingsAvailable;

  connectedCallback() {
    loadStyle(
      this,
      LIGHTNING_STATIC_RESOURCE_PATH + "/global-header_css.css"
    ).then(() => {
      if (this.showAll !== undefined) {
        this.showPath = false;
      } else {
        this.showPath = true;
      }
    });
  }

    @wire(getRecord, { recordId: '$projectId', fields: [ SAME_MARKET_PROMOTIONAL_PACK_SUBTYPE, ARE_TIMINGS_AVAILABLE ]})
    projectDetails({error, data}) {
        if (data) {
            this.isSameMarketPromotionalPack = data.fields.IsSameMarketPromotionalPack__c?.value;
            this.areTimingsAvailable = data.fields.AreTimingsAvailable__c?.value;
        } else if (error) {
            console.log(error);
        }
    }

  get display() {
    if (!this.showPhases) {
      return "displayNone";
    }
    return "";
  }

  get displayStage() {
    if (this.showPhases != null && !this.showStages) {
      return "displayNone";
    }
    return "";
  }
  goNext() {
    console.log('in go next Custom Path')
    console.log(this.phase)
    const navigateNextEvent = new FlowNavigationNextEvent();
    this.dispatchEvent(navigateNextEvent);
  }
  onPhaseClicked(event) {
    this.phaseClicked = event.detail;
    this.goNext();
  }
}