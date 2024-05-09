public class InvocableUpdateProjectStatus {

    public class InputVariables {
        @InvocableVariable(Label='Project Id' Required=true)
        public String projectId;

        @InvocableVariable(Label='Project Status' Required=true)
        public String projectStatus;

        @InvocableVariable(Label='Rejection Reason')
        public String rejectionReason;

        @InvocableVariable(Label='Reason for the Status Change' Required=true)
        public String reasonForStatusChange;

        @InvocableVariable(Label='User Profile Name' Required=true)
        public String userProfileName;

        @InvocableVariable(Label='User Name' Required=true)
        public String userName;
    }

    @InvocableMethod(Label='Update Project Status' Description='Updates the Project Status if Project is in the Approval Process')
    public static List<String> updateProjectStatus(List<InputVariables> inputVariables) {
        List<String> results = new List<String>();
        String projectId = inputVariables[0].projectId;
        String projectStatus = inputVariables[0].projectStatus;
        String rejectionReason = inputVariables[0].rejectionReason;
        String reasonForStatusChange = inputVariables[0].reasonForStatusChange;
        String userProfileName = inputVariables[0].userProfileName;
        String userName = inputVariables[0].userName;

        String result = updateProjectStatusREST(projectId, projectStatus, rejectionReason, reasonForStatusChange, userProfileName, userName);
        results.add(result);

        return results;
    }

    public static String updateProjectStatusREST(Id projectId, String projectStatus, String rejectionReason, String reasonForStatusChange,
        String userProfileName, String userName) {
        String result;
        RestService.init();
        UpdateProjectRequestBody reqBody = new UpdateProjectRequestBody();
        reqBody.projectId = projectId;
        reqBody.projectStatus = projectStatus;
        reqBody.reasonForStatusChange = reasonForStatusChange;
        reqBody.userProfileName = userProfileName;
        reqBody.userName = userName;
        if (projectStatus == 'Cancelled') {
            reqBody.rejectionReason = rejectionReason;
        }
        String body = JSON.serialize(reqBody);
        HttpResponse response = RestService.post(body, RestService.getUpdateProjectEndpoint());
        if (response != null) {
            result = String.valueOf(response.getStatusCode());
        }
        return result;
    }

    public class UpdateProjectRequestBody {
        public String projectId;
        public String projectStatus;
        public String rejectionReason;
        public String reasonForStatusChange;
        public String userProfileName;
        public String userName;
    }
}