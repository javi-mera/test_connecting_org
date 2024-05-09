public with sharing class ApprovalHistoryRestService {

    public class ApprovalHistoryRequestBody{
        public String projectId;
        public String approvalHistoryData;
    }

    @future(callout=true)
    public static void updateProjectWithStepNameData (Id projectId, String stepNameData) {
        updateApprovalHistoryREST(projectId,stepNameData);
    }

    public static void updateApprovalHistoryREST(Id projectId, String approvalHistoryData){
        RestService.init();
        ApprovalHistoryRequestBody reqBody = new ApprovalHistoryRequestBody();
        reqBody.projectId = projectId;
        reqBody.approvalHistoryData = approvalHistoryData;
        String body = JSON.serialize(reqBody);
        if(!Test.isRunningTest()){
            HttpResponse response = RestService.put(body, RestService.getUpdateApprovalHistoryEndpoint());
            if(response!=null){
                String trimmedResponse = response.getBody().unescapeCsv().remove('\\');
            }
        }
    }

    @future(callout=true)
    public static void updateProjectWithReassignCommentData(Id projectId, String data) {
        updateReassignCommentREST(projectId,data);
    }

    public static void updateReassignCommentREST(Id projectId, String reassignCommentJson){
        RestService.init();
        ApprovalHistoryRequestBody reqBody = new ApprovalHistoryRequestBody();
        reqBody.projectId = projectId;
        reqBody.approvalHistoryData = reassignCommentJson;
        String body = JSON.serialize(reqBody);
        if(!Test.isRunningTest()){
            HttpResponse response = RestService.put(body, RestService.getReassignCommentEndpoint());
            if(response!=null){
                String trimmedResponse = response.getBody().unescapeCsv().remove('\\');
            }
        }
    }
}