public with sharing class LegalAndRegulatoryNotificationService {

    public static void sendLegalAndRegulatoryNotifications(Project__c project) {
        List<String> brands = project.Brand__c.split(';');
        List<BrandLegalAndRegulatoryPrimo__mdt> brandLegalAndRegulatoryPrimos = LegalAndRegulatoryNotifiactionRepository.getBrandLegalAndRegulatoryPrimos(brands);
        Set<String> emails = new Set<String>();
        for (BrandLegalAndRegulatoryPrimo__mdt brandLegalAndRegulatoryPrimo : brandLegalAndRegulatoryPrimos) {
            emails.add(brandLegalAndRegulatoryPrimo.LegalPrimoEmail__c);
            emails.add(brandLegalAndRegulatoryPrimo.RegulatoryPrimoEmail__c);
        }
        if (emails.isEmpty()) {
            BrandLegalAndRegulatoryPrimo__mdt defaultPrimos = BrandLegalAndRegulatoryPrimo__mdt.getInstance('New');
            emails.add(defaultPrimos.LegalPrimoEmail__c);
            emails.add(defaultPrimos.RegulatoryPrimoEmail__c);
        }
        
        EmailTemplate emailTemplate = ApprovalProcessRepository.getTemplateByName(InnovatorConstants.LEGAL_AND_REGULATORY_PRIMOS_EMAIL);
        String subject = '';
        String htmlBody = '';

        subject = emailTemplate.Subject.replace('{{{Project__c.ProjectNumberFormula__c}}}', project.ProjectNumberFormula__c);
        subject = subject.replace('{{{Project__c.Name}}}', project.Name);
        htmlBody = emailTemplate.HtmlValue.replace('{{{Project__c.ProjectNumberFormula__c}}}', project.ProjectNumberFormula__c);
        htmlBody = htmlBody.replace('{{{Project__c.Name}}}', project.Name);
        htmlBody = htmlBody.replace('{{{Project__c.ProjectClassification__c}}}', project.ProjectClassification__c);
        htmlBody = htmlBody.replace('{{{Project__c.ProjectLeaderFormula__c}}}', project.ProjectLeaderFormula__c);
        htmlBody = htmlBody.replace('{{{Project__c.ProjectManagerFormula__c}}}', project.ProjectManagerFormula__c);
        htmlBody = htmlBody.replace('{{{Project__c.URL}}}', URL.getSalesforceBaseUrl().toExternalForm() + '/' + project.Id);
        htmlBody = htmlBody.replace('{{{Project__c.Brand__c}}}', project.Brand__c);
        EmailService.sendEmail(new List<String>(emails), project.Id, subject, htmlBody);
    }

}