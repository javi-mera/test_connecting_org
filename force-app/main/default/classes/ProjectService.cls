public with sharing class ProjectService {
    private static final String GENERIC_ICON = 'Generic';
    private static final String BRAND_LOGOS_STATICRESOURCE = 'InnovatorBrandLogos';

    private static final String CI = 'Continuous Improvement';
    private static final String MANDATORY = 'Mandatory';
    
    private static final Map<Integer, String> yearToField = new Map<Integer, String> {
        1 => 'FirstFiscalYearFilled__c',
        2 => 'SecondFiscalYearFilled__c',
        3 => 'ThirdFiscalYearFilled__c',
        4 => 'FourthFiscalYearFilled__c',
        5 => 'FifthFiscalYearFilled__c'
    };

    public static void updateFinancialFilledFields(List<Financial__c> financials, Integer phase, Project__c project) {
        Map<Integer, Boolean> yearToFilled = new Map<Integer, Boolean> {
            1 => false
        };
        if (phase == 1) {
            yearToFilled.put(5, false);
        } else {
            yearToFilled.put(2, false);
            yearToFilled.put(3, false);
            yearToFilled.put(4, false);
            yearToFilled.put(5, false);
        }
        for (Integer i = 0; i < financials.size(); i++) {
            if (phase == 1) {
                if (financials[i].NSVAmbition__c != null) {
                    if (i + 1 == 2) {
                        yearToFilled.put(5, true);
                    } else {
                        yearToFilled.put(i + 1, true);
                    }
                }
            } else {
                if (financials[i].Volume__c != null && financials[i].TotalGP__c != null && financials[i].NSV__c != null && financials[i].AP__c != null) {
                    yearToFilled.put(i + 1, true);
                }
            }
        }
        for (Integer year : yearToFilled.keySet()) {
            project.put(yearToField.get(year), yearToFilled.get(year));
        }
    }

    public static void updateCriticalKPIFields(List<Financial__c> financials, Integer phase, Project__c project) {
        Map<String, Boolean> criticalKPIs = new Map<String, Boolean> {
            'BCA' => true,
            'BCV' => true,
            'CM' => true,
            'PN' => true
        };
        for (Financial__c financial : financials) {
            if (financial.BCAValue__c == null) {
                criticalKPIs.put('BCA', false);
            }
            if (financial.BCVVAlue__c == null) {
                criticalKPIs.put('BCV', false);
            }
            if (financial.CMValue__c == null) {
                criticalKPIs.put('CM', false);
            }
            if (financial.PMValue__c == null) {
                criticalKPIs.put('PN', false);
            }
        }
        project.BusinessCaseAmbitionFilled__c = criticalKPIs.get('BCA');
        project.BusinessCaseValidationFilled__c = criticalKPIs.get('BCV');
        project.CommercialMilestoneFilled__c = criticalKPIs.get('CM');
        project.ProductionMilestone__c = criticalKPIs.get('PN');
    }
    
    public static void updateFinancialsFilled(List<Financial__c> financials, Project__c project) {
        Project__c projectFinancials = ProjectRepository.getProject(project.Id);
        Map<String, Boolean> financialsFilled = new Map<String, Boolean> {
            'BCA' => false,
            'BCV' => false,
            'PM' => false
        };
        for (Integer financialIndex = 0; financialIndex < financials.size(); financialIndex++) {
            Financial__c financial = financials[financialIndex];
            Boolean isFilled = financial.Volume__c != null && financial.TotalNSV__c != null && financial.IncrementalNSV__c != null && financial.TotalCOGs__c != null && financial.AP__c != null && financial.GM__c != null && financial.StructuralCosts__c != null && financial.TotalNP__c != null && financial.TotalCosts__c != null && financial.IncrementalDBC__c != null && financial.ReturnOnInvestment__c != null;
            if (financialIndex == 0) {
                financialsFilled.put('BCA', isFilled);
            } else if (financialIndex == 1 && project.Complexity__c == 'Medium') {
                financialsFilled.put('BCV', isFilled);
            } else if (financialIndex == 2 || (financialIndex == 1 && project.Complexity__c == 'Low')) {
                financialsFilled.put('PM', isFilled);
            }
        }
        project.BusinessCaseAmbitionFilled__c = projectFinancials.BusinessCaseAmbitionFilled__c && project.ProjectPhase__c != 'Define' ? projectFinancials.BusinessCaseAmbitionFilled__c : financialsFilled.get('BCA');
        project.BusinessCaseValidationFilled__c = projectFinancials.BusinessCaseValidationFilled__c && project.ProjectPhase__c != 'Design' ? projectFinancials.BusinessCaseValidationFilled__c :financialsFilled.get('BCV');
        project.ProductionMilestone__c = projectFinancials.ProductionMilestone__c && project.ProjectPhase__c != 'Deploy' ? projectFinancials.ProductionMilestone__c :financialsFilled.get('PM');
    }


    public static void updateFinancialFirstYearFilled(Financial__c financial, Project__c project, String projectClassification) {
        project.FirstFiscalYearFilled__c = false;
        if (financial.Volume__c != null && financial.COGSDecreaseCurrent__c != null && financial.COGSIncreaseCurrent__c != null && financial.COGSNoChangeCurrent__c != null && financial.TotalCOGs__c != null && financial.TotalCAPEX__c != null && financial.TotalTooling__c != null && financial.TotalWriteOffs__c != null && financial.TotalOtherOneOffCosts__c != null) {
            if (MANDATORY.equals(projectClassification)) {
                project.FirstFiscalYearFilled__c = true;
            } else {
                if (financial.TotalWorkingCapitalImpact__c != null && financial.PaybackTime__c != null) {
                    project.FirstFiscalYearFilled__c = true;
                }
            }
        }
    }


    // A Future is needed due PageReference getContent is considered a callout and can't be done in the context of a Trigger.
    @Future(callout=true)
    public static void setBrandIcon(String projectId) {
        Project__c project = ProjectRepository.getProject(projectId);

        String newBrand = project.Brand__c;

        if (newBrand != null) {
            List<String> splittedBrands = newBrand.split(';');
            if (splittedBrands.size() == 1) {
                project.BrandIconResource__c = splittedBrands.get(0).toLowerCase();
                if (!doesResourceExistForBrand(project.BrandIconResource__c)) {
                    project.BrandIconResource__c = GENERIC_ICON;
                }
            } else if (splittedBrands.size() == 0 || splittedBrands.size() > 1) {
                project.BrandIconResource__c = GENERIC_ICON;
            }
        }

        update project;
    }

    private static Boolean doesResourceExistForBrand(String brand) {
        Boolean doesBrandResourceExist = false;

        try {
            PageReference file = PageReference.forResource(BRAND_LOGOS_STATICRESOURCE, brand + '.png');
            file.getContent();
            doesBrandResourceExist = true;
        } catch(VisualforceException e) {
            // 404 error happened here
        }

        return doesBrandResourceExist;
    }

    /**
     * @description To copy project leader and manager values in the project leader and searchable fields,
     *  in order to use quick search for project leader and manager
     */
    public static void setProjectLeaderAndManager(Boolean isInsert, List<Project__c> newProjects, Map<Id, Project__c> oldProjects){
        Map<Id, String> projectLeaderAndManagerName = getProjectLeaderAndMangerName(isInsert, newProjects, oldProjects);
        for (Project__c newProject : newProjects) {
            Boolean isProjectLeaderChanged = false;
            Boolean isProjectMangerChanged= false;
            if(!isInsert){
                isProjectLeaderChanged = newProject.ProjectLeader__c != oldProjects.get(newProject.Id).ProjectLeader__c;
                isProjectMangerChanged = newProject.ProjectManager__c != oldProjects.get(newProject.Id).ProjectManager__c;
            }
            if((isProjectLeaderChanged || isInsert) && projectLeaderAndManagerName.containsKey(newProject.ProjectLeader__c)){
                newProject.ProjectLeaderSearchable__c = projectLeaderAndManagerName.get(newProject.ProjectLeader__c);
            } else if (isProjectLeaderChanged && newProject.ProjectLeader__c == null) {
                newProject.ProjectLeaderSearchable__c = '';
            }
            if((isProjectMangerChanged || isInsert) && projectLeaderAndManagerName.containsKey(newProject.ProjectManager__c)){
                newProject.ProjectManagerSearchable__c = projectLeaderAndManagerName.get(newProject.ProjectManager__c);
            } else if (isProjectMangerChanged && newProject.ProjectManager__c == null) {
                newProject.ProjectManagerSearchable__c = '';
            }
        }
    }

    public static Map<Id, String> getProjectLeaderAndMangerName(Boolean isInsert, List<Project__c> newProjects, Map<Id, Project__c> oldProjects){
        Set<Id> projectLeaderAndManagerIds = new Set<Id>();
        for (Project__c newProject : newProjects) {
            Boolean isProjectLeaderChanged = false;
            Boolean isProjectMangerChanged = false;
            if(!isInsert){
                isProjectLeaderChanged = newProject.ProjectLeader__c != oldProjects.get(newProject.Id).ProjectLeader__c;
                isProjectMangerChanged = newProject.ProjectManager__c != oldProjects.get(newProject.Id).ProjectManager__c;
            }
            
            if((isProjectLeaderChanged || isInsert) && newProject.ProjectLeader__c != null) {
                projectLeaderAndManagerIds.add(newProject.ProjectLeader__c);
            }
            if((isProjectMangerChanged || isInsert) && newProject.ProjectManager__c != null) {
                projectLeaderAndManagerIds.add(newProject.ProjectManager__c);
            }
        }

        Map<Id, String> projectLeaderAndManagerName = new Map<Id, String>();
        List<User> userList = new List<User>();
        if(!(projectLeaderAndManagerIds.isEmpty())){
            userList = ProjectRepository.getUserNamesList(projectLeaderAndManagerIds);
        }
        
        for(User user: userList){
            projectLeaderAndManagerName.put(user.id, user.Name);
        }
        return projectLeaderAndManagerName;
    }
    public static void setTaskListAndDecisionRequired(Project__c project, List<Decision_Required__mdt> decisionRequiredList){
        Decision_Required__mdt drToUpdate = new Decision_Required__mdt();
        String projectSubtype = project.ProjectClassificationSubtype__c == InnovatorConstants.LIMITED_EDITION_PACK_SUBTYPE ||
                                project.ProjectClassificationSubtype__c == InnovatorConstants.VALUE_ADDED_PACK_SUBTYPE ?
                                'Pack Change' : project.ProjectClassificationSubtype__c;
        for(Decision_Required__mdt dr : decisionRequiredList){
            if(dr.DecisionStep__c == project.DecisionStep__c &&
               project.ProjectClassification__c == dr.ProjectClassification__c &&
                (dr.Complexity__c == project.Complexity__c || project.Complexity__c == null) &&
                (dr.ProjectClassificationSubtype__c == projectSubtype ||
                    (dr.ProjectClassificationSubtype__c == null &&
                        (project.DecisionStep__c == InnovatorConstants.DECISION_STEP_PRODUCTION || project.DecisionStep__c == InnovatorConstants.DECISION_STEP_PLR)
                    )
                )
            ){
                project.TaskList__c = dr.TaskList__c; 
                project.DecisionRequired__c = dr.DecisionRequired__c;               
            }
        }
    }
}