@isTest
public class TestFactory {
  private static final String MATRIX_RT = 'Approval_Matrix';
  private static final String OC_RT = 'OC';
  private static final String BMC_RT = 'BMC';
  private static final String OPPORTUNITY_MILESTONE = 'Opportunity';
  private static final String BUSINESS_CASE_AMBITION_MILESTONE = 'Business Case Ambition';
  private static final String BUSINESS_CASE_VALIDATION_MILESTONE = 'Business Case Validation';
  private static final String COMMERCIAL_MILESTONE = 'Commercial Milestone';
  private static final String PRODUCTION_MILESTONE = 'Production Milestone';
  private static final String POST_LAUNCH_REVIEW_MILESTONE = 'Post-Launch Review';
  private static final String DISCOVER_PHASE = 'Discover';
  private static final String DEFINE_PHASE = 'Define';
  private static final String DESIGN_PHASE = 'Design';
  private static final String DEVELOP_PHASE = 'Develop';
  private static final String DEPLOY_PHASE = 'Deploy';
  private static final String DIAGNOSE_PHASE = 'Diagnose';
  private static final String PROJECT_CLASSIFICATION_BUSINESS_ENABLER = 'Business Enabler';
  private static final String PROJECT_CLASSIFICATION_PROMOTIONAL_PACK = 'Promotional Pack';
  private static final String PROJECT_CLASSIFICATION_GEOEXTENSION = 'Geographical Extension';
  private static final String PROJECT_CLASSIFICATION_REPACK = 'Repack';
  private static final String PROJECT_CLASSIFICATION_CI = 'Continuous Improvement';
  private static final String PROJECT_CLASSIFICATION_MANDATORY = 'Mandatory';
  private static final String PROJECT_TRADETYPE_ONTRADE = 'On-Trade';
  private static final String BACARDI_NAME = 'Bacardi';
  private static final String PROFILE_NAME_INNOVAPP_USER = 'Innovapp User';
  private static final String PROFILE_NAME_PROJECT_LEADER = 'Project Leader';
  private static final String PROFILE_NAME_PROJECT_MANAGER = 'Project Manager';
  private static final String TEAM_MEMBER_ACCESS_EDIT = 'Edit';
  private static final String TEAM_MEMBER_ACCESS_READ = 'Read';
  private static final String NEW_HIERARCHY_TYPE = 'NEW';
  private static final String NEW_HIERARCHY_DESCRIPTION = 'New';
  private static final String GEO_COUNTRY = 'IN';
  private static final String GEO_COUNTRY_DESCRIPTION = 'India';
  private static final String GEO_REGION = 'AMEA';
  private static final String GEO_HUB = 'INDIA & SEA CLUSTER';
  private static final String GEO_CLUSTER = 'INDIA CLUSTER';
  private static final String GEO_DC = 'Domestic';

  private static List<User> userList = new List<User>();
  private static List<CustomTeams__Teams__c> customTeamList = new List<CustomTeams__Teams__c>();
  private static List<CustomTeams__Team_Members__c> customTeamMemberList = new List<CustomTeams__Team_Members__c>();
  private static List<Account> accountList = new List<Account>();
  private static List<Contact> contactList = new List<Contact>();
  private static List<Project__c> projectList = new List<Project__c>();
  private static List<ApprovalMatrix__c> approvalMatrixList = new List<ApprovalMatrix__c>();
  private static List<ProductHierarchy__c> productHierarchyList = new List<ProductHierarchy__c>();
  private static List<GeoHierarchy__c> geoHierarchyList = new List<GeoHierarchy__c>();
  private static List<Financial__c> financialList = new List<Financial__c>();
  private static List<Financial__c> deliverableList = new List<Financial__c>();

  public static void generateBasicSetUp() {
    createUsers();
    createTeams();
    createAccounts();
    createContacts();
    createApprovalMatrices();
    createProjects();
    createTeamMembers();
    createProductHierarchies();
    createGeoHierarchies();
    createFinancials();
    createDeliverables();
    createRuleMatrix(userList[0].Id);
  }

