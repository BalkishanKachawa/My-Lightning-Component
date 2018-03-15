/**************

        Class Name     :    DropBoxOAuthController_Test
        Author         :    Sushil Kumar
        Email          :    sushil.verma1988@gmail.com
        Date           :    30/11/2015
        Description    :    This class is test for DropBoxOAuthController.

**************/

@isTest
public class DropBoxOAuthController_Test{
   
    public static testMethod void unitTest(){
        ApexPages.currentPage().getParameters().put('code', 'xxxxxx');
        Dropbox_key__c dKey = new Dropbox_key__c (isAuthorized__c = false, Redirect_URI__c = 'xxxxxx', App_Key__c = 'xxxxxx', App_Secret__c = 'xxxxxx');
        insert dKey;
        DropBoxOAuthController db = new DropBoxOAuthController();
        system.assertNotEquals(db.userOverride, true);
        db.checkAuthorized();
        Dropbox_Authentication__c  da = new Dropbox_Authentication__c (Token__c = 'xxxxxx', UserId__c='xxxxxxx');
        insert da;
               
        DropBoxOAuthController db1 = new DropBoxOAuthController();
        system.assertEquals(db1.userOverride, false);
        db1.checkAuthorized();
        db1.GoBack();
        
    }
}