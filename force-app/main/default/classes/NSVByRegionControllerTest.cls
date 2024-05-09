@IsTest
public class NSVByRegionControllerTest {

    final static List<String> CLASSIFICATIONS = new List<String>{
        InnovatorConstants.FEARLESS_BET,
        InnovatorConstants.BUSINESS_ENABLER,
        InnovatorConstants.BRAND_ENERGIZER,
        InnovatorConstants.GEO_EXTENSION
    };
    final static Id NSV_RECORD_TYPE = Schema.SObjectType.Financial__c.getRecordTypeInfosByName().get(InnovatorConstants.REGIONAL_NSV_RECORDTYPE).getRecordTypeId();

    final static List<String> REGIONS = new List<String>{
        'AMEA',
        'EUROPE & LAC',
        'NORTH AMERICA'
    };

    final static List<String> INITIAL_REGIONS = new List<String>{
        'AMEA',
        'EUROPE & LAC',
        'GTR'
    };


    @TestSetup
    static void setup() {
        TestFactory.generateBasicSetUp();

        List<Project__c> projects = [
            SELECT ProjectClassification__c, Region__c, AddAdditionalRegionOrRegions__c, ProjectStatus__c, GeoExtensionProjectSubClassification__c
            FROM Project__c
        ];

        for (Project__c project : projects) {
            project.Region__c = 'AMEA';
            project.AddAdditionalRegionOrRegions__c = 'AMEA;GTR-NORTH AMERICA;EUROPE & LAC;GTR-AMEA';
            project.ProjectStatus__c = InnovatorConstants.PROJECT_STATUS_ACTIVE;
            if (project.ProjectClassification__c == InnovatorConstants.GEO_EXTENSION) {
                project.GeoExtensionProjectSubClassification__c = InnovatorConstants.GEO_EXTENSION_INNOVATION;
            }
        }
        update projects;
    }

    @IsTest
    static void updateNSVByRegionFinancialsTest() {
        List<Financial__c> financials = [
            SELECT Region__c, Project__c, Project__r.ProjectClassification__c
            FROM Financial__c
            WHERE RecordTypeId = :NSV_RECORD_TYPE
        ];

        Map<Id, List<Financial__c>> financialsByProjectIds = getFinancialsByProjectIdsMap(financials);
        for (Id projectId : financialsByProjectIds.keySet()) {
            Assert.areEqual(3, financialsByProjectIds.get(projectId).size());
        }

        for (Id projectId : financialsByProjectIds.keySet()) {
            for (Financial__c financial : financialsByProjectIds.get(projectId)) {
                Assert.isTrue(INITIAL_REGIONS.contains(financial.Region__c));
            }
        }

        List<Project__c> projects = [
            SELECT ProjectClassification__c, Region__c, AddAdditionalRegionOrRegions__c, ProjectStatus__c, GeoExtensionProjectSubClassification__c
            FROM Project__c
        ];

        for (Project__c project : projects) {
            project.Region__c = 'AMEA';
            project.AddAdditionalRegionOrRegions__c = 'EUROPE & LAC;NORTH AMERICA';
            project.ProjectStatus__c = InnovatorConstants.PROJECT_STATUS_ACTIVE;
        }

        Test.startTest();
        update projects;
        Test.stopTest();

        List<Financial__c> updatedFinancials = [
            SELECT Region__c, Project__c, Project__r.ProjectClassification__c
            FROM Financial__c
            WHERE RecordTypeId = :NSV_RECORD_TYPE
        ];

        Map<Id, List<Financial__c>> updatedFinancialsByProjectIds = getFinancialsByProjectIdsMap(updatedFinancials);
        for (Id projectId : updatedFinancialsByProjectIds.keySet()) {
            Assert.areEqual(3, updatedFinancialsByProjectIds.get(projectId).size());
        }

        for (Id projectId : updatedFinancialsByProjectIds.keySet()) {
            for (Financial__c financial : updatedFinancialsByProjectIds.get(projectId)) {
                Assert.isTrue(REGIONS.contains(financial.Region__c));
            }
        }
    }

    @IsTest
    static void createNSVByRegionBatchTest(){
        List<Financial__c> financialsToDelete = [
            SELECT Region__c, Project__c, Project__r.ProjectClassification__c
            FROM Financial__c
            WHERE RecordTypeId = :NSV_RECORD_TYPE
        ];

        if (!financialsToDelete.isEmpty()) {
            delete financialsToDelete;
        }

        Test.startTest();
        Database.executeBatch(new NSVByRegionCreationBatch());
        Test.stopTest();

        List<Financial__c> financials = [
            SELECT Region__c, Project__c, Project__r.ProjectClassification__c
            FROM Financial__c
            WHERE RecordTypeId = :NSV_RECORD_TYPE
        ];

        Map <Id, List<Financial__c>> financialsByProjectIds = getFinancialsByProjectIdsMap(financials);
        for (Id projectId : financialsByProjectIds.keySet()) {
            Assert.areEqual(3, financialsByProjectIds.get(projectId).size());
        }

        for (Id projectId : financialsByProjectIds.keySet()) {
            for (Financial__c financial : financialsByProjectIds.get(projectId)) {
                Assert.isTrue(INITIAL_REGIONS.contains(financial.Region__c));
            }
        }

    }

    public static Map<Id, List<Financial__c>> getFinancialsByProjectIdsMap(List<Financial__c> financials) {
        Map <Id, List<Financial__c>> financialsByProjectIds = new Map<Id, List<Financial__c>>();
        for (Financial__c financial : financials) {
            if (CLASSIFICATIONS.contains(financial.Project__r.ProjectClassification__c)) {
                if (financialsByProjectIds.containsKey(financial.Project__c)) {
                    financialsByProjectIds.get(financial.Project__c).add(financial);
                } else {
                    financialsByProjectIds.put(financial.Project__c, new List<Financial__c>{financial});
                }
            }
        }
        return financialsByProjectIds;
    }
}