  public static void createUsers() {
    Id innovaAppProfileId = [
      SELECT Id
      FROM Profile
      WHERE Name = :PROFILE_NAME_INNOVAPP_USER
      LIMIT 1
    ]
    .Id;
    Id projectLeaderProfileId = [
      SELECT Id
      FROM Profile
      WHERE Name = :PROFILE_NAME_PROJECT_LEADER
      LIMIT 1
    ]
    .Id;
    Id projectManagerProfileId = [
      SELECT Id
      FROM Profile
      WHERE Name = :PROFILE_NAME_PROJECT_MANAGER
      LIMIT 1
    ]
    .Id;

    userList.add(newUser('Project Manager 1', projectManagerProfileId, false));
    userList.add(newUser('Project Manager 2', projectManagerProfileId, false));
    userList.add(newUser('Project Leader 1', projectLeaderProfileId, false));
    userList.add(newUser('Project Leader 2', projectLeaderProfileId, false));
    userList.add(newUser('Innovap User 1', innovaAppProfileId, false));
    userList.add(newUser('Innovap User 2', innovaAppProfileId, false));
    userList.add(newUser('Innovap User 3', innovaAppProfileId, false));
    userList.add(newUser('Innovap User 4', innovaAppProfileId, false));

    insert userList;
  }

  public static void createTeams() {
    customTeamList.add(newCustomTeam('Team 1', false));
    customTeamList.add(newCustomTeam('Team 2', false));

    insert customTeamList;
  }

  public static void createTeamMembers() {
    customTeamMemberList.add(
      newCustomTeamMember(
        userList.get(0),
        customTeamList.get(0),
        TEAM_MEMBER_ACCESS_READ,
        null,
        false
      )
    );
    customTeamMemberList.add(
      newCustomTeamMember(
        userList.get(2),
        customTeamList.get(0),
        TEAM_MEMBER_ACCESS_EDIT,
        null,
        false
      )
    );
    customTeamMemberList.add(
      newCustomTeamMember(
        userList.get(4),
        customTeamList.get(0),
        TEAM_MEMBER_ACCESS_EDIT,
        null,
        false
      )
    );
    customTeamMemberList.add(
      newCustomTeamMember(
        userList.get(5),
        customTeamList.get(0),
        TEAM_MEMBER_ACCESS_EDIT,
        null,
        false
      )
    );

    customTeamMemberList.add(
      newCustomTeamMember(
        userList.get(1),
        customTeamList.get(1),
        TEAM_MEMBER_ACCESS_READ,
        null,
        false
      )
    );
    customTeamMemberList.add(
      newCustomTeamMember(
        userList.get(3),
        customTeamList.get(1),
        TEAM_MEMBER_ACCESS_EDIT,
        null,
        false
      )
    );
    customTeamMemberList.add(
      newCustomTeamMember(
        userList.get(6),
        customTeamList.get(1),
        TEAM_MEMBER_ACCESS_EDIT,
        null,
        false
      )
    );
    customTeamMemberList.add(
      newCustomTeamMember(
        userList.get(7),
        customTeamList.get(1),
        TEAM_MEMBER_ACCESS_EDIT,
        null,
        false
      )
    );

    insert customTeamMemberList;
  }

  public static void createAccounts() {
    accountList.add(newAccount(BACARDI_NAME, false));

    insert accountList;
  }

  public static void createContacts() {
    contactList.add(newContact(BACARDI_NAME, false));

    insert contactList;
  }

  public static void createProjects() {
    projectList.add(
      newProject(
        'Test Fearless Bet',
        InnovatorConstants.FEARLESS_BET,
        DISCOVER_PHASE,
        userList.get(0),
        userList.get(2),
        customTeamList.get(0),
        false
      )
    );
    projectList.add(
      newProject(
        'Test Repack (Container + Artwork)',
        PROJECT_CLASSIFICATION_REPACK,
        DISCOVER_PHASE,
        userList.get(0),
        userList.get(2),
        customTeamList.get(0),
        false
      )
    );
    projectList.get(1).NewPrimaryPack__c = true;
    projectList.add(
      newProject(
        'Test Repack (Artwork)',
        PROJECT_CLASSIFICATION_REPACK,
        DISCOVER_PHASE,
        userList.get(0),
        userList.get(2),
        customTeamList.get(0),
        false
      )
    );
    projectList.get(2).ArtworkChange__c = true;
    projectList.add(
      newProject(
        'Test Promotional Pack',
          PROJECT_CLASSIFICATION_PROMOTIONAL_PACK,
        DISCOVER_PHASE,
        userList.get(0),
        userList.get(2),
        customTeamList.get(0),
        false
      )
    );
    projectList.add(
      newProject(
        'Test Geographical Extension (Innovation)',
        PROJECT_CLASSIFICATION_GEOEXTENSION,
        DISCOVER_PHASE,
        userList.get(0),
        userList.get(2),
        customTeamList.get(0),
        false
      )
    );
    projectList.get(4)
      .GeoExtensionProjectSubClassification__c = InnovatorConstants.GEO_EXTENSION_OTHER;
    projectList.add(
      newProject(
        'Test Geographical Extension (Other)',
        PROJECT_CLASSIFICATION_GEOEXTENSION,
        DISCOVER_PHASE,
        userList.get(0),
        userList.get(2),
        customTeamList.get(0),
        false
      )
    );
    projectList.get(5)
      .GeoExtensionProjectSubClassification__c = InnovatorConstants.GEO_EXTENSION_OTHER;
    projectList.add(
      newProject(
        'Test Continuous Improvement',
        PROJECT_CLASSIFICATION_CI,
        DISCOVER_PHASE,
        userList.get(0),
        userList.get(2),
        customTeamList.get(0),
        false
      )
    );
    projectList.add(
      newProject(
        'Test Mandatory',
        PROJECT_CLASSIFICATION_MANDATORY,
        DISCOVER_PHASE,
        userList.get(0),
        userList.get(2),
        customTeamList.get(0),
        false
      )
    );
    projectList.add(
      newProject(
        'Test Business Enabler',
        PROJECT_CLASSIFICATION_BUSINESS_ENABLER,
        DISCOVER_PHASE,
        userList.get(0),
        userList.get(2),
        customTeamList.get(0),
        false
      )
    );
    projectList.add(
      newProject(
        'Test Brand Energizer',
        InnovatorConstants.BRAND_ENERGIZER,
        DISCOVER_PHASE,
        userList.get(0),
        userList.get(2),
        customTeamList.get(0),
        false
      )
    );

    insert projectList;
  }

