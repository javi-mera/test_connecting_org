public with sharing class ApprovalMatrixRepository {
  public static List<ApprovalMatrix__c> loadMatrixByType(
    String classification,
    String categories,
    String brands,
    String subBrands,
    String hub,
    String cluster,
    String market,
    String distributionChannel,
    String tradeType,
    String recordtype,
    String approvalStep
  ) {
    return [
      SELECT
        Id,
        Name,
        Approver__c,
        Approver__r.Name,
        Approver__r.IsActive,
        Approver__r.DelegatedApproverId,
        Approver__r.Start__c,
        Approver__r.End__c,
        ApproverRole__c,
        ApprovalType__c,
        RecordTypeId,
        DecisionStep__c,
        ApprovalStep__c,
        RuleKey__c,
        TradeType__c,
        toLabel(LeadMarket__c),
        NewLiquid__c,
        NewOrChangePrimaryPack__c,
        DistributionChannel__c,
        New_Change_Secondary_pack__c,
        Hub__c,
        Cluster__c,
        ProjectClassification__c,
        ProjectClassificationSubtype__c,
        Category__c,
        ExceptBrand__c,
        Brand__c,
        SubBrand__c,
        TradeTypeExactMatch__c
      FROM ApprovalMatrix__c
      WHERE
        RecordTypeId = :recordtype
        AND (ApprovalStep__c = :approvalStep
        OR ApprovalStep__c = NULL)
        AND (ProjectClassification__c INCLUDES (:classification)
        OR Category__c INCLUDES (:categories)
        OR Brand__c INCLUDES (:brands)
        OR SubBrand__c INCLUDES (:subBrands)
        OR Hub__c INCLUDES (:hub)
        OR Cluster__c INCLUDES (:cluster)
        OR LeadMarket__c INCLUDES (:market)
        OR DistributionChannel__c INCLUDES (:distributionChannel)
        OR TradeType__c INCLUDES (:tradeType)
        OR ProjectClassification__c = NULL
        OR Category__c = NULL
        OR Brand__c = NULL
        OR SubBrand__c = NULL
        OR Hub__c = NULL
        OR Cluster__c = NULL
        OR LeadMarket__c = NULL
        OR DistributionChannel__c = NULL
        OR TradeType__c = NULL)
    ];
  }

  public static List<ApprovalMatrix__c> loadMatrixByType(
    String classification,
    String categories,
    String brands,
    String subBrands,
    String hub,
    String cluster,
    String distributionChannel,
    String recordtype
  ) {
    return [
      SELECT
        Id,
        Name,
        OC__c,
        Approver__r.Name,
        Approver__r.DelegatedApproverId,
        Approver__r.Start__c,
        Approver__r.End__c,
        ApproverRole__c,
        ApprovalType__c,
        ApprovalStep__c,
        RuleKey__c,
        ProjectClassification__c,
        RecordTypeId,
        DistributionChannel__c,
        Hub__c,
        Cluster__c,
        Category__c,
        ExceptBrand__c,
        Brand__c,
        SubBrand__c,
        TradeTypeExactMatch__c
      FROM ApprovalMatrix__c
      WHERE
        RecordTypeId = :recordtype
        AND (ProjectClassification__c INCLUDES (:classification)
        OR Category__c INCLUDES (:categories)
        OR Brand__c INCLUDES (:brands)
        OR SubBrand__c INCLUDES (:subBrands)
        OR Hub__c INCLUDES (:hub)
        OR Cluster__c INCLUDES (:cluster)
        OR DistributionChannel__c INCLUDES (:distributionChannel)
        OR ProjectClassification__c = NULL
        OR Category__c = NULL
        OR Brand__c = NULL
        OR SubBrand__c = NULL
        OR Hub__c = NULL
        OR Cluster__c = NULL
        OR DistributionChannel__c = NULL)
    ];
  }

  public static List<ApprovalMatrix__c> loadBMCMatrixByRecordType(
    String recordType
  ) {
    return [
      SELECT Id, Name, toLabel(LeadMarket__c), RuleKey__c, Brand__c, Region__c, Category__c, BMCClassification__c, MarketClassification__c
      FROM ApprovalMatrix__c
      WHERE RecordTypeId = :recordType
    ];
  }

  public static List<ProcessInstanceStep> getLastProcessInstanceSteps(
    Id projectId,
    Id processInstanceId
  ) {
    return [
      SELECT
        Id,
        ProcessInstanceId,
        OriginalActorId,
        OriginalActor.Name,
        ActorId,
        Actor.Name,
        Actor.Email,
        StepStatus,
        Comments
      FROM ProcessInstanceStep
      WHERE
        ProcessInstance.TargetObjectId = :projectId
        AND ProcessInstanceId = :processInstanceId
    ];
  }

  public static List<ProcessInstance> getRecentlyApprovedProcessInstanceId(
    Id projectId
  ) {
    return [
      SELECT Id, Status, CreatedDate
      FROM ProcessInstance
      WHERE TargetObjectId = :projectId
      ORDER BY CreatedDate DESC
      LIMIT 1
    ];
  }

  public static List<ProcessInstanceStep> getApprovalComments(
    Id projectId,
    Id processInstanceId
  ) {
    return [
      SELECT Id, Comments, StepStatus, Actor.Name
      FROM ProcessInstanceStep
      WHERE
        ProcessInstance.TargetObjectId = :projectId
        AND ProcessInstanceId = :processInstanceId
        AND StepStatus != :InnovatorConstants.STARTED_STATUS
    ];
  }

  public static List<ProcessInstanceStep> getProcessInstanceSteps(
    Id projectId,
    List<Id> processInstanceIds
  ) {
    return [
      SELECT Id, OriginalActorId, ActorId, StepStatus
      FROM ProcessInstanceStep
      WHERE
        ProcessInstance.TargetObjectId = :projectId
        AND ProcessInstanceId IN :processInstanceIds
        AND StepStatus = :InnovatorConstants.REASSIGNED_STATUS
      ORDER BY CreatedDate ASC
    ];
  }

  public static List<ProcessInstance> getProjectRelatedProcessInstances(
    Id projectId
  ) {
    return [
      SELECT Id, Status, CreatedDate
      FROM ProcessInstance
      WHERE TargetObjectId = :projectId
      ORDER BY CreatedDate DESC
    ];
  }

  public static List<ProcessInstanceStep> getProcessInstanceStepsFromProcessInstance(Id processInstanceId) {
    return [SELECT Id, OriginalActorId, OriginalActor.Name, Comments FROM ProcessInstanceStep WHERE ProcessInstanceId =: processInstanceId];
  }

  public static List<ProcessInstanceWorkItem> getProcessInstanceWorkItemsFromProcessInstance(Id processInstanceId) {
    return [SELECT Id, OriginalActorId, OriginalActor.Name FROM ProcessInstanceWorkItem WHERE ProcessInstanceId =: processInstanceId];
  }
}