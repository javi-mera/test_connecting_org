trigger AutoApprovalTrigger on AutoApproval__e (after insert) {

    switch on Trigger.operationType {
        when AFTER_INSERT {
            AutoApprovalTriggerHandler.afterInsert(Trigger.new);
        }
    }

}