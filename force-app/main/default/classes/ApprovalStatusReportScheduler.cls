public with sharing class ApprovalStatusReportScheduler  implements schedulable
{
    public void execute(SchedulableContext stx)
    {        
        sendPendingApprovalEmail();
    }

    public static void sendPendingApprovalEmail(){
        List<ApprovalStatusReport.ApprovalWrapperClass> wrapList = ApprovalStatusReport.getWrapList();
        List<String> emails = getApproverEmail(wrapList);
        sendEmail(emails);
    }

    public static List<String> getApproverEmail(List<ApprovalStatusReport.ApprovalWrapperClass> wrapList){
        Set<Id> approverIds = new Set<Id>();
        List<String> approverEmails = new List<String>();
        for(ApprovalStatusReport.ApprovalWrapperClass wrap :wrapList){
            approverIds.add(wrap.approverId);
        }
        for(User user :ApprovalStatusReportRepository.getUserEmails(approverIds)){
            approverEmails.add(user.Email);
        }
        return approverEmails;
    }

    public static List<String> getAdminEmails(){
        List<String> emails = new List<String>();
        Map<String, Admin_Emails__mdt> emailsMeta = Admin_Emails__mdt.getAll();
        for(Admin_Emails__mdt emailMeta : emailsMeta.values()){
            emails.add(emailMeta.email__c);
        }
        return emails;
    }
    
    /**
     * @description This function will send the emails to pending approver using the visualforce email template
     * @param emails 
     */
    public static void sendEmail(List<String> emails){
        EmailTemplate template = ApprovalStatusReportRepository.getApprovalEmailTemplate();
        Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(template.id, null, null);
        email.setToAddresses(emails);
        email.setCcAddresses(getAdminEmails());
        email.setSaveAsActivity(false);
        email.setTreatTargetObjectAsRecipient(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});              
    }
}