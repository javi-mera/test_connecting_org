public with sharing class FinancialDataService {

    public static void updateFinancialData(List<Financial__c> financials) {
        update financials;
        if (financials[0].Project__c != null) {
            updateFinancialToleranceInProject(financials[0].Project__c);
        }
    }

    public static void updateFinancialsCIMandatory(List<Financial__c> financials, Id projectId) {
        Financial__c financial = financials[0];
        Financial__c projectFinancial = FinancialDataRespository.getCIProjectFinancials(projectId);
        financial.Id = projectFinancial.Id;
        update financial;
    }

    public static void updateFinancialToleranceInProject(Id projectId) {
        List<Financial__c> financials = FinancialDataRespository.getProjectDeliverables(projectId);
        if (financials.size() > 0) {
            Project__c projectToUpdate = new Project__c();
            projectToUpdate.Id = projectId;
            Boolean areValuesWithinTolerance = true;
            for (Financial__c fin : financials) {
                areValuesWithinTolerance = areValuesWithinTolerance && fin.IsValueWithinTolerance__c;
            }
            projectToUpdate.FinancialTolerancesOutsideThreshold__c = !areValuesWithinTolerance;
            update projectToUpdate;
        }
    }

    @future
    public static void updateFinancialTolerances(Id projectId) { 
        List<Financial__c> financials = FinancialDataRespository.getProjectDeliverables(projectId);
        if (financials.size() > 0) { 
            for (Financial__c fin : financials) {
                if (!fin.IsValueWithinTolerance__c) {
                    Decimal newTolerance = (fin.LatestValue__c / fin.BCAValue__c)*100.0;
                    fin.LatestTolerance__c = newTolerance;
                }
            }
            update financials;
        }
    }
}