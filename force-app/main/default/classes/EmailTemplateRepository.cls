public with sharing class EmailTemplateRepository {

    public static EmailTemplate getEmailTemplateByName(String name) {
        return [SELECT Id FROM EmailTemplate WHERE Name =: name];
    }

}