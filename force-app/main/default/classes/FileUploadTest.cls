@isTest
public with sharing class FileUploadTest {
    @isTest
    static void testDeleteFile(){       
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;   
        ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 1]; 
        Test.startTest();
        FileUploadController.deleteFile(document.Id);
        Test.stopTest();
        List<ContentDocument> existingDocuments = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        system.assertEquals(true, existingDocuments.size() == 0, 'Checking the file is deleted properly');
    }
    @isTest
    static void testDeleteFileException(){ 
        Boolean firedException = false;
        Test.startTest();
        try{
            FileUploadController.deleteFile('test');
        }catch(Exception ex){
            firedException = true;
        }
        Test.stopTest();
        system.assertEquals(true, firedException, 'Checking the exception fired properly');
    }
}