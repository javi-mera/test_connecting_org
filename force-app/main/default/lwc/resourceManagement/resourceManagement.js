import {LightningElement, api, wire, track} from "lwc";
import {NavigationMixin} from "lightning/navigation";

import FTEPM from "@salesforce/schema/Project__c.FTEPM__c";
import IS_PM_DEDICATED from "@salesforce/schema/Project__c.IsPMdedicated__c";
import FTE_PACK_DEV from "@salesforce/schema/Project__c.FTEPackDev__c";
import FTE_LIQUID from "@salesforce/schema/Project__c.FTELiquid__c";
import FTE_GRAPHICS from "@salesforce/schema/Project__c.FTEGraphics__c";
import RESOURCE_COMMENT from "@salesforce/schema/Project__c.ResourcesComments__c";

import COST from "@salesforce/schema/Project__c.Cost__c";
import CAPEX from "@salesforce/schema/Project__c.Capex__c";

import PROJECT_MANAGEMENT_COMPLEXITY from "@salesforce/schema/Project__c.ProjectManagementComplexity__c";
import TECHNICAL_FEASIBILTY_LIQUID from "@salesforce/schema/Project__c.TechnicalFeasibilityLiquid__c";
import TECHNICAL_FEASIBILTY_PACK from "@salesforce/schema/Project__c.TechnicalFeasibilityPackDev__c";
import COMPLEXITY_COMMENT from "@salesforce/schema/Project__c.ComplexityComments__c";

import TIMINGRISK from "@salesforce/schema/Project__c.TimingRisk__c";
import TECHNICALRISK from "@salesforce/schema/Project__c.TechnicalRisk__c";
import COSTRISK from "@salesforce/schema/Project__c.CostRisk__c";
import RISKCOMMENT from "@salesforce/schema/Project__c.RiskComments__c";
const PROJECT_OBJECT = "Project__c";

export default class ResourceManagement extends NavigationMixin(LightningElement) {
    @api recordId;
    @api isFlow;
    @api isProjectSnapshot;
    error;
    currentObject = PROJECT_OBJECT;
    FTEPMField = FTEPM;
    isPMDedicatedField = IS_PM_DEDICATED;
    FTEPackDevField = FTE_PACK_DEV;
    FTELiquidField = FTE_LIQUID;
    FTEGraphicsField = FTE_GRAPHICS;
    resourceCommentField = RESOURCE_COMMENT;
    costField = COST;
    capexField = CAPEX;

    projectManagementComplexityField = PROJECT_MANAGEMENT_COMPLEXITY;
    technicalFeasibilityLiquidField = TECHNICAL_FEASIBILTY_LIQUID;
    technicalFeasibilityPackDevField = TECHNICAL_FEASIBILTY_PACK;
    complexityCommentsField = COMPLEXITY_COMMENT;
    timingRiskField = TIMINGRISK;
    technicalRiskField = TECHNICALRISK;
    costRiskField = COSTRISK;
    riskCommentField = RISKCOMMENT;

    @api FTEPMValue;
    @api isPMDedicatedValue;
    @api FTEPackDevValue;
    @api FTELiquidValue;
    @api FTEGraphicsValue;
    @api resourceCommentValue;
    @api costValue;
    @api capexValue;

    @api projectManagementComplexity;
    @api technicalFeasibilityLiquid;
    @api technicalFeasibilityPackDev;
    @api complexityComment;
    @api timingRisk;
    @api technicalRisk;
    @api costRisk;
    @api riskComment;

    projectComplexity = 0;
    projectRisk = 0;
    isFormLoaded = false;

