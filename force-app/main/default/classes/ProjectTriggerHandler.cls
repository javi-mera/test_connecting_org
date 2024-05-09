public class ProjectTriggerHandler {

    private static final String TEAM_TEMP_NAME = 'Project Team with Temporary Name';

    public static void handleIsBeforeInsert(List<Project__c> newProjects) {
        Map<String, CustomTeams__Teams__c> customTeams = new Map<String, CustomTeams__Teams__c>();
        for (Project__c newProject : newProjects) {
            setProjectPhase(newProject);
            CustomTeams__Teams__c team = new CustomTeams__Teams__c();
            team.Name = TEAM_TEMP_NAME;
            team.IsPrivate__c = newProject.IsPrivate__c;
            customTeams.put(newProject.Name, team);

            Boolean hasTimings = newProject.ProjectClassification__c == InnovatorConstants.FEARLESS_BET ||
                newProject.ProjectClassification__c == InnovatorConstants.BRAND_ENERGIZER ||
                newProject.ProjectClassification__c == InnovatorConstants.BUSINESS_ENABLER ||
                newProject.ProjectClassification__c == InnovatorConstants.REPACK ||
                newProject.ProjectClassification__c == InnovatorConstants.GEO_EXTENSION;

            if (hasTimings) {
                TimingsTableController.checkProjectTimings(newProject);
            }
        }
        insert customTeams.values();
        for (Project__c newProject : newProjects) {
            newProject.Team__c = customTeams.get(newProject.Name).Id;
        }
        ProjectService.setProjectLeaderAndManager(true, newProjects, new Map<Id, Project__c>());
        List<Decision_Required__mdt> decisionRequiredList = DecisionRequiredMetadataUpdateRepository.getAllMetadata();
        for (Project__c newProject : newProjects) {
            ProjectService.setTaskListAndDecisionRequired(newProject, decisionRequiredList);
        }
    }

    public static void handleIsAfterInsert(List<Project__c> newProjects) {
        List<CustomTeams__Teams__c> customTeams = new List<CustomTeams__Teams__c>();
        for (Project__c newProject : newProjects) {
            CustomTeams__Teams__c team = new CustomTeams__Teams__c();
            team.Id = newProject.Team__c;
            team.Name = newProject.Name;
            if (newProject.ProjectLeader__c != null) {
                team.OwnerId = newProject.ProjectLeader__c;
            }
            customTeams.add(team);
        }
        update customTeams;
    }

    public static void handleIsBeforeUpdate(List<Project__c> newProjects, Map<Id, Project__c> oldProjectsMap) {
        List<Decision_Required__mdt> decisionRequiredList = DecisionRequiredMetadataUpdateRepository.getAllMetadata();
        List<Project__c> projectsWithUpdatedRegions = new List<Project__c>();

        for (Project__c newProject : newProjects) {
            Project__c oldProject = oldProjectsMap.get(newProject.Id);
            Boolean hasProjectApprovalProcessStatusChanged = newProject.ApprovalProcessStatus__c != oldProject.ApprovalProcessStatus__c;
            Boolean hasAdditionalApproversChanged = newProject.AdditionalApprover1__c != oldProject.AdditionalApprover1__c;
            if (oldProject.AdditionalApprover1__c != null && hasAdditionalApproversChanged) {
                ApprovalProcessService.setAdditionalApproversToNull(newProject);
            }

            if (hasProjectApprovalProcessStatusChanged && newProject.ApprovalProcessStatus__c != InnovatorConstants.RECALLED_STATUS) {
                ApprovalProcessService.updateProjectStatus(newProject, (String) oldProject.ApprovalProcessStatus__c);
            }

            Boolean hasProjectPhaseChanged = newProject.ProjectPhase__c != oldProject.ProjectPhase__c;
            Boolean isAutomaticApproval = oldProject.ProjectPhase__c == InnovatorConstants.DISCOVER_PHASE || oldProject.ProjectPhase__c == InnovatorConstants.DEPLOY_PHASE ||
                (oldProject.ProjectPhase__c == InnovatorConstants.DEVELOP_PHASE && oldProject.ProjectClassification__c == InnovatorConstants.REPACK);

            if (hasProjectApprovalProcessStatusChanged && newProject.ApprovalProcessStatus__c != null) {
                if (newProject.ApprovalProcessStatus__c.contains(InnovatorConstants.SUBMITTED_STATUS) && !isAutomaticApproval) {
                    LeadRegionNotificationService.sendEmailToLeadRegion(newProject, oldProject, false);
                } else if (newProject.ApprovalProcessStatus__c == InnovatorConstants.APPROVED_STATUS) {
                    LeadRegionNotificationService.sendEmailToLeadRegion(newProject, oldProject, true);
                }
            }

            Boolean hasChangedToCancelledProject = newProject.ProjectStatus__c == InnovatorConstants.PROJECT_STATUS_CANCELLED && newProject.ProjectStatus__c != oldProject.ProjectStatus__c;
            if (hasChangedToCancelledProject) {
                if (!newProject.AvoidSnapshotCreation__c) {
                    ApprovalProcessService.updateProjectRejectedStatus(newProject);
                }
                ApprovalProcessService.setAdditionalApproversToNull(newProject);
            }
            Boolean hasProjectClassificationChanged = newProject.ProjectClassification__c != oldProject.ProjectClassification__c;
            Boolean hasProjectClassificationSubtypeChanged = newProject.ProjectClassificationSubtype__c != oldProject.ProjectClassificationSubtype__c;
            if (hasProjectPhaseChanged || hasProjectClassificationSubtypeChanged || hasProjectClassificationChanged) {
                ProjectService.setTaskListAndDecisionRequired(newProject, decisionRequiredList);
            }
            Boolean hasDecisionStepStatusChanged = newProject.SubmissionStatus__c != oldProject.SubmissionStatus__c;
            Boolean isDecisionStepStatusSubmitted = newProject.SubmissionStatus__c?.contains(InnovatorConstants.SUBMITTED_STATUS);
            if (hasDecisionStepStatusChanged && !isDecisionStepStatusSubmitted && newProject.ProjectPhase__c != InnovatorConstants.DIAGNOSE_PHASE) {
                newProject.ProjectDevelopmentDocument__c = false;
                newProject.ProjectPL__c = false;
            }

            Date dateToday = System.today();
            Boolean isComplexRepack = newProject.ProjectClassification__c == InnovatorConstants.REPACK && newProject.ProjectClassificationSubtype__c == InnovatorConstants.PRIMARY_PACK_CHANGE_SUBTYPE;
            if (hasDecisionStepStatusChanged && !hasProjectPhaseChanged && isDecisionStepStatusSubmitted) {
                if (oldProject.ProjectPhase__c == InnovatorConstants.DEFINE_PHASE) {
                    newProject.BCASubmissionDate__c = dateToday;
                } else if (oldProject.ProjectPhase__c == InnovatorConstants.DESIGN_PHASE) {
                    newProject.BCVSubmissionDate__c = dateToday;
                } else if (oldProject.ProjectPhase__c == InnovatorConstants.DEVELOP_PHASE && !isComplexRepack) {
                    newProject.CommercialSubmissionDate__c = dateToday;
                }
            }

            Boolean isDecisionStepStatusApproved = newProject.SubmissionStatus__c?.contains(InnovatorConstants.APPROVED_STATUS);

            if (hasDecisionStepStatusChanged && hasProjectPhaseChanged && isDecisionStepStatusApproved) {
                if (oldProject.ProjectPhase__c == InnovatorConstants.DISCOVER_PHASE) {
                    newProject.OpportunitySubmissionDate__c = dateToday;
                } else if (oldProject.ProjectPhase__c == InnovatorConstants.DEFINE_PHASE) {
                    newProject.BCAApprovalDate__c = dateToday;
                } else if (oldProject.ProjectPhase__c == InnovatorConstants.DESIGN_PHASE) {
                    newProject.BCVApprovalDate__c = dateToday;
                } else if (oldProject.ProjectPhase__c == InnovatorConstants.DEVELOP_PHASE) {
                    if (isComplexRepack) {
                        newProject.CommercialSubmissionDate__c = dateToday;
                    } else {
                        newProject.CommercialApprovalDate__c = dateToday;
                    }
                } else if (oldProject.ProjectPhase__c == InnovatorConstants.DEPLOY_PHASE) {
                    newProject.ProductionSubmissionDate__c = dateToday;
                }
            }

            if (newProject.IsThePostLaunchReviewRequired__c && newProject.ProjectStatus__c == InnovatorConstants.PROJECT_STATUS_COMPLETED && newProject.ProjectStatus__c != oldProject.ProjectStatus__c) {
                newProject.ActualPLRDate__c = dateToday;
            }

            if (newProject.ProjectStatus__c == InnovatorConstants.PROJECT_STATUS_COMPLETED && newProject.ProjectStatus__c != oldProject.ProjectStatus__c) {
                newProject.OnOffTrack__c = '';
            }

            Boolean hasTimings = newProject.AreTimingsAvailable__c && (newProject.ProjectClassification__c == InnovatorConstants.FEARLESS_BET ||
                newProject.ProjectClassification__c == InnovatorConstants.BRAND_ENERGIZER ||
                newProject.ProjectClassification__c == InnovatorConstants.BUSINESS_ENABLER ||
                newProject.ProjectClassification__c == InnovatorConstants.REPACK ||
                newProject.ProjectClassification__c == InnovatorConstants.GEO_EXTENSION);

            Boolean areTargetDatesChanged = newProject.TargetOnShelfDateLeadRegion__c != oldProject.TargetOnShelfDateLeadRegion__c ||
                newProject.TargetReadyShipmentDate__c != oldProject.TargetReadyShipmentDate__c || newProject.Estimated1stCustomerPresentationDate__c != oldProject.Estimated1stCustomerPresentationDate__c;
            if (hasTimings && (areTargetDatesChanged || hasProjectPhaseChanged || hasDecisionStepStatusChanged)) {
                TimingsTableController.checkProjectTimings(newProject);
            }

            OnHoldCounterService.setOnHoldRelatedFields(oldProject, newProject);
            if (newProject.AddAdditionalRegionOrRegions__c != null && newProject.AddAdditionalRegionOrRegions__c != '' && !newProject.ProjectClassification__c.equals('Continuous Improvement') && !newProject.ProjectClassification__c.equals('Mandatory') && !newProject.ProjectClassification__c.equals('Promotional Pack')) {
                List<String> additionalRegions = newProject.AddAdditionalRegionOrRegions__c.split(';');
                List<String> additionalRegionsWithoutLeadRegion = additionalRegions.clone();
                Integer indexToRemove = additionalRegionsWithoutLeadRegion.indexOf(newProject.Region__c);
                if (indexToRemove >= 0) {
                    additionalRegionsWithoutLeadRegion.remove(indexToRemove);
                }
                List<String> hubNames = new List<String>();
                List<AggregateResult> hubs = LookupGeoHierarchyRepository.getGroupedGeoHierarchiesByRegions(additionalRegionsWithoutLeadRegion);
                Boolean hasMultiRegionHubs = false;
                Boolean hasDifferentClusters = false;
                if (newProject.AddAdditionalHubOrHubs__c != null) {
                    List<String> additionalHubs = newProject.AddAdditionalHubOrHubs__c.split(';');
                    for (AggregateResult hubResult : hubs) {
                        if (additionalHubs.contains((String) hubResult.get('HUB__c'))) {
                            hasMultiRegionHubs = true;
                        }
                    }
                    if (newProject.AddAdditionalClusterOrClusters__c != null) {
                        List<String> clusters = newProject.AddAdditionalClusterOrClusters__c.split(';');
                        if (clusters.size() == 1) {
                            hasDifferentClusters = newProject.Cluster__c != clusters[0];
                        } else if (clusters.size() > 1) {
                            hasDifferentClusters = true;
                        }
                    }
                    newProject.IsMultiRegion__c = newProject.AddAdditionalRegionOrRegions__c != null && ((additionalRegionsWithoutLeadRegion.size() > 0 && hasMultiRegionHubs) || hasDifferentClusters);
                }
            } else if (newProject.AddAdditionalRegionOrRegions__c == null || newProject.AddAdditionalRegionOrRegions__c == '') {
                newProject.IsMultiRegion__c = false;
            }
            Boolean hasLeadMarketChange = newProject.LeadMarket__c != oldProject.LeadMarket__c;
            Boolean hasAdditionalMarketChange = newProject.AddAdditionalMarketOrMarkets__c != oldProject.AddAdditionalMarketOrMarkets__c;
            Boolean hasBrandChange = newProject.Brand__c != oldProject.Brand__c;
            Boolean hasCategoryChange = newProject.Category__c != oldProject.Category__c;
            if ((hasBrandChange || hasLeadMarketChange || hasCategoryChange || hasAdditionalMarketChange) && newProject.Category__c != null && newProject.LeadMarket__c != null && newProject.Brand__c != null) {
                BMCMatrixService.setBMC(newProject);
            }
            if (newProject.AvoidSnapshotCreation__c) {
                newProject.AvoidSnapshotCreation__c = false;
            }

            Boolean haveRegionsChanged = newProject.Region__c != oldProject.Region__c ||
                newProject.AddAdditionalRegionOrRegions__c != oldProject.AddAdditionalRegionOrRegions__c;

            Boolean isOtherGeoExtensionSubtype = newProject.ProjectClassification__c == InnovatorConstants.GEO_EXTENSION && newProject.GeoExtensionProjectSubClassification__c == InnovatorConstants.GEO_EXTENSION_OTHER;

            if (haveRegionsChanged && InnovatorConstants.REGIONAL_NSV_APPLICABLE_CLASSIFICATIONS.contains(newProject.ProjectClassification__c) && !isOtherGeoExtensionSubtype) {
                projectsWithUpdatedRegions.add(newProject);
            }
        }
        ProjectService.setProjectLeaderAndManager(false, newProjects, oldProjectsMap);
        if (!projectsWithUpdatedRegions.isEmpty()) {
            NSVByRegionController.updateNSVByRegionFinancials(projectsWithUpdatedRegions, oldProjectsMap);
        }
    }

    public static void handleIsAfterUpdate(List<Project__c> newProjects, Map<Id, Project__c> oldProjectsMap) {
        //TODO: remove the query in the loop
        List<CustomTeams__Teams__c> customTeams = new List<CustomTeams__Teams__c>();
        for (Project__c newProject : newProjects) {
            Project__c oldProject = oldProjectsMap.get(newProject.Id);
            Boolean hasProjectLeaderChanged =
                newProject.ProjectLeader__c != oldProject.ProjectLeader__c;
            if (hasProjectLeaderChanged && oldProject.ProjectLeader__c != null) {
                TeamMemberService.deleteTeamMember(
                    newProject.Id,
                    oldProject.ProjectLeader__c
                );
            }
            if (hasProjectLeaderChanged && newProject.ProjectLeader__c != null) {
                TeamMemberService.addNewTeamMembersEditAccess(
                    newProject.Id,
                    new List<Id>{
                        newProject.ProjectLeader__c
                    },
                    TeamMemberService.TEAM_MEMBER_ROLE_PL
                );
            }
            Boolean hasProjectManagerChanged =
                newProject.ProjectManager__c != oldProject.ProjectManager__c;
            if (hasProjectManagerChanged && oldProject.ProjectManager__c != null) {
                TeamMemberService.deleteTeamMember(
                    newProject.Id,
                    oldProject.ProjectManager__c
                );
            }
            if (hasProjectManagerChanged && newProject.ProjectManager__c != null) {
                TeamMemberService.addNewTeamMembersEditAccess(
                    newProject.Id,
                    new List<Id>{
                        newProject.ProjectManager__c
                    },
                    TeamMemberService.TEAM_MEMBER_ROLE_PM
                );
            }
            Boolean hasProjectPhaseChange =
                newProject.ProjectPhase__c != oldProject.ProjectPhase__c;
            if (
                hasProjectPhaseChange &&
                    newProject.ProjectPhase__c != InnovatorConstants.DIAGNOSE_PHASE &&
                    newProject.ProjectPhase__c != InnovatorConstants.DEFINE_PHASE
            ) {
                FinancialDataService.updateFinancialTolerances(newProject.Id);
            }
            Boolean hasBrandChange = newProject.Brand__c != oldProject.Brand__c;
            if (hasBrandChange && newProject.Brand__c != null) {
                ProjectService.setBrandIcon(newProject.Id);
            }
            Boolean isGeoExtensionSubclassificationChanged =
                oldProject.GeoExtensionProjectSubClassification__c != null &&
                    (oldProject.GeoExtensionProjectSubClassification__c !=
                        newProject.GeoExtensionProjectSubClassification__c);
            if (
                oldProject.ProjectClassification__c !=
                    newProject.ProjectClassification__c ||
                    isGeoExtensionSubclassificationChanged
            ) {
                String oldProjectClassification = ProjectUtility.projectClassificationToCombinedName(
                    oldProject.ProjectClassification__c,
                    oldProject.GeoExtensionProjectSubClassification__c
                );
                String newProjectClassification = ProjectUtility.projectClassificationToCombinedName(
                    newProject.ProjectClassification__c,
                    newProject.GeoExtensionProjectSubClassification__c
                );
                ProjectUtility.recalculateProjectFinancialsOnClassificationChange(
                    newProject,
                    newProjectClassification,
                    oldProjectClassification
                );
            }
            Boolean isProjectClassifcationNotChanged =
                oldProject.ProjectClassification__c ==
                    newProject.ProjectClassification__c;
            Boolean isProjectPhaseChanged =
                oldProject.ProjectPhase__c != newProject.ProjectPhase__c;
            Boolean isTriggeredViaAdminConsole = newProject.AvoidSnapshotCreation__c;
            if (
                isProjectClassifcationNotChanged &&
                    isProjectPhaseChanged &&
                    isTriggeredViaAdminConsole
            ) {
                ProjectUtility.recalculateProjectFinancialsOnProjectPhaseChange(
                    newProject,
                    newProject.ProjectPhase__c,
                    oldProject.ProjectPhase__c
                );
            }
            Boolean hasIsPrivateChanged = oldProject.IsPrivate__c != newProject.IsPrivate__c;
            if (hasIsPrivateChanged) {
                CustomTeams__Teams__c team = new CustomTeams__Teams__c(
                    Id = newProject.Team__c,
                    IsPrivate__c = newProject.IsPrivate__c
                );
                customTeams.add(team);
            }
        }

        if (!customTeams.isEmpty()) {
            update customTeams;
        }
    }

    private static void setProjectPhase(Project__c newProject) {
        Boolean projectClassifications =
            newProject.ProjectClassification__c ==
                InnovatorConstants.BUSINESS_ENABLER ||
                newProject.ProjectClassification__c == InnovatorConstants.GEO_EXTENSION;
        if (
            projectClassifications &&
                String.isBlank(newProject.ProjectPhase__c) &&
                String.isBlank(newProject.DecisionStep__c)
        ) {
            newProject.ProjectPhase__c = InnovatorConstants.DEFINE_PHASE;
            newProject.DecisionStep__c = 'Business Case Ambition';
        }
    }
}