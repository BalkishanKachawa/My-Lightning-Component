/**************

        Class Name     :    DropboxKeyWrapper
        Author         :    Sushil Kumar
        Email          :    sushil.verma1988@gmail.com
        Date           :    15/11/2015
        Description    :    This class is used as a Wrapper class of DropBoxCmpController.

**************/

global with sharing class DropboxKeyWrapper{
    @AuraEnabled
    public Boolean isAuthorized;
     
    @AuraEnabled
    public String redirectURI;
    
    @AuraEnabled
    public String appKey;
     
    @AuraEnabled
    public String appSecret;
}