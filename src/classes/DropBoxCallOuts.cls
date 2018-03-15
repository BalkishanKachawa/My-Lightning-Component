/**************

        Class Name     :    DropBoxCallOuts
        Author         :    Balkishan Kachawa
        Email          :    balkishan.kachawagmail.com
        Date           :    
        Description    :    This class is used for callout dropbox.

**************/
global with sharing class DropBoxCallOuts{
    private static final String DROPBOX_HOST = 'https://api.dropbox.com/2';
    private static final String UPLOAD_HOST = 'https://content.dropboxapi.com/2';
    private static final String OAUTH_HOST = 'https://www.dropbox.com/oauth2/authorize';
    
    //Request for Access Token
    public static HttpResponse requestOAuthAccessToken(String code){ 
        Dropbox_key__c DropboxKey = new Dropbox_key__c(); 
        if (Schema.sObjectType.Dropbox_key__c.fields.App_Key__c.isAccessible() && Schema.sObjectType.Dropbox_key__c.fields.App_Secret__c.isAccessible()){ 
            DropboxKey = [select App_Key__c, App_Secret__c, Redirect_URI__c from Dropbox_key__c limit 1];
            system.debug('@@@@DropboxKey =: ' + DropboxKey );   
        }  
        HttpRequest req = new HttpRequest();
        req.setEndpoint(DROPBOX_HOST.remove('/2')+'/oauth2/token');
        req.setBody('code=' + code + '&grant_type=authorization_code&client_id=' + DropboxKey.App_Key__c + '&client_secret=' + DropboxKey.App_Secret__c + '&redirect_uri=' + DropboxKey.Redirect_URI__c);
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse response;
        if(Test.isRunningTest()){
            response=new HttpResponse();
            response.setHeader('Content-type', 'application/json');
            response.setBody('{"access_token": "aSOGehEuKjwAAAAAAAABVKD6u8T-je1URwWN4Ioevxz1ReMpmY-m2Lioz8DJW-N3", "token_type": "bearer", "uid": "346639323"}');
            response.setStatusCode(200);
        }else{
            response=http.send(req);            
        }
        system.debug('@@@@response=:' +response.getBody());
        return response;
    }
    
    //Account Information
    public static HttpResponse getUserAccountInfo(String access_token, String user_id){
        HttpRequest req = new HttpRequest();
        //req.setEndPoint(DROPBOX_HOST+'/users/get_current_account?access_token='+access_token+'&oauth_consumer_key='+user_id);
        req.setEndPoint('https://api.dropboxapi.com/2/users/get_current_account');
        req.setHeader('Authorization', 'Bearer '+access_token);
        req.setMethod('POST');    
        Http http = new Http();
        HttpResponse response;
        if(Test.isRunningTest()){
            response=new HttpResponse();
            response.setHeader('Content-type', 'application/json');
            response.setHeader('Authorization', 'Bearer '+access_token);
            response.setBody('{"referral_link": "https://db.tt/ntKZLOhM", "display_name": "Jay Colios-Terry", "uid": 346639323, "locale": "en", "email_verified": true, "team": null, "quota_info": {"datastores": 0, "shared": 0, "quota": 1102732853248, "normal": 45443141}, "is_paired": false, "country": "ES", "name_details": {"familiar_name": "Jay", "surname": "Colios-Terry", "given_name": "Jay"}, "email": "jay@dpmcinternational.com"}');
            response.setStatusCode(200);
        }else{
            response=http.send(req);            
        }
        system.debug('@@@@response=:' +response.getBody());
        
        return response;
    }
    
    // Create new folder at given root and path in dropbox.
    public static HttpResponse createFolder(String access_token, String user_id, String root, String path){
        System.debug('====> '+root+' '+path+' '+access_token+' '+user_id);
        HttpRequest httpReq = new HttpRequest();
        
        String endPoint = DROPBOX_HOST+'/files/create_folder';
        httpReq.setHeader('Authorization', 'Bearer '+access_token);
        httpReq.setHeader('Content-type', 'application/json');
        httpReq.setTimeout(60000);
        httpReq.setEndpoint(endPoint);
        httpReq.setBody('{\"path\": \"/'+path+'\"}');
        httpReq.setMethod('POST');
        Http http = new Http();
        HttpResponse response;
        if(Test.isRunningTest()){
            response=new HttpResponse();
            response.setHeader('Content-type', 'application/json');
            response.setBody('{"referral_link": "https://db.tt/ntKZLOhM", "display_name": "Jay Colios-Terry", "uid": 346639323, "locale": "en", "email_verified": true, "team": null, "quota_info": {"datastores": 0, "shared": 0, "quota": 1102732853248, "normal": 45443141}, "is_paired": false, "country": "ES", "name_details": {"familiar_name": "Jay", "surname": "Colios-Terry", "given_name": "Jay"}, "email": "jay@dpmcinternational.com"}');
            response.setStatusCode(200);
        }else{
            response=http.send(httpReq);            
        }
        system.debug('@@@@response=:' +response.getBody());
        return response;
    }
    
    // Chunck Uploading
    public static HttpResponse uploadChunk(String access_token, String user_id, String upload_id, String offset, Blob chunk_body){        
        System.debug('====> '+chunk_body+' '+offset+' '+access_token+' '+user_id);
        HttpRequest httpReq = new HttpRequest();
        
        String endPoint = UPLOAD_HOST+'/files/upload_session/start';
        httpReq.setHeader('Authorization', 'Bearer '+access_token);
        httpReq.setHeader('Dropbox-API-Arg', '{\"close\": false}');
        httpReq.setHeader('Content-type', 'application/octet-stream');
        httpReq.setEndpoint(endPoint);
        //httpReq.setBody('{\"path\": \"/'+path+'\"}');
        httpReq.setBodyAsBlob(chunk_body);
        httpReq.setMethod('POST');
        Http http = new Http();
        HttpResponse response;
        if(Test.isRunningTest()){
            response=new HttpResponse();
            response.setHeader('Content-type', 'application/json');
            response.setBody('{"read_only": false, "hash": "a986d542a422b3bba28a08f5bbb98711", "revision": 590, "bytes": 0, "thumb_exists": false, "rev": "24e2b6b3273", "modified": "Thu, 30 Jul 2015 09:00:49 +0000", "size": "0 bytes", "path": "/Salesforce Documents/Opportunities/006m0000004UCaB", "is_dir": true, "modifier": null, "root": "dropbox", "contents": [{"size": "0 bytes", "read_only": false, "modifier": null, "is_deleted": true, "rev": "2552b6b3273", "thumb_exists": false, "bytes": 0, "modified": "Thu, 06 Aug 2015 16:44:30 +0000", "path": "/Salesforce Documents/Opportunities/006m0000004UCaB/test", "is_dir": true, "icon": "folder_gray", "root": "dropbox", "revision": 597}, {"rev": "24f2b6b3273", "thumb_exists": true, "path": "/Salesforce Documents/Opportunities/006m0000004UCaB/yrLogo.png", "is_dir": false, "client_mtime": "Thu, 30 Jul 2015 09:01:35 +0000", "icon": "page_white_picture", "read_only": false, "modifier": null, "bytes": 3418, "modified": "Thu, 30 Jul 2015 09:01:35 +0000", "size": "3.3 KB", "root": "dropbox", "mime_type": "image/png", "revision": 591}], "icon": "folder"}');
            response.setStatusCode(200);
        }else{
            response=http.send(httpReq);            
        }
        system.debug('@@@@response=:' +response.getBody());
        
        return response;
    }
    
    // append_v2 
    public static HttpResponse appendChunkData(String access_token, String user_id, String upload_id, String offset, Blob chunk_body, Boolean check){        
        System.debug('====> '+chunk_body+' chunk_body.size() '+chunk_body.size()+' '+offset+' '+access_token+' '+user_id);
        HttpRequest httpReq = new HttpRequest();
        
        String endPoint = UPLOAD_HOST+'/files/upload_session/append_v2';
        httpReq.setHeader('Authorization', 'Bearer '+access_token);
        httpReq.setHeader('Dropbox-API-Arg', '{\"cursor\": {\"session_id\": \"'+upload_id+'\",\"offset\": '+offset+'},\"close\": '+check+'}');
        httpReq.setHeader('Content-type', 'application/octet-stream');
        httpReq.setEndpoint(endPoint);
        //httpReq.setBody('{\"path\": \"/'+path+'\"}');
        httpReq.setBodyAsBlob(chunk_body);
        httpReq.setMethod('POST');
        Http http = new Http();
        HttpResponse response;
        if(Test.isRunningTest()){
            response=new HttpResponse();
            response.setHeader('Content-type', 'application/json');
            response.setBody('{"read_only": false, "hash": "a986d542a422b3bba28a08f5bbb98711", "revision": 590, "bytes": 0, "thumb_exists": false, "rev": "24e2b6b3273", "modified": "Thu, 30 Jul 2015 09:00:49 +0000", "size": "0 bytes", "path": "/Salesforce Documents/Opportunities/006m0000004UCaB", "is_dir": true, "modifier": null, "root": "dropbox", "contents": [{"size": "0 bytes", "read_only": false, "modifier": null, "is_deleted": true, "rev": "2552b6b3273", "thumb_exists": false, "bytes": 0, "modified": "Thu, 06 Aug 2015 16:44:30 +0000", "path": "/Salesforce Documents/Opportunities/006m0000004UCaB/test", "is_dir": true, "icon": "folder_gray", "root": "dropbox", "revision": 597}, {"rev": "24f2b6b3273", "thumb_exists": true, "path": "/Salesforce Documents/Opportunities/006m0000004UCaB/yrLogo.png", "is_dir": false, "client_mtime": "Thu, 30 Jul 2015 09:01:35 +0000", "icon": "page_white_picture", "read_only": false, "modifier": null, "bytes": 3418, "modified": "Thu, 30 Jul 2015 09:01:35 +0000", "size": "3.3 KB", "root": "dropbox", "mime_type": "image/png", "revision": 591}], "icon": "folder"}');
            response.setStatusCode(200);
        }else{
            response=http.send(httpReq);            
        }
        system.debug('@@@@response=:' +response.getBody());
        
        return response;
    }
    
      // Commit Chunk Uploading 
    public static HttpResponse commitUploadedChunk(String access_token, String user_id, String root, String path, String upload_id, Blob chunk_body, String offset){
        path = path.replaceAll('//','/');
        System.debug('====> '+chunk_body+' chunk_body.size() '+chunk_body.size()+' '+offset+' '+access_token+' '+user_id);
        HttpRequest httpReq = new HttpRequest();
        
        String endPoint = DROPBOX_HOST+'/files/upload_session/finish_batch';
        httpReq.setHeader('Authorization', 'Bearer '+access_token);
        //httpReq.setHeader('Dropbox-API-Arg', '{\"cursor\": {\"session_id\": \"'+upload_id+'\",\"offset\": '+offset+'},\"commit\": {\"path\": \"/'+path+'\",\"mode\": \"add\",\"autorename\": true,\"mute\": false}}');
        httpReq.setBody('{\"entries\": [{\"cursor\": {\"session_id\": \"'+upload_id+'\",\"offset\": '+offset+'},\"commit\": {\"path\": \"/'+path+'\",\"mode\": \"add\",\"autorename\": true,\"mute\": false}}]}');
        //httpReq.setHeader('Content-type', 'application/octet-stream');
        httpReq.setHeader('Content-type', 'application/json');
        httpReq.setEndpoint(endPoint);
        //httpReq.setBodyAsBlob(chunk_body);
        httpReq.setMethod('POST');
        Http http = new Http();
        HttpResponse response;
        
        if(Test.isRunningTest()){
            response=new HttpResponse();
            response.setHeader('Content-type', 'application/json');
            response.setBody('{"revision": 88, "bytes": 2547, "thumb_exists": false, "rev": "583f4a33b7", "modified": "Sat, 21 Nov 2015 11:49:07 +0000", "shareable": false, "mime_type": "text/html", "path": "/Salesforce Box/emi.html", "is_dir": false, "size": "2.5 KB", "root": "dropbox", "id": "id:b173YvvKFfAAAAAAAAAANQ", "client_mtime": "Sat, 21 Nov 2015 11:49:07 +0000", "icon": "page_white_code"}');
            response.setStatusCode(200);
        }else{
            response=http.send(httpReq);            
        }
        system.debug('@@@@response=:' +response.getBody());        
        return response;
    } 
    
    public static String getTokenValue(JSONParser parser, String token){
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == token)) {
                // Get the value. 
                if(parser.getText() == token){
                    parser.nextToken();
                    return parser.getText();
                }
            }
        }
        return '';
    }
        
    // Get MetaData
    public static HttpResponse getMetadata(String access_token, String user_id, String root, String path){
      Dropbox_User_Settings__c dropboxUCS = Dropbox_User_Settings__c.getInstance(UserInfo.getUserId());
        System.debug('====> '+root+' '+path+' '+access_token+' '+user_id);
        HttpRequest httpReq = new HttpRequest();
        
        String endPoint = 'https://api.dropboxapi.com/2'+'/files/list_folder';
        httpReq.setHeader('Authorization', 'Bearer '+access_token);
        httpReq.setHeader('Content-type', 'application/json');
        httpReq.setTimeout(60000);
        httpReq.setEndpoint(endPoint);
        httpReq.setBody('{\"path\": \"/'+path+'\"}');
        httpReq.setMethod('POST');
        Http http = new Http();
        HttpResponse response;
        if(Test.isRunningTest()){
            response=new HttpResponse();
            response.setHeader('Content-type', 'application/json');
            response.setBody('{"read_only": false, "hash": "a986d542a422b3bba28a08f5bbb98711", "revision": 590, "bytes": 0, "thumb_exists": false, "rev": "24e2b6b3273", "modified": "Thu, 30 Jul 2015 09:00:49 +0000", "size": "0 bytes", "path": "/Salesforce Documents/Opportunities/006m0000004UCaB", "is_dir": true, "modifier": null, "root": "dropbox", "contents": [{"size": "0 bytes", "read_only": false, "modifier": null, "is_deleted": true, "rev": "2552b6b3273", "thumb_exists": false, "bytes": 0, "modified": "Thu, 06 Aug 2015 16:44:30 +0000", "path": "/Salesforce Documents/Opportunities/006m0000004UCaB/test", "is_dir": true, "icon": "folder_gray", "root": "dropbox", "revision": 597}, {"rev": "24f2b6b3273", "thumb_exists": true, "path": "/Salesforce Documents/Opportunities/006m0000004UCaB/yrLogo.png", "is_dir": false, "client_mtime": "Thu, 30 Jul 2015 09:01:35 +0000", "icon": "page_white_picture", "read_only": false, "modifier": null, "bytes": 3418, "modified": "Thu, 30 Jul 2015 09:01:35 +0000", "size": "3.3 KB", "root": "dropbox", "mime_type": "image/png", "revision": 591}], "icon": "folder"}');
            response.setStatusCode(200);
        }else{
            System.debug('====> httpReq '+httpReq);
            response=http.send(httpReq);            
        }
        system.debug('@@@@response=:' +response.getBody());
        
        return response;
    }
    
    // Get View Media URL
    public static HttpResponse getViewMediaURL(String access_token, String user_id, String root, String path){
        HttpRequest req = new HttpRequest();
        String endPoint = DROPBOX_HOST+'/media/'+root;
               endPoint += path.trim().length() > 0 ?  '/'+path : '' ;
               endPoint += '?access_token='+access_token+'&oauth_consumer_key='+user_id;
        system.debug('@@@@endPoint=>' + endPoint);
        req.setEndpoint(endPoint);
        req.setMethod('POST');
        Http http = new Http();
         HttpResponse response;
        if(Test.isRunningTest()){
            response=new HttpResponse();
            response.setHeader('Content-type', 'application/json');
            response.setBody('{"read_only": false, "hash": "a986d542a422b3bba28a08f5bbb98711", "revision": 590, "bytes": 0, "thumb_exists": false, "rev": "24e2b6b3273", "modified": "Thu, 30 Jul 2015 09:00:49 +0000", "size": "0 bytes", "path": "/Salesforce Documents/Opportunities/006m0000004UCaB", "is_dir": true, "modifier": null, "root": "dropbox", "contents": [{"size": "0 bytes", "read_only": false, "modifier": null, "is_deleted": true, "rev": "2552b6b3273", "thumb_exists": false, "bytes": 0, "modified": "Thu, 06 Aug 2015 16:44:30 +0000", "path": "/Salesforce Documents/Opportunities/006m0000004UCaB/test", "is_dir": true, "icon": "folder_gray", "root": "dropbox", "revision": 597}, {"rev": "24f2b6b3273", "thumb_exists": true, "path": "/Salesforce Documents/Opportunities/006m0000004UCaB/yrLogo.png", "is_dir": false, "client_mtime": "Thu, 30 Jul 2015 09:01:35 +0000", "icon": "page_white_picture", "read_only": false, "modifier": null, "bytes": 3418, "modified": "Thu, 30 Jul 2015 09:01:35 +0000", "size": "3.3 KB", "root": "dropbox", "mime_type": "image/png", "revision": 591}], "icon": "folder"}');
            response.setStatusCode(200);
        }else{
            response=http.send(req);            
        }
        system.debug('@@@@response=:' +response.getBody());
        
        return response;
    }
    
    //Delete Media
    public static HttpResponse deleteMedia(String access_token, String user_id, String root, String path){
        HttpRequest req = new HttpRequest();
        req.setEndPoint(DROPBOX_HOST+'/fileops/delete?access_token='+access_token+'&oauth_consumer_key='+user_id+'&root='+root+'&path='+EncodingUtil.urlEncode(path, 'UTF-8'));
        req.setMethod('POST');    
        Http http = new Http();
        HttpResponse response;
        if(Test.isRunningTest()){
            response=new HttpResponse();
            response.setHeader('Content-type', 'application/json');
            response.setBody('{"read_only": false, "is_deleted": true, "revision": 600, "bytes": 0, "thumb_exists": false, "rev": "2582b6b3273", "modified": "Fri, 07 Aug 2015 09:35:15 +0000", "mime_type": "text/plain", "size": "0 bytes", "path": "/Salesforce Documents/Opportunities/006m0000004UCaB/Testing.txt", "is_dir": false, "modifier": null, "root": "dropbox", "client_mtime": "Wed, 31 Dec 1969 23:59:59 +0000", "icon": "page_white_text"}');
            response.setStatusCode(200);
        }else{
            response=http.send(req);            
        }
        system.debug('@@@@response=:' +response.getBody());
        
        return response;
    }
}