    handleOnLoad(event) {
        let record = event.detail.records;
        let fields = record[this.recordId].fields;
        this.FTEPMValue = fields.FTEPM__c?.value;
        this.isPMDedicatedValue = fields.IsPMdedicated__c?.value;
        this.FTEPackDevValue = fields.FTEPackDev__c?.value;
        this.FTELiquidValue = fields.FTELiquid__c?.value;
        this.FTEGraphicsValue = fields.FTEGraphics__c?.value;
        this.resourceCommentValue = fields.ResourcesComments__c?.value;
        this.costValue = fields.Cost__c?.value;
        this.capexValue = fields.Capex__c?.value;
        this.projectManagementComplexity = fields.ProjectManagementComplexity__c?.value;
        this.technicalFeasibilityLiquid = fields.TechnicalFeasibilityLiquid__c?.value;
        this.technicalFeasibilityPackDev = fields.TechnicalFeasibilityPackDev__c?.value;
        this.timingRisk = fields.TimingRisk__c?.value;
        this.technicalRisk = fields.TechnicalRisk__c?.value;
        this.costRisk = fields.CostRisk__c?.value;
        this.complexityComment = fields.ComplexityComments__c?.value;
        this.riskComment = fields.RiskComments__c?.value;
        this.calculateProjectComplexity();
        this.calculateProjectRisk();
        this.isFormLoaded = true;
    }

    calculateProjectComplexity() {
        this.projectComplexity = Math.max(this.projectManagementComplexity, this.technicalFeasibilityLiquid, this.technicalFeasibilityPackDev);
    }

    calculateProjectRisk() {
        this.projectRisk = Math.max(this.timingRisk, this.technicalRisk, this.costRisk);
    }

    onProjectComplexityChange(event) {
        let isComplexityOrRiskField = false;

        switch (event.target.fieldName) {
            case FTEPM.fieldApiName:
                this.FTEPMValue = event.target.value === '' ? null : event.target.value;
                break;
            case IS_PM_DEDICATED.fieldApiName:
                this.isPMDedicatedValue = event.target.value;
                break;
            case FTE_PACK_DEV.fieldApiName:
                this.FTEPackDevValue = event.target.value === '' ? null : event.target.value;
                break;
            case FTE_LIQUID.fieldApiName:
                this.FTELiquidValue = event.target.value === '' ? null : event.target.value;
                break;
            case FTE_GRAPHICS.fieldApiName:
                this.FTEGraphicsValue = event.target.value === '' ? null : event.target.value;
                break;
            case RESOURCE_COMMENT.fieldApiName:
                this.resourceCommentValue = event.target.value;
                break;
            case COST.fieldApiName:
                this.costValue = event.target.value === '' ? null : event.target.value;
                break;
            case CAPEX.fieldApiName:
                this.capexValue = event.target.value === '' ? null : event.target.value;
                break;
            case PROJECT_MANAGEMENT_COMPLEXITY.fieldApiName:
                this.projectManagementComplexity = event.target.value === '' ? null : event.target.value;
                isComplexityOrRiskField = true;
                break;
            case TECHNICAL_FEASIBILTY_LIQUID.fieldApiName:
                this.technicalFeasibilityLiquid = event.target.value === '' ? null : event.target.value;
                isComplexityOrRiskField = true;
                break;
            case TECHNICAL_FEASIBILTY_PACK.fieldApiName:
                this.technicalFeasibilityPackDev = event.target.value === '' ? null : event.target.value;
                isComplexityOrRiskField = true;
                break;
            case TIMINGRISK.fieldApiName:
                this.timingRisk = event.target.value === '' ? null : event.target.value;
                isComplexityOrRiskField = true;
                break;
            case TECHNICALRISK.fieldApiName:
                this.technicalRisk = event.target.value === '' ? null : event.target.value;
                isComplexityOrRiskField = true;
                break;
            case COSTRISK.fieldApiName:
                this.costRisk = event.target.value === '' ? null : event.target.value;
                isComplexityOrRiskField = true;
                break;
        }

        if (isComplexityOrRiskField) {
            this.calculateProjectComplexity();
            this.calculateProjectRisk();
        }
    }

    onComplexityCommentChange(event) {
        this.complexityComment = event.target.value;
    }

    onRiskCommentChange(event) {
        this.riskComment = event.target.value;
    }

    handlePPMSave() {
        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                objectApiName: this.currentObject,
                actionName: "view",
                recordId: this.recordId
            }
        });
    }
}