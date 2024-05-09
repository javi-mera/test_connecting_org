@isTest
public class GetOrgBaseUrl_Test {
    
    @testSetup
    static void setup() {
        
        // Create a test account
        Account a = new Account(Name='Test Account');
        a.ShippingStreet  = 'Test Street';
        a.ShippingCity   = 'Test City';
        a.ShippingCountry   = 'Test Country';
        a.ShippingPostalCode = '1234';
        a.ShippingState = 'Test State';
        insert a;    
    }
    
    @isTest
    static void stripHtmlTags() {
        
        // Access the opportunity that was just created.
        Account account = [SELECT Id, Name FROM Account LIMIT 1];
        
        GetOrgBaseUrl.getBaseUrl(new List<sObject> {account});
    }
}