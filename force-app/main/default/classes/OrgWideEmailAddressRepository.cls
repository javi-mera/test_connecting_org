public with sharing class OrgWideEmailAddressRepository {

    public static List<OrgWideEmailAddress> getOrgWideEmailAddresses() {
        return [SELECT Id FROM OrgWideEmailAddress];
    }
    
}