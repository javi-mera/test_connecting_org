@IsTest
public class LookupToProjectControllerTest {
    private static final String FEARLESS_BET_CLASSIFICATION = 'Fearless Bet';
    private static final String BRAND_ENERGIZER_CLASSIFICATION = 'Brand Energizer';
    private static final String BUSINESS_ENABLER_CLASSIFICATION = 'Business Enabler';
    private static final String REPACK_CLASSIFICATION = 'Repack';
    private static final String GEO_CLASSIFICATION = 'Geographical Extension';
    private static final String PROMO_PACK_CLASSIFICATION = 'Promotional Pack';
    private static final String ACTIVE_STATUS = 'Active';
    private static final String COMPLETED_STATUS = 'Completed';

    @TestSetup
    static void testSetup() {
        TestFactory.generateBasicSetUp();

        User plUser = [
            SELECT Id
            FROM User
            WHERE ProfileName__c = 'Project Leader' AND IsActive = true
            LIMIT 1
        ];

        User pmUser = [
            SELECT Id
            FROM User
            WHERE ProfileName__c = 'Project Manager' AND IsActive = true
            LIMIT 1
        ];

        CustomTeams__Teams__c team = [
            SELECT Id
            FROM CustomTeams__Teams__c
            LIMIT 1
        ];

        TestFactory.newProject(
            'Promo Pack',
            PROMO_PACK_CLASSIFICATION,
            'Define',
            plUser,
            pmUser,
            team,
            true
            );
    }

    @IsTest
    static void searchProjectsGeo_Test() {
        List<Project__c> projects = [
            SELECT ProjectClassification__c
            FROM Project__c
            WHERE ProjectClassification__c = :FEARLESS_BET_CLASSIFICATION
            OR ProjectClassification__c = :BRAND_ENERGIZER_CLASSIFICATION
            OR ProjectClassification__c = :BUSINESS_ENABLER_CLASSIFICATION
            OR ProjectClassification__c = :REPACK_CLASSIFICATION
        ];

        Project__c geoExtensionProject = [
            SELECT ProjectClassification__c
            FROM Project__c
            WHERE ProjectClassification__c = :GEO_CLASSIFICATION
            LIMIT 1
        ];

        Test.startTest();
        if (!projects.isEmpty()) {
            for (Project__c project : projects) {
                project.ProjectStatus__c = ACTIVE_STATUS;
            }
            update projects;
        }

        List<LookupSearchResult> projectsSearchResults = LookupToProjectController.searchProjects(geoExtensionProject.Id, geoExtensionProject.ProjectClassification__c);
        Test.stopTest();

        System.assertEquals(projects.size(), projectsSearchResults.size());
    }

    @IsTest
    static void searchProjectsPromoPack_Test() {
        Project__c promoPackProject = [
            SELECT ProjectClassification__c, Name
            FROM Project__c
            WHERE ProjectClassification__c = :PROMO_PACK_CLASSIFICATION
            LIMIT 1
        ];

        List<Project__c> projects = [
            SELECT ProjectClassification__c, Name
            FROM Project__c
            WHERE ProjectClassification__c = :PROMO_PACK_CLASSIFICATION
            AND Id != :promoPackProject.Id
        ];

        Test.startTest();
        if (!projects.isEmpty()) {
            for (Project__c project : projects) {
                project.ProjectStatus__c = ACTIVE_STATUS;
            }
            update projects;
        }

        List<LookupSearchResult> projectsSearchResults = LookupToProjectController.searchProjects(promoPackProject.Id, promoPackProject.ProjectClassification__c);

        Id[] fixedSearchResults = new Id[1];
        fixedSearchResults[0] = projects[0].Id;
        Test.setFixedSearchResults(fixedSearchResults);


        List<LookupSearchResult> projectsSearchResultsByTerm = LookupToProjectController.searchProjectBySearchTerm(promoPackProject.Id, projects[0].Name, promoPackProject.ProjectClassification__c);

        Test.stopTest();

        System.assertEquals(projects.size(), projectsSearchResults.size());
        System.assertEquals(projects[0].Name, projectsSearchResultsByTerm[0].title);

    }

    @IsTest
    static void searchProjectBySearchTermGeo_Test() {
        Project__c project = [
            SELECT Name, ProjectStatus__c, ProjectClassification__c
            FROM Project__c
            WHERE ProjectClassification__c = :FEARLESS_BET_CLASSIFICATION
            LIMIT 1
        ];
        if (project != null) {
            project.ProjectStatus__c = COMPLETED_STATUS;
            update project;
        }

        Project__c geoExtensionProject = [
            SELECT ProjectClassification__c
            FROM Project__c
            WHERE ProjectClassification__c = :GEO_CLASSIFICATION
            LIMIT 1
        ];

        Id[] fixedSearchResults = new Id[1];
        fixedSearchResults[0] = project.Id;
        Test.setFixedSearchResults(fixedSearchResults);

        Test.startTest();
        List<LookupSearchResult> projectsSearchResults = LookupToProjectController.searchProjectBySearchTerm(geoExtensionProject.Id, project.Name, geoExtensionProject.ProjectClassification__c);
        Test.stopTest();

        System.assertEquals(project.Name, projectsSearchResults[0].title);
    }
}