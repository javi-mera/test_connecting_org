public with sharing class FinancialDataController {

    private static final String CI = 'Continuous Improvement';
    private static final String MANDATORY = 'Mandatory';
    private static final String PROMOTIONAL_PACK = 'Promotional Pack';
    private static final String K_USD = '(K USD)';
    private static final Integer PROMOTIONAL_PACK_FINANCIAL_SIZE = 13;

    private static final List<String> fields = new List<String> {
        'Volume__c',
        'TotalNSV__c',
        'NSV__c',
        'TotalCOGs__c',
        'TotalGP__c',
        'AP__c',
        'RSP__c',
        'Id'
    };

    private static final List<String> DEFINE_FIELDS = new List<String> {
        'Volume__c',
        'NSV__c',
        'TotalGP__c',
        'AP__c',
        'Id'
    };

    private static final List<String> CI_MANDATORY_LABELS = new List<String> {
        '*Volume',
        'NSV Change (if any)',
        '',
        '*COGS Impact ($/9L CS)',
        '',
        '*Total COGS impact (1 year)',
        '*Total CAPEX',
        '*Total Tooling',
        '*Total Write-Offs',
        '*Total Other One-off costs',
        '*Total working Capital Impact',
        '*Payback Time',
        'Id'
    };

    private static final List<String> CI_MANDATORY_FIELD_NAMES = new List<String> {
        '(9L case)',
        '($/9L CS)',
        '*COGS Decrease vs. Current',
        '*COGS Increase vs. Current',
        '*COGS No Change vs. Current',
        K_USD,
        K_USD,
        K_USD,
        K_USD,
        K_USD,
        K_USD,
        '(Years)',
        'Id'
    };

    private static final List<String> CI_MANDATORY_FIELDS = new List<String> {
        'Volume__c',
        'NSV__c',
        'COGSDecreaseCurrent__c',
        'COGSIncreaseCurrent__c',
        'COGSNoChangeCurrent__c',
        'TotalCOGs__c',
        'TotalCAPEX__c',
        'TotalTooling__c',
        'TotalWriteOffs__c',
        'TotalOtherOneOffCosts__c',
        'TotalWorkingCapitalImpact__c',
        'PaybackTime__c',
        'Id'
    };

    private static final List<String> PROMOTIONAL_PACKS_MANDATORY_FIELDS = new List<String>{
        'Volume__c',
        'TotalWriteOffs__c',
        'TotalNSV__c',
        'IncrementalNSV__c',
        'TotalCOGs__c',
        'AP__c',
        'TotalNP__c',
        'GM__c',
        'StructuralCosts__c',
        'TotalCosts__c',
        'IncrementalDBC__c',
        'ReturnOnInvestment__c',
        'Id'
    };

    private static final List<String> PROMOTIONAL_PACKS_MANDATORY_FIELD_NAMES = new List<String>{
        '*Volume (9L cases)',
        '*One Off Write Off Costs ($)',
        '*Total NSV ($)',
        '*Incremental NSV ($)',
        '*COGs (including MOQ Write Off Costs) ($)',
        '*A&P ($)',
        'Net Profit ($) (Total NSV - COGs – A&P – Structure Costs)',
        '*GM%',
        '*Structure Costs ($)',
        '*Total Investment ($)',
        '*Incremental DBC',
        'Return on Investment (Incremental DBC ($) / - Total Investment ($) - 1)',
        'Id'
    };

    private static final List<String> DISCOVER_FIELD_NAMES = new List<String> {
        'NSVAmbition__c',
        'Id'
    };

    private static final Map<String, Integer> PHASE_TO_NUMBER = new Map<String, Integer> {
        'Discover' => 1,
        'Define' => 2,
        'Design' => 3,
        'Develop' => 4,
        'Deploy' => 5,
        'Diagnose' => 6
    };

    private static final Map<String, Integer> PHASE_AND_COMPLEXITY_TO_SIZE = new Map<String, Integer>{
        'Define' => 1,
        'Design' => 2,
        'Low|Deploy' => 2,
        'Medium|Deploy' => 3,
        'Low|Diagnose' => 2,
        'Medium|Diagnose' => 3
    };

    private static void prepareCIOrMandatoryFinancials(Financial__c financial, List<Map<String,Object>> result, Integer size, String projectType, Integer phase) {
        for (Integer i = 0; i < size; i++) {
            Map<String, Object> rowData = new Map<String, Object>();
            rowData.put('fieldLabel', CI_MANDATORY_LABELS.get(i));
            rowData.put('fieldName', CI_MANDATORY_FIELD_NAMES.get(i));
            rowData.put('fieldValue2', financial.get(CI_MANDATORY_FIELDS.get(i)));
            result.add(rowData);
        }
        result.add(new Map<String, Object> {
            'size' => 1,
            'phase' => phase,
            'projectType' => projectType
        });
    }

    private static void preparePromotionalPackFinancials(List<Financial__c> financials, List<Map<String, Object>> result, String projectType, String complexity, String phase) {
        List<String> fieldLabels = PROMOTIONAL_PACKS_MANDATORY_FIELD_NAMES;
        List<String> fieldNames = PROMOTIONAL_PACKS_MANDATORY_FIELDS;
        String mappingValue = phase == 'Deploy' || phase == 'Diagnose' ? complexity + '|' + phase : phase;
        Integer size = PHASE_AND_COMPLEXITY_TO_SIZE.get(mappingValue);
        for (Integer i = 0; i < PROMOTIONAL_PACK_FINANCIAL_SIZE; i++) {
            Map<String, Object> rowData = new Map<String, Object>();
            rowData.put('fieldName', fieldLabels.get(i));
            for (Integer j = 0; j < size; j++) {
                rowData.put('fieldValue' + (j + 2), financials.get(j).get(fieldNames.get(i)));
            }
            result.add(rowData);
        }
        result.add(new Map<String, Object> {
            'size' => size,
            'phase' => PHASE_TO_NUMBER.get(phase),
            'projectType' => projectType,
            'complexity' => complexity
        });
    }

    private static void prepareFinancials(List<Financial__c> financials, List<Map<String,Object>> result, String projectType, Integer phase, String financialThresholdNotMetComment) {
        List<String> fieldLabels = InnovatorConstants.DEFINE_FIELD_NAMES;
        List<String> fieldNames = DEFINE_FIELDS;
        Integer financialSize = 5;
        if (phase == 1) {
            financialSize = 2;
            fieldLabels = InnovatorConstants.DISCOVER_FIELD_LABELS;
            fieldNames = DISCOVER_FIELD_NAMES;
        }
        for (Integer i = 0; i < financialSize; i++) {
            Map<String, Object> rowData = new Map<String, Object>();
            rowData.put('fieldName', fieldLabels.get(i));
            for (Integer j = 0; j < financials.size(); j++) {
                rowData.put('fieldValue' + (j + 2), financials.get(j).get(fieldNames.get(i)));
            }
            result.add(rowData);
        }
        result.add(new Map<String, Object> {
            'size' => financialSize,
            'phase' => phase,
            'projectType' => projectType,
            'financialThresholdNotMetComment' => financialThresholdNotMetComment
        });
    }

    @AuraEnabled
    public static List<Map<String, Object>> getInvertedFinancialData(Id projectId) {
        Project__c project = ProjectRepository.getProject(projectId);
        Integer phase = PHASE_TO_NUMBER.get(project.ProjectPhase__c);
        List<Map<String, Object>> result = new List<Map<String,Object>>();
        if (MANDATORY.equals(project.ProjectClassification__c)) {
            prepareCIOrMandatoryFinancials(FinancialDataRespository.getCIProjectFinancials(projectId), result, 11, 'Mandatory', phase);
        } else if (CI.equals(project.ProjectClassification__c))  {
            prepareCIOrMandatoryFinancials(FinancialDataRespository.getCIProjectFinancials(projectId), result, 13, 'CI', phase);
        } else if (PROMOTIONAL_PACK.equals(project.ProjectClassification__c)) {
            preparePromotionalPackFinancials(FinancialDataRespository.getProjectFinancials(projectId), result, project.ProjectClassification__c, project.Complexity__c, project.ProjectPhase__c);
        } else {
            prepareFinancials(FinancialDataRespository.getProjectFinancials(projectId), result, project.ProjectClassification__c, phase, project.FinancialThresholdNotMetComment__c);
        }
        return result;
    }

    @AuraEnabled
    public static List<Map<String, Object>> getInvertedSnapshotFinancialData(Id projectSnapshotId) {
        Project_Snapshot__c projectSnapshot = ProjectSnapshotRepository.getProjectSnapshot(projectSnapshotId);
        Integer phase = PHASE_TO_NUMBER.get(projectSnapshot.ProjectPhase__c);
        List<Map<String, Object>> result = new List<Map<String,Object>>();
        if (MANDATORY.equals(projectSnapshot.ProjectClassification__c)) {
            prepareCIOrMandatoryFinancials(FinancialDataRespository.getCIProjectSnapshotFinancials(projectSnapshotId), result, 11, 'Mandatory', phase);
        } else if (CI.equals(projectSnapshot.ProjectClassification__c))  {
            prepareCIOrMandatoryFinancials(FinancialDataRespository.getCIProjectSnapshotFinancials(projectSnapshotId), result, 13, 'CI', phase);
        } else if (PROMOTIONAL_PACK.equals(projectSnapshot.ProjectClassification__c)) {
            preparePromotionalPackFinancials(FinancialDataRespository.getProjectSnapshotFinancials(projectSnapshotId), result, projectSnapshot.ProjectClassification__c, projectSnapshot.Complexity__c, projectSnapshot.ProjectPhase__c);
        } else {
            prepareFinancials(FinancialDataRespository.getProjectSnapshotFinancials(projectSnapshotId), result, projectSnapshot.ProjectClassification__c, phase, projectSnapshot.FinancialThresholdNotMetComment__c);
        }
        return result;
    }

    @AuraEnabled
    public static Map<String, Object> getDeliverableData(Id projectId) {
        Project__c project = ProjectRepository.getProject(projectId);
        Map<String, Object> result = new Map<String, Object> {
            'deliverables' => FinancialDataRespository.getProjectDeliverables(projectId),
            'phase' => project.ProjectPhase__c,
            'subType' => project.ProjectClassificationSubType__c,
            'type' => project.ProjectClassification__c
        };
        return result;
    }
    
    @AuraEnabled
    public static Map<String, Object> getSnapshotDeliverableData(Id projectSnapshotId) {
        Project_Snapshot__c projectSnapshot = ProjectSnapshotRepository.getProjectSnapshot(projectSnapshotId);
        Map<String, Object> result = new Map<String, Object> {
            'deliverables' => FinancialDataRespository.getProjectSnapshotDeliverables(projectSnapshotId),
            'phase' => projectSnapshot.ProjectPhase__c,
            'subType' => projectSnapshot.ProjectClassificationSubType__c,
            'type' => projectSnapshot.ProjectClassification__c
        };
        return result;
    }

    @AuraEnabled
    public static void updateFinancialData(List<Financial__c> financials, Integer phase, Project__c project, String type) {
        if (!CI.equals(project.ProjectClassification__c) && !MANDATORY.equals(project.ProjectClassification__c) && !PROMOTIONAL_PACK.equals(project.ProjectClassification__c)) {
            FinancialDataService.updateFinancialData(financials);
            if (type == 'Financials') {
                ProjectService.updateFinancialFilledFields(financials, phase, project);
            } else {
                ProjectService.updateCriticalKPIFields(financials, phase, project);
            }
        } else if (PROMOTIONAL_PACK.equals(project.ProjectClassification__c)) {
            FinancialDataService.updateFinancialData(financials);
            ProjectService.updateFinancialsFilled(financials, project);
        } else {
            FinancialDataService.updateFinancialsCIMandatory(financials, project.Id);
            ProjectService.updateFinancialFirstYearFilled(financials[0], project, project.ProjectClassification__c);
        }
        update project;
    }

    @AuraEnabled
    public static void updateFinancialsList(List<Financial__c> financials) {
        if (!financials.isEmpty()) {
            update financials;
        }
    }
}