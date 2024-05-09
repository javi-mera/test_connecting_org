/* Project Classification API Names */
const CONST_CI_API_NAME = 'CI';

/* Project Classification Names */
const CONST_GEO_EXTENSION_NAME = 'Geographical Extension';
const CONST_PROMOTIONAL_PACK_NAME = 'Promotional Pack';
const CONST_BUSINESS_ENABLER_NAME = 'Business Enabler';
const CONST_CI_NAME = 'Continuous Improvement';
const CONST_MANDATORY_NAME = 'Mandatory';
const CONST_REPACK_NAME = 'Repack';
const CONST_FEARLESS_BET_NAME = 'Fearless Bet';
const CONST_BRAND_ENERGIZER_NAME = 'Brand Energizer';

/* Project Classification Subtypes API Names */
const CONST_IPC_API_NAME = 'IPC';
const CONST_IPC_EXTENSION_SUBTYPE_NAME = 'IPC Extension';
const CONST_ARTWORK_CHANGE_API_NAME = 'Artwork Change';
const CONST_PACK_LIQUID_CHANGE_SUBTYPE_NAME = 'Pack/Liquid Change';
const CONST_ARTWORK_CHANGE_ONLY_API_NAME = 'Artwork change only';
const CONST_INNOVATION_GEO_EXT_API_NAME = 'Innovation Geo Extension';
const CONST_NECK_TAG_NAME = 'Neck Tag';
const CONST_REPEATING_PROMOTIONAL_PACK_NAME = 'Repeat of Previous or Existing Promotional Pack';
const CONST_LIMITED_EDITION_PACK = 'Limited Edition Pack';
const CONST_VALUE_ADDED_PACK = 'Value Added Pack';
const CONST_PRIMARY_PACK_CHANGE_NAME = 'Primary pack change';
const CONST_LIQUID_PACK_CHANGE_SUBTYPE_NAME = 'Liq/Sourcing/Pack Change';

/* Phase Descriptions */
const CONST_BUSINESS_CASE_AMBITION_DESCRIPTION = 'Business Case Ambition (BCA)';
const CONST_BCA_SHORT_NAME = 'BCA';
const CONST_BUSINESS_CASE_VALIDATION_DESCRIPTION = 'Business Case Validation (BCV)';
const CONST_BCV_SHORT_NAME = 'BCV';
const CONST_COMMERCIAL_MILESTONE_DESCRIPTION = 'Commercial Milestone';
const CONST_PRODUCTION_MILESTONE_DESCRIPTION = 'Production Milestone';
const CONST_CUSTOMER_MEETING_DESCRIPTION = 'First Customer Meeting';
const CONST_SHIPMENT_DESCRIPTION = 'Shipment';
const CONST_ON_SHELF_DATE_DESCRIPTION = 'On Shelf Date';
const CONST_POST_LAUNCH_REVIEW_DESCRIPTION = 'Post Launch Review';
const CONST_OPPORTUNITY_MILESTONE_DESCRIPTION = 'Opportunity Milestone';

/* Project Phases */
const CONST_DISCOVER_PHASE = 'Discover';
const CONST_DEFINE_PHASE = 'Define';
const CONST_DESIGN_PHASE = 'Design';
const CONST_DEVELOP_PHASE = 'Develop';
const CONST_DEPLOY_PHASE = 'Deploy';
const CONST_DIAGNOSE_PHASE = 'Diagnose';

/* Project Decision Step Statuses */
const CONST_OPPORTUNITY_TO_BE_SUBMITTED = 'Opportunity Milestone yet to be submitted';
const CONST_BCA_TO_BE_SUBMITTED = 'Business Case Ambition yet to be Submitted';

/* Financial Types */
const CONST_DELIVERABLE_TYPE = 'Deliverables';

/* Object Names */
const CONST_PROJECT_SNAPSHOT = 'Project Snapshot';

