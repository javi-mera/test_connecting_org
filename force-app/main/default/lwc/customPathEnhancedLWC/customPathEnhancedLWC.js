import { LightningElement, wire, api } from "lwc";
import PATH_CURSOR from "@salesforce/resourceUrl/pathCursor";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

import PHASE_FIELD from "@salesforce/schema/Project__c.ProjectPhase__c";
import DECISION_STEP_STATUS_FIELD from "@salesforce/schema/Project__c.SubmissionStatus__c";
import PROJECT_CLASSIFICATION from "@salesforce/schema/Project__c.ProjectClassification__c";
import PROJECT_COMPLEXITY from "@salesforce/schema/Project__c.Complexity__c";
import PROJECT_STATUS from "@salesforce/schema/Project__c.ProjectStatus__c";
import {
  ALL_PHASES,
  PHASES_DEFINE_AND_DIAGNOSE,
  PHASES_DEFINE_DEPLOY_AND_DIAGNOSE,
  PHASES_DEFINE_AND_DEVELOP_AND_DIAGNOSE,
  PHASES_WITHOUT_DEVELOP,
  PHASES_WITHOUT_DISCOVER,
  PHASES_WITHOUT_DISCOVER_AND_DEVELOP,
  PHASES_DEFINE_AND_DEVELOP_AND_DEPLOY_AND_DIAGNOSE
} from "./phases";
const fields = [
  PHASE_FIELD,
  DECISION_STEP_STATUS_FIELD,
  PROJECT_CLASSIFICATION,
  PROJECT_COMPLEXITY,
  PROJECT_STATUS
];

const DEFINE_PHASE = "Define";
const DESIGN_PHASE = "Design";
const DEVELOP_PHASE = "Develop";
const DEPLOY_PHASE = "Deploy";
const DIAGNOSE_PHASE = "Diagnose";
const DECISION_STEP_STATUS_BUSINESS_CASE_AMBITION_SUBMITTED = "Business Case Ambition Submitted";
const DECISION_STEP_STATUS_BUSINESS_CASE_AMBITION_REJECTED = "Business Case Ambition Rejected";
const DECISION_STEP_STATUS_BUSINESS_CASE_VALIDATION_SUBMITTED = "Business Case Validation Submitted";
const DECISION_STEP_STATUS_BUSINESS_CASE_VALIDATION_REJECTED = "Business Case Validation Rejected";
const DECISION_STEP_STATUS_COMMERCIAL_MILESTONE_SUBMITTED = "Commercial Milestone Submitted";
const DECISION_STEP_STATUS_COMMERCIAL_MILESTONE_REJECTED = "Commercial Milestone Rejected";

const PROJECT_CLASSIFICATION_FEARLESS_BET = "Fearless Bet";
const PROJECT_CLASSIFICATION_BUSINESS_ENABLER = "Business Enabler";
const PROJECT_CLASSIFICATION_BRAND_ENERGIZER = "Brand Energizer";
const PROJECT_CLASSIFICATION_GEO_EXTENSION = "Geographical Extension";
const PROJECT_CLASSIFICATION_REPACK = "Repack";
const PROJECT_CLASSIFICATION_PROMOTIONAL_PACK = "Promotional Pack";
const PROJECT_CLASSIFICATION_MANDATORY = "Mandatory";
const PROJECT_CLASSIFICATION_CI = "Continuous Improvement";

const PROJECT_COMPLEXITY_MEDIUM = "Medium";
const PROJECT_COMPLEXITY_LOW = "Low";

const PROJECT_STATUS_COMPLETED = "Completed";

const CSS_CLASS_BOX = "slds-col box slds-align_absolute-center";
const CSS_CLASS_TEXT = "slds-col textBox slds-align_absolute-center";
const CSS_CLASS_COMPLETED_BOX = " completedBox";
const CSS_CLASS_COMPLETED_TEXT = " completedTextBox";
const CSS_CLASS_PENDING_BOX = " pendingBox";
const CSS_CLASS_PENDING_TEXT = " pendingTextBox";
const CSS_CLASS_CURRENT_BOX = " currentBox";
const CSS_CLASS_CURRENT_TEXT = " currentTextBox";
const CSS_CLASS_TEXT_EDIT_FLOW = " textBoxFontEditFlow";
const CSS_CLASS_BOX_EDIT_FLOW = " boxFontEditFlow";

const CSS_CLASS_VISIBLE = "visible";
const CSS_CLASS_VISIBLE_EDIT_FLOW = "visibleEditFlow";
const CSS_CLASS_NOT_VISIBLE = "notVisible";

