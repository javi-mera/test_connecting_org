@IsTest
public class ProjectUtilityTest {

    @TestSetup
    static void makeData(){
        TestFactory.generateBasicSetUp();
    }

    @IsTest
    static void fearlessBetToBrandEnergizer() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{InnovatorConstants.FEARLESS_BET}).get(0);
        Test.startTest();
        project.ProjectClassification__c = InnovatorConstants.BRAND_ENERGIZER;
        project.AvoidSnapshotCreation__c = true;
        update project;
        Test.stopTest();
    }
    
    @IsTest
    static void repackToFearlessBet() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{InnovatorConstants.REPACK}).get(0);
        Test.startTest();
        project.ProjectClassification__c = InnovatorConstants.FEARLESS_BET;
        project.AvoidSnapshotCreation__c = true;
        update project;
        Test.stopTest();
    }
    
    @IsTest
    static void fearlessBetDiscoverToDefine() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{InnovatorConstants.FEARLESS_BET}).get(0);
        
        Test.startTest();
        project.ProjectPhase__c = InnovatorConstants.DEFINE_PHASE;
        project.AvoidSnapshotCreation__c = true;
        update project;
        Test.stopTest();
    }
    
    @IsTest
    static void brandEnergizerDiscoverToDefine() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{InnovatorConstants.BRAND_ENERGIZER}).get(0);
        
        Test.startTest();
        project.ProjectPhase__c = InnovatorConstants.DEFINE_PHASE;
        project.AvoidSnapshotCreation__c = true;
        update project;
        Test.stopTest();
    }
    
    
    @IsTest
    static void brandEnergizerDiscoverToDefineToDiscover() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{InnovatorConstants.BRAND_ENERGIZER}).get(0);
        
        Test.startTest();
        project.ProjectPhase__c = InnovatorConstants.DEFINE_PHASE;
        project.AvoidSnapshotCreation__c = true;
        update project;
        project.ProjectPhase__c = InnovatorConstants.DISCOVER_PHASE;
        project.AvoidSnapshotCreation__c = true;
        update project;
        Test.stopTest();
    }
    
    @IsTest
    static void repackDiscoverToDefine() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{InnovatorConstants.REPACK}).get(0);
        
        Test.startTest();
        project.ProjectPhase__c = InnovatorConstants.DEFINE_PHASE;
        project.AvoidSnapshotCreation__c = true;
        update project;
        Test.stopTest();
    }
    
    @IsTest
    static void continuousImprovementToFearlessBet() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{InnovatorConstants.CONTINUOUS_IMPROVEMENT}).get(0);
        
        Test.startTest();
        project.ProjectClassification__c = InnovatorConstants.FEARLESS_BET;
        project.AvoidSnapshotCreation__c = true;
        update project;
        Test.stopTest();
    }
    
    
    @IsTest
    static void fearlessBetToCI() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{InnovatorConstants.FEARLESS_BET}).get(0);
        
        Test.startTest();
        project.ProjectClassification__c = InnovatorConstants.CONTINUOUS_IMPROVEMENT;
        project.AvoidSnapshotCreation__c = true;
        update project;
        Test.stopTest();
    }
    
    @IsTest
    static void continuousImprovementToRepack() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{InnovatorConstants.CONTINUOUS_IMPROVEMENT}).get(0);
        
        Test.startTest();
        project.ProjectClassification__c = InnovatorConstants.REPACK;
        project.AvoidSnapshotCreation__c = true;
        update project;
        Test.stopTest();
    }
    
    @IsTest
    static void continuousImprovementToGeoExtensionInnovation() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{InnovatorConstants.CONTINUOUS_IMPROVEMENT}).get(0);
        
        Test.startTest();
        project.ProjectClassification__c = InnovatorConstants.GEO_EXTENSION;
        project.GeoExtensionProjectSubClassification__c = InnovatorConstants.GEO_EXTENSION_INNOVATION;
        project.AvoidSnapshotCreation__c = true;
        update project;
        Test.stopTest();
    }
    
    @IsTest
    static void continuousImprovementToGeoExtensionOther() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{InnovatorConstants.CONTINUOUS_IMPROVEMENT}).get(0);
        
        Test.startTest();
        project.ProjectClassification__c = InnovatorConstants.GEO_EXTENSION;
        project.GeoExtensionProjectSubClassification__c = InnovatorConstants.GEO_EXTENSION_OTHER;
        project.AvoidSnapshotCreation__c = true;
        update project;
        Test.stopTest();
    }
    
    @IsTest
    static void geoExtensionOtherToInnovation() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{InnovatorConstants.GEO_EXTENSION}).get(1);
        
        Test.startTest();
        project.GeoExtensionProjectSubClassification__c = InnovatorConstants.GEO_EXTENSION_INNOVATION;
        project.AvoidSnapshotCreation__c = true;
        update project;
        Test.stopTest();

    }


}