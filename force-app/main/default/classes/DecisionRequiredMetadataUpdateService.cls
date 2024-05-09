public with sharing class DecisionRequiredMetadataUpdateService implements Metadata.DeployCallback{
    private static final String METADATA_NAME = 'Decision_Required';
    private static final String TASK_LIST_FIELD = 'TaskList__c';
    private static final String DECISION_REQUIRED_FIELD = 'DecisionRequired__c';
    public static final String SUCCESS_MSG = 'Success';
    public static final String NOT_FOUND_MSG = 'Not Found';
    public class MetadataRequestBody{
        public String label;
        public String taskListToUpdate;
        public String decisionRequiredToUpdate;
    }
    @AuraEnabled
    public static String updateCustomMetadata(String label, String taskListToUpdate, String decisionRequiredToUpdate){
        RestService.init();
        MetadataRequestBody reqBody = new MetadataRequestBody();
        reqBody.label = label;
        reqBody.taskListToUpdate = taskListToUpdate;
        reqBody.decisionRequiredToUpdate = decisionRequiredToUpdate;
        String body = JSON.serialize(reqBody);
        HttpResponse response = RestService.put(body, RestService.getUpdateMetadataEndpoint());
        if(response!=null){
            String trimmedResponse = response.getBody().unescapeCsv().remove('\\');
            return trimmedResponse;
        }
        return null;
    }
    public static String updateMetadata(String label, String taskListToUpdate, String decisionRequiredToUpdate){
        try {
            List<Decision_Required__mdt> decisionRequiredList = Decision_Required__mdt.getAll().values();
            Decision_Required__mdt drToUpdate;
            for(Decision_Required__mdt dr : decisionRequiredList){
                if(dr.label == label){
                    drToUpdate = dr;
                }
            }
            if(drToUpdate!=null){
                Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
                customMetadata.fullName = METADATA_NAME+'.'+drToUpdate.DeveloperName; //custom metadata name
                customMetadata.label = drToUpdate.label;
                Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue(); //the values you're changing/updating
                customField1.field = TASK_LIST_FIELD; //the custom field API Name that you're wanting to insert/update a value of
                customField1.value = taskListToUpdate;
                customMetadata.values.add(customField1);//add the changes to list of changes to be deployed

                Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue(); //the values you're changing/updating
                customField2.field = DECISION_REQUIRED_FIELD; //the custom field API Name that you're wanting to insert/update a value of
                customField2.value = decisionRequiredToUpdate;
                customMetadata.values.add(customField2);//add the changes to list of changes to be deployed
                        
                Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
                mdContainer.addMetadata(customMetadata);
                
                DecisionRequiredMetadataUpdateService callback = new DecisionRequiredMetadataUpdateService();

                //Metadata cannot be deployed within a test
                if(!Test.isRunningTest()){
                    Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
                }
                
                return SUCCESS_MSG;
            }

            return NOT_FOUND_MSG;
            
        } catch (Exception e) {
            return e.getMessage();
        }
    }
    // find all sObjects available in the organization
    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
        if(result.status == Metadata.DeployStatus.SUCCEEDED){
            //success
            System.debug(' ===>'+ result);
        }else{
            //not success
            System.debug(' ===> fail '+ result);
        }
        
    }
    @AuraEnabled
    public static List<Decision_Required__mdt> getAllMetadata(){
        return DecisionRequiredMetadataUpdateRepository.getAllMetadata();
    }
}