import {LightningElement, api, wire} from "lwc";
import { loadStyle } from "lightning/platformResourceLoader";
import LIGHTNING_STATIC_RESOURCE_PATH from "@salesforce/resourceUrl/FileUploadStyles";
import {constants} from 'c/utils';
import {getFieldValue, getRecord} from "lightning/uiRecordApi";

export default class CustomPathStages extends LightningElement {
  @api current;
  @api projectType;
  @api subType;
  @api geoExtensionSubType;
  @api phase;
  @api projectId;
  @api isAdmin;
  @api areTimingsAvailable;

  phaseClicked = "";

  connectedCallback() {
    loadStyle(
      this,
      LIGHTNING_STATIC_RESOURCE_PATH + "/global-header_css.css"
    ).then(() => {});
  }
  renderedCallback() {
    this.template
      .querySelector("[data-id='" + this.current + "']")?.classList.add("readonlyPath");
  }

  get isOverviewVisible() {
    return true;
  }

  get isProductisible() {
    return true;
  }

  get isGeographyVisible() {
    return true;
  }

  get isFinancialsVisible() {
    return (
      (this.projectType === constants.CONST_GEO_EXTENSION_NAME && this.geoExtensionSubType === constants.CONST_INNOVATION_GEO_EXT_API_NAME) ||
      (this.projectType !== constants.CONST_GEO_EXTENSION_NAME && !(this.projectType === constants.CONST_REPACK_NAME && this.phase === "1")) ||
      (this.projectType === constants.CONST_PROMOTIONAL_PACK_NAME && this.subType !== constants.CONST_NECK_TAG_NAME)
    );
  }

  get isAttachmentsVisible() {
    return true;
  }

  get isTaskListVisible() {
    return true;
  }

  get isResourceMgtVisible() {
    return this.isAdmin;
  }

  get isTimingsVisible() {
    return this.projectType !== constants.CONST_CI_NAME && this.projectType !== constants.CONST_MANDATORY_NAME && this.projectType !== constants.CONST_PROMOTIONAL_PACK_NAME && this.areTimingsAvailable;
  }

  get isChecklistVisible() {
    return this.projectType === constants.CONST_PROMOTIONAL_PACK_NAME;
  }

  fireEvent() {
    const phaseClickedEvent = new CustomEvent("phaseclicked", {
      detail: this.phaseClicked
    });
    this.dispatchEvent(phaseClickedEvent);
  }
  onclickOverview() {
    if (this.phaseClicked === "") {
      this.phaseClicked = "Overview";
      this.fireEvent();
    }
  }
  onclickProduct() {
    if (this.phaseClicked === "") {
      this.phaseClicked = "Product";
      this.fireEvent();
    }
  }
  onclickGeography() {
    if (this.phaseClicked === "") {
      this.phaseClicked = "Geography";
      this.fireEvent();
    }
  }
  onclickFinancials() {
    if (this.phaseClicked === "") {
      this.phaseClicked = "Financials";
      this.fireEvent();
    }
  }
  onclickAttachments() {
    if (this.phaseClicked === "") {
      this.phaseClicked = "Attachments";
      this.fireEvent();
    }
  }
  onclickResourceMgt() {
    if (this.phaseClicked === "") {
      this.phaseClicked = "ResourceMgt";
      this.fireEvent();
    }
  }
  onclickTimings() {
    if (this.phaseClicked === "") {
      this.phaseClicked = "Timings";
      this.fireEvent();
    }
  }
  onclickChecklist() {
    if (this.phaseClicked === "") {
      this.phaseClicked = "Checklist";
      this.fireEvent();
    }
  }
}