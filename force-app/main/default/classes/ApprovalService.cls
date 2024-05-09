global class ApprovalService{
    @InvocableMethod(Label='Get Approval Status')
    global static List<Results> getLockStatus(List<sObject> sourceRecords){
        
        List<Results> sfdcURLs=new List<Results>();
        for(sObject obj:sourceRecords){
            Results r=new Results();
            r.locked=Approval.isLocked(obj);
            sfdcURLs.add(r);
        }
        return sfdcURLs;
    }
    
    global class Results{
        @InvocableVariable
        global Boolean locked;
    }
}