export default class CustomPathEnhancedLWC extends LightningElement {
  pathCursorURL = PATH_CURSOR;
  bcaSubmitted = "";
  bcvSubmitted = "";
  allPhasesLength = ALL_PHASES.length;

  @api recordId;
  @api isFlow;
  @wire(getRecord, { recordId: "$recordId", fields }) project;

  get projectPhase() {
    return getFieldValue(this.project.data, PHASE_FIELD);
  }

  get projectDecisionStepStatus() {
    return getFieldValue(this.project.data, DECISION_STEP_STATUS_FIELD);
  }

  get projectClassificaiton() {
    return getFieldValue(this.project.data, PROJECT_CLASSIFICATION);
  }

  get projectComplexity() {
    return getFieldValue(this.project.data, PROJECT_COMPLEXITY);
  }

  get projectStatus() {
    return getFieldValue(this.project.data, PROJECT_STATUS);
  }

  get isComponentVisible() {
    let isVisible = false;
    if (
      this.projectClassificaiton === PROJECT_CLASSIFICATION_FEARLESS_BET ||
      this.projectClassificaiton === PROJECT_CLASSIFICATION_BUSINESS_ENABLER ||
      //For other project types aside fro the above, We set the complexity when we know the classification subtype.
      //At that point we know the differente phases it will have and we can display the component
      this.projectClassificaiton === PROJECT_CLASSIFICATION_BRAND_ENERGIZER ||
      this.projectClassificaiton === PROJECT_CLASSIFICATION_REPACK ||
      this.projectComplexity !== null
    ) {
      isVisible = true;
    }
    return isVisible;
  }

  get projectPathType() {
    let pathType = "allPhases";
    if (
      this.projectClassificaiton === PROJECT_CLASSIFICATION_BUSINESS_ENABLER
    ) {
      pathType = "noDiscover";
    } else if (
      this.projectClassificaiton === PROJECT_CLASSIFICATION_REPACK &&
      this.projectComplexity === PROJECT_COMPLEXITY_MEDIUM
    ) {
      pathType = "noDevelop";
    } else if (
      (this.projectClassificaiton === PROJECT_CLASSIFICATION_PROMOTIONAL_PACK &&
        this.projectComplexity === PROJECT_COMPLEXITY_MEDIUM) ||
      (this.projectClassificaiton === PROJECT_CLASSIFICATION_CI &&
        this.projectComplexity === PROJECT_COMPLEXITY_MEDIUM) ||
        (this.projectClassificaiton === PROJECT_CLASSIFICATION_MANDATORY &&
        this.projectComplexity === PROJECT_COMPLEXITY_MEDIUM)
    ) {
      pathType = "noDiscoverNoDevelop";
    } else if (
      this.projectClassificaiton === PROJECT_CLASSIFICATION_PROMOTIONAL_PACK &&
      this.projectComplexity === PROJECT_COMPLEXITY_LOW
    ) {
      pathType = "define+Deploy+Diagnose";
    } else if (
      (this.projectClassificaiton === PROJECT_CLASSIFICATION_GEO_EXTENSION &&
        this.projectComplexity === PROJECT_COMPLEXITY_LOW)
    ) {
      pathType = "define+Develop+Diagnose";
    } else if (
      (this.projectClassificaiton === PROJECT_CLASSIFICATION_GEO_EXTENSION &&
        this.projectComplexity === PROJECT_COMPLEXITY_MEDIUM)
    ) {
      pathType = "define+Develop+Deploy+Diagnose";
    } else if (
      (this.projectClassificaiton === PROJECT_CLASSIFICATION_CI &&
        this.projectComplexity === PROJECT_COMPLEXITY_LOW) ||
      (this.projectClassificaiton === PROJECT_CLASSIFICATION_MANDATORY &&
        this.projectComplexity === PROJECT_COMPLEXITY_LOW)
    ) {
      pathType = "define+Diagnose";
    }
    return pathType;
  }

  get isVisibleAllPhases() {
    return this.projectPathType === "allPhases";
  }

  get isVisibileNoDiscover() {
    return this.projectPathType === "noDiscover";
  }

  get isVisibileNoDefine() {
    return this.projectPathType === "noDefine";
  }

  get isVisibileNoDevelop() {
    return this.projectPathType === "noDevelop";
  }

  get isVisibleNoDiscoverNoDevelop() {
    return this.projectPathType === "noDiscoverNoDevelop";
  }

  get isVisibleDefineAndDesignAndDiagnose() {
    return this.projectPathType === "define+Deploy+Diagnose";
  }