/* API Field Names */
const CONST_LABEL_API_FIELD_NAME = 'Label__c';
const CONST_BUSINESS_CASE_AMBITION_API_FIELD_NAME = 'BCAValue__c';
const CONST_BUSINESS_CASE_VALIDATION_API_FIELD_NAME = 'BCVVAlue__c';
const CONST_COMMERCIAL_MILESTONE_API_FIELD_NAME = 'CMValue__c';
const CONST_PRODUCTION_MILESTONE_API_FIELD_NAME = 'PMValue__c';

/* Error Messages */
const CONST_VALUE_OUT_OF_BOUNDS_FINANCIALS_ERROR = 'Value/s you want to update is/are out of bounds. [Minimum: 0, Maximum: 999,999,999]';
const CONST_VALUE_OUT_OF_BOUNDS_PERCENTAGE_ERROR = 'Value/s you want to update is/are out of bounds. [Minimum: 0, Maximum: 99.9]';
const CONST_VALUE_OUT_OF_FLOATING_POINT_ERROR = 'Value you want to update needs to have precision of one decimal place. [Minimum: 0, Maximum: 0.9]';
const CONST_TRYING_TO_UPDATE_BCA_PASTE_ERROR = `You're trying to update BCA which is already passed`;

/*Project statuses*/
const CONST_COMPLETED_STATUS = 'Completed';
const CONST_LAUNCHED_STATUS = 'Launched';

/*Project Complexity*/
const CONST_LOW_COMPLEXITY = 'Low';
const CONST_MEDIUM_COMPLEXITY = 'Medium';

/*Project fields*/
import CONST_PROJECT_CLASSIFICATION from '@salesforce/schema/Project__c.ProjectClassification__c';
import CONST_PROJECT_CLASSIFICATION_SUBTYPE from '@salesforce/schema/Project__c.ProjectClassificationSubtype__c';
import CONST_PROJECT_PHASE from '@salesforce/schema/Project__c.ProjectPhase__c';
import CONST_ARE_TIMINGS_AVAILABLE from '@salesforce/schema/Project__c.AreTimingsAvailable__c';

/*Financial labels*/
import CONST_FEARLESS_BET_LABEL from '@salesforce/label/c.Fearless_Bet_NSV_Info';
import CONST_BRAND_ENERGIZER_LABEL from '@salesforce/label/c.Brand_Energizer_NSV_Info';
import CONST_BUSINESS_ENABLER_LABEL from '@salesforce/label/c.Business_Enabler_NSV_Info';
import CONST_GEOGRAPHICAL_EXTENSION_LABEL from '@salesforce/label/c.Geograhpical_Extension_NSV_Info';
import CONST_GEOGRAPHICAL_EXTENSION_I_ICON_LABEL from '@salesforce/label/c.Geographical_Extension_i_icon';
import CONST_GEOGRAPHICAL_EXTENSION_FINANCIAL_THRESHOLD_NOT_MET_LABEL from '@salesforce/label/c.Geographical_Extension_Financial_Threshold_Not_Met';
import CONST_FINANCIAL_THRESHOLD_NOT_MET_DEFAULT_LABEL from '@salesforce/label/c.Financial_Threshold_Not_Met_Default_Text';
import CONST_PROMOTIONAL_PACK_LABEL from '@salesforce/label/c.Promotional_Pack_NSV_Info';
import CONST_REPACK_LABEL from '@salesforce/label/c.Repack_NSV_Info';

//Financials constants
const NSV_AMBITION = '*NSV Ambition ($000 USD)';
const VOLUME_9L_CASES = '*Volume (000 9L Cases)';
const NSV = '*NSV ($000 USD)';
const GROSS_PROFIT = '*Gross Profit ($000 USD)';
const AP = '*A&P ($000 USD)';

