public with sharing class DelegateOOOApprovalModalController {

    @AuraEnabled
    public static void updateDelegateWithDate(User user) {
        if (user.Id == null) {
            user.Id = UserInfo.getUserId();
        }
        update user;
        EmailManager.sendEmailToDelegatedApprover(user.Id, user.DelegatedApproverId, user.Start__c, user.End__c);
    }

}