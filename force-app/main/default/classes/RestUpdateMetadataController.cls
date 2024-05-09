@RestResource(urlMapping='/metadata/*')
global with sharing class RestUpdateMetadataController {
    @HttpPut
    global static void updateMetadata(String label, String taskListToUpdate, String decisionRequiredToUpdate) {
        DecisionRequiredMetadataUpdateService.updateMetadata(label, taskListToUpdate, decisionRequiredToUpdate);
    }
}