//Financials Labels
import SIZE_OF_PRIZE_DELIVERABLE from '@salesforce/label/c.Size_of_Prize_Deliverable';
import INVESTMENT_REQUIRED_DELIVERABLE from '@salesforce/label/c.Investment_Required_Deliverable';
import YEAR_ONE_GP_DELIVERABLE from '@salesforce/label/c.Year_First_Gross_Profit_Deliverable';
import YEAR_TWO_GP_DELIVERABLE from '@salesforce/label/c.Ongoing_Year_Two_Structural_Profitability_Deliverable';
import PROJECT_AVERAGE_GM from '@salesforce/label/c.Project_Average_GM';


/*Help Text Labels*/
import CONST_GEO_PARENT_PROJECT_LABEL from '@salesforce/label/c.Geographical_Extension_Parent_Project_Help_Text';
import CONST_PROMOTIONAL_PACK_PARENT_PROJECT_LABEL from '@salesforce/label/c.Promotional_Pack_Parent_Project_Help_Text';
import CONST_TIMINGS_INFO_LABEL from '@salesforce/label/c.Timings_Info';
import CONST_TIMINGS_DATE_FORMAT_INFO_LABEL from '@salesforce/label/c.Timings_Date_Format_Info';
import CONST_TIMINGS_WARNING_GEO_LABEL from '@salesforce/label/c.Timings_Warning_Text_Geo_Extension';
import CONST_TIMINGS_WARNING_REPACK_LABEL from '@salesforce/label/c.Timings_Warning_Text_Repack';
import CONST_TIMINGS_WARNING_TOO_EARLY_LABEL from '@salesforce/label/c.Timings_Warning_Too_Early';
import CONST_TIMINGS_WARNING_CUSTOMER_MEETING_LABEL from '@salesforce/label/c.Timings_Warning_Customer_Meeting';
import CONST_TIMINGS_WARNING_CUSTOMER_MEETING_GEO_LABEL from '@salesforce/label/c.Timings_Warning_Customer_Meeting_Geo';
import CONST_TIMINGS_DATE_IN_PAST_LABEL from '@salesforce/label/c.Timings_Date_In_Past';
import CONST_VAP_EXPECTED_PRICE_WARNING_MESSAGE_LABEL from '@salesforce/label/c.VAP_Expected_Price_Warning_Message';
import CONST_PROJECT_DEVELOPMENT_COSTS_TO_DATE_HELP_TEXT from '@salesforce/label/c.ProjectDevelopmentCostsToDateHelpText';

/*Checklist Labels*/
import CONST_PACK_DEV_MANAGER_POINT_LABEL from '@salesforce/label/c.Checklist_Pack_Dev_Manager_Point';
import CONST_INNOVATION_SUPPLY_COMMUNITY_LINK_LABEL from '@salesforce/label/c.Checklist_Innovation_Supply_Community_Link';
import CONST_LEGAL_REGULATORY_APPROVAL_MEDIUM_POINT_LABEL from '@salesforce/label/c.Checklist_Legal_Regulatory_Approvals_Medium_Point';
import CONST_LEGAL_REGULATORY_APPROVAL_LOW_POINT_LABEL from '@salesforce/label/c.Checklist_Legal_Regulatory_Approvals_Low_Point';
import CONST_LEGAL_AND_REGS_PRIMOS_LINK_LABEL from '@salesforce/label/c.Checklist_Legal_And_Regs_Primos_Link';
import CONST_PACK_DEV_MANAGER_CONFIRMATION_LABEL from '@salesforce/label/c.Checklist_Pack_Dev_Manager_Confirmation';
import CONST_LEGAL_REGULATORY_APPROVAL_CONFIRMATION_LABEL from '@salesforce/label/c.Checklist_Legal_Regulatory_Approvals_Confirmation';
import CONST_LOW_PROMO_PACK_BCA_INTRO_LABEL from '@salesforce/label/c.Checklist_Low_Promo_Pack_BCA_Intro';
import CONST_MEDIUM_PROMO_PACK_BCA_INTRO_LABEL from '@salesforce/label/c.Checklist_Medium_Promo_Pack_BCA_Intro';
import CONST_MEDIUM_PROMO_PACK_BCV_INTRO_LABEL from '@salesforce/label/c.Checklist_Medium_Promo_Pack_BCV_Intro';
import CONST_MEDIUM_PROMO_PACK_PRODUCTION_INTRO_LABEL from '@salesforce/label/c.Checklist_Medium_Promo_Pack_Production_Intro';
import CONST_GIFTBOX_POINT_LABEL from '@salesforce/label/c.Checklist_GiftBox_Point';
import CONST_GIFTBOX_EXCEPTION_LABEL from '@salesforce/label/c.Checklist_GiftBox_Exception';
import CONST_LOW_PROMO_PACK_CONFIRMATION_LABEL from '@salesforce/label/c.Checklist_Low_Promo_Pack_Confirmation';
import CONST_LOW_PROMO_PACK_PRODUCTION_INTRO_LABEL from '@salesforce/label/c.Checklist_Low_Promo_Pack_Production_Intro';

