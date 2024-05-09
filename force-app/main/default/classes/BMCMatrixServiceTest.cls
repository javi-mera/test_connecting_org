@IsTest
public class BMCMatrixServiceTest {

    @TestSetup
    static void testSetup() {
        TestFactory.generateBasicSetUp();
    }

    @IsTest
    static void setBMCAirMustWin() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{ InnovatorConstants.REPACK }).get(0);
        project.ProjectPhase__c = 'Define';
        project.LeadMarket__c = 'AF';
        project.Brand__c = 'BACARDI';
        BMCMatrixService.setBMC(project);
    }
    
    @IsTest
    static void setBMCAirNA() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{ InnovatorConstants.REPACK }).get(0);
        project.ProjectPhase__c = 'Define';
        project.LeadMarket__c = 'PT';
        project.Brand__c = 'BACARDI';
        BMCMatrixService.setBMC(project);
    }
    
    @IsTest
    static void setBMCNew() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{ InnovatorConstants.REPACK }).get(0);
        project.ProjectPhase__c = 'Define';
        project.LeadMarket__c = 'PT';
        project.Brand__c = 'New';
        BMCMatrixService.setBMC(project);
    }
    
    @IsTest
    static void setBMCNotExisting() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{ InnovatorConstants.REPACK }).get(0);
        project.ProjectPhase__c = 'Define';
        project.LeadMarket__c = 'PT';
        project.Brand__c = '42 BELOW';
        BMCMatrixService.setBMC(project);
    }
    
    @IsTest
    static void calculateBMC() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{ InnovatorConstants.REPACK }).get(0);
        project.ProjectPhase__c = 'Define';
        project.LeadMarket__c = 'AF';
        project.Brand__c = 'BACARDI';
        BMCMatrixService.calculateBMC(project.Id, 'Afghanistan', '');
    }
    
    @IsTest
    static void calculateBMCNull() {
        Project__c project = ProjectRepository.getProjectByProjectClassification(new List<String>{ InnovatorConstants.REPACK }).get(0);
        project.ProjectPhase__c = 'Define';
        project.LeadMarket__c = 'AF';
        project.Brand__c = 'BACARDI';
        BMCMatrixService.calculateBMC(project.Id, null, null);
    }

}