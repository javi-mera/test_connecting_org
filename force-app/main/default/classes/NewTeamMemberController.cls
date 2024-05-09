public with sharing class NewTeamMemberController {
  private class DataTableUserWrapper {
    @AuraEnabled
    public Id teamMemberId { get; set; }
    @AuraEnabled
    public String userName { get; set; }
    @AuraEnabled
    public String userUrl { get; set; }
    @AuraEnabled
    public String accessLevel { get; set; }
    @AuraEnabled
    public String memberRole { get; set; }
  }

  @AuraEnabled
  public static CustomTeams__Team_Members__c createNewTeamMember(
    Id projectId,
    Id teamMemberUserId
  ) {
    //TODO: control input parameters;
    //TODO: add ability to remove a team member
    //TODO: refresh related list after team member creation

    //TODO: move all this logic to a service + repo
    Project__c currentProject = TeamMemberRepository.getProjectById(projectId);
    Id originalOwnerId = currentProject.Team__r.OwnerId;

    //TODO: control if we can add team members depending on the user type
    CustomTeams__Team_Members__c teamMember = new CustomTeams__Team_Members__c();
    CustomTeams__Teams__c team = new CustomTeams__Teams__c();
    if (currentProject.Team__c != null) {
      team.Id = currentProject.Team__c;
      team.OwnerId = UserInfo.getUserId();
      update team;

      teamMember.CustomTeams__Access_Level__c = 'Read';
      teamMember.CustomTeams__Team__c = team.Id;
      teamMember.CustomTeams__User__c = teamMemberUserId;
      insert teamMember;

      team.OwnerId = originalOwnerId;
      update team;
    }

    setProjectTeamMembers(projectId);

    return teamMember;
  }

  @AuraEnabled
  public static CustomTeams__Team_Members__c deleteTeamMember(
    Id teamMemberId,
    Id projectId
  ) {
    CustomTeams__Team_Members__c teamMember = TeamMemberRepository.getTeamMemberById(
      teamMemberId
    );
    CustomTeams__Teams__c team = new CustomTeams__Teams__c();
    if (teamMember.CustomTeams__Team__c != null) {
      team.Id = teamMember.CustomTeams__Team__c;
      team.OwnerId = UserInfo.getUserId();
      update team;

      delete teamMember;

      team.OwnerId = teamMember.CustomTeams__Team__r.OwnerId;
      update team;
    }

    setProjectTeamMembers(projectId);

    return teamMember;
  }

  public static void setProjectTeamMembers(Id projectId) {
    Project__c project = ProjectRepository.getProject(projectId);
    TeamMemberService.setTeamMembers(project);
    update project;
  }

  @AuraEnabled
  public static List<DataTableUserWrapper> getProjectTeamMembers(Id projectId) {
    Project__c currentProject = TeamMemberRepository.getProjectById(projectId);
    List<CustomTeams__Team_Members__c> projectTeamMembers = TeamMemberRepository.getProjectTeamMembersByTeamIdExcludingRoles(
      currentProject.Team__c
    );

    List<DataTableUserWrapper> projectTeamMembersWrapped = new List<DataTableUserWrapper>();
    for (CustomTeams__Team_Members__c teamMember : projectTeamMembers) {
      DataTableUserWrapper teamMemberWrapped = new DataTableUserWrapper();
      teamMemberWrapped.teamMemberId = teamMember.Id;
      teamMemberWrapped.userName = teamMember.CustomTeams__User__r.Name;
      teamMemberWrapped.accessLevel = teamMember.CustomTeams__Access_Level__c;
      teamMemberWrapped.memberRole = teamMember.MemberRole__c;
      projectTeamMembersWrapped.add(teamMemberWrapped);
    }

    return projectTeamMembersWrapped;
  }
}