  public static void createApprovalMatrices() {
    Id matrixRecordTypeId = Schema.SObjectType.ApprovalMatrix__c.getRecordTypeInfosByDeveloperName().get(MATRIX_RT).getRecordTypeId();
    Id ocRecordTypeId = Schema.SObjectType.ApprovalMatrix__c.getRecordTypeInfosByDeveloperName().get(OC_RT).getRecordTypeId();
    Id bmcRecordTypeId = Schema.SObjectType.ApprovalMatrix__c.getRecordTypeInfosByDeveloperName().get(BMC_RT).getRecordTypeId();

    approvalMatrixList.add(
      newApprovalMatrix(
        matrixRecordTypeId,
        userList.get(0),
        OPPORTUNITY_MILESTONE,
        false
      )
    );
    approvalMatrixList.add(
      newApprovalMatrix(
        matrixRecordTypeId,
        userList.get(0),
        OPPORTUNITY_MILESTONE,
        false
      )
    );
    approvalMatrixList.add(
      newApprovalMatrix(
        matrixRecordTypeId,
        userList.get(1),
        BUSINESS_CASE_AMBITION_MILESTONE,
        false
      )
    );
    approvalMatrixList.add(
      newApprovalMatrix(
        matrixRecordTypeId,
        userList.get(2),
        BUSINESS_CASE_VALIDATION_MILESTONE,
        false
      )
    );
    approvalMatrixList.add(
      newApprovalMatrix(
        matrixRecordTypeId,
        userList.get(3),
        COMMERCIAL_MILESTONE,
        false
      )
    );
    approvalMatrixList.add(
      newApprovalMatrix(
        matrixRecordTypeId,
        userList.get(4),
        PRODUCTION_MILESTONE,
        false
      )
    );
    approvalMatrixList.add(
      newApprovalMatrix(
        matrixRecordTypeId,
        userList.get(5),
        POST_LAUNCH_REVIEW_MILESTONE,
        false
      )
    );

    ApprovalMatrix__c approvalMatrixBMCTwo = new ApprovalMatrix__c(BMCClassification__c = 'Air', Category__c = 'RUM', MarketClassification__c = 'Must Win', Brand__c = 'BACARDI', LeadMarket__c = 'PT', RecordTypeId = bmcRecordTypeId);
    approvalMatrixList.add(approvalMatrixBMCTwo);
      
    ApprovalMatrix__c approvalMatrix = new ApprovalMatrix__c(BMCClassification__c = 'Air', Category__c = 'RUM', MarketClassification__c = 'Must Win', Brand__c = 'BACARDI', LeadMarket__c = 'AF', RecordTypeId = bmcRecordTypeId);
    approvalMatrixList.add(approvalMatrix);

    insert approvalMatrixList;
  }

