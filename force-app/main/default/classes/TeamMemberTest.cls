@isTest
public with sharing class TeamMemberTest {
    private static final String PROJECT_CLASSIFICATION_REPACK = 'Repack';
    @TestSetup
    static void testSetup(){
        TestFactory.generateBasicSetUp();
    }
    @isTest
    static void testAddNewTeamMembersReadAccess(){
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{PROJECT_CLASSIFICATION_REPACK}).get(0);
        List<LookupSearchResult> users = LookupUserController.searchAllUsers();
        Test.startTest();
        TeamMemberService.addNewTeamMembersReadAccess(project.Id,new List<Id>{users.get(0).getId()});
        Test.stopTest();
    }
    @isTest
    static void testAddNewTeamMembersReadAccessWithExistingTeamMember(){
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{PROJECT_CLASSIFICATION_REPACK}).get(0);
        List<LookupSearchResult> users = LookupUserController.searchAllUsers();
        TeamMemberService.addNewTeamMembersReadAccess(project.Id,new List<Id>{users.get(0).getId()});
        Test.startTest();
        TeamMemberService.addNewTeamMembersReadAccess(project.Id,new List<Id>{users.get(1).getId()});
        Test.stopTest();
    }
    @isTest
    static void testAddNewTeamMembersEditAccess(){
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{PROJECT_CLASSIFICATION_REPACK}).get(0);
        List<LookupSearchResult> users = LookupUserController.searchAllUsers();
        Test.startTest();
        TeamMemberService.addNewTeamMembersEditAccess(project.Id,new List<Id>{users.get(0).getId()},TeamMemberService.TEAM_MEMBER_ROLE_PL);
        Test.stopTest();
    }
    @isTest
    static void testDeleteTeamMember(){
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{PROJECT_CLASSIFICATION_REPACK}).get(0);
        List<LookupSearchResult> users = LookupUserController.searchAllUsers();
        List<CustomTeams__Team_Members__c> resultMember = TeamMemberService.addNewTeamMembersEditAccess(project.Id,new List<Id>{users.get(0).getId()},TeamMemberService.TEAM_MEMBER_ROLE_PM);
        Test.startTest();
        TeamMemberService.deleteTeamMember(project.Id,resultMember.get(0).CustomTeams__User__c);
        Test.stopTest();
    }
    @isTest
    static void testGetTeamMemberById(){
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{PROJECT_CLASSIFICATION_REPACK}).get(0);
        List<LookupSearchResult> users = LookupUserController.searchAllUsers();
        List<CustomTeams__Team_Members__c> resultMember = TeamMemberService.addNewTeamMembersEditAccess(project.Id,new List<Id>{users.get(0).getId()},TeamMemberService.TEAM_MEMBER_ROLE_PM);
        Test.startTest();
        TeamMemberRepository.getTeamMemberById(resultMember.get(0).Id);
        Test.stopTest();
    }
    @isTest
    static void testGetProjectTeamMembersByTeamIdExcludingRoles(){
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{PROJECT_CLASSIFICATION_REPACK}).get(0);
        Test.startTest();
        TeamMemberRepository.getProjectTeamMembersByTeamIdExcludingRoles(project.Team__c);
        Test.stopTest();
    }
}