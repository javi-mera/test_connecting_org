public with sharing class ContactRepository {

    private static final String CONTACT_NOT_FOUND = 'Notification could not be sent to recipients due to default contact for the email template not being present in the system. Please contact your administrator to correct this configuration issue.';

    public static Contact getContactByName(String name) {
        try {
            return [SELECT Id FROM Contact WHERE Name =: name];
        } catch(QueryException queryException) {
            throw new AuraHandledException(CONTACT_NOT_FOUND);
        }

    }

}