  get isVisibleDefineAndDevelopAndDiagnose() {
    return this.projectPathType === "define+Develop+Diagnose";
  }

  get isVisibleDefineAndDiagnose() {
    return this.projectPathType === "define+Diagnose";
  }

  get currentStatus() {
    let phaseNumber = 1;
    if (
      this.projectPhase === DEFINE_PHASE &&
      this.projectDecisionStepStatus !==
        DECISION_STEP_STATUS_BUSINESS_CASE_AMBITION_SUBMITTED &&
      this.projectDecisionStepStatus !==
        DECISION_STEP_STATUS_BUSINESS_CASE_AMBITION_REJECTED
    ) {
      phaseNumber = 3;
    } else if (
      this.projectPhase === DEFINE_PHASE &&
      (this.projectDecisionStepStatus ===
        DECISION_STEP_STATUS_BUSINESS_CASE_AMBITION_SUBMITTED ||
        this.projectDecisionStepStatus ===
          DECISION_STEP_STATUS_BUSINESS_CASE_AMBITION_REJECTED)
    ) {
      phaseNumber = 4;
    } else if (
      this.projectPhase === DESIGN_PHASE &&
      this.projectDecisionStepStatus !==
        DECISION_STEP_STATUS_BUSINESS_CASE_VALIDATION_SUBMITTED &&
      this.projectDecisionStepStatus !==
        DECISION_STEP_STATUS_BUSINESS_CASE_VALIDATION_REJECTED
    ) {
      phaseNumber = 5;
    } else if (
      this.projectPhase === DESIGN_PHASE &&
      (this.projectDecisionStepStatus ===
        DECISION_STEP_STATUS_BUSINESS_CASE_VALIDATION_SUBMITTED ||
            this.projectDecisionStepStatus ===
          DECISION_STEP_STATUS_BUSINESS_CASE_VALIDATION_REJECTED)
    ) {
      phaseNumber = 6;
    } else if (
      this.projectPhase === DEVELOP_PHASE &&
      this.projectDecisionStepStatus !==
        DECISION_STEP_STATUS_COMMERCIAL_MILESTONE_SUBMITTED &&
      this.projectDecisionStepStatus !==
        DECISION_STEP_STATUS_COMMERCIAL_MILESTONE_REJECTED) {
      phaseNumber = 7;
    } else if (
      this.projectPhase === DEVELOP_PHASE &&
      (this.projectDecisionStepStatus ===
        DECISION_STEP_STATUS_COMMERCIAL_MILESTONE_SUBMITTED ||
            this.projectDecisionStepStatus ===
            DECISION_STEP_STATUS_COMMERCIAL_MILESTONE_REJECTED)
    ) {
      phaseNumber = 8;
    } else if (this.projectPhase === DEPLOY_PHASE) {
      phaseNumber = 9;
    } else if (
      this.projectPhase === DIAGNOSE_PHASE &&
      this.projectStatus !== PROJECT_STATUS_COMPLETED
    ) {
      phaseNumber = 11;
    } else if (
      this.projectPhase === DIAGNOSE_PHASE &&
      this.projectStatus === PROJECT_STATUS_COMPLETED
    ) {
      phaseNumber = 12;
    }
    return phaseNumber;
  }

  get discoverClass() {
    return this.getBoxCSSBasedOnPosition(1);
  }

  get opportunityClass() {
    return this.getCSSTextBasedOnPosition(2);
  }

  get defineClass() {
    return this.getBoxCSSBasedOnPosition(3);
  }

  get bcaClass() {
    if (this.currentStatus === 4) {
      this.bcaSubmitted = " submitted";
    } else {
      this.bcaSubmitted = "";
    }
    return this.getCSSTextBasedOnPosition(4);
  }

  get designClass() {
    return this.getBoxCSSBasedOnPosition(5);
  }

  get bcvClass() {
    if (this.currentStatus === 6) {
      this.bcvSubmitted = " submitted";
    } else {
      this.bcvSubmitted = "";
    }
    return this.getCSSTextBasedOnPosition(6);
  }

  get developClass() {
    return this.getBoxCSSBasedOnPosition(7);
  }

  get commercialClass() {
    return this.getCSSTextBasedOnPosition(8);
  }

  get deployClass() {
    return this.getBoxCSSBasedOnPosition(9);
  }

  get productionClass() {
    return this.getCSSTextBasedOnPosition(10);
  }

  get diagnoseClass() {
    return this.getBoxCSSBasedOnPosition(11);
  }

