public with sharing class UserRepository {

    @AuraEnabled
    public static User getUserById(Id id) {
        return [SELECT Id, Name, Email FROM User WHERE Id =: id];
    }

}