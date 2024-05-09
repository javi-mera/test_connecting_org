public with sharing class RestService {
    public static final String REST_PRE_ENDPOINT = '/services/apexrest/';
    public static final String UPDATE_APPROVAL_HISTORY_ENDPOINT = 'approvals/updateApprovalHistory';
    public static final String REASSIGN_COMMENT_ENDPOINT = 'reassign/updateResassignComment';
    public static final String RECALL_ENDPOINT = 'approvals/recall';
    public static final String UPDATE_METADATA_ENDPOINT = 'metadata/updateMetadata';
    public static final String UPDATE_PROJECT_ENDPOINT = 'projectUpdates/updateProjectStatus';
    public static final String AUTH_ENDPOINT = '/services/oauth2/token';
    public static String orgURL;
    private static String clientId;
    private static String clientSecret;
    private static String authEndpoint;
    private static String username;
    private static String password;

    
    public static String getRecallEndpoint(){
        return orgURL+REST_PRE_ENDPOINT+RECALL_ENDPOINT;
    }
    public static String getReassignCommentEndpoint(){
        return orgURL+REST_PRE_ENDPOINT+REASSIGN_COMMENT_ENDPOINT;
    }
    public static String getUpdateApprovalHistoryEndpoint(){
        return orgURL+REST_PRE_ENDPOINT+UPDATE_APPROVAL_HISTORY_ENDPOINT;
    }
    public static String getUpdateMetadataEndpoint(){
        return orgURL+REST_PRE_ENDPOINT+UPDATE_METADATA_ENDPOINT;
    }
  public static String getUpdateProjectEndpoint(){
    return orgURL+REST_PRE_ENDPOINT+UPDATE_PROJECT_ENDPOINT;
  }
    //TODO: replace custom metdata ReworkConfiguration__mdt for Named Credentials in order to follow best practices to store passwords.
    public static void init() {
        orgURL = URL.getSalesforceBaseUrl().toExternalForm();
        Boolean isDevOrg = orgUrl.contains('dev');
        Boolean isQAenvOrg = orgUrl.contains('qaenv');
        Boolean isUATOrg = orgUrl.contains('uat');
        Boolean isProdOrg = orgUrl.contains('bacardiinnovator');
        ReworkConfiguration__mdt reworkConfiguration;
        if(isDevOrg) {
            reworkConfiguration = ReworkConfiguration__mdt.getInstance('Dev');
        } else if (isQAenvOrg) {
            reworkConfiguration = ReworkConfiguration__mdt.getInstance('QA');
        } else if (isUATOrg) {
            reworkConfiguration = ReworkConfiguration__mdt.getInstance('UAT');
        } else if (isProdOrg) {
            reworkConfiguration = ReworkConfiguration__mdt.getInstance('Prod');
        }
        clientId = reworkConfiguration.clientId__c;
        clientSecret = reworkConfiguration.clientSecret__c;
        authEndpoint = orgURL+AUTH_ENDPOINT;
        username = reworkConfiguration.username__c;
        password = reworkConfiguration.password__c;
    }
    public static String getAccessToken(){
        String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret
                        +'&username='+username+'&password='+password;
        Http httpCaller = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqbody);
        req.setMethod('POST'); 
        req.setEndpoint(authEndpoint);
        HttpResponse res=httpCaller.send(req);
        AuthResponse resp1= (AuthResponse)JSON.deserialize(res.getBody(),AuthResponse.class);
        return resp1.access_token;
    }
    public static HttpResponse post(String body, String endpoint){
        String accessToken = getAccessToken();
        if(accessToken != null) {
            Http h2 = new Http();
            HttpRequest req1 = new HttpRequest();
            req1.setBody(body);
            req1.setHeader('Authorization', 'Bearer ' + accessToken);
            req1.setHeader('Content-Type','application/json');
            req1.setHeader('accept','application/json');
            req1.setMethod('POST');
            req1.setTimeout(120000);
            req1.setEndpoint(endpoint);
            return h2.send(req1);
        }
        return null;
    }
    public static HttpResponse put(String body, String endpoint){
        String accessToken = getAccessToken();
        if(accessToken != null) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setBody(body);
            request.setHeader('Authorization','Bearer ' + accessToken);
            request.setHeader('Content-Type','application/json');
            request.setHeader('accept','application/json');
            request.setMethod('PUT');
            request.setEndpoint(endpoint);
            return http.send(request);
        }
        return null;
    }
    public class AuthResponse{
        public String id;
        public String access_token;
    }
}