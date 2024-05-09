public with sharing class FinancialDataRespository {

@AuraEnabled
    public static List<Financial__c> getProjectFinancials(Id projectId) {
        List<Financial__c> financials = [
            SELECT
                Id,
                NSVAmbition__c,
                ActualFY__c,
                Volume__c,
                TotalNSV__c,
                NSV__c,
                TotalNP__c,
                StructuralCosts__c,
                IncrementalNSV__c,
                GM__c,
                TotalCOGs__c,
                TotalGP__c,
                AP__c,
                RSP__c,
                Project__c,
                TotalCosts__c,
                IncrementalDBC__c,
                ReturnOnInvestment__c,
                TotalWriteOffs__c
            FROM
                Financial__c
            WHERE
                Project__c =: projectId AND
                RecordType.Name = 'Financial Data' AND
                ProjectSnapshot__c = NULL
            ORDER BY ActualFY__c ASC
        ];
        return financials;
    }

    public static Financial__c getCIProjectFinancials (Id projectId) {
        Financial__c financials = [
            SELECT 
                Id,
                Volume__c,
                NSV__c,
                COGSDecreaseCurrent__c,
                COGSIncreaseCurrent__c,
                COGSNoChangeCurrent__c,
                TotalCOGs__c,
                TotalCAPEX__c,
                TotalTooling__c,
                TotalWriteOffs__c,
                TotalOtherOneOffCosts__c,
                TotalWorkingCapitalImpact__c,
                PaybackTime__c,
                Project__c
            FROM 
                Financial__c 
            WHERE 
                Project__c =: projectId AND
                RecordType.Name = 'Financial Data' AND
                ActualFY__c = 1 AND
                ProjectSnapshot__c = NULL
        ];

        return financials;
    }

    public static List<Financial__c> getProjectDeliverables(Id projectId) {
        List<Financial__c> deliverables = [
            SELECT
                Id,
                Label__c,
                BCVVAlue__c,
                BCAValue__c,
                PMValue__c,
                CMValue__c,
                IsValueWithinTolerance__c,
                LatestTolerance__c,
                LatestValue__c,
                Project__c
            FROM
                Financial__c
            WHERE
                Project__c =: projectId AND
                RecordType.Name = 'Deliverable' AND
                ProjectSnapshot__c = NULL
        ];
        return deliverables;
    }

    public static List<Financial__c> getProjectSnapshotDeliverables(Id projectSnapshotId) {
        List<Financial__c> deliverables = [
            SELECT
                Id,
                Label__c,
                BCVVAlue__c,
                BCAValue__c,
                PMValue__c,
                CMValue__c,
                IsValueWithinTolerance__c,
                LatestTolerance__c,
                LatestValue__c,
                Project__c
            FROM
                Financial__c
            WHERE
                RecordType.Name = 'Deliverable' AND
                ProjectSnapshot__c =: projectSnapshotId
        ];
        return deliverables;
    }
    
    public static Financial__c getCIProjectSnapshotFinancials (Id projectSnapshotId) {
        Financial__c financials = [
            SELECT 
                Id,
                Volume__c,
                NSV__c,
                COGSDecreaseCurrent__c,
                COGSIncreaseCurrent__c,
                COGSNoChangeCurrent__c,
                TotalCOGs__c,
                TotalCAPEX__c,
                TotalTooling__c,
                TotalWriteOffs__c,
                TotalOtherOneOffCosts__c,
                TotalWorkingCapitalImpact__c,
                PaybackTime__c,
                Project__c
            FROM 
                Financial__c 
            WHERE 
                RecordType.Name = 'Financial Data' AND
                ActualFY__c = 1 AND
                ProjectSnapshot__c =: projectSnapshotId
        ];

        return financials;
    }

    public static List<Financial__c> getProjectSnapshotFinancials(Id projectSnapshotId) {
        List<Financial__c> financials = [
            SELECT
                Id,
                NSVAmbition__c,
                ActualFY__c,
                Volume__c,
                TotalNSV__c,
                TotalWriteOffs__c,
                NSV__c,
                TotalNP__c,
                StructuralCosts__c,
                IncrementalNSV__c,
                GM__c,
                TotalCOGs__c,
                TotalGP__c,
                AP__c,
                RSP__c,
                Project__c,
                TotalCosts__c,
                IncrementalDBC__c,
                ReturnOnInvestment__c
            FROM
                Financial__c
            WHERE
                RecordType.Name = 'Financial Data' AND
                ProjectSnapshot__c =: projectSnapshotId
            ORDER BY ActualFY__c ASC
        ];
        return financials;
    }

    public static List<Financial__c> getRegionalNSVFinancialsByProjectIds(List<Project__c> projects){
        return [
            SELECT Region__c, Project__c, AmountOfNSV__c, ContributionToTotalNSV__c
            FROM Financial__c
            WHERE RecordType.Name = 'Regional NSV'
            AND IsFromProjectSnapshot__c = FALSE
            AND Project__c IN :projects
        ];
    }

    @AuraEnabled
    public static List<Financial__c> getRegionalNSVFinancialsByProjectId(Id projectId){
        return [
            SELECT Region__c, Project__c, AmountOfNSV__c, ContributionToTotalNSV__c
            FROM Financial__c
            WHERE RecordType.Name = 'Regional NSV'
            AND IsFromProjectSnapshot__c = FALSE
            AND Project__c = :projectId
        ];
    }

    @AuraEnabled
    public static List<Financial__c> getRegionalNSVFinancialsBySnapshotId(Id snapshotId){
        return [
            SELECT Region__c, Project__c, AmountOfNSV__c, ContributionToTotalNSV__c
            FROM Financial__c
            WHERE RecordType.Name = 'Regional NSV'
            AND IsFromProjectSnapshot__c = TRUE
            AND ProjectSnapshot__c = :snapshotId
        ];
    }


    public static List<Financial__c> getFinancialsNSVYearOne(Id projectId) {
        return [
            SELECT NSV__c
            FROM Financial__c
            WHERE RecordType.Name = 'Financial Data'
            AND Project__c = :projectId
            AND IsFromProjectSnapshot__c = FALSE
            AND ActualFY__c = 1
            LIMIT 1
        ];
    }

}