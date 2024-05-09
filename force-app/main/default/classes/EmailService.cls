public with sharing class EmailService {

    public static Messaging.SendEmailResult[] sendEmail(String[] toEmails,String record, String subject, String htmlValue){
        return sendEmail(toEmails, null, null, null, record, subject, htmlValue);
    }

    public static Messaging.SendEmailResult[] sendEmail(String[] toEmails, String[] ccEmails, String[] bccEmails, OrgWideEmailAddress fromAddress, String record, String subject, String htmlValue) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        if(toEmails != null){
            message.toAddresses = toEmails;
        }
        if(ccEmails != null){
            message.setCCAddresses(ccEmails);
        }
        if(bccEmails != null){
            message.setBCCAddresses(bccEmails);
        }
        if(fromAddress != null){
            message.setOrgWideEmailAddressId(fromAddress.Id);
        }
        message.setSaveAsActivity(true);
        message.setWhatId(record);
        message.setUseSignature(false);
        message.setSubject(subject);
        message.setHtmlBody(htmlValue);
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        return Messaging.sendEmail(messages);
    }

    public static Messaging.SingleEmailMessage createEmail(String[] toEmails,String record, String subject, String htmlValue){
        return createEmail(toEmails, null, null, null, record, subject, htmlValue);
    }

    public static Messaging.SingleEmailMessage createEmail(String[] toEmails, String[] ccEmails, String[] bccEmails, OrgWideEmailAddress fromAddress, String record, String subject, String htmlValue) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        if(toEmails != null){
            message.toAddresses = toEmails;
        }
        if(ccEmails != null){
            message.setCCAddresses(ccEmails);
        }
        if(bccEmails != null){
            message.setBCCAddresses(bccEmails);
        }
        if(fromAddress != null){
            message.setOrgWideEmailAddressId(fromAddress.Id);
        }
        message.setSaveAsActivity(true);
        message.setWhatId(record);
        message.setUseSignature(false);
        message.setSubject(subject);
        message.setHtmlBody(htmlValue);
        return message;
    }
    
}