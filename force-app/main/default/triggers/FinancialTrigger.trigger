trigger FinancialTrigger on Financial__c (before insert) {
    if (trigger.isInsert && trigger.isBefore) {
        for (Financial__c fin : trigger.new) {
            if (fin.label__c == Label.Size_of_Prize_Deliverable) { fin.LatestTolerance__c = 90;}
            else if (fin.label__c == Label.Investment_Required_Deliverable) { fin.LatestTolerance__c = 90; }
            else { fin.LatestTolerance__c = 95; }
        }
    }
}