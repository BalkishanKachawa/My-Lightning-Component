/**************

        Class Name     :    DropBoxOAuthController
        Author         :    Balkishan Kachawa
        Email          :    balkishan.kachawagmail.com
        Date           :    
        Description    :    This class is used for authenticate user with dropbox.

**************/
global with sharing class DropBoxOAuthController{
    public Boolean userOverride{get;set;}
    public Boolean isError{get;set;}
    Dropbox_Authentication__c AuthenticationCS;
    
    //constructor
    public DropBoxOAuthController(){
        Dropbox_Setting__c dropboxCS = Dropbox_Setting__c.getInstance([SELECT Id FROM Profile WHERE Name='System administrator'].Id);
        
        userOverride = dropboxCS.User_Override__c;     
        isError = true; 
        
    }
    
    public void checkAuthorized(){
        // Get Authorization Custom Setting 
        if(userOverride)
            AuthenticationCS = Dropbox_Authentication__c.getInstance( UserInfo.getUserId() );
        else
            AuthenticationCS = Dropbox_Authentication__c.getInstance( [SELECT Id FROM Profile WHERE Name='System administrator'].Id );
        
        System.debug('Custom Setting: '+AuthenticationCS);
        
        if(AuthenticationCS.Token__c != null && AuthenticationCS.UserId__c != null){ 
            HttpResponse res = DropBoxCallOuts.getUserAccountInfo(AuthenticationCS.Token__c, AuthenticationCS.UserId__c);
            System.debug('User Info: '+res.getBody());
            if(res.getStatusCode() != 200)
                createAuthentication(); 
        }else{
            createAuthentication();
        }
    }
    
    private void createAuthentication(){
        String code = ApexPages.currentPage().getParameters().get('code');
        if(code != null && code.trim().length() > 0){
            HttpResponse res = DropBoxCallOuts.requestOAuthAccessToken(code);
            
            if(res.getStatusCode() == 200){
                JSONParser parser = JSON.createParser(res.getBody());                    
                Dropbox_Authentication__c newAuthenticationCS;
                
                if(userOverride)
                    newAuthenticationCS = Dropbox_Authentication__c.getInstance( UserInfo.getUserId() );
                else
                    newAuthenticationCS = Dropbox_Authentication__c.getInstance( [SELECT Id FROM Profile WHERE Name='System administrator'].Id );
    
                newAuthenticationCS.token__c = DropBoxCallOuts.getTokenValue(parser, 'access_token');
                newAuthenticationCS.Userid__c = DropBoxCallOuts.getTokenValue(parser, 'uid');                    
                res = DropBoxCallOuts.getUserAccountInfo(newAuthenticationCS.Token__c, newAuthenticationCS.UserId__c);
                
                if(res.getStatusCode() == 200){
                    if(Schema.sObjectType.Dropbox_Authentication__c.fields.token__c.isUpdateable() && Schema.sObjectType.Dropbox_Authentication__c.fields.Userid__c.isUpdateable() &&
                       Schema.sObjectType.Dropbox_Authentication__c.fields.token__c.isCreateable() && Schema.sObjectType.Dropbox_Authentication__c.fields.Userid__c.isCreateable())
                    
                        upsert newAuthenticationCS;
                } 
                isError = false;  
            }else{
                isError = true;
            } 
        }
    }
    public PageReference GoBack(){
        String recordId = ApexPages.currentPage().getParameters().get('state');
        return new PageReference('/' + recordId ).setRedirect(true);
    }
    
}