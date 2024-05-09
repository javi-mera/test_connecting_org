public with sharing class GetListOfNotificationMails {

    @InvocableMethod(Label='Get List of Emails for Notifications')
    public static List<Results> getListOfNotifiactionEmails(List<Project__c> projects) {
        List<Results> results = new List<Results>();
        List<User> adminUsers = [SELECT Email FROM User WHERE ProfileName__c = 'Innovapp Admin' AND IsActive = TRUE];
        List<String> adminEmails = new List<String>();
        Set<Id> projectTeamIds = new Set<Id>();
        Set<Id> projectLeaderManagerIds = new Set<Id>();

        for (User adminUser : adminUsers) {
            if (!adminEmails.contains(adminUser.Email)) {
                adminEmails.add(adminUser.Email);
            }
        }

        for (Project__c project : projects) {
            projectTeamIds.add(project.Team__c);
            projectLeaderManagerIds.add(project.ProjectLeader__c);
            projectLeaderManagerIds.add(project.ProjectManager__c);
        }

        List<CustomTeams__Team_Members__c> teamMembers = [
            SELECT CustomTeams__User__r.Email, CustomTeams__User__c
            FROM CustomTeams__Team_Members__c
            WHERE CustomTeams__Team__c IN :projectTeamIds
            AND CustomTeams__User__r.IsActive = TRUE
        ];

        List<User> users = [
            SELECT Email
            FROM User
            WHERE Id IN :projectLeaderManagerIds
            AND IsActive = TRUE
        ];

        for (Project__c project : projects) {
            Results result = new Results();
            result.adminEmails.addAll(adminEmails);

            for (CustomTeams__Team_Members__c teamMember : teamMembers) {
                if (teamMember.CustomTeams__User__c != project.ProjectLeader__c && teamMember.CustomTeams__User__c != project.ProjectManager__c) {
                if (!result.teamMembersEmails.contains(teamMember.CustomTeams__User__r.Email)) {
                    result.teamMembersEmails.add(teamMember.CustomTeams__User__r.Email);
                }
            }
            }
            result.plAndPMAndTeamMembersEmails.addAll(result.teamMembersEmails);
            result.pmAndTeamMembersEmails.addAll(result.teamMembersEmails);
            for (User user : users) {
                if (user.Id == project.ProjectLeader__c) {
                    if (!result.plAndPMAndTeamMembersEmails.contains(user.Email)) {
                        result.plAndPMAndTeamMembersEmails.add(user.Email);
                    }
                    if (!result.plAndPMEmails.contains(user.Email)) {
                        result.plAndPMEmails.add(user.Email);
                    }
                } else if (user.Id == project.ProjectManager__c) {
                    if (!result.plAndPMAndTeamMembersEmails.contains(user.Email)) {
                        result.plAndPMAndTeamMembersEmails.add(user.Email);
                    }
                    if (!result.plAndPMEmails.contains(user.Email)) {
                        result.plAndPMEmails.add(user.Email);
                    }
                    if (!result.pmAndTeamMembersEmails.contains(user.Email)) {
                        result.pmAndTeamMembersEmails.add(user.Email);
                    }
                }
            }

            //to exclude a project submitter from notification recipients
            
            String currentLoginUserEmail = UserInfo.getUserEmail();
            if ((!result.plAndPMAndTeamMembersEmails.isEmpty()) && result.plAndPMAndTeamMembersEmails.contains(currentLoginUserEmail)) {
                for(Integer i=0; i<result.plAndPMAndTeamMembersEmails.size(); i++ ) {
                    if(result.plAndPMAndTeamMembersEmails[i] == currentLoginUserEmail) {
                        result.plAndPMAndTeamMembersEmails.remove(i);
                        break;
                    }
                }
            }
            if (result.adminEmails.isEmpty()) {
                result.adminEmails = null;
            } else {
                result.adminEmailsString = String.join(result.adminEmails, ';');
            }
            if (result.plAndPMAndTeamMembersEmails.isEmpty()) {
                result.plAndPMAndTeamMembersEmails = null;
            } else {
                result.plAndPMAndTeamMembersEmailsString = String.join(result.plAndPMAndTeamMembersEmails, ';');
            }
            if (result.plAndPMEmails.isEmpty()) {
                result.plAndPMEmails = null;
            } else {
                result.plAndPMEmailsString = String.join(result.plAndPMEmails, ';');
            }
            if (result.pmAndTeamMembersEmails.isEmpty()) {
                result.pmAndTeamMembersEmails = null;
            } else {
                result.pmAndTeamMembersEmailsString = String.join(result.pmAndTeamMembersEmails, ';');
            }
            if (result.teamMembersEmails.isEmpty()) {
                result.teamMembersEmails = null;
            } else {
                result.teamMembersEmailsString = String.join(result.teamMembersEmails, ';');
            }
            results.add(result);
        }
        return results;
    }
    
    public class Results {
        @InvocableVariable
        public List<String> teamMembersEmails = new List<String>();

        @InvocableVariable
        public List<String> plAndPMEmails = new List<String>();

        @InvocableVariable
        public List<String> plAndPMAndTeamMembersEmails = new List<String>();
        
        @InvocableVariable
        public List<String> pmAndTeamMembersEmails = new List<String>();

        @InvocableVariable
        public List<String> adminEmails = new List<String>();

        @InvocableVariable
        public String teamMembersEmailsString = '';

        @InvocableVariable
        public String plAndPMEmailsString = '';

        @InvocableVariable
        public String plAndPMAndTeamMembersEmailsString = '';
        
        @InvocableVariable
        public String pmAndTeamMembersEmailsString = '';

        @InvocableVariable
        public String adminEmailsString = '';
    }

}