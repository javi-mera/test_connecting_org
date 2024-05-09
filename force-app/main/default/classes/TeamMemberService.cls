public with sharing class TeamMemberService {
    public static final String TEAM_MEMBER_ROLE_PM = 'Project Manager';
    public static final String TEAM_MEMBER_ROLE_PL = 'Project Leader';

    public static List<CustomTeams__Team_Members__c> addNewTeamMembersReadAccess(
        Id projectId,
        List<Id> newTeamMemberIds
    ) {
        return addNewTeamMembers(projectId, newTeamMemberIds, 'Read');
    }

    public static List<CustomTeams__Team_Members__c> addNewTeamMembersEditAccess(
        Id projectId,
        List<Id> newTeamMemberIds,
        String memberRole
    ) {
        return addNewTeamMembers(projectId, newTeamMemberIds, 'Edit', memberRole);
    }
    public static List<CustomTeams__Team_Members__c> addNewTeamMembers(
        Id projectId,
        List<Id> newTeamMemberIds,
        String accessLevel
    ) {
        return addNewTeamMembers(projectId, newTeamMemberIds, accessLevel, null);
    }
    /*
     * HACK: Due to a Custom Teams package limitation, we cannot add or remove team members if we are not the team owner
     * To allow other users to add/remove team members, we temporarily change the team owner to the current user.
     */
    /*
     * Update (18/12/2023): If a user is already a Team Member and this user is assigned as a PL or PM, the logic updates the access to Edit
     */
    public static List<CustomTeams__Team_Members__c> addNewTeamMembers(
        Id projectId,
        List<Id> newTeamMemberIds,
        String accessLevel,
        String memberRole
    ) {
        Project__c currentProject = TeamMemberRepository.getProjectById(projectId);
        List<CustomTeams__Team_Members__c> projectTeamMembers = TeamMemberRepository.getProjectTeamMembersByTeamId(
            currentProject.Team__c
        );
        Set<Id> existingTeamMemberUserIds = new Set<Id>();
        Map<Id, Id> teamMemberIdsByExistingMemberIds = new Map<Id, Id>();

        for (CustomTeams__Team_Members__c existingTeamMember : projectTeamMembers) {
            existingTeamMemberUserIds.add(existingTeamMember.CustomTeams__User__c);
            if (existingTeamMember.CustomTeams__User__c == currentProject.ProjectLeader__c || existingTeamMember.CustomTeams__User__c == currentProject.ProjectManager__c) {
                teamMemberIdsByExistingMemberIds.put(existingTeamMember.CustomTeams__User__c, existingTeamMember.Id);
            }
        }

        Set<Id> newTeamMemberIdsFiltered = new Set<Id>();

        for (Id teamMemberUserId : newTeamMemberIds) {
            if (!existingTeamMemberUserIds.contains(teamMemberUserId)) {
                newTeamMemberIdsFiltered.add(teamMemberUserId);
            }
        }

        List<CustomTeams__Team_Members__c> newTeamMembers = new List<CustomTeams__Team_Members__c>();
        List<CustomTeams__Team_Members__c> teamMembersToUpdate = new List<CustomTeams__Team_Members__c>();

        CustomTeams__Teams__c team = new CustomTeams__Teams__c();
        if (currentProject.Team__c != null && (newTeamMemberIdsFiltered.size() > 0 || teamMemberIdsByExistingMemberIds.size() > 0)) {
            //Temporary change of team owner
            team.Id = currentProject.Team__c;
            team.OwnerId = UserInfo.getUserId();
            update team;

            if (newTeamMemberIdsFiltered.size() > 0) {
                for (Id teamMemberUserId : newTeamMemberIdsFiltered) {
                    CustomTeams__Team_Members__c teamMember = new CustomTeams__Team_Members__c();
                    teamMember.CustomTeams__Access_Level__c = accessLevel;
                    teamMember.CustomTeams__Team__c = currentProject.Team__c;
                    teamMember.CustomTeams__User__c = teamMemberUserId;
                    if (memberRole != null) {
                        teamMember.MemberRole__c = memberRole;
                    }
                    newTeamMembers.add(teamMember);
                }
            }

            if (teamMemberIdsByExistingMemberIds.size() > 0) {
                for (Id teamMemberUserId : teamMemberIdsByExistingMemberIds.keySet()) {
                    CustomTeams__Team_Members__c teamMember = new CustomTeams__Team_Members__c();
                    teamMember.CustomTeams__Access_Level__c = accessLevel;
                    teamMember.Id = teamMemberIdsByExistingMemberIds.get(teamMemberUserId);
                    if (memberRole != null) {
                        teamMember.MemberRole__c = memberRole;
                    }
                    teamMembersToUpdate.add(teamMember);
                }
            }
        }

        if (newTeamMembers.size() > 0 || teamMembersToUpdate.size() > 0) {
            if (newTeamMembers.size() > 0) {
                insert newTeamMembers;
            }
            if (teamMembersToUpdate.size() > 0) {
                update teamMembersToUpdate;
            }
            //Restoring team owner
            //team.OwnerId = originalOwnerId;
            //Restoring the Owner of the project to the PL
            team.OwnerId = currentProject.ProjectLeader__c;
            update team;
        }

        return newTeamMembers;
    }

    public static void deleteTeamMember(Id projectId, Id teamMemberId) {
        Project__c currentProject = TeamMemberRepository.getProjectById(projectId);
        if (currentProject.Team__c != null) {
            List<CustomTeams__Team_Members__c> projectTeamMembers = TeamMemberRepository.getProjectTeamMembersByUserIdAndTeamId(
                teamMemberId,
                currentProject.Team__c
            );
            Map<Id, CustomTeams__Team_Members__c> existingTeamMemberByUserIds = new Map<Id, CustomTeams__Team_Members__c>();
            for (
                CustomTeams__Team_Members__c existingTeamMember : projectTeamMembers
            ) {
                existingTeamMemberByUserIds.put(
                    existingTeamMember.CustomTeams__User__c,
                    existingTeamMember
                );
            }

            List<CustomTeams__Team_Members__c> teamMembersToDelete = new List<CustomTeams__Team_Members__c>();

            CustomTeams__Teams__c team = new CustomTeams__Teams__c();
            if (
                currentProject.Team__c != null && !existingTeamMemberByUserIds.isEmpty()
            ) {
                //Temporary change of team owner
                team.Id = currentProject.Team__c;
                team.OwnerId = UserInfo.getUserId();
                update team;

                if (existingTeamMemberByUserIds.keySet().contains(teamMemberId)) {
                    CustomTeams__Team_Members__c teamMember = new CustomTeams__Team_Members__c();
                    teamMember.CustomTeams__Team__c = currentProject.Team__c;
                    teamMember.CustomTeams__User__c = teamMemberId;
                    teamMember.Id = existingTeamMemberByUserIds.get(teamMemberId).Id;
                    teamMembersToDelete.add(teamMember);
                }
            }
            if (teamMembersToDelete.size() > 0) {
                delete teamMembersToDelete;
                //Restoring team owner
                if (currentProject.ProjectLeader__c != null) {
                    team.OwnerId = currentProject.ProjectLeader__c;
                    update team;
                }
            }
        }
    }

    /*
    *********************************************************
    @Method Name    : setTeamMembers
    @author         : Maciej Zaręba
    @description    : This functionality stores ids of the Current Team Members at Project Level
    @param          : project
    ********************************************************
    */
    public static void setTeamMembers(Project__c project) {
        System.debug('project 2 ' + project);
        List<CustomTeams__Team_Members__c> teamMembers = TeamMemberRepository.getProjectTeamMembersByTeamId(
            project.Team__c
        );
        String teamMembersString = '';
        String secondTeamMembersString = '';
        for (Integer i = 0; i < teamMembers.size(); i++) {
            if (i <= InnovatorConstants.MAX_TEAM_MEMBER_PER_FIELD - 1) {
                teamMembersString += teamMembers[i].CustomTeams__User__c + ';';
            } else {
                secondTeamMembersString += teamMembers[i].CustomTeams__User__c + ';';
            }
        }
        project.TeamMembers__c = String.join(teamMembersString.split(';'), ';');
        project.SecondTeamMembers__c = String.join(
            secondTeamMembersString.split(';'),
            ';'
        );

        System.debug('project.TeamMembers__c ' + project.TeamMembers__c);
        System.debug('project.SecondTeamMembers__c ' + project.SecondTeamMembers__c);
    }
}