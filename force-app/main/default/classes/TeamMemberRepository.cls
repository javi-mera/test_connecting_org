public with sharing class TeamMemberRepository {
    public static CustomTeams__Team_Members__c getTeamMemberById (Id teamMemberId) {
        return [SELECT Id, Name, CustomTeams__Team__c, CustomTeams__Team__r.OwnerId FROM CustomTeams__Team_Members__c WHERE Id = :teamMemberId];
    }

    public static Project__c getProjectById (Id projectId) {
        return [SELECT Id, Name, Team__r.OwnerId, Team__c, ProjectLeader__c, ProjectManager__c FROM Project__c WHERE Id = :projectId];
    }

    public static List<CustomTeams__Team_Members__c> getProjectTeamMembersByTeamId (Id teamId) {
        return [SELECT Id, CustomTeams__User__r.Name, CustomTeams__User__c, MemberRole__c, CustomTeams__Access_Level__c 
                FROM CustomTeams__Team_Members__c WHERE CustomTeams__Team__c = :teamId ORDER BY CustomTeams__User__r.Name ASC];
    }
    public static List<CustomTeams__Team_Members__c> getProjectTeamMembersByTeamIdExcludingRoles (Id teamId) {
        List<String> rolesToExclude = new List<String>{TeamMemberService.TEAM_MEMBER_ROLE_PM,TeamMemberService.TEAM_MEMBER_ROLE_PL};
        return [SELECT Id, CustomTeams__User__r.Name, CustomTeams__User__c, MemberRole__c, CustomTeams__Access_Level__c 
                FROM CustomTeams__Team_Members__c WHERE CustomTeams__Team__c = :teamId AND MemberRole__c NOT IN :rolesToExclude ORDER BY CustomTeams__User__r.Name ASC];
    }
    public static List<CustomTeams__Team_Members__c> getProjectTeamMembersByUserIdAndTeamId (Id userId, Id teamId) {
        return [SELECT Id, CustomTeams__Team__c, CustomTeams__User__c, MemberRole__c, CustomTeams__Access_Level__c 
                FROM CustomTeams__Team_Members__c WHERE CustomTeams__User__c = :userId AND CustomTeams__Team__c = :teamId];
    }
}