  public static void createProductHierarchies() {
    productHierarchyList.add(
      newProductHierarchy(true, false, false, false, false, false)
    );
    productHierarchyList.add(
      newProductHierarchy(false, true, false, false, false, false)
    );
    productHierarchyList.add(
      newProductHierarchy(false, false, true, false, false, false)
    );
    productHierarchyList.add(
      newProductHierarchy(false, false, false, true, false, false)
    );
    productHierarchyList.add(
      newProductHierarchy(false, false, false, false, true, false)
    );

    insert productHierarchyList;
  }

  public static void createGeoHierarchies() {
    geoHierarchyList.add(newGeoHierarchy(false));

    insert geoHierarchyList;
  }

  public static void createFinancials() {
    Id recordTypeId = [
      SELECT Id, Name
      FROM RecordType
      WHERE Name = 'Financial Data'
    ]
    .Id;
    for (Project__c project : projectList) {
      financialList.add(newFinancial(project.Id, recordTypeId, false));
    }
    insert financialList;
  }
  public static void createDeliverables() {
    Id recordTypeId = [
      SELECT Id, Name
      FROM RecordType
      WHERE Name = 'Deliverable'
    ]
    .Id;
    for (Project__c project : projectList) {
      deliverableList.add(newDeliverable(project.Id, recordTypeId, false));
    }
    insert deliverableList;
  }
  public static User newUser(String name, Id profileId, Boolean doInsert) {
    User user = new User(
      Alias = String.valueOf(Crypto.getRandomInteger()).substring(1, 5),
      Email = 'testuser@test.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Test',
      FirstName = name,
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      ProfileId = profileId,
      TimeZoneSidKey = 'America/Los_Angeles',
      Username = name.deleteWhitespace() + 'testuser@test.com'
    );

    if (doInsert) {
      insert user;
    }
    return user;
  }

  public static Account newAccount(String name, Boolean doInsert) {
    Account account = new Account(
      Name = name,
      ShippingPostalCode = '1',
      ShippingState = '1',
      ShippingCountry = '1',
      ShippingCity = '1',
      ShippingStreet = '1'
    );

    if (doInsert) {
      insert account;
    }
    return account;
  }

  public static Contact newContact(String lastName, Boolean doInsert) {
    Contact contact = new Contact(LastName = lastName, FirstName = lastName);

    if (doInsert) {
      insert contact;
    }
    return contact;
  }

  public static CustomTeams__Teams__c newCustomTeam(
    String name,
    Boolean doInsert
  ) {
    CustomTeams__Teams__c team = new CustomTeams__Teams__c(Name = name);

    if (doInsert) {
      insert team;
    }
    return team;
  }

  public static CustomTeams__Team_Members__c newCustomTeamMember(
    User user,
    CustomTeams__Teams__c team,
    String accessLevel,
    String role,
    Boolean doInsert
  ) {
    CustomTeams__Team_Members__c teamMember = new CustomTeams__Team_Members__c(
      CustomTeams__User__c = user.Id,
      CustomTeams__Team__c = team.Id,
      CustomTeams__Access_Level__c = accessLevel,
      CustomTeams__Role__c = role
    );

    if (doInsert) {
      insert teamMember;
    }
    return teamMember;
  }

  public static Project__c newProject(
    String name,
    String projectClassification,
    String projectPhase,
    User projectLeader,
    User projectManager,
    CustomTeams__Teams__c team,
    Boolean doInsert
  ) {
    Project__c project = new Project__c(
      Name = name,
      ProjectClassification__c = projectClassification,
      ProjectPhase__c = projectPhase,
      ProjectLeader__c = projectLeader.Id,
      ProjectManager__c = projectManager.Id,
      Team__c = team.Id,
      Brand__c = NEW_HIERARCHY_DESCRIPTION,
      Subrand__c = NEW_HIERARCHY_DESCRIPTION,
      Category__c = NEW_HIERARCHY_DESCRIPTION,
      Flavour__c = NEW_HIERARCHY_DESCRIPTION,
      Size__c = NEW_HIERARCHY_DESCRIPTION,
      Cluster__c = 'Test Cluster',
      Hub__c = 'Test Hub',
      DC__c = NEW_HIERARCHY_DESCRIPTION,
      TradeType__c = PROJECT_TRADETYPE_ONTRADE
    );

    if (doInsert) {
      insert project;
    }
    return project;
  }

