/**************

        Class Name     :    DropBoxCmpController_Test
        Author         :    Sushil Kumar
        Date           :    30/11/2015
        Description    :    This class is test for DropBoxCmpController.

**************/

@isTest
public class DropBoxCmpController_Test{
   
    public static testMethod void unitTest(){
        Dropbox_Authentication__c  da = new Dropbox_Authentication__c (Token__c = 'xxxxxx', UserId__c='xxxxxxx');
        insert da;
        Dropbox_key__c dKey = new Dropbox_key__c (isAuthorized__c = false, Redirect_URI__c = 'xxxxxx', App_Key__c = 'xxxxxx', App_Secret__c = 'xxxxxx');
        insert dKey; 
        DropBoxCmpController dbc = new DropBoxCmpController();
        DropBoxCmpController.checkAuthentication();
        String rtn = DropBoxCmpController.uploadChunk('xxxxxxxxxx', 'xxxxxxxx','xxxxxxxxxx', 0, false);
        system.assertNotEquals(rtn, ''); 
        rtn = DropBoxCmpController.uploadChunk('xxxxxxxxxx', 'xxxxxxxx','xxxxxxxxxx', 0, true);  
        system.assertEquals(rtn, ''); 
        DropBoxCmpController.commitUploadChunk('xxxxxxxxxx', 'xxxxxxxx');
        String path = 'xxxx';
        DropBoxCmpController.createNewFolder(path);
        DropBoxCmpController.deleteMedia(path);
        DropBoxCmpController.viewMedia(path);
        list<MetadataContents> mc = DropBoxCmpController.getMetadata(path);
        
        DropboxKeyWrapper dw = new DropboxKeyWrapper();
       
        dw.isAuthorized = true;
        dw.appSecret = 'xx';
        dw.appKey = 'xx';
        dw.redirectURI = 'xx';
        MetadataContents mdtc = new MetadataContents(true, 1, 1, false, '', '','', '', true,'', '');
    }
}