public with sharing class ApprovalHistoricalDTO implements Comparable{
    public String projectId {get; set;}
    public String projectCode {get; set;}
    public String phase {get; set;}
    public String email {get; set;}
    public String comments {get; set;}
    public String status {get; set;}
    public String delegatedTo {get; set;}
    public String createdDate {get; set;}

    public Integer compareTo(Object compareTo) {
        Integer returnValue = 1;
        ApprovalHistoricalDTO compareToApproval = (ApprovalHistoricalDTO)compareTo;
        Datetime createdDateTime;
        if(String.isNotBlank(createdDate) && !createdDate.contains('null')){
            createdDateTime = DateTime.valueOf(createdDate);
        }
        Datetime compareDateTime;
        if(String.isNotBlank(compareToApproval.createdDate) && !compareToApproval.createdDate.contains('null')){
            compareDateTime = DateTime.valueOf(compareToApproval.createdDate);
        }
        if(createdDateTime!=null && compareDateTime!=null){
            if(compareDateTime > createdDateTime){
                returnValue = 1;
            }else if(compareDateTime < createdDateTime){
                returnValue = -1;
            }
        }else {
            if(createdDateTime!=null){
                returnValue = 1;
            }else if(compareDateTime!=null){
                returnValue = -1;
            }else{
                returnValue = 0;
            }
        }
        
        return returnValue;
    }
}