/*Home Page Labels*/
import CONST_HOME_PAGE_DOC_REPO_TITLE_INFO from '@salesforce/label/c.Home_Page_Documents_Repository_Title';
import CONST_HOME_PAGE_ONE_MARKET_INFO from '@salesforce/label/c.Home_Page_One_Marketing_Info';
import CONST_HOME_PAGE_TRAINING_INFO from '@salesforce/label/c.Home_Page_Training_Info';
import CONST_HOME_PAGE_DEVELOPMENT_DOCUMENTS_INFO from '@salesforce/label/c.Home_Page_Development_Documents_Info';
import CONST_HOME_PAGE_GOVERNANCE_INFO from '@salesforce/label/c.Home_Page_Governance_Info';
import CONST_HOME_PAGE_SUBMISSION_CALENDAR_INFO from '@salesforce/label/c.Home_Page_Submission_Calendar_To_BCA_BCV_Info';

/*Labels*/
import CONST_APPROVAL_HISTORY_HIGHLIGHT from '@salesforce/label/c.Approval_History_Highlight';
import CONST_NSV_BY_REGIONS_HELP_TEXT from '@salesforce/label/c.NSV_By_Regions_Help_Text';

/*Geo Hierarchy Component const*/
import LEAD_REGION_HELP_TEXT_LABEL from '@salesforce/label/c.Lead_Region_Help_Text';
import LEAD_HUB_HELP_TEXT_LABEL from '@salesforce/label/c.Lead_Hub_Help_Text';
import LEAD_CLUSTER_HELP_TEXT_LABEL from '@salesforce/label/c.Lead_Cluster_Help_Text';
import LEAD_MARKET_HELP_TEXT_LABEL from '@salesforce/label/c.Lead_Market_Help_Text';
import DISTRIBUTION_CHANNEL_HELP_TEXT_LABEL from '@salesforce/label/c.Distribution_Channel_Help_Text';
import TRADE_TYPE_HELP_TEXT_LABEL from '@salesforce/label/c.Trade_Type_Help_Text';
import LEAD_REGION_ALIGNED_HELP_TEXT_LABEL from '@salesforce/label/c.Lead_Region_Aligned_To_Project_Help_Text';
import NO_CHANGES_NEEDED_FOR_PROMOTIONAL_PACK_LABEL from '@salesforce/label/c.No_Changes_Needed_for_Promotional_Pack_Label';
import NO_CHANGES_NEEDED_FOR_PROMOTIONAL_PACK_HELP_TEXT_LABEL from '@salesforce/label/c.No_Changes_Needed_for_Promotional_Pack_Help_Text';
import ADDITIONAL_MARKET_HELP_TEXT_LABEL from '@salesforce/label/c.Additional_Market_Help_Text';
import ADDITIONAL_REGION_HELP_TEXT_LABEL from '@salesforce/label/c.Additional_Region_Help_Text';
import ADDITIONAL_HUB_HELP_TEXT_LABEL from '@salesforce/label/c.Additional_Hub_Help_Text';
import ADDITIONAL_CLUSTER_HELP_TEXT_LABEL from '@salesforce/label/c.Additional_Cluster_Help_Text';

