trigger ApprovalRuleTrigger on ApprovalMatrix__c (before update) {

    if (Trigger.isBefore && Trigger.isUpdate) {
        ApprovalRuleTriggerHandler.handleIsBeforeUpdate();
    }

}