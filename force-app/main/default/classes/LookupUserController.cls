public with sharing class LookupUserController {

    private static final String PROJECT_MANAGER = 'ProjectManager';
    private static final String PROJECT_LEADER = 'ProjectLeader';
    private static final String STANDARD_USER_ICON = 'standard:user';
    private static final String USER_SOBJECT  = 'User';

    
    @AuraEnabled()
    public static List<LookupSearchResult> searchUsers(String searchTerm, List<String> selectedIds) {
        List<List<SObject>> searchResults = LookupUserRepository.getUsers(searchTerm, selectedIds);
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        if (searchResults[0].size() > 0) {
            User[] users = (List<User>) searchResults[0];
            for (User user: users) {
                results.add(
                    new LookupSearchResult(
                        user.Id,
                        USER_SOBJECT,
                        STANDARD_USER_ICON,
                        user.Name,
                        user.Name,
                        user.Name
                    )
                );
            }
        }
        return results;
    } 

    @AuraEnabled()
    public static List<LookupSearchResult> searchUsersBySearchTerm(String searchTerm, List<String> selectedIds) {
        List<List<SObject>> searchResults = LookupUserRepository.getUsersBySearchTerm(searchTerm, selectedIds);
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        if (searchResults[0].size() > 0) {
            User[] users = (List<User>) searchResults[0];
            for (User user: users) {
                results.add(
                    new LookupSearchResult(
                        user.Id,
                        USER_SOBJECT,
                        STANDARD_USER_ICON,
                        user.Name,
                        user.Name,
                        user.Name
                    )
                );
            }
        }
        return results;
    } 
    
    @AuraEnabled()
    public static List<LookupSearchResult> searchPMUsers(String searchTerm, List<String> selectedIds) {
        List<List<SObject>> searchResults = LookupUserRepository.getPMUsers(searchTerm, selectedIds);
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        if (searchResults[0].size() > 0) {
            User[] users = (List<User>) searchResults[0];
            for (User user: users) {
                results.add(
                    new LookupSearchResult(
                        user.Id,
                        USER_SOBJECT,
                        STANDARD_USER_ICON,
                        user.Name,
                        user.Name,
                        user.Name
                    )
                );
            }
        }
        return results;
    }

    @AuraEnabled()
    public static List<LookupSearchResult> searchAllUsers() {
        List<SObject> searchResults = LookupUserRepository.getAllUsers();
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        if (searchResults.size() > 0) {
            User[] users = (List<User>) searchResults;
            for (User user: users) {
                results.add(
                    new LookupSearchResult(
                        user.Id,
                        USER_SOBJECT,
                        STANDARD_USER_ICON,
                        user.Name,
                        user.Name,
                        user.Name
                    )
                );
            }
        }
        return results;
    }

    @AuraEnabled()
    public static List<LookupSearchResult> searchAllUsersByIsActive() {
        List<SObject> searchResults = LookupUserRepository.getAllUsersByIsActive();
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        if (searchResults.size() > 0) {
            User[] users = (List<User>) searchResults;
            for (User user: users) {
                results.add(
                    new LookupSearchResult(
                        user.Id,
                        USER_SOBJECT,
                        STANDARD_USER_ICON,
                        user.Name,
                        user.Name,
                        user.Name
                    )
                );
            }
        }
        return results;
    }

    @AuraEnabled()
    public static List<LookupSearchResult> searchAllPMUsers() {
        List<SObject> searchResults = LookupUserRepository.getAllPMUsers();
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        if (searchResults.size() > 0) {
            User[] users = (List<User>) searchResults;
            for (User user: users) {
                results.add(
                    new LookupSearchResult(
                        user.Id,
                        USER_SOBJECT,
                        STANDARD_USER_ICON,
                        user.Name,
                        user.Name,
                        user.Name
                    )
                );
            }
        }
        return results;
    } 

    @AuraEnabled
    public static List<LookupSearchResult> transformPLUser(String id) {
        User user = LookupUserRepository.getUserById(id);
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        if (user != null) {
            results.add(
                new LookupSearchResult(
                    user.Id,
                    USER_SOBJECT,
                    STANDARD_USER_ICON,
                    user.Name,
                    user.Name,
                    user.Name
                )
            );
        }
        return results;
    } 

    @AuraEnabled
    public static String getUserProfile() {
        Id currentUserProfileId = UserInfo.getProfileId();
        String profileName = [SELECT Name FROM Profile WHERE Id =: currentUserProfileId].Name;
        return profileName;
    } 

    @InvocableMethod(label='Transform Users')
    public static List<List<LookupSearchResult>> transformToLookupResult(List<FlowRequest> requests) {
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        FlowRequest request = requests.get(0);
        if (request.type.equals(PROJECT_MANAGER)) {
            results = transformToLookupSearchResult(request.userId, request.userName);
        }
        List<List<LookupSearchResult>> resultList = new List<List<LookupSearchResult>>();
        Map<String,LookupSearchResult> mapResult = new Map<String,LookupSearchResult>();
        for (LookupSearchResult result : results) {
            mapResult.put(result.value,result);
        }
        resultList.add(mapResult.values());
        return resultList;
    }

    private static List<LookupSearchResult> transformToLookupSearchResult(String userId, String userName){
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        if (!String.isBlank(userId)) {
            results.add(
                new LookupSearchResult(
                    userId,
                    USER_SOBJECT,
                    STANDARD_USER_ICON,
                    userName,
                    userName,
                    userName
                )
            );
        }
        return results;
    }

    public class FlowRequest{
        @InvocableVariable
        public String userId;
        @InvocableVariable
        public String userName;
        @InvocableVariable
        public String type;
    }
}