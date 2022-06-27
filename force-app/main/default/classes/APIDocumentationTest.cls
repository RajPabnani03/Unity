@IsTest
public class APIDocumentationTest
{

    public static testMethod void testMethod1()
    {

        Test.starttest();
        API_Request__c ApiReq = new API_Request__c();
        //ApiReq.Account__c=acc.Id;
        ApiReq.Software_System__c='ARIA';
        ApiReq.API_Type__c='ARIA Access';
        ApiReq.Approval_Status__c='Approved';
        ApiReq.Requestor_Email__c='testing@mail.com';
        insert ApiReq;

        Id fileId = APIDocumentation.saveChunk(ApiReq.id, 'Testing for Attachment','testing body','text/plain','');
        Id fileId2 = APIDocumentation.saveChunk(ApiReq.id, 'Testing for Attachment','testing body','text/plain',fileId);
        Test.stoptest();
    }
}