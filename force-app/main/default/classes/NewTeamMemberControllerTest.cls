@IsTest
public class NewTeamMemberControllerTest {

    @IsTest
    static void createNewTeamMemberTest() {
        TestFactory.createAccounts();
        TestFactory.createContacts();
        Id projectLeaderProfileId = [SELECT Id FROM Profile WHERE Name = :InnovatorConstants.PROJECT_LEADER_USER_PROFILE LIMIT 1].Id;
        Id projectManagerProfileId = [SELECT Id FROM Profile WHERE Name = :InnovatorConstants.PROJECT_MANAGER_USER_PROFILE LIMIT 1].Id;
        Id innovappUserProfileId = [SELECT Id FROM Profile WHERE Name = :InnovatorConstants.INNOVAPP_USER_PROFILE LIMIT 1].Id;
        User projectLeader = TestFactory.newUser('Project Leader', projectLeaderProfileId, true);
        User projectManager = TestFactory.newUser('Project Manager', projectManagerProfileId, true);
        User innovappUser = TestFactory.newUser('Innovapp User', innovappUserProfileId, true);
        CustomTeams__Teams__c team = TestFactory.newCustomTeam('Fearless Bet Project Team', true);
        Project__c project = TestFactory.newProject(
            'Fearless Bet Project', 
        	InnovatorConstants.FEARLESS_BET,
        	InnovatorConstants.DISCOVER_PHASE,
        	projectLeader,
        	projectManager,
        	team,
        	true
        );
        Test.startTest();
        NewTeamMemberController.createNewTeamMember(project.id, innovappUser.Id);
        Test.stopTest();
    }

    @IsTest
    static void deleteTeamMemberTest() {
        TestFactory.createAccounts();
        TestFactory.createContacts();
        Id projectLeaderProfileId = [SELECT Id FROM Profile WHERE Name = :InnovatorConstants.PROJECT_LEADER_USER_PROFILE LIMIT 1].Id;
        Id projectManagerProfileId = [SELECT Id FROM Profile WHERE Name = :InnovatorConstants.PROJECT_MANAGER_USER_PROFILE LIMIT 1].Id;
        Id innovappUserProfileId = [SELECT Id FROM Profile WHERE Name = :InnovatorConstants.INNOVAPP_USER_PROFILE LIMIT 1].Id;
        User projectLeader = TestFactory.newUser('Project Leader', projectLeaderProfileId, true);
        User projectManager = TestFactory.newUser('Project Manager', projectManagerProfileId, true);
        User innovappUser = TestFactory.newUser('Innovapp User', innovappUserProfileId, true);
        CustomTeams__Teams__c team = TestFactory.newCustomTeam('Fearless Bet Project Team', true);
        Project__c project = TestFactory.newProject(
            'Fearless Bet Project', 
        	InnovatorConstants.FEARLESS_BET,
        	InnovatorConstants.DISCOVER_PHASE,
        	projectLeader,
        	projectManager,
        	team,
        	true
        );
        CustomTeams__Team_Members__c teamMember = NewTeamMemberController.createNewTeamMember(project.id, innovappUser.Id);
        Test.startTest();
        NewTeamMemberController.deleteTeamMember(teamMember.Id, project.id);
        Test.stopTest();
    }

    @IsTest
    static void getProjectTeamMembersTest() {
        TestFactory.createAccounts();
        TestFactory.createContacts();
        Id projectLeaderProfileId = [SELECT Id FROM Profile WHERE Name = :InnovatorConstants.PROJECT_LEADER_USER_PROFILE LIMIT 1].Id;
        Id projectManagerProfileId = [SELECT Id FROM Profile WHERE Name = :InnovatorConstants.PROJECT_MANAGER_USER_PROFILE LIMIT 1].Id;
        Id innovappUserProfileId = [SELECT Id FROM Profile WHERE Name = :InnovatorConstants.INNOVAPP_USER_PROFILE LIMIT 1].Id;
        User projectLeader = TestFactory.newUser('Project Leader', projectLeaderProfileId, true);
        User projectManager = TestFactory.newUser('Project Manager', projectManagerProfileId, true);
        User innovappUser = TestFactory.newUser('Innovapp User', innovappUserProfileId, true);
        CustomTeams__Teams__c team = TestFactory.newCustomTeam('Fearless Bet Project Team', true);
        Project__c project = TestFactory.newProject(
            'Fearless Bet Project', 
        	InnovatorConstants.FEARLESS_BET,
        	InnovatorConstants.DISCOVER_PHASE,
        	projectLeader,
        	projectManager,
        	team,
        	true
        );
        CustomTeams__Team_Members__c teamMember = NewTeamMemberController.createNewTeamMember(project.id, innovappUser.Id);
        Test.startTest();
        NewTeamMemberController.getProjectTeamMembers(project.id);
        Test.stopTest();
    }
}