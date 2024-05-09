public with sharing class FileUploadController {
    @AuraEnabled
    public static void deleteFile(String docId){
        try{
            ContentDocument file = new ContentDocument(Id = docId);
            delete file;
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
}