public with sharing class OnHoldCounterService {

    public static void setOnHoldRelatedFields(Project__c oldProject, Project__c newProject) {
        if (
            oldProject.ProjectStatus__c ==
            InnovatorConstants.PROJECT_STATUS_ON_HOLD &&
            newProject.ProjectStatus__c != InnovatorConstants.PROJECT_STATUS_ON_HOLD
          ) {
            newProject.OnHoldAccumulator__c = newProject.OnHoldCounterFormula__c;
            newProject.OnHoldStartDate__c = null;
          }
          if (
            oldProject.ProjectStatus__c !=
            InnovatorConstants.PROJECT_STATUS_ON_HOLD &&
            newProject.ProjectStatus__c == InnovatorConstants.PROJECT_STATUS_ON_HOLD
          ) {
            newProject.OnHoldStartDate__c = Date.today();
          }
    }

}