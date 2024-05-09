public with sharing class InvocableSendEmail {
  private static final String BACARDII_CONTACT_NAME = 'Bacardi Bacardi';

  public class Parameters {
    @InvocableVariable(label='Email Addresses' required=true)
    public List<String> recepients;

    @InvocableVariable(label='Email Template Name' required=false)
    public String emailTemplate;

    @InvocableVariable(label='Subject' required=false)
    public String subject;

    @InvocableVariable(label='Body' required=false)
    public String body;

    @InvocableVariable(label='Record Id' required=false)
    public String recordId;

        @InvocableVariable(label='OrgWideAddress Id' required=true)
        public String OrgWideAddressId;
  }

  @InvocableMethod(label='Send Email to Recepients')
  public static void sendEmail(List<Parameters> parameters) {
    Messaging.reserveMassEmailCapacity(parameters.size());
        Contact dummyContact = ContactRepository.getContactByName(BACARDII_CONTACT_NAME);
        String orgWideAddressId = parameters[0].OrgWideAddressId;
    for (Parameters parameter : parameters) {
      List<String> filteredEmailAddresses = new List<String>();
      if (
        parameter.recepients != null &&
        !parameter.recepients.isEmpty() &&
        !String.isBlank(parameter.recordId)
      ) {
        for (String recepient : parameter.recepients) {
          if (!String.isBlank(recepient)) {
            filteredEmailAddresses.add(recepient);
          }
        }
        List<String> carbonCopyRecepients = new List<String>(
          filteredEmailAddresses
        );
        carbonCopyRecepients.remove(0);
        Messaging.SingleEmailMessage mailToSend = new Messaging.SingleEmailMessage();
        mailToSend.setTargetObjectId(dummyContact.Id);
        mailToSend.setTreatTargetObjectAsRecipient(false);
        mailToSend.setWhatId(parameter.recordId);
        if (parameter.emailTemplate != null) {
          EmailTemplate selectedTemplate = EmailTemplateRepository.getEmailTemplateByName(
            parameter.emailTemplate
          );
                    mailToSend.setTemplateId(selectedTemplate.Id);
        }
        if (parameter.body != null) {
          mailToSend.setHtmlBody(parameter.body);
        }
        if (parameter.subject != null) {
          mailToSend.setSubject(parameter.subject);
        }
        mailToSend.setToAddresses(
          new List<String>{ filteredEmailAddresses[0] }
        );
        mailToSend.setCcAddresses(carbonCopyRecepients);
        mailToSend.setSaveAsActivity(true);
                if (!String.isBlank(orgWideAddressId)) {
                    mailToSend.setOrgWideEmailAddressId(orgWideAddressId);
        }
        Messaging.sendEmail(new List<Messaging.Email>{ mailToSend });
      }
    }
  }
}