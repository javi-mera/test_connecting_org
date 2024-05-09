@IsTest
private class TimingsTableControllerTest {

    @TestSetup
    static void setup() {
        TestFactory.generateBasicSetUp(); // Discover Phase
    }

    @IsTest
    static void checkProjectTimingsTest() {
        List<Project__c> projects = [
            SELECT DecisionStep__c, ProjectClassification__c, ProjectPhase__c, ProjectStatus__c, SubmissionStatus__c, TargetOnShelfDateLeadRegion__c
            FROM Project__c
            WHERE ProjectClassification__c =: InnovatorConstants.FEARLESS_BET
            OR ProjectClassification__c =: InnovatorConstants.REPACK
        ];

        for (Project__c project : projects) {
            project.DecisionStep__c = InnovatorConstants.DECISION_STEP_BCA;
            project.ProjectStatus__c = InnovatorConstants.PROJECT_STATUS_ACTIVE;
            project.ProjectPhase__c = InnovatorConstants.DEFINE_PHASE;
            project.SubmissionStatus__c = 'Opportunity Milestone Approved';
            project.TargetOnShelfDateLeadRegion__c = System.today().addDays(180);
        }

        Test.startTest();
        update projects;
        Test.stopTest();
        
        List<Project__c> newProjects = [
            SELECT DecisionStep__c, ProjectPhase__c, OpportunitySubmissionDate__c
            FROM Project__c
            WHERE ProjectClassification__c =: InnovatorConstants.FEARLESS_BET
            OR ProjectClassification__c =: InnovatorConstants.REPACK
        ];

        for (Project__c newProject : newProjects) {
            Project__c project = TimingsTableController.getProject(newProject.Id);
            Assert.areEqual(System.today(), project.OpportunitySubmissionDate__c);
        }
    }

    @IsTest
    static void timingsUpdateBatchTest() {
        List<Project__c> projects = [
            SELECT OpportunityRecommendedDate__c, DecisionStep__c, ProjectClassification__c, ProjectPhase__c, ProjectStatus__c, SubmissionStatus__c, TargetOnShelfDateLeadRegion__c
            FROM Project__c
            WHERE ProjectClassification__c =: InnovatorConstants.FEARLESS_BET
            OR ProjectClassification__c =: InnovatorConstants.REPACK
        ];

        for (Project__c project : projects) {
            project.OpportunityRecommendedDate__c = null;
        }
        update projects;
        System.debug(projects);

        Test.startTest();
        Database.executeBatch(new TimingsUpdateBatch());
        Test.stopTest();

        List<Project__c> newProjects = [
            SELECT OpportunityRecommendedDate__c
            FROM Project__c
            WHERE ProjectClassification__c =: InnovatorConstants.FEARLESS_BET
            OR ProjectClassification__c =: InnovatorConstants.REPACK
        ];

        System.debug(System.today());
        System.debug(projects);

        for (Project__c newProject : newProjects) {
            System.debug(newProject);
            Assert.areEqual(System.today(), newProject.OpportunityRecommendedDate__c);
        }
    }

    @IsTest
    static void timingsUpdateScheduledBatchTest() {
        List<Project__c> projects = [
            SELECT OpportunityRecommendedDate__c, DecisionStep__c, ProjectClassification__c, ProjectPhase__c, ProjectStatus__c, SubmissionStatus__c, TargetOnShelfDateLeadRegion__c
            FROM Project__c
        ];

        for (Project__c project : projects) {
            if (project.ProjectClassification__c == InnovatorConstants.FEARLESS_BET ||
                project.ProjectClassification__c == InnovatorConstants.REPACK) {
                project.ProjectStatus__c = InnovatorConstants.PROJECT_STATUS_DRAFT;
            }
            project.OpportunityRecommendedDate__c = null;
        }
        update projects;

        Test.startTest();
        TimingsUpdateScheduledBatchScheduler.initializeSchedule();
        Database.executeBatch(new TimingsUpdateScheduledBatch());
        Test.stopTest();

        List<Project__c> newProjects = [
            SELECT OpportunityRecommendedDate__c, ProjectClassification__c
            FROM Project__c
        ];

        for (Project__c newProject : newProjects) {
            if (newProject.ProjectClassification__c == InnovatorConstants.FEARLESS_BET ||
                newProject.ProjectClassification__c == InnovatorConstants.REPACK) {
                Assert.areEqual(System.today(), newProject.OpportunityRecommendedDate__c);
            } else {
                Assert.areEqual(null, newProject.OpportunityRecommendedDate__c);
            }
        }
    }
}