public without sharing class AutomaticApprovalAction {
  public class Result {
    @InvocableVariable(label='Has Error?')
    public Boolean hasError;
    @InvocableVariable(label='Error Message')
    public String errorMessage;
  }

  @InvocableMethod(label='Automatic Approval')
  public static List<Result> approveByProcessInstances(
    List<Id> processInstances
  ) {
    List<Result> results = new List<Result>();
    for (Id processInstanceId : processInstances) {
      Result result = new Result();
      List<User> users = new List<User>();
      List<ProcessInstanceWorkitem> projectInstanceWorkitems = [
        SELECT Id, ActorId, Actor.Name, ProcessInstance.TargetObjectId
        FROM ProcessInstanceWorkitem
        WHERE ProcessInstanceId = :processInstanceId
      ];
      Project__c project = [SELECT Id, ProjectClassification__c, ProjectPhase__c FROM Project__c WHERE Id =: projectInstanceWorkitems[0].ProcessInstance.TargetObjectId];
      for (ProcessInstanceWorkitem processInstanceWorkitem : projectInstanceWorkitems) {
        Approval.ProcessWorkitemRequest processWorkItemRequest = new Approval.ProcessWorkitemRequest();
        String nextPhase = ApprovalMatrixService.getNextPhaseName(project);
        processWorkItemRequest.setComments(
          'Project progressed to ' +
            nextPhase +
            ' phase. \n Notification sent to: ' +
            processInstanceWorkitem.Actor.Name
        );
        processWorkItemRequest.setAction('Approve');
        processWorkItemRequest.setWorkitemId(processInstanceWorkitem.Id);
        Approval.ProcessResult res = Approval.process(processWorkItemRequest);
      }
      result.hasError = false;
      result.errorMessage = '';
      results.add(result);
    }
    return results;
  }
}