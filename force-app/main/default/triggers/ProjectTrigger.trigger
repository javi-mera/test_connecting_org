trigger ProjectTrigger on Project__c(before insert, before update, after insert, after update) {

    if (Trigger.isInsert && Trigger.isBefore) {
        ProjectTriggerHandler.handleIsBeforeInsert(Trigger.new);
    } else if (Trigger.isInsert && Trigger.isAfter) {
        ProjectTriggerHandler.handleIsAfterInsert(Trigger.new);
    } else if (Trigger.isUpdate && Trigger.isBefore) {
        ProjectTriggerHandler.handleIsBeforeUpdate(Trigger.new, Trigger.oldMap);
    } else if (Trigger.isUpdate && Trigger.isAfter) {
        ProjectTriggerHandler.handleIsAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}