  getBoxCSSBasedOnPosition(position) {
    let extra =
      this.currentStatus > position
        ? CSS_CLASS_COMPLETED_BOX
        : CSS_CLASS_PENDING_BOX;
    if (this.currentStatus === position) {
      extra = CSS_CLASS_CURRENT_BOX;
    }
    if (this.isFlow) {
      extra += CSS_CLASS_BOX_EDIT_FLOW;
    }
    return CSS_CLASS_BOX + extra;
  }

  getCSSTextBasedOnPosition(position) {
    let extra =
      this.currentStatus > position
        ? CSS_CLASS_COMPLETED_TEXT
        : CSS_CLASS_PENDING_TEXT;
    if (this.currentStatus === position) {
      extra = CSS_CLASS_CURRENT_TEXT;
    }
    if (this.isFlow) {
      extra += CSS_CLASS_TEXT_EDIT_FLOW;
    }
    return CSS_CLASS_TEXT + extra;
  }

  get discoverCursor1() {
    return this.getCursorCSSBasedOnPosition(this.currentStatus, 1);
  }

  get discoverCursor2() {
    return this.getCursorCSSBasedOnPosition(this.currentStatus, 2);
  }

  get discoverCursor3() {
    return this.getCursorCSSBasedOnPosition(this.currentStatus, 3);
  }

  get discoverCursor4() {
    return this.getCursorCSSBasedOnPosition(this.currentStatus, 4);
  }

  get discoverCursor5() {
    return this.getCursorCSSBasedOnPosition(this.currentStatus, 5);
  }

  get discoverCursor6() {
    return this.getCursorCSSBasedOnPosition(this.currentStatus, 6);
  }

  get discoverCursor7() {
    return this.getCursorCSSBasedOnPosition(this.currentStatus, 7);
  }

  get discoverCursor8() {
    return this.getCursorCSSBasedOnPosition(this.currentStatus, 8);
  }

  get discoverCursor9() {
    return this.getCursorCSSBasedOnPosition(this.currentStatus, 9);
  }

  get discoverCursor10() {
    return this.getCursorCSSBasedOnPosition(this.currentStatus, 10);
  }

  get discoverCursor11() {
    return this.getCursorCSSBasedOnPosition(this.currentStatus, 11);
  }

  getCursorCSSBasedOnPosition(currentNumber, position) {
    let css = CSS_CLASS_NOT_VISIBLE;
    if (currentNumber === position && this.isFlow) {
      css = CSS_CLASS_VISIBLE_EDIT_FLOW;
    } else if (currentNumber === position && !this.isFlow) {
      css = CSS_CLASS_VISIBLE;
    }
    return css;
  }

  get phases() {
    switch (this.projectPathType) {
      case "allPhases":
        return this.mapPhases(ALL_PHASES);
      case "noDiscover":
        return this.mapPhases(PHASES_WITHOUT_DISCOVER);
      case "noDevelop":
        return this.mapPhases(PHASES_WITHOUT_DEVELOP);
      case "noDiscoverNoDevelop":
        return this.mapPhases(PHASES_WITHOUT_DISCOVER_AND_DEVELOP);
      case "define+Deploy+Diagnose":
        return this.mapPhases(PHASES_DEFINE_DEPLOY_AND_DIAGNOSE);
      case "define+Develop+Diagnose":
        return this.mapPhases(PHASES_DEFINE_AND_DEVELOP_AND_DIAGNOSE);
      case "define+Develop+Deploy+Diagnose":
        return this.mapPhases(PHASES_DEFINE_AND_DEVELOP_AND_DEPLOY_AND_DIAGNOSE);
      case "define+Diagnose":
        return this.mapPhases(PHASES_DEFINE_AND_DIAGNOSE);
      default:
        return [];
    }
  }

  mapPhases(phases) {
    const newPhases = JSON.parse(JSON.stringify(phases));
    newPhases.map((phase) => {
      phase.class = this[phase.class];
      phase.cursor = this[phase.cursor];
      return phase;
    });
    const missingEmpty = this.allPhasesLength - newPhases.length;
    for (let index = 0; index < missingEmpty; index++) {
      newPhases.push({
        isEmpty: true,
        key: `phase-${index}`
      });
    }
    return newPhases;
  }

  get outsideClass() {
    return this.isFlow
      ? "slds-grid slds-card slds-p-top_x-small slds-p-left_small slds-p-right_small firstRowEditFlow"
      : "slds-grid slds-card slds-p-around_large firstRow";
  }

  get outsideCursorClass() {
    return this.isFlow
      ? "slds-grid slds-p-left_small slds-p-right_small secondRowEditFlow"
      : "slds-grid slds-p-left_large slds-p-right_large secondRow";
  }
}