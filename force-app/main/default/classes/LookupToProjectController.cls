public class LookupToProjectController {

    private static final String PROJECT_SOBJECT  = 'Project__c';
    private static final String CUSTOM_PROJECT_ICON = 'custom:custom56';
    private static final List<String> GEO_PROJECT_CLASSIFICATIONS = new List<String>{
        InnovatorConstants.FEARLESS_BET,
        InnovatorConstants.BRAND_ENERGIZER, InnovatorConstants.BUSINESS_ENABLER, InnovatorConstants.REPACK
    };
    private static final List<String> PROMOTIONAL_PACK_PROJECT_CLASSIFICATIONS = new List<String>{
        InnovatorConstants.PROMOTIONAL_PACK
    };
    private static final List<String> GEO_PROJECT_STATUSES = new List<String>{
        InnovatorConstants.PROJECT_STATUS_ACTIVE,
        InnovatorConstants.PROJECT_STATUS_COMPLETED,
        InnovatorConstants.PROJECT_STATUS_LAUNCHED
    };
    private static final List<String> PROMOTIONAL_PACK_PROJECT_STATUSES = new List<String>{
        InnovatorConstants.PROJECT_STATUS_ACTIVE,
        InnovatorConstants.PROJECT_STATUS_COMPLETED
    };

    @AuraEnabled(Cacheable=true)
    public static List<LookupSearchResult> searchProjectBySearchTerm(String currentProjectId, String searchTerm, String projectClassification) {
        List<List<SObject>> searchResults = new List<List<SObject>>();
        List<String> projectIds = new List<String>{currentProjectId};
        if (projectClassification == InnovatorConstants.GEO_EXTENSION) {
            searchResults = ProjectRepository.getProjects(searchTerm, projectIds, GEO_PROJECT_CLASSIFICATIONS, GEO_PROJECT_STATUSES);
        } else if (projectClassification == InnovatorConstants.PROMOTIONAL_PACK) {
            searchResults = ProjectRepository.getProjects(searchTerm, projectIds, PROMOTIONAL_PACK_PROJECT_CLASSIFICATIONS,
                PROMOTIONAL_PACK_PROJECT_STATUSES);
        }

        List<LookupSearchResult> results = new List<LookupSearchResult>();
        String projectDescription;
        if (searchResults[0].size() > 0) {
            List<Project__c> projects = (List<Project__c>) searchResults[0];
            for (Project__c project: projects) {
                projectDescription = getProjectDescription(project);
                results.add(
                    new LookupSearchResult(
                        project.Id,
                        PROJECT_SOBJECT,
                        CUSTOM_PROJECT_ICON,
                        project.Name,
                        project.ProjectNumber__c,
                        projectDescription
                    )
                );
            }
        }
        return results;
    }

    @AuraEnabled(Cacheable=true)
    public static List<LookupSearchResult> searchProjects(String currentProjectId, String projectClassification) {
        List<Project__c> projects = new List<Project__c>();
        List<String> projectIds = new List<String>{currentProjectId};
        if (projectClassification == InnovatorConstants.GEO_EXTENSION) {
            projects = ProjectRepository.getProjectByClassificationStatus(GEO_PROJECT_CLASSIFICATIONS, GEO_PROJECT_STATUSES, projectIds);
        } else if (projectClassification == InnovatorConstants.PROMOTIONAL_PACK) {
            projects = ProjectRepository.getProjectByClassificationStatus(PROMOTIONAL_PACK_PROJECT_CLASSIFICATIONS,
                PROMOTIONAL_PACK_PROJECT_STATUSES, projectIds);
        }
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        String projectDescription;
        if (projects.size() > 0) {
            for (Project__c project : projects) {
                projectDescription = getProjectDescription(project);
                results.add(
                    new LookupSearchResult(
                        project.Id,
                        PROJECT_SOBJECT,
                        CUSTOM_PROJECT_ICON,
                        project.Name,
                        project.ProjectNumber__c,
                        projectDescription
                    )
                );
            }
        }
        return results;
    }

    public static String getProjectDescription(Project__c project) {
        String projectDescription;
        if (project.ProjectClassification__c == InnovatorConstants.FEARLESS_BET ||
            project.ProjectClassification__c == InnovatorConstants.BRAND_ENERGIZER ||
            project.ProjectClassification__c == InnovatorConstants.BUSINESS_ENABLER) {
            projectDescription = project.DescriptionAndOpportunity__c;
        } else if (project.ProjectClassification__c == InnovatorConstants.PROMOTIONAL_PACK) {
            projectDescription = project.ProjectDescription__c;
        } else {
            projectDescription = project.Opportunity__c;
        }
        return projectDescription;
    }
}