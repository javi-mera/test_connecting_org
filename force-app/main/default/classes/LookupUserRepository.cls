public with sharing class LookupUserRepository {

    public static List<List<SObject>> getUsers(String searchTerm, List<String> selectedIds) {
        searchTerm += '*';
        return [FIND :searchTerm 
                IN ALL FIELDS 
                RETURNING
                    User(Id, Name, LastName WHERE Id NOT IN :selectedIds AND ProfileName__c IN ('Project Leader', 'Super User') AND IsActive = true ORDER BY Name)
                LIMIT 5
        ];
    }

    public static List<List<SObject>> getUsersBySearchTerm(String searchTerm, List<String> selectedIds) {
        searchTerm += '*';
        return [
            FIND :searchTerm 
            IN ALL FIELDS 
            RETURNING
                User(Id, Name, LastName WHERE Id NOT IN :selectedIds AND IsActive = true ORDER BY Name)
            LIMIT 5
        ];
    }

    public static List<List<SObject>> getPMUsers(String searchTerm, List<String> selectedIds) {
        searchTerm += '*';
        return [FIND :searchTerm 
                IN ALL FIELDS 
                RETURNING
                    //User(Id, Name, LastName WHERE Id NOT IN :selectedIds AND ProfileName__c = 'Project Manager' AND IsActive = true)
                    User(Id, Name, LastName WHERE Id NOT IN :selectedIds AND ProfileName__c IN ('Project Manager', 'Project Leader', 'Super User') AND IsActive = true ORDER BY Name)
                LIMIT 5
        ];
    }

    public static List<SObject> getAllUsers() {
        return [Select Id, Name, LastName FROM User WHERE ProfileName__c IN ('Project Leader', 'Super User') AND IsActive = true ORDER BY Name];
    }

    public static List<SObject> getAllUsersByIsActive() {
        return [Select Id, Name, LastName FROM User WHERE IsActive = true ORDER BY Name];
    }

    public static List<SObject> getAllPMUsers() {
        return [Select Id, Name, LastName FROM User WHERE ProfileName__c IN ('Project Manager', 'Project Leader', 'Super User') AND IsActive = true ORDER BY Name];
    }

    public static User getUserById(String id) {
        return [SELECT Id, Name, LastName, Email FROM User WHERE Id =: id LIMIT 1];
    }
}