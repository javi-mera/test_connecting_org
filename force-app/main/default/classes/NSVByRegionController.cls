public class NSVByRegionController {

    private static final String GTR_REGION = 'GTR';

    public static void updateNSVByRegionFinancials(List<Project__c> newProjects, Map<Id, Project__c> oldProjectsMap) {
        Map<Id, Project__c> projectsWithEmptyRegionsMap = new Map<Id, Project__c>(); //remove all financials if any
        Map<Id, Set<String>> newRegionsByProjectIdMap = new Map<Id, Set<String>>(); //add financials
        Map<Id, Set<String>> oldRegionsByProjectIdMap = new Map<Id, Set<String>>(); //remove financials if any

        //check changes to/from null
        for (Project__c project : newProjects) {
            Project__c oldProject = oldProjectsMap.get(project.Id);

            Boolean areNewRegionsEmpty = String.isBlank(project.Region__c) && String.isBlank(project.AddAdditionalRegionOrRegions__c);
            Boolean areOldRegionsEmpty = String.isBlank(oldProject.Region__c) && String.isBlank(oldProject.AddAdditionalRegionOrRegions__c);

            if (areNewRegionsEmpty && !areOldRegionsEmpty) {
                projectsWithEmptyRegionsMap.put(project.Id, project);
            } else if (!areNewRegionsEmpty && areOldRegionsEmpty) {
                Set<String> regionsToAdd = getRegionsSet(project.Region__c, project.AddAdditionalRegionOrRegions__c);
                newRegionsByProjectIdMap.put(project.Id, regionsToAdd);
            } else {
                Set<String> newRegions = getRegionsSet(project.Region__c, project.AddAdditionalRegionOrRegions__c);
                Set<String> oldRegions = getRegionsSet(oldProject.Region__c, oldProject.AddAdditionalRegionOrRegions__c);

                Set<String> regionsToCreate = new Set<String>();
                Set<String> regionsToRemove = new Set<String>();

                for (String oldRegion : oldRegions) {
                    if (!newRegions.contains(oldRegion)) {
                        regionsToRemove.add(oldRegion);
                    }
                }

                for (String newRegion : newRegions) {
                    if (!oldRegions.contains(newRegion)) {
                        regionsToCreate.add(newRegion);
                    }
                }

                if (!regionsToCreate.isEmpty()) {
                    newRegionsByProjectIdMap.put(project.Id, regionsToCreate);
                }

                if (!regionsToRemove.isEmpty()) {
                    oldRegionsByProjectIdMap.put(project.Id, regionsToRemove);
                }
            }
        }

        List<Financial__c> financials = FinancialDataRespository.getRegionalNSVFinancialsByProjectIds(newProjects);
        List<Financial__c> financialsToDelete = new List<Financial__c>();
        List<Financial__c> financialsToCreate = new List<Financial__c>();

        if (!financials.isEmpty()) {
            for (Financial__c financial : financials) {
                if (projectsWithEmptyRegionsMap.containsKey(financial.Project__c)) {
                    financialsToDelete.add(financial);
                } else if (oldRegionsByProjectIdMap.containsKey(financial.Project__c) &&
                    oldRegionsByProjectIdMap.get(financial.Project__c).contains(financial.Region__c)) {
                    financialsToDelete.add(financial);
                }
            }
        }

        if (!newRegionsByProjectIdMap.isEmpty()) {
            Id recordTypeId = Schema.SObjectType.Financial__c.getRecordTypeInfosByName().get(InnovatorConstants.REGIONAL_NSV_RECORDTYPE).getRecordTypeId();
            for (Id projectId : newRegionsByProjectIdMap.keySet()) {
                for (String region : newRegionsByProjectIdMap.get(projectId)) {
                    Financial__c newFinancial = new Financial__c(
                        Project__c = projectId,
                        Region__c = region,
                        RecordTypeId = recordTypeId
                    );
                    financialsToCreate.add(newFinancial);
                }
            }
        }

        if (!financialsToDelete.isEmpty()) {
            delete financialsToDelete;
        }

        if (!financialsToCreate.isEmpty()) {
            insert financialsToCreate;
        }

        //recalculate total%
        recalculateTotalNSVPercentage(newProjects);
    }

    public static Set<String> getRegionsSet(String leadRegion, String additionalRegions) {
        Set<String> regions = new Set<String>();
        if (String.isNotBlank(leadRegion)) {
            if (leadRegion.contains(GTR_REGION)) {
                regions.add(GTR_REGION);
            } else {
                regions.add(leadRegion);
            }
        }

        if (String.isNotBlank(additionalRegions)) {
            for (String additionalRegion : additionalRegions.split(';')) {
                if (additionalRegion.contains(GTR_REGION)) {
                    regions.add(GTR_REGION);
                } else {
                    regions.add(additionalRegion);
                }
            }
        }
        return regions;
    }

    public static void recalculateTotalNSVPercentage(List<Project__c> newProjects) {
        List<Financial__c> financials = FinancialDataRespository.getRegionalNSVFinancialsByProjectIds(newProjects);
        if (!financials.isEmpty()) {
            for (Project__c project : newProjects) {
                project.NSVByRegionTotalPercentage__c = 0;
                for (Financial__c financial : financials) {
                    if (financial.Project__c == project.Id) {
                        project.NSVByRegionTotalPercentage__c += financial.ContributionToTotalNSV__c == null ? 0 : financial.ContributionToTotalNSV__c;
                    }
                }
            }
        } else {
            for (Project__c project : newProjects) {
                project.NSVByRegionTotalPercentage__c = 0;
            }
        }
    }

    @AuraEnabled
    public static Decimal getFinancialsNSV(Id projectId) {
        Decimal nsvValue = null;
        List <Financial__c> financials = FinancialDataRespository.getFinancialsNSVYearOne(projectId);
        if (!financials.isEmpty()) {
            nsvValue = financials[0].NSV__c;
        }
        return nsvValue;
    }

    @AuraEnabled
    public static void updateFinancialsNSVByRegion(List<Financial__c> financials) {
        if (!financials.isEmpty()) {
            update financials;
        }
    }
}