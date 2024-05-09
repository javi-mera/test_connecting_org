/*
 * This file will contain all Innovator constants that need to be re-used across several classes.
 * Contants that need to be used in a single class should live inside that class.
 */
public with sharing class InnovatorConstants {
    // Limit Constants
    public static final Integer MAX_TEAM_MEMBER_PER_FIELD = 12;

    //project classifications
    public static final String FEARLESS_BET = 'Fearless Bet';
    public static final String BRAND_ENERGIZER = 'Brand Energizer';
    public static final String BUSINESS_ENABLER = 'Business Enabler';
    public static final String PROMOTIONAL_PACK = 'Promotional Pack';
    public static final String GEO_EXTENSION = 'Geographical Extension';
    public static final String REPACK = 'Repack';
    public static final String CONTINUOUS_IMPROVEMENT = 'Continuous Improvement';
    public static final String MANDATORY = 'Mandatory';

    //Project Classification Subtypes
    public static final String LIMITED_EDITION_PACK_SUBTYPE = 'Limited Edition Pack';
    public static final String VALUE_ADDED_PACK_SUBTYPE = 'Value Added Pack';
    public static final String HITCH_HIKER_SUBTYPE = 'Hitch Hiker';
    public static final String NECK_TAG_SUBTYPE = 'Neck Tag';
    public static final String REPEATING_PROMOTIONAL_PACK_SUBTYPE = 'Repeat of Previous or Existing Promotional Pack';
    public static final String REORDER_SAME_MARKET_PACK_SUBTYPE = 'Reorder in same market';
    public static final String REORDER_DIFFERENT_MARKET_PACK_SUBTYPE = 'Reorder in different market';
    public static final String IPC_SUBTYPE_API = 'IPC';
    public static final String PRIMARY_PACK_CHANGE_SUBTYPE = 'Primary pack change';
    public static final String LIQUID_PACK_CHANGE_SUBTYPE = 'Liq/Sourcing/Pack Change';
    public static final String ARTWORK_CHANGE_ONLY_SUBTYPE = 'Artwork change only';
    public static final String ARTWORK_CHANGE_SUBTYPE = 'Artwork Change';


    //Project Classification Geo Extension Sub Type
    public static final String GEO_EXTENSION_INNOVATION = 'Innovation Geo Extension';
    public static final String GEO_EXTENSION_OTHER = 'Other Geo Extension';

    //Project phases
    public static final String DISCOVER_PHASE = 'Discover';
    public static final String DEFINE_PHASE = 'Define';
    public static final String DESIGN_PHASE = 'Design';
    public static final String DEVELOP_PHASE = 'Develop';
    public static final String DEPLOY_PHASE = 'Deploy';
    public static final String DIAGNOSE_PHASE = 'Diagnose';

    //Project Milestones
    public static final String DECISION_STEP_OPPORTUNITY = 'Opportunity Milestone';
    public static final String DECISION_STEP_OPPORTUNITY_SHORT = 'Opportunity';
    public static final String DECISION_STEP_BCA = 'Business Case Ambition';
    public static final String DECISION_STEP_BCV = 'Business Case Validation';
    public static final String DECISION_STEP_COMMERCIAL = 'Commercial Milestone';
    public static final String DECISION_STEP_COMMERCIAL_SHORT = 'Commercial';
    public static final String DECISION_STEP_PRODUCTION = 'Production Milestone';
    public static final String DECISION_STEP_PRODUCTION_SHORT = 'Production';
    public static final String DECISION_STEP_PLR = 'Post-Launch Review';

    //Submission Statuses
    public static final String BUSINESS_CASE_AMBITION_SUBMITTED = 'Business Case Ambition Submitted';
    public static final String BUSINESS_CASE_VALIDATION_SUBMITTED = 'Business Case Validation Submitted';
    public static final String COMMERCIAL_MILESTONE_SUBMITTED = 'Commercial Milestone Submitted';
    public static final String POST_LAUNCH_REVIEW_SUBMITTED = 'Post Launch Review Submitted';

    //City Constants
    public static final String CITY_OTHER = 'Other';

    //Project status
    public static final String PROJECT_STATUS_DRAFT = 'Draft';
    public static final String PROJECT_STATUS_ACTIVE = 'Active';
    public static final String PROJECT_STATUS_ON_HOLD = 'On Hold';
    public static final String PROJECT_STATUS_COMPLETED = 'Completed';
    public static final String PROJECT_STATUS_CANCELLED = 'Cancelled';
    public static final String PROJECT_STATUS_LAUNCHED = 'Launched';

    //Financial recordtypes
    public static final String FINANCIAL_DATA_RECORDTYPE = 'FinancialData';
    public static final String DELIVERABLE_RECORDTYPE = 'Deliverable';
    public static final String REGIONAL_NSV_RECORDTYPE = 'Regional NSV';

    //Financials Constants
    public static final String ID_FIELD = 'Id';
    public static final String NSV_AMBITION = '*NSV Ambition ($000 USD)';
    public static final String VOLUME_9L_CASES = '*Volume (000 9L Cases)';
    public static final String NSV = '*NSV ($000 USD)';
    public static final String GROSS_PROFIT = '*Gross Profit ($000 USD)';
    public static final String AP = '*A&P ($000 USD)';

    public static final List<String> DISCOVER_FIELD_LABELS = new List<String> {
        NSV_AMBITION,
        ID_FIELD
    };

    public static final List<String> DEFINE_FIELD_NAMES = new List<String> {
        VOLUME_9L_CASES,
        NSV,
        GROSS_PROFIT,
        AP,
        ID_FIELD
    };

    //Approval Matrix Record Types
    public static final String BMC_RECORDTYPE = 'BMC';
    public static final String OC_RECORDTYPE = 'OC';

    //Email Templates
    public static final String LEGAL_AND_REGULATORY_PRIMOS_EMAIL = 'Legal and Regulatory Primos Notification';
    public static final String LEAD_REGION_EMAIL_TEMPLATE_NAME = 'Project Submission Notification to Lead Region';
    public static final String MILESTONE_PASSED_TO_REGIONAL_LEADERS_EMAIL_TEMPLATE_NAME = 'Project Passed Milestone Notification to Regional Leaders';
    public static final String TEMPLATE_NAME_NO_BCA_BCV = 'Project submitted to approvers without BCA and BCV';
    public static final String TEMPLATE_NAME_BCA = 'Project submitted to approvers with BCA';
    public static final String TEMPLATE_NAME_BCV = 'Project submitted to approvers with BCV';

    //Decision Steps
    public static final Map<String, String> MAP_DECISION_STEP = new Map<String, String>{
        DISCOVER_PHASE => DECISION_STEP_OPPORTUNITY,
        DEFINE_PHASE => DECISION_STEP_BCA,
        DESIGN_PHASE => DECISION_STEP_BCV,
        DEVELOP_PHASE => DECISION_STEP_COMMERCIAL,
        DEPLOY_PHASE => DECISION_STEP_PRODUCTION,
        DIAGNOSE_PHASE => DECISION_STEP_PLR
    };

    //Additional Approvers for Second Submission
    public static final String SECOND_SUBMISSION_WITH_PRIOR_ADDITIONAL_APPROVERS = 'Second Submission With Prior Additional Approvers';

    //Approval Step Status
    public static final String APPROVED_STATUS = 'Approved';
    public static final String STARTED_STATUS = 'Started';
    public static final String REJECTED_STATUS = 'Rejected';
    public static final String REWORKED_STATUS = 'Removed';
    public static final String REASSIGNED_STATUS = 'Reassigned';
    public static final String SUBMITTED_STATUS = 'Submitted';
    public static final String RECALLED_STATUS = 'Recalled';

    //Approval Actions
    public static final String APPROVAL_ACTION_APPROVE = 'Approve';
    public static final String APPROVAL_ACTION_REJECT = 'Reject';
    public static final String APPROVAL_ACTION_REWORK = 'Rework';

    //Profiles
    public static final String INNOVAPP_USER_PROFILE = 'Innovapp User';
    public static final String PROJECT_LEADER_USER_PROFILE = 'Project Leader';
    public static final String PROJECT_MANAGER_USER_PROFILE = 'Project Manager';
    public static final String SUPER_USER_PROFILE = 'Super User';
    public static final String INNOVAPP_ADMIN_PROFILE = 'Innovapp Admin';
    public static final String SYSTEM_ADMIN_PROFILE = 'System Administrator';
    public static final String PROJECT_PORTFOLIO_MANAGER_PROFILE = 'Project Portfolio Manager';

    //Global Lists
    public static final List<String> REGIONAL_NSV_APPLICABLE_CLASSIFICATIONS = new List<String>{
        FEARLESS_BET,
        BRAND_ENERGIZER,
        BUSINESS_ENABLER,
        GEO_EXTENSION
    };

    public static final List<String> LEGAL_AND_REGULATORY_DISCOVER_CLASSIFICATION = new List<String>{
        REPACK,
        FEARLESS_BET,
        BRAND_ENERGIZER
    };

    public static final List<String> LEGAL_AND_REGULATORY_DEFINE_CLASSIFICATION = new List<String>{
        BUSINESS_ENABLER,
        GEO_EXTENSION,
        PROMOTIONAL_PACK
    };

    public static final List<String> CONCEPT_VALIDATION_CLASSIFICATION = new List<String>{
        REPACK,
        FEARLESS_BET,
        BRAND_ENERGIZER
    };

    public static final List<String> COMMERCIAL_MILESTONE_ONLINE_APPROVAL_CLASSIFICATIONS = new List<String>{
        FEARLESS_BET,
        BRAND_ENERGIZER,
        BUSINESS_ENABLER,
        GEO_EXTENSION
    };

    public static final List<String> AUTOMATIC_APPROVAL_PHASES = new List<String>{
        DISCOVER_PHASE,
        DEPLOY_PHASE
    };

    public static final List<String> PHASES_GEO_EXTENSION_PRODUCT_MODIFICATION = new List<String>{
        DEFINE_PHASE,
        DESIGN_PHASE,
        DEPLOY_PHASE,
        DIAGNOSE_PHASE
    };

    public static final List<String> PHASES_GEO_EXTENSION_PRODUCT_MODIFICATION_IPC_EXTENSION = new List<String>{
        DEFINE_PHASE,
        DIAGNOSE_PHASE
    };

    public static final List<String> PHASES_PROMOTIONAL_PACK_COMPLEX = new List<String>{
        DEFINE_PHASE,
        DESIGN_PHASE,
        DEPLOY_PHASE,
        DIAGNOSE_PHASE
    };

    public static final List<String> PHASES_PROMOTIONAL_PACK_SIMPLE = new List<String>{
        DEFINE_PHASE,
        DEPLOY_PHASE,
        DIAGNOSE_PHASE
    };

    public static final List<String> PHASES_REPACK_ARTWORK_CHANGE_ONLY = new List<String>{
        DISCOVER_PHASE,
        DEFINE_PHASE,
        DESIGN_PHASE,
        DEPLOY_PHASE,
        DIAGNOSE_PHASE
    };

    public static final List<String> PHASES_CI_MANDATORY_SIMPLE = new List<String>{
        DEFINE_PHASE,
        DIAGNOSE_PHASE
    };

    public static final List<String> PHASES_CI_MANDATORY_COMPLEX = new List<String>{
        DEFINE_PHASE,
        DESIGN_PHASE,
        DEPLOY_PHASE,
        DIAGNOSE_PHASE
    };

    public static final List<String> PHASES_ORDERED = new List<String>{
        DISCOVER_PHASE,
        DEFINE_PHASE,
        DESIGN_PHASE,
        DEVELOP_PHASE,
        DEPLOY_PHASE,
        DIAGNOSE_PHASE
    };

    public static final List<String> PROJECT_CLASSIFICATIONS_WITH_SUBTYPES = new List<String>{
        GEO_EXTENSION,
        REPACK,
        PROMOTIONAL_PACK,
        MANDATORY,
        CONTINUOUS_IMPROVEMENT
    };

    //Maps
    public static final Map<String, String> PROJECT_CLASSIFICATION_TO_NSV_THRESHOLD = new Map<String, String>{
        FEARLESS_BET => Label.Fearless_Bet_NSV_Info,
        BRAND_ENERGIZER => Label.Brand_Energizer_NSV_Info,
        BUSINESS_ENABLER => Label.Business_Enabler_NSV_Info,
        GEO_EXTENSION => Label.Geograhpical_Extension_NSV_Info + Label.Geographical_Extension_NSV_Email_Info,
        PROMOTIONAL_PACK => Label.Promotional_Pack_NSV_Info
    };

    public static final Map<String, Integer> PROJECT_PHASE_TO_NUMBER = new Map<String, Integer>{
        DISCOVER_PHASE => 1,
        DEFINE_PHASE => 2,
        DESIGN_PHASE => 3,
        DEVELOP_PHASE => 4,
        DEPLOY_PHASE => 5,
        DIAGNOSE_PHASE => 6
    };

    public static final Map<String, String> MAP_PHASES_TO_MILESTONES = new Map<String, String>{
        DISCOVER_PHASE => DECISION_STEP_OPPORTUNITY_SHORT,
        DEFINE_PHASE => DECISION_STEP_BCA,
        DESIGN_PHASE => DECISION_STEP_BCV,
        DEVELOP_PHASE => DECISION_STEP_COMMERCIAL_SHORT,
        DEPLOY_PHASE => DECISION_STEP_PRODUCTION_SHORT,
        DIAGNOSE_PHASE => DECISION_STEP_PLR
    };

    public static final Map<String, String> MAP_PHASES_TO_SUBMISSION_STATUS = new Map<String, String>{
        DEFINE_PHASE => BUSINESS_CASE_AMBITION_SUBMITTED,
        DESIGN_PHASE => BUSINESS_CASE_VALIDATION_SUBMITTED,
        DEVELOP_PHASE => COMMERCIAL_MILESTONE_SUBMITTED,
        DIAGNOSE_PHASE => POST_LAUNCH_REVIEW_SUBMITTED
    };

    //Picklist values
    public static final String NO_CONCEPT_VALIDATION_PICKLIST_VALUE = 'No Concept Validation research completed';
    public static final String ON_TRACK = 'On Track';
    public static final String OFF_TRACK = 'Off Track';

    //Trade Type Names
    public static final String ECOMMERCE_TRADE_TYPE = 'Ecommerce';
    public static final String BRAND_HOME_TRADE_TYPE = 'Brand Home';

    //Notifications constants

    public static String THRESHOLD_NOT_MET_MILESTONE_MSG_START = 'This project has been submitted by the project leader even though it does not meet the first 12 months $NSV threshold. A ';
    public static String THRESHOLD_NOT_MET_MSG_END = ' The reason given by the project leader for this is: ';
    public static String THRESHOLD_NOT_MET_MSG_START = 'This project has been submitted for approval by the project leader even though it does not meet the first 12 months $NSV threshold. A ';
    public static String CONCEPT_VALIDATION_JUSTIFICATION_MSG_START = 'Please be aware, no concept validation testing has happened for this project. The reason given by the Project Leader for not undertaking Concept Validation testing is: ';
    public static final String PROJECT_SUBMITTER_TEXT = 'This comment has been added by the project team while submitting the decision step';
    public static final String PROJECT_REASSIGN_TEXT = 'This comment has been added by the approver while reassigning the approval';

    public static final Map<String, String> PHASE_TO_TEMPLATE = new Map<String, String>{
        DEFINE_PHASE => TEMPLATE_NAME_BCA,
        DESIGN_PHASE => TEMPLATE_NAME_BCV
    };

    // Approval History Auto Step Names
    public static final String APPROVAL_HISTORY_OPPORTUNITY_STEP_NAME = 'Opportunity Milestone (Notification Sent)';
    public static final String APPROVAL_HISTORY_COMMERCIAL_STEP_NAME = 'Commercial Milestone';
    public static final String APPROVAL_HISTORY_COMMERCIAL_NOTIFICATION_STEP_NAME = 'Commercial Milestone (Notification Sent)';
    public static final String APPROVAL_HISTORY_PRODUCTION_STEP_NAME = 'Production Milestone (Notification Sent)';


    public static final Map<String, String> MAP_APPROVAL_HISTORY_STEP_NAMES_TO_MILESTONES = new Map<String, String>{
        APPROVAL_HISTORY_OPPORTUNITY_STEP_NAME => DECISION_STEP_OPPORTUNITY_SHORT,
        DECISION_STEP_BCA => DECISION_STEP_BCA,
        DECISION_STEP_BCV => DECISION_STEP_BCV,
        APPROVAL_HISTORY_COMMERCIAL_NOTIFICATION_STEP_NAME => DECISION_STEP_COMMERCIAL_SHORT,
        APPROVAL_HISTORY_COMMERCIAL_STEP_NAME => DECISION_STEP_COMMERCIAL_SHORT,
        APPROVAL_HISTORY_PRODUCTION_STEP_NAME => DECISION_STEP_PRODUCTION_SHORT
    };

    // Approvers' Roles (API values, Labels are full names)
    public static final String VP_REGIONAL_MARKETING = 'Rgl Marketing VP';
    public static final String ECOMMERCE_VP_REGIONAL_MARKETING = 'Ecommerce VP';
    public static final String REGIONAL_CFO_MARKETING = 'Rgl CFO';
    public static final String ECOMMERCE_REGIONAL_CFO_MARKETING = 'Ecommerce CFO';
    public static final String SC_VP_REGIONAL_MARKETING = 'Rgl Supply Chain VP';
    public static final String BCA_MEETING_APPROVER = 'Business Case Ambition Meeting';
    public static final String BCV_MEETING_APPROVER = 'Business Case Validation Meeting';
    public static final String COMMERCIAL_DIRECTOR = 'Commercial Director';
    public static final String TEELING_COMMERCIAL_APPROVER = 'Teeling Commercial Approver';
    public static final String TEELING_SUPPLY_APPROVER = 'Teeling Supply Approver';
    public static final String BRAND_HOMES_PERFORMANCE_MANAGER = 'Brand Homes Performance Manager';
    public static final String BRAND_HOMES_COMMERCIAL_APPROVER = 'Brand Homes Commercial Approver';
    public static final String REGIONAL_PRESIDENT = 'Regional President';
    public static final String REGIONAL_SUPPLY_CHAIN_DIRECTOR = 'Rgl Supply Chain Director';
    public static final String SUPPLY_DIRECTOR = 'Supply Director';
    public static final String PLANNING_AND_LOGISTICS_APPROVER = 'Planning and Logistics Approver';
    public static final String SUPPLY_FINANCE_DIRECTOR = 'Supply Finance Director';
    public static final String CFO = 'CFO';
    public static final String RECEIVING_SC_VP = 'Receiving Supply Chain VP';
    public static final String INNOVATION_DIRECTOR = 'Innovation Director';
    public static final String MARKETING_DIRECTOR = 'Marketing Director';
    public static final String BRAND_DIRECTOR = 'Brand Director';
    public static final String NO_ROLE_ASSIGNED = 'Additional Approver'; // this "role" is used if there's no role for additional approver

    // List of Approvers
    public static final List<String> BCV_LEAD_REGION_APPROVERS = new List<String>{ //is used if offline meeting for multiregion - BCV
        SC_VP_REGIONAL_MARKETING,
        VP_REGIONAL_MARKETING,
        REGIONAL_CFO_MARKETING,
        COMMERCIAL_DIRECTOR,
        TEELING_COMMERCIAL_APPROVER,
        CFO,
        RECEIVING_SC_VP,
        INNOVATION_DIRECTOR,
        MARKETING_DIRECTOR
    };

    public static final List<String> OPPORTUNITY_MULTI_REGION_APPROVERS = new List<String>{ //Opportunity for multiregion
        VP_REGIONAL_MARKETING,
        ECOMMERCE_VP_REGIONAL_MARKETING,
        CFO,
        RECEIVING_SC_VP,
        INNOVATION_DIRECTOR,
        MARKETING_DIRECTOR,
        TEELING_COMMERCIAL_APPROVER,
        TEELING_SUPPLY_APPROVER,
        BRAND_HOMES_PERFORMANCE_MANAGER,
        BRAND_HOMES_COMMERCIAL_APPROVER
    };

    public static final List<String> BCA_MULTI_REGION_APPROVERS = new List<String>{ //BCA multiregion for Fearless Bet and Repack Primary change
        REGIONAL_PRESIDENT,
        ECOMMERCE_VP_REGIONAL_MARKETING,
        ECOMMERCE_REGIONAL_CFO_MARKETING,
        CFO,
        RECEIVING_SC_VP,
        INNOVATION_DIRECTOR,
        MARKETING_DIRECTOR,
        SC_VP_REGIONAL_MARKETING,
        TEELING_COMMERCIAL_APPROVER,
        TEELING_SUPPLY_APPROVER,
        BRAND_HOMES_PERFORMANCE_MANAGER,
        BRAND_HOMES_COMMERCIAL_APPROVER
    };

    public static final List<String> REPACK_BCA_MULTI_REGION_APPROVERS = new List<String>{ //BCA multiregion for Repack Artwork
        REGIONAL_PRESIDENT,
        ECOMMERCE_VP_REGIONAL_MARKETING,
        ECOMMERCE_REGIONAL_CFO_MARKETING,
        CFO,
        RECEIVING_SC_VP,
        INNOVATION_DIRECTOR,
        MARKETING_DIRECTOR,
        SC_VP_REGIONAL_MARKETING,
        TEELING_COMMERCIAL_APPROVER,
        TEELING_SUPPLY_APPROVER,
        BRAND_HOMES_PERFORMANCE_MANAGER,
        BRAND_HOMES_COMMERCIAL_APPROVER
    };

    public static final List<String> BE_GEO_BCA_MULTI_REGION_APPROVERS = new List<String>{ //BCA multiregion for Business Enabler and Geo Extension
        VP_REGIONAL_MARKETING,
        REGIONAL_CFO_MARKETING,
        COMMERCIAL_DIRECTOR,
        REGIONAL_SUPPLY_CHAIN_DIRECTOR,
        ECOMMERCE_VP_REGIONAL_MARKETING,
        ECOMMERCE_REGIONAL_CFO_MARKETING,
        CFO,
        RECEIVING_SC_VP,
        INNOVATION_DIRECTOR,
        MARKETING_DIRECTOR,
        SC_VP_REGIONAL_MARKETING,
        TEELING_COMMERCIAL_APPROVER,
        TEELING_SUPPLY_APPROVER,
        BRAND_HOMES_PERFORMANCE_MANAGER,
        BRAND_HOMES_COMMERCIAL_APPROVER
    };

    public static final List<String> BCV_MULTI_REGION_APPROVERS = new List<String>{ //BCV multiregion for Fearless Bet, Brand Energizer and Repack Primary change
        SC_VP_REGIONAL_MARKETING,
        VP_REGIONAL_MARKETING,
        REGIONAL_CFO_MARKETING,
        COMMERCIAL_DIRECTOR,
        ECOMMERCE_VP_REGIONAL_MARKETING,
        ECOMMERCE_REGIONAL_CFO_MARKETING,
        CFO,
        RECEIVING_SC_VP,
        INNOVATION_DIRECTOR,
        MARKETING_DIRECTOR,
        TEELING_COMMERCIAL_APPROVER,
        TEELING_SUPPLY_APPROVER,
        BRAND_HOMES_PERFORMANCE_MANAGER,
        BRAND_HOMES_COMMERCIAL_APPROVER
    };

    public static final List<String> RP_BE_GEO_BCV_MULTI_REGION_APPROVERS = new List<String>{ //BCV multiregion for Geo Extention, Business Enabler and Repack Artwork
        VP_REGIONAL_MARKETING,
        REGIONAL_CFO_MARKETING,
        COMMERCIAL_DIRECTOR,
        REGIONAL_SUPPLY_CHAIN_DIRECTOR,
        ECOMMERCE_VP_REGIONAL_MARKETING,
        ECOMMERCE_REGIONAL_CFO_MARKETING,
        CFO,
        RECEIVING_SC_VP,
        INNOVATION_DIRECTOR,
        MARKETING_DIRECTOR,
        SC_VP_REGIONAL_MARKETING,
        TEELING_COMMERCIAL_APPROVER,
        TEELING_SUPPLY_APPROVER,
        BRAND_HOMES_PERFORMANCE_MANAGER,
        BRAND_HOMES_COMMERCIAL_APPROVER
    };

    public static final List<String> COMMERCIAL_GEO_EXTENSION_MULTI_REGION_APPROVERS = new List<String>{ // Commercial multiregion
        VP_REGIONAL_MARKETING,
        REGIONAL_CFO_MARKETING,
        COMMERCIAL_DIRECTOR,
        ECOMMERCE_VP_REGIONAL_MARKETING,
        ECOMMERCE_REGIONAL_CFO_MARKETING,
        CFO,
        RECEIVING_SC_VP,
        INNOVATION_DIRECTOR,
        MARKETING_DIRECTOR,
        TEELING_COMMERCIAL_APPROVER,
        TEELING_SUPPLY_APPROVER,
        BRAND_HOMES_PERFORMANCE_MANAGER,
        BRAND_HOMES_COMMERCIAL_APPROVER,
        REGIONAL_SUPPLY_CHAIN_DIRECTOR
    };

    public static final List<String> COMMERCIAL_MULTI_REGION_APPROVERS = new List<String>{ // Commercial multiregion
        VP_REGIONAL_MARKETING,
        REGIONAL_CFO_MARKETING,
        COMMERCIAL_DIRECTOR,
        ECOMMERCE_VP_REGIONAL_MARKETING,
        ECOMMERCE_REGIONAL_CFO_MARKETING,
        CFO,
        RECEIVING_SC_VP,
        INNOVATION_DIRECTOR,
        MARKETING_DIRECTOR,
        TEELING_COMMERCIAL_APPROVER,
        TEELING_SUPPLY_APPROVER,
        BRAND_HOMES_PERFORMANCE_MANAGER,
        BRAND_HOMES_COMMERCIAL_APPROVER
    };

    public static final List<String> PRODUCTION_MULTI_REGION_APPROVERS = new List<String>{ //Production multiregion Fearless Bet
        SC_VP_REGIONAL_MARKETING,
        VP_REGIONAL_MARKETING,
        REGIONAL_CFO_MARKETING,
        COMMERCIAL_DIRECTOR,
        ECOMMERCE_VP_REGIONAL_MARKETING,
        ECOMMERCE_REGIONAL_CFO_MARKETING,
        CFO,
        RECEIVING_SC_VP,
        INNOVATION_DIRECTOR,
        MARKETING_DIRECTOR,
        TEELING_COMMERCIAL_APPROVER,
        TEELING_SUPPLY_APPROVER,
        BRAND_HOMES_PERFORMANCE_MANAGER,
        BRAND_HOMES_COMMERCIAL_APPROVER
    };

    public static final List<String> RP_BE_PRODUCTION_MULTI_REGION_APPROVERS = new List<String>{// Production multiregion for Brand Energizer, Repack, Business Enabler
        SC_VP_REGIONAL_MARKETING,
        VP_REGIONAL_MARKETING,
        REGIONAL_CFO_MARKETING,
        COMMERCIAL_DIRECTOR,
        ECOMMERCE_VP_REGIONAL_MARKETING,
        ECOMMERCE_REGIONAL_CFO_MARKETING,
        CFO,
        RECEIVING_SC_VP,
        INNOVATION_DIRECTOR,
        MARKETING_DIRECTOR,
        TEELING_COMMERCIAL_APPROVER,
        TEELING_SUPPLY_APPROVER,
        BRAND_HOMES_PERFORMANCE_MANAGER,
        BRAND_HOMES_COMMERCIAL_APPROVER
    };

    public static final List<String> GEO_PRODUCTION_MULTI_REGION_APPROVERS = new List<String>{ // Production multiregion for Geo Extension
        SC_VP_REGIONAL_MARKETING,
        VP_REGIONAL_MARKETING,
        REGIONAL_CFO_MARKETING,
        COMMERCIAL_DIRECTOR,
        ECOMMERCE_VP_REGIONAL_MARKETING,
        ECOMMERCE_REGIONAL_CFO_MARKETING,
        CFO,
        RECEIVING_SC_VP,
        INNOVATION_DIRECTOR,
        MARKETING_DIRECTOR,
        TEELING_COMMERCIAL_APPROVER,
        TEELING_SUPPLY_APPROVER,
        BRAND_HOMES_PERFORMANCE_MANAGER,
        BRAND_HOMES_COMMERCIAL_APPROVER
    };
}