  public static ApprovalMatrix__c newApprovalMatrix(
    String recordTypeId,
    User approver,
    String decisionStep,
    Boolean doInsert
  ) {
    ApprovalMatrix__c approvalMatrix = new ApprovalMatrix__c(
      RecordTypeId = recordTypeId,
      Approver__c = approver.Id,
      DecisionStep__c = decisionStep,
      ProjectClassification__c = 'Fearless Bet;Business Enabler;Promotional Pack;Brand Energizer;Repack;Continuous Improvement;Mandatory;Geographical Extension',
      ApprovalStep__c = '1',
      ApprovalType__c = 'Online Approvals'
    );

    if (doInsert) {
      insert approvalMatrix;
    }
    return approvalMatrix;
  }
  public static ProductHierarchy__c newProductHierarchy(
    Boolean isBrand,
    Boolean isSubbrand,
    Boolean isCategory,
    Boolean isFlavour,
    Boolean isSize,
    Boolean doInsert
  ) {
    ProductHierarchy__c productHierarchy = new ProductHierarchy__c(
      Brand__c = NEW_HIERARCHY_TYPE,
      SubBrand__c = NEW_HIERARCHY_TYPE,
      Category__c = NEW_HIERARCHY_TYPE,
      Flavour__c = NEW_HIERARCHY_TYPE,
      Size__c = NEW_HIERARCHY_TYPE,
      IsBrand__c = isBrand,
      IsSubrand__c = isSubbrand,
      IsCategory__c = isCategory,
      IsFlavour__c = isFlavour,
      IsSize__c = isSize,
      BrandDescription__c = NEW_HIERARCHY_DESCRIPTION,
      SubBrandDescription__c = NEW_HIERARCHY_DESCRIPTION,
      CategoryDescription__c = NEW_HIERARCHY_DESCRIPTION,
      FlavourDescription__c = NEW_HIERARCHY_DESCRIPTION,
      SizeDescription__c = NEW_HIERARCHY_DESCRIPTION
    );
    if (doInsert) {
      insert productHierarchy;
    }
    return productHierarchy;
  }
  public static GeoHierarchy__c newGeoHierarchy(Boolean doInsert) {
    GeoHierarchy__c geoHierarchy = new GeoHierarchy__c(
      Cluster__c = GEO_CLUSTER,
      Country__c = GEO_COUNTRY,
      DC__c = GEO_DC,
      HUB__c = GEO_HUB,
      Region__c = GEO_REGION,
      CountryDescription__c = GEO_COUNTRY_DESCRIPTION
    );
    if (doInsert) {
      insert geoHierarchy;
    }
    return geoHierarchy;
  }
  public static Financial__c newFinancial(
    Id projectId,
    Id recordTypeId,
    Boolean doInsert
  ) {
    Financial__c financial = new Financial__c(
      Volume__c = 1.0,
      NSV__c = 1.0,
      COGSDecreaseCurrent__c = 1.0,
      COGSIncreaseCurrent__c = 1.0,
      COGSNoChangeCurrent__c = 1.0,
      Project__c = projectId,
      RecordTypeId = recordTypeId,
      ActualFY__c = 1
    );
    if (doInsert) {
      insert financial;
    }
    return financial;
  }
  public static Financial__c newDeliverable(
    Id projectId,
    Id recordTypeId,
    Boolean doInsert
  ) {
    Financial__c financial = new Financial__c(
      Label__c = 'Test',
      BCVVAlue__c = 1.0,
      BCAValue__c = 1.0,
      PMValue__c = 1.0,
      CMValue__c = 1.0,
      Project__c = projectId,
      RecordTypeId = recordTypeId
    );
    if (doInsert) {
      insert financial;
    }
    return financial;
  }

  public static void createRuleMatrix(Id userId) {
    List<ApprovalMatrix__c> approvalMatrixes = new List<ApprovalMatrix__c>();
    Id bmcRecordTypeId = Schema.SObjectType.ApprovalMatrix__c.getRecordTypeInfosByDeveloperName()
      .get(InnovatorConstants.BMC_RECORDTYPE)
      .getRecordTypeId();
    ApprovalMatrix__c approvalMatrix = new ApprovalMatrix__c(
      RuleKey__c = 'R-00001',
      ProjectClassification__c = PROJECT_CLASSIFICATION_PROMOTIONAL_PACK,
      DistributionChannel__c = GEO_DC,
      Approver__c = userId,
      DecisionStep__c = 'Business Case Ambition',
      ApprovalStep__c = '1',
      ApprovalType__c = 'Online Approvals'
    );
    ApprovalMatrix__c bmcApprovalMatrix = new ApprovalMatrix__c(
      RuleKey__c = 'R-00002',
      LeadMarket__c = 'ES',
      Brand__c = 'BACARDI',
      RecordTypeId = bmcRecordTypeId
    );
    approvalMatrixes.add(approvalMatrix);
    approvalMatrixes.add(bmcApprovalMatrix);
    insert approvalMatrixes;
  }
}