@isTest
public with sharing class ApprovalProcessServiceTest {
    private static final String PROMOTIONAL_PACK = 'Promotional Pack';
    private static final String GEO_EXTENSION = 'Geographical Extension';
    private static final String REPACK = 'Repack';
    private static final String CONTINUOUS_IMPROVEMENT = 'Continuous Improvement';
    private static final String MANDATORY = 'Mandatory';
    private static final String FEARLESS_BET = 'Fearless Bet';

    private static final String GEO_EXTENSION_IPC = 'IPC';
    private static final String GEO_EXTENSION_CHANGE = 'Liq/Sourcing/Pack Change';
    private static final String BRAND_ACTIVATION_LOCAL = 'Local execution';
    private static final String BRAND_ACTIVATION_NEW_PACK = 'Produced at plant/New Pack';
    private static final String BRAND_ACTIVATION_ARTWORK_CHANGE = 'Produced at plant/Artwork Change';
    private static final String REPACK_PRIMARY_PACK_CHANGE = 'Primary pack change';
    private static final String REPACK_ARTWORK_CHANGE_ONLY = 'Artwork change only';
    private static final String CI_MANDATORY_LIQ_PACK_CHANGE = 'Pack/Liquid Change';
    private static final String CI_MANDATORY_ARTWORK_CHANGE = 'Artwork Change';
    private static final String CORRECT_CALCULATION_MESSAGE = 'Correct calculation of subtype';
    private static final String CORRECT_CALCULATION_COMPLEX_MESSAGE = 'Correct calculation of subtype Complex Subtype';
    private static final String CORRECT_SUBMISSION_STATUS_MESSAGE = 'A Project that was originally in define and moved to the next phase, should have "Business Case Ambition Approved" as decision step status';
    private static final String CORRECT_SUBMISSION_STATUS_MESSAGE_ADDITIONAL_APPROVER = 'A Project that was originally in define and has Additional Approver, should have "Opportunity Milestone yet to be submitted" as decision step status';
    private static final String SUBMISSION_STATUS_BCA_APPROVED = 'Business Case Ambition Approved';
    private static final String SUBMISSION_STATUS_OPPORTUNITY_APPROVED = 'Opportunity Milestone Approved';
    private static final String SUBMISSION_STATUS_OPPORTUNITY_MILESTONE = 'Opportunity Milestone yet to be submitted';

    static void makeData() {
        List<Project__c> geoExtensionProjectList = new List<Project__c>();
        List<Project__c> promotionalPackProjectList = new List<Project__c>();
        List<Project__c> repackProjectList = new List<Project__c>();
        List<Project__c> ciMandatoryProjectList = new List<Project__c>();
        List<Project__c> fearlessBetProjectList = new List<Project__c>();

        Project__c project1 = new Project__c();
        project1.Name = 'Project 1';
        project1.ProjectClassification__c = GEO_EXTENSION;
        project1.IPCExtensionWithoutArtworkChange__c = true;
        project1.ProjectClassificationSubtype__c = GEO_EXTENSION_IPC;
        project1.ArtworkChange__c = true;
        project1.NewLiquid__c = true;
        project1.NewPrimaryPack__c = true;
        project1.SourcingChange__c = true;
        project1.ApprovalProcessStatus__c = 'Submitted';

        geoExtensionProjectList.add(project1);

        Project__c project2 = new Project__c();
        project2.Name = 'Project 2';
        project2.ProjectClassification__c = GEO_EXTENSION;
        project2.IPCExtensionWithoutArtworkChange__c = true;
        project2.ArtworkChange__c = false;
        project2.NewLiquid__c = false;
        project2.NewPrimaryPack__c = false;
        project2.SourcingChange__c = true;
        project2.ProjectClassificationSubtype__c = GEO_EXTENSION_CHANGE;
        project2.ApprovalProcessStatus__c = 'Submitted';

        geoExtensionProjectList.add(project2);

        Project__c project3 = new Project__c();
        project3.Name = 'Project 3';
        project3.ProjectClassification__c = GEO_EXTENSION;
        project3.IPCExtensionWithoutArtworkChange__c = true;
        project3.ArtworkChange__c = false;
        project3.NewLiquid__c = false;
        project3.NewPrimaryPack__c = false;
        project3.SourcingChange__c = false;
        project3.ApprovalProcessStatus__c = 'Submitted';

        geoExtensionProjectList.add(project3);
        
        Project__c project18 = new Project__c();
        project18.Name = 'Project 18';
        project18.ProjectClassification__c = GEO_EXTENSION;
        project18.IPCExtensionWithoutArtworkChange__c = true;
        project18.ArtworkChange__c = true;
        project18.NewLiquid__c = false;
        project18.NewPrimaryPack__c = false;
        project18.SourcingChange__c = false;
        project18.ApprovalProcessStatus__c = 'Submitted';

        geoExtensionProjectList.add(project18);

        insert geoExtensionProjectList;

        Project__c project9 = new Project__c();
        project9.Name = 'Project 9';
        project9.ProjectClassification__c = REPACK;
        project9.NewPrimaryPack__c = true;
        project9.ArtworkChange__c = true;
        project9.ApprovalProcessStatus__c = 'Submitted';

        repackProjectList.add(project9);

        Project__c project10 = new Project__c();
        project10.Name = 'Project 10';
        project10.ProjectClassification__c = REPACK;
        project10.NewPrimaryPack__c = false;
        project10.ArtworkChange__c = false;
        project10.ApprovalProcessStatus__c = 'Submitted';

        repackProjectList.add(project10);

        Project__c project11 = new Project__c();
        project11.Name = 'Project 11';
        project11.ProjectClassification__c = REPACK;
        project11.NewPrimaryPack__c = false;
        project11.ArtworkChange__c = true;
        project11.ProjectClassificationSubtype__c = REPACK_ARTWORK_CHANGE_ONLY;
        project11.ApprovalProcessStatus__c = 'Submitted';

        repackProjectList.add(project11);

        Project__c project12 = new Project__c();
        project12.Name = 'Project 12';
        project12.ProjectClassification__c = REPACK;
        project12.NewPrimaryPack__c = true;
        project12.ArtworkChange__c = false;
        project12.ApprovalProcessStatus__c = 'Submitted';

        repackProjectList.add(project12);

        insert repackProjectList;

        Project__c project13 = new Project__c();
        project13.Name = 'Project 13';
        project13.ProjectClassification__c = MANDATORY;
        project13.ArtworkChange__c = false;
        project13.NewLiquid__c = false;
        project13.PrimarySecondaryPackChange__c = true;

        ciMandatoryProjectList.add(project13);

        Project__c project14 = new Project__c();
        project14.Name = 'Project 14';
        project14.ProjectClassification__c = MANDATORY;
        project14.ArtworkChange__c = false;
        project14.NewLiquid__c = false;
        project14.PrimarySecondaryPackChange__c = false;
        project14.ValueCreation__c = false;
        project14.SourcingChange__c = false;

        ciMandatoryProjectList.add(project14);

        Project__c project15 = new Project__c();
        project15.Name = 'Project 15';
        project15.ProjectClassification__c = CONTINUOUS_IMPROVEMENT;
        project15.ArtworkChange__c = true;
        project15.NewLiquid__c = false;
        project15.PrimarySecondaryPackChange__c = false;
        project15.ValueCreation__c = false;
        project15.SourcingChange__c = false;
        project15.ApprovalProcessStatus__c = 'Submitted';

        ciMandatoryProjectList.add(project15);

        Project__c project16 = new Project__c();
        project16.Name = 'Project 16';
        project16.ProjectClassification__c = CONTINUOUS_IMPROVEMENT;
        project16.ArtworkChange__c = true;
        project16.ValueCreation__c = true;
        project16.NewLiquid__c = false;
        project16.PrimarySecondaryPackChange__c = false;
        project16.SourcingChange__c = false;
        project16.ApprovalProcessStatus__c = 'Submitted';

        ciMandatoryProjectList.add(project16);

        insert ciMandatoryProjectList;

        Project__c project17 = new Project__c();
        project17.Name = 'Project 17';
        project17.ProjectClassification__c = FEARLESS_BET;
        project17.ArtworkChange__c = false;
        project17.NewLiquid__c = false;
        project17.PrimarySecondaryPackChange__c = false;
        project17.ValueCreation__c = false;
        project17.SourcingChange__c = false;
        project17.ApprovalProcessStatus__c = 'Submitted';

        fearlessBetProjectList.add(project17);

        insert fearlessBetProjectList;
    }

    @IsTest
    private static void testGeoExtensionSubtypeCalculation() {
        makeData();
        List<Project__c> projectlist = [SELECT Id, ProjectClassification__c, ProjectClassificationSubtype__c, IPCExtensionWithoutArtworkChange__c, ArtworkChange__c, NewLiquid__c, NewPrimaryPack__c, SourcingChange__c FROM Project__c WHERE ProjectClassification__c = 'Geographical Extension'];

        Test.startTest();
        for (Integer index = 0; index < projectlist.size(); index++) {
            projectlist[index] = ApprovalProcessService.setGeoExtensionProjectSubType(projectlist[index]);
        }
        update projectlist;
        Test.stopTest();

        Project__c project1 = projectlist.get(0);
        Project__c project2 = projectlist.get(1);
        Project__c project3 = projectlist.get(2);
        Project__c project4 = projectlist.get(3);

        system.assertEquals(GEO_EXTENSION_CHANGE, project1.ProjectClassificationSubtype__c, CORRECT_CALCULATION_MESSAGE);
        system.assertEquals(GEO_EXTENSION_CHANGE, project2.ProjectClassificationSubtype__c, CORRECT_CALCULATION_MESSAGE);
        system.assertEquals(GEO_EXTENSION_IPC, project3.ProjectClassificationSubtype__c, CORRECT_CALCULATION_MESSAGE);
        system.assertEquals(GEO_EXTENSION_IPC, project4.ProjectClassificationSubtype__c, CORRECT_CALCULATION_MESSAGE);

    }

    @IsTest
    private static void testCIMandatorySubtypeCalculation() {
        makeData();
        List<Project__c> CIProjectlist = [SELECT Id, ProjectClassification__c, ProjectClassificationSubtype__c, ArtworkChange__c, NewLiquid__c, PrimarySecondaryPackChange__c, ValueCreation__c, SourcingChange__c FROM Project__c WHERE ProjectClassification__c = 'Continuous Improvement'];
        List<Project__c> mandatoryProjectlist = [SELECT Id, ProjectClassification__c, ProjectClassificationSubtype__c, ArtworkChange__c, NewLiquid__c, PrimarySecondaryPackChange__c, ValueCreation__c, SourcingChange__c FROM Project__c WHERE ProjectClassification__c = 'Mandatory'];

        Test.startTest();
            for (Integer index = 0; index < CIProjectlist.size(); index++) {
                CIProjectlist[index] = ApprovalProcessService.setCiMandatorySubType(CIProjectlist[index]);
            }
            update CIProjectlist;
            for (Integer index = 0; index < mandatoryProjectlist.size(); index++) {
                mandatoryProjectlist[index] = ApprovalProcessService.setCiMandatorySubType(mandatoryProjectlist[index]);
            }
            update mandatoryProjectlist;
        Test.stopTest();

        Project__c project1 = CIProjectlist.get(0);
        Project__c project2 = CIProjectlist.get(1);

        Project__c project3 = mandatoryProjectlist.get(0);
        Project__c project4 = mandatoryProjectlist.get(1);

        system.assertEquals(CI_MANDATORY_ARTWORK_CHANGE, project1.ProjectClassificationSubtype__c, CORRECT_CALCULATION_COMPLEX_MESSAGE);
        system.assertEquals(CI_MANDATORY_ARTWORK_CHANGE, project2.ProjectClassificationSubtype__c, CORRECT_CALCULATION_COMPLEX_MESSAGE);
        system.assertEquals(CI_MANDATORY_LIQ_PACK_CHANGE, project3.ProjectClassificationSubtype__c, CORRECT_CALCULATION_COMPLEX_MESSAGE);
        system.assertEquals(CI_MANDATORY_LIQ_PACK_CHANGE, project4.ProjectClassificationSubtype__c, CORRECT_CALCULATION_COMPLEX_MESSAGE);
    }

    @isTest
    private static void testRepackSubtypeCalculation() {
        makeData();
        List<Project__c> projectlist = [SELECT Id, ProjectClassification__c, ProjectClassificationSubtype__c, NewPrimaryPack__c, ArtworkChange__c FROM Project__c WHERE ProjectClassification__c = 'Repack' ];

        Test.startTest();
        for (Integer index = 0; index < projectlist.size(); index++) {
            projectlist[index] = ApprovalProcessService.setRepackSubType(projectlist[index]);
        }
        update projectlist;
        Test.stopTest();

        Project__c project1 = projectlist.get(0);
        Project__c project2 = projectlist.get(1);
        Project__c project3 = projectlist.get(2);
        project__c project4 = projectlist.get(3);

        system.assertEquals(REPACK_PRIMARY_PACK_CHANGE, project1.ProjectClassificationSubtype__c, CORRECT_CALCULATION_COMPLEX_MESSAGE);
        system.assertEquals(REPACK_PRIMARY_PACK_CHANGE, project2.ProjectClassificationSubtype__c, CORRECT_CALCULATION_COMPLEX_MESSAGE);
        system.assertEquals(REPACK_ARTWORK_CHANGE_ONLY, project3.ProjectClassificationSubtype__c, CORRECT_CALCULATION_MESSAGE);
        system.assertEquals(REPACK_PRIMARY_PACK_CHANGE, project4.ProjectClassificationSubtype__c, CORRECT_CALCULATION_MESSAGE);
    }

    @isTest
    private static void testUpdateRejectedStatus() {
        makeData();
        Project__c project = [SELECT Id, ProjectClassification__c, ProjectClassificationSubtype__c, NewPrimaryPack__c, ArtworkChange__c, ProjectPhase__c FROM Project__c WHERE ProjectClassification__c = 'Repack' LIMIT 1];

        Test.startTest();
        ApprovalProcessService.updateProjectRejectedStatus(project);
        Test.stopTest();
    }

    @IsTest
    private static void testUpdateStatus_BrandActivation_CI() {
        makeData();
        Id adminUserId = ApprovalProcessRepository.getAdminUserId();
        List<String> classifications = new List<String>{ CONTINUOUS_IMPROVEMENT };
        List<Project__c> projects = ApprovalProcessRepository.getProjectsByClassifications(classifications);

        for (Project__c project : projects) {
            project.ProjectPhase__c = 'Define';
            project.ApprovalProcessStatus__c = 'Approved';
            project.ProjectLeader__c = adminUserId;
            project.ProjectManager__c = adminUserId;
        }

        Test.startTest();
        update projects;
        Test.stopTest();

        List<Project__c> updatedProjects = ApprovalProcessRepository.getProjectsByClassifications(classifications);

        for (Project__c project : updatedProjects) {
            if (project.ProjectClassification__c == PROMOTIONAL_PACK || project.ProjectClassification__c == CONTINUOUS_IMPROVEMENT) {
                System.assertEquals(SUBMISSION_STATUS_BCA_APPROVED, project.SubmissionStatus__c, project.Name + ': ' +  CORRECT_SUBMISSION_STATUS_MESSAGE);
            }
        }
    }

    @IsTest
    private static void testUpdateStatus_Repack() {
        makeData();
        Id adminUserId = ApprovalProcessRepository.getAdminUserId();
        List<String> classifications = new List<String>{ REPACK };
        List<Project__c> projects = ApprovalProcessRepository.getProjectsByClassifications(classifications);

        projects[0].AdditionalApprover1__c = adminUserId;
        for (Project__c project : projects) {
            project.ProjectPhase__c = 'Define';
            project.ApprovalProcessStatus__c = 'Approved';
            project.ProjectLeader__c = adminUserId;
            project.ProjectManager__c = adminUserId;
        }

        Test.startTest();
        update projects;
        Test.stopTest();

        List<Project__c> updatedProjects = ApprovalProcessRepository.getProjectsByClassifications(classifications);

        for (Project__c project : updatedProjects) {
            if (project.ProjectClassification__c == REPACK && project.AdditionalApprover1__c == null) {
                System.assertEquals(SUBMISSION_STATUS_BCA_APPROVED, project.SubmissionStatus__c, project.Name + ': ' + CORRECT_SUBMISSION_STATUS_MESSAGE);
            } else  {
                System.assertEquals(SUBMISSION_STATUS_OPPORTUNITY_MILESTONE, project.SubmissionStatus__c, project.Name + ': ' + CORRECT_SUBMISSION_STATUS_MESSAGE_ADDITIONAL_APPROVER);
            }
        }
    }

    @IsTest
    private static void testUpdateStatus_GEO() {
        makeData();
        Id adminUserId = ApprovalProcessRepository.getAdminUserId();
        List<String> classifications = new List<String>{ FEARLESS_BET, GEO_EXTENSION };
        List<Project__c> projects = ApprovalProcessRepository.getProjectsByClassifications(classifications);

        for (Project__c project : projects) {
            project.ProjectPhase__c = 'Define';
            project.ApprovalProcessStatus__c = 'Approved';
            project.ProjectLeader__c = adminUserId;
            project.ProjectManager__c = adminUserId;
            project.Region__c = 'NORTH AMERICA';
        }

        Test.startTest();
        update projects;
        Test.stopTest();

        List<Project__c> updatedProjects = ApprovalProcessRepository.getProjectsByClassifications(classifications);

        for (Project__c project : updatedProjects) {
            if (project.ProjectClassification__c == GEO_EXTENSION || project.ProjectClassification__c == FEARLESS_BET) {
                System.assertEquals(SUBMISSION_STATUS_BCA_APPROVED, project.SubmissionStatus__c, project.Name + ': ' + CORRECT_SUBMISSION_STATUS_MESSAGE);
            }
        }
    }

    @IsTest
    private static void testSendEmailForAutoApprovalAndGetListOfRecipients() {
        makeData();
        Id adminUserId = ApprovalProcessRepository.getAdminUserId();
        Set<Id> ids = new Set<Id>();
        ids.add(adminUserId);
        List<String> classifications = new List<String>{ FEARLESS_BET };
        List<Project__c> projects = ApprovalProcessRepository.getProjectsByClassifications(classifications);
		Project__c project = ProjectRepository.getProject(projects[0].Id);
        Test.startTest();
        String recipient = EmailManager.sendEmailForAutoApprovalAndGetListOfRecipients(project, ids, '', 'Define', true);
        Test.stopTest();
        
        System.assertNotEquals(null, recipient);
    }
}