const BRAND_HOME_HELP_TEXT = 'Select Brand Home.';

const GEO_HIERARCHY_OBJECT = 'GeoHierarchy__c';
const GEO_HIERARCHY_ICON = 'standard:location';
const LEAD_MARKET_LABEL = 'Lead Market';
const LEAD_REGION_LABEL = 'Lead Region';
const LEAD_HUB_LABEL = 'Lead Hub';
const LEAD_CLUSTER_LABEL = 'Lead Cluster';
const DISTRIBUTION_CHANNELS_LABEL = 'Distribution Channel(s)';
const TRADE_TYPE_LABEL = 'Trade Type(s)';
const TRADE_TYPE_SINGULAR_LABEL = 'Trade Type';
const BRAND_HOME_LABEL = 'Brand Home';
const ADDITIONAL_MARKET_LABEL = 'Additional Market(s) to launch this fiscal year';
const ADDITIONAL_MARKET_SINGULAR_LABEL = 'Additional Market';
const ADDITIONAL_REGION_LABEL = 'Additional Region(s) to launch this fiscal year';
const ADDITIONAL_REGION_SINGULAR_LABEL = 'Additional Region';
const ADDITIONAL_HUB_LABEL = 'Additional Hub(s) to launch this fiscal year';
const ADDITIONAL_HUB_SINGULAR_LABEL = 'Additional Hub';
const ADDITIONAL_CLUSTER_LABEL = 'Additional Cluster(s) to launch this fiscal year';
const ADDITIONAL_CLUSTER_SINGULAR_LABEL = 'Additional Cluster';

const BMC_COMMENT_LABEL = '*If Pebble, Sand or Air, please enter your recommendation to approvers as to why the project should progress';

const constants = {
    CONST_CI_API_NAME,
    CONST_DISCOVER_PHASE,
    CONST_DEFINE_PHASE,
    CONST_DESIGN_PHASE,
    CONST_DEVELOP_PHASE,
    CONST_DEPLOY_PHASE,
    CONST_DIAGNOSE_PHASE,
    CONST_PROJECT_SNAPSHOT,
    CONST_LABEL_API_FIELD_NAME,
    CONST_BUSINESS_CASE_AMBITION_API_FIELD_NAME,
    CONST_BUSINESS_CASE_VALIDATION_API_FIELD_NAME,
    CONST_COMMERCIAL_MILESTONE_API_FIELD_NAME,
    CONST_PRODUCTION_MILESTONE_API_FIELD_NAME,
    CONST_IPC_API_NAME,
    CONST_GEO_EXTENSION_NAME,
    CONST_PROMOTIONAL_PACK_NAME,
    CONST_BUSINESS_ENABLER_NAME,
    CONST_CI_NAME,
    CONST_MANDATORY_NAME,
    CONST_REPACK_NAME,
    CONST_ARTWORK_CHANGE_API_NAME,
    CONST_ARTWORK_CHANGE_ONLY_API_NAME,
    CONST_VALUE_OUT_OF_BOUNDS_FINANCIALS_ERROR,
    CONST_VALUE_OUT_OF_BOUNDS_PERCENTAGE_ERROR,
    CONST_VALUE_OUT_OF_FLOATING_POINT_ERROR,
    CONST_TRYING_TO_UPDATE_BCA_PASTE_ERROR,
    CONST_BUSINESS_CASE_AMBITION_DESCRIPTION,
    CONST_BUSINESS_CASE_VALIDATION_DESCRIPTION,
    CONST_COMMERCIAL_MILESTONE_DESCRIPTION,
    CONST_PRODUCTION_MILESTONE_DESCRIPTION,
    CONST_DELIVERABLE_TYPE,
    CONST_PROJECT_CLASSIFICATION,
    CONST_PROJECT_CLASSIFICATION_SUBTYPE,
    CONST_FEARLESS_BET_LABEL,
    CONST_BRAND_ENERGIZER_LABEL,
    CONST_BUSINESS_ENABLER_LABEL,
    CONST_GEOGRAPHICAL_EXTENSION_LABEL,
    CONST_GEOGRAPHICAL_EXTENSION_I_ICON_LABEL,
    CONST_GEOGRAPHICAL_EXTENSION_FINANCIAL_THRESHOLD_NOT_MET_LABEL,
    CONST_FINANCIAL_THRESHOLD_NOT_MET_DEFAULT_LABEL,
    CONST_PROMOTIONAL_PACK_LABEL,
    CONST_REPACK_LABEL,
    CONST_GEO_PARENT_PROJECT_LABEL,
    CONST_PROMOTIONAL_PACK_PARENT_PROJECT_LABEL,
    CONST_NECK_TAG_NAME,
    CONST_REPEATING_PROMOTIONAL_PACK_NAME,
    CONST_LIMITED_EDITION_PACK,
    CONST_VALUE_ADDED_PACK,
    CONST_INNOVATION_GEO_EXT_API_NAME,
    CONST_FEARLESS_BET_NAME,
    CONST_BRAND_ENERGIZER_NAME,
    CONST_PRIMARY_PACK_CHANGE_NAME,
    CONST_BCA_SHORT_NAME,
    CONST_BCV_SHORT_NAME,
    CONST_CUSTOMER_MEETING_DESCRIPTION,
    CONST_SHIPMENT_DESCRIPTION,
    CONST_ON_SHELF_DATE_DESCRIPTION,
    CONST_POST_LAUNCH_REVIEW_DESCRIPTION,
    CONST_OPPORTUNITY_MILESTONE_DESCRIPTION,
    CONST_LIQUID_PACK_CHANGE_SUBTYPE_NAME,
    CONST_PACK_LIQUID_CHANGE_SUBTYPE_NAME,
    CONST_IPC_EXTENSION_SUBTYPE_NAME,
    CONST_COMPLETED_STATUS,
    CONST_LAUNCHED_STATUS,
    CONST_OPPORTUNITY_TO_BE_SUBMITTED,
    CONST_BCA_TO_BE_SUBMITTED,
    CONST_TIMINGS_INFO_LABEL,
    CONST_TIMINGS_DATE_FORMAT_INFO_LABEL,
    CONST_PROJECT_PHASE,
    CONST_TIMINGS_WARNING_GEO_LABEL,
    CONST_TIMINGS_WARNING_REPACK_LABEL,
    CONST_ARE_TIMINGS_AVAILABLE,
    CONST_TIMINGS_WARNING_TOO_EARLY_LABEL,
    CONST_TIMINGS_WARNING_CUSTOMER_MEETING_LABEL,
    CONST_TIMINGS_WARNING_CUSTOMER_MEETING_GEO_LABEL,
    CONST_TIMINGS_DATE_IN_PAST_LABEL,
    CONST_VAP_EXPECTED_PRICE_WARNING_MESSAGE_LABEL,
    CONST_LOW_COMPLEXITY,
    CONST_MEDIUM_COMPLEXITY,
    CONST_LOW_PROMO_PACK_BCA_INTRO_LABEL,
    CONST_MEDIUM_PROMO_PACK_BCA_INTRO_LABEL,
    CONST_MEDIUM_PROMO_PACK_BCV_INTRO_LABEL,
    CONST_MEDIUM_PROMO_PACK_PRODUCTION_INTRO_LABEL,
    CONST_GIFTBOX_POINT_LABEL,
    CONST_GIFTBOX_EXCEPTION_LABEL,
    CONST_LOW_PROMO_PACK_CONFIRMATION_LABEL,
    CONST_LOW_PROMO_PACK_PRODUCTION_INTRO_LABEL,
    CONST_PACK_DEV_MANAGER_POINT_LABEL,
    CONST_APPROVAL_HISTORY_HIGHLIGHT,
    CONST_LEGAL_REGULATORY_APPROVAL_MEDIUM_POINT_LABEL,
    CONST_LEGAL_REGULATORY_APPROVAL_LOW_POINT_LABEL,
    CONST_INNOVATION_SUPPLY_COMMUNITY_LINK_LABEL,
    CONST_LEGAL_AND_REGS_PRIMOS_LINK_LABEL,
    CONST_PACK_DEV_MANAGER_CONFIRMATION_LABEL,
    CONST_LEGAL_REGULATORY_APPROVAL_CONFIRMATION_LABEL,
    CONST_HOME_PAGE_DOC_REPO_TITLE_INFO,
    CONST_HOME_PAGE_ONE_MARKET_INFO,
    CONST_HOME_PAGE_TRAINING_INFO,
    CONST_HOME_PAGE_DEVELOPMENT_DOCUMENTS_INFO,
    CONST_HOME_PAGE_GOVERNANCE_INFO,
    CONST_HOME_PAGE_SUBMISSION_CALENDAR_INFO,
    LEAD_REGION_HELP_TEXT_LABEL,
    LEAD_HUB_HELP_TEXT_LABEL,
    LEAD_CLUSTER_HELP_TEXT_LABEL,
    LEAD_MARKET_HELP_TEXT_LABEL,
    LEAD_REGION_ALIGNED_HELP_TEXT_LABEL,
    DISTRIBUTION_CHANNEL_HELP_TEXT_LABEL,
    TRADE_TYPE_HELP_TEXT_LABEL,
    NO_CHANGES_NEEDED_FOR_PROMOTIONAL_PACK_LABEL,
    NO_CHANGES_NEEDED_FOR_PROMOTIONAL_PACK_HELP_TEXT_LABEL,
    ADDITIONAL_MARKET_HELP_TEXT_LABEL,
    ADDITIONAL_REGION_HELP_TEXT_LABEL,
    ADDITIONAL_HUB_HELP_TEXT_LABEL,
    ADDITIONAL_CLUSTER_HELP_TEXT_LABEL,
    BRAND_HOME_HELP_TEXT,
    GEO_HIERARCHY_OBJECT,
    GEO_HIERARCHY_ICON,
    LEAD_MARKET_LABEL,
    LEAD_REGION_LABEL,
    LEAD_HUB_LABEL,
    LEAD_CLUSTER_LABEL,
    DISTRIBUTION_CHANNELS_LABEL,
    TRADE_TYPE_LABEL,
    TRADE_TYPE_SINGULAR_LABEL,
    BRAND_HOME_LABEL,
    ADDITIONAL_MARKET_LABEL,
    ADDITIONAL_MARKET_SINGULAR_LABEL,
    ADDITIONAL_REGION_LABEL,
    ADDITIONAL_REGION_SINGULAR_LABEL,
    ADDITIONAL_HUB_LABEL,
    ADDITIONAL_HUB_SINGULAR_LABEL,
    ADDITIONAL_CLUSTER_LABEL,
    ADDITIONAL_CLUSTER_SINGULAR_LABEL,
    BMC_COMMENT_LABEL,
    CONST_PROJECT_DEVELOPMENT_COSTS_TO_DATE_HELP_TEXT,
    NSV_AMBITION,
    VOLUME_9L_CASES,
    NSV,
    GROSS_PROFIT,
    AP,
    CONST_NSV_BY_REGIONS_HELP_TEXT,
    SIZE_OF_PRIZE_DELIVERABLE,
    INVESTMENT_REQUIRED_DELIVERABLE,
    YEAR_ONE_GP_DELIVERABLE,
    YEAR_TWO_GP_DELIVERABLE,
    PROJECT_AVERAGE_GM
}

export { 
    constants
}