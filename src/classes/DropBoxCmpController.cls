/**************

        Class Name     :    DropBoxCmpController
        Author         :    Balkishan Kachawa
        Email          :    balkishan.kachawagmail.com
        Date           :    
        Description    :    This class is used from lightning component for calling auraEnabled methods.

**************/

global with sharing class DropBoxCmpController{

    global DropBoxCmpController(){}  
      
    global DropBoxCmpController( DropBoxOAuthController dropbox ){}
    
    @AuraEnabled
    public Static DropboxKeyWrapper checkAuthentication(){        
         list<Dropbox_Authentication__c> dbCSs = new list<Dropbox_Authentication__c>();
         if (Schema.sObjectType.Dropbox_Authentication__c.fields.Token__c.isAccessible() && Schema.sObjectType.Dropbox_Authentication__c.fields.UserId__c.isAccessible())
             dbCSs = [SELECT Token__c, UserId__c FROM Dropbox_Authentication__c limit 1];
             
         Dropbox_key__c DropboxKey = new Dropbox_key__c();   
         DropboxKey = [select isAuthorized__c, Redirect_URI__c, App_Key__c, App_Secret__c from Dropbox_key__c limit 1];      
         DropboxKeyWrapper dbkw = new DropboxKeyWrapper();
         
         dbkw.isAuthorized = DropboxKey.isAuthorized__c;
         dbkw.redirectURI = DropboxKey.Redirect_URI__c;
         dbkw.appKey = DropboxKey.App_Key__c;
         dbkw.appSecret = DropboxKey.App_Secret__c;
         
         /*if (Schema.sObjectType.dropboxkeys__c.fields.App_Key__c.isAccessible() && Schema.sObjectType.dropboxkeys__c.fields.App_Secret__c.isAccessible() &&
             Schema.sObjectType.dropboxkeys__c.fields.isAuthorized__c.isAccessible() && Schema.sObjectType.dropboxkeys__c.fields.Redirect_URI__c.isAccessible()){ 
             DropboxKey = [select isAuthorized__c, Redirect_URI__c, App_Key__c, App_Secret__c from dropboxkeys__c limit 1];     
         }  */
         
         if(dbCSs.size() > 0){ 
             //DropboxKey.isAuthorized__c = true;
             dbkw.isAuthorized = true;
             return dbkw;
         }
         dbkw.isAuthorized = false;
         return dbkw;
    }
    
     // Upload Chunk
    @AuraEnabled
    public static String uploadChunk(String fileName, String base64Data, String uploadId, Integer offset, Boolean commitFlag, String uploadStatus) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');        
        System.debug('base64Data '+base64Data);
        list<Dropbox_Authentication__c> dbCSs = new list<Dropbox_Authentication__c>();
         if (Schema.sObjectType.Dropbox_Authentication__c.fields.Token__c.isAccessible() && Schema.sObjectType.Dropbox_Authentication__c.fields.UserId__c.isAccessible())
             dbCSs = [SELECT Token__c, UserId__c FROM Dropbox_Authentication__c limit 1];
             
        String token = dbCSs[0].token__c;
        String UserId = dbCSs[0].UserId__c;
        HttpResponse res;
        if(!commitFlag){ 
            
            if(uploadStatus == 'appendStart'){
                System.debug('session_id '+uploadStatus+' '+uploadId+' offset '+offset);
                res = DropBoxCallOuts.uploadChunk(token, UserId, uploadId, offset+'', EncodingUtil.base64Decode(base64Data));
                Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                Integer size = EncodingUtil.base64Decode(base64Data).size();
                String sessionJson = '{\"session_id\": \"'+(String)m.get('session_id')+'\",\"offset\": \"'+size+'\"}';
                return sessionJson;
            }
            if(uploadStatus == 'appendUpload'){
                System.debug('session_id '+uploadStatus+' '+uploadId+' offset '+offset);
                DropBoxCallOuts.appendChunkData(token, UserId, uploadId, offset+'', EncodingUtil.base64Decode(base64Data),false);
                Integer size = EncodingUtil.base64Decode(base64Data).size() + offset;
                String sessionJson = '{\"session_id\": \"'+uploadId+'\",\"offset\": \"'+size+'\"}';
                return sessionJson;
            }
            
            //DropBoxCallOuts.commitUploadedChunk(token, UserId, 'dropbox', 'Salesforce Box/' + fileName, (String)m.get('session_id'), EncodingUtil.base64Decode(base64Data));
            
        }else{
            System.debug('session_id '+uploadStatus+' '+uploadId);
            DropBoxCallOuts.appendChunkData(token, UserId, uploadId, offset+'', EncodingUtil.base64Decode(base64Data),true);
            System.debug('====$$$ EncodingUtil.base64Decode(base64Data) '+EncodingUtil.base64Decode(base64Data));
            offset+= EncodingUtil.base64Decode(base64Data).size();
            res = DropBoxCallOuts.commitUploadedChunk(token, UserId, 'dropbox', 'Salesforce Box/' + fileName, uploadId, EncodingUtil.base64Decode(base64Data),offset+'');
        }
        //system.debug('@@@@res.getBody() =>' + res.getBody());
        return '';
    }
    
    /*@AuraEnabled
    public static String commitUploadChunk(String upload_id, String file_path){
        list<Dropbox_Authentication__c> dbCSs = new list<Dropbox_Authentication__c>();
         if (Schema.sObjectType.Dropbox_Authentication__c.fields.Token__c.isAccessible() && Schema.sObjectType.Dropbox_Authentication__c.fields.UserId__c.isAccessible())
             dbCSs = [SELECT Token__c, UserId__c FROM Dropbox_Authentication__c limit 1];
             
        String token = dbCSs[0].token__c;
        String UserId = dbCSs[0].UserId__c;
        HttpResponse res = DropBoxCallOuts.commitUploadedChunk(token, UserId, 'dropbox', file_path, upload_id);
        return 'DONE';
    }*/
    
     // Create New Folder
    @AuraEnabled
    public static String createNewFolder(String path){
      list<Dropbox_Authentication__c> dbCSs = new list<Dropbox_Authentication__c>();
      if (Schema.sObjectType.Dropbox_Authentication__c.fields.Token__c.isAccessible() && Schema.sObjectType.Dropbox_Authentication__c.fields.UserId__c.isAccessible())
          dbCSs = [SELECT Token__c, UserId__c FROM Dropbox_Authentication__c limit 1];
      system.debug('@@@@path=>' + path);       
      if(!dbCSs.isEmpty()){    
          HttpResponse res = DropBoxCallOuts.createFolder(dbCSs[0].Token__c, dbCSs[0].UserId__c, 'dropbox', 'Salesforce Box/' + path);
          return 'Done';
      }
      return '';
    }
    
    // Delete
    @AuraEnabled
    public static String deleteMedia(String path){
      list<Dropbox_Authentication__c> dbCSs = new list<Dropbox_Authentication__c>();
      if (Schema.sObjectType.Dropbox_Authentication__c.fields.Token__c.isAccessible() && Schema.sObjectType.Dropbox_Authentication__c.fields.UserId__c.isAccessible())
          dbCSs = [SELECT Token__c, UserId__c FROM Dropbox_Authentication__c limit 1];
      system.debug('@@@@path=>' + path);       
      if(!dbCSs.isEmpty()){    
          HttpResponse res = DropBoxCallOuts.deleteMedia(dbCSs[0].Token__c, dbCSs[0].UserId__c, 'dropbox', 'Salesforce Box/' + path);
          return 'Done';
      }
      return '';
    }
    
    // View Media
    @AuraEnabled
    public static String viewMedia(String path){
      list<Dropbox_Authentication__c> dbCSs = new list<Dropbox_Authentication__c>();
      if (Schema.sObjectType.Dropbox_Authentication__c.fields.Token__c.isAccessible() && Schema.sObjectType.Dropbox_Authentication__c.fields.UserId__c.isAccessible())
          dbCSs = [SELECT Token__c, UserId__c FROM Dropbox_Authentication__c limit 1];
      system.debug('@@@@path=>' + path);       
      if(!dbCSs.isEmpty()){          
          HttpResponse res = DropBoxCallOuts.getViewMediaURL(dbCSs[0].Token__c, dbCSs[0].UserId__c, 'dropbox', 'Salesforce Box/' + path);
          JSONParser parser = JSON.createParser(res.getBody());
          return DropBoxCallOuts.getTokenValue(parser, 'url');
      }
      return '';
    }
    
    //getting metadata
    @AuraEnabled
    public static list<MetadataContents> getMetadata(String path){
        list<Dropbox_Authentication__c> dbCSs = new list<Dropbox_Authentication__c>();
         if (Schema.sObjectType.Dropbox_Authentication__c.fields.Token__c.isAccessible() && Schema.sObjectType.Dropbox_Authentication__c.fields.UserId__c.isAccessible())
             dbCSs = [SELECT Token__c, UserId__c FROM Dropbox_Authentication__c limit 1];
             
        String token = dbCSs[0].token__c;
        String UserId = dbCSs[0].UserId__c;
        String pathURL = '';
        
        if(path == '')
            pathURL = '';
        else{
            if(path.indexOf('/') == 0)
                pathURL = path;
            else
                pathURL = '/' + path;
        }
        HttpResponse response = DropBoxCallOuts.getMetadata(dbCSs[0].Token__c, dbCSs[0].UserId__c, 'dropbox', 'Salesforce Box' + pathURL );
        if(response.getStatusCode() == 200){
            String newContents = response.getBody().replaceAll('\".tag\"','\"tag\"');
            Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(newContents);
            system.debug('@@@@@@====>'  +JSON.serialize(m));
            
            list<MetadataContents> contents = (list<MetadataContents>)JSON.deserializeStrict(JSON.serialize(m.get('entries')), list<MetadataContents>.class);
            system.debug('@@@@@@====> contents '  +contents);
            
            /*List<String> newContents = (List<String>)JSON.deserialize(JSON.serialize(m.get('entries')),List<String>.class);
            system.debug('@@@@@@====> newContents '  +newContents);*/
            
            list<MetadataContents> tmpLstContents = new list<MetadataContents>(); 
            for(MetadataContents con : contents){
                con.file_name =  con.path_display.subString(con.path_display.lastIndexOf('/')+1, con.path_display.length());
                con.short_file_name = con.file_name.length() > 35 ? con.file_name.subString(0, 25)+ '...' + con.file_name.subString(con.file_name.length()-10, con.file_name.length()): con.file_name;
                con.mime_type = con.tag;
                con.icon = con.tag;
                tmpLstContents.add(con);
                /*con.file_name =  con.path.subString(con.path.lastIndexOf('/')+1, con.path.length());
                con.short_file_name = con.file_name.length() > 35 ? con.file_name.subString(0, 25)+ '...' + con.file_name.subString(con.file_name.length()-10, con.file_name.length()): con.file_name;
                con.mime_type = DropBoxCmpController.applicationTypes.get(con.mime_type) != null ? applicationTypes.get(con.mime_type) : 'file'; 
                tmpLstContents.add(con);*/
            }
            tmpLstContents.sort();
            contents = tmpLstContents;
            System.debug('Metadata: ==>>'+contents );
            //contents = contents.sort();
            return contents;
            
            
        }
        
        return null;
    }
    
    static Map<String, String> applicationTypes = 
        new Map<String, String>{
            'application/atom+xml' => 'code',
            'application/ecmascript' => 'code',
            'application/json' => 'file',
            'application/javascript' => 'code',
            'text/javascript' => 'code',
            'application/octet-stream' => 'file',
            'application/ogg' => 'file',
            'application/pdf' => 'document',
            'application/postscript' => 'code',
            'application/rdf+xml' => 'code',
            'application/rss+xml' => 'code',
            'application/soap+xml' => 'code',
            'application/x-font-woff' => 'file',
            'application/xhtml+xml' => 'code',
            'application/xml' => 'code',
            'application/xml-dtd' => 'code',
            'application/xop+xml' => 'code',
            'application/zip' => 'archive',
            'application/rar' => 'archive',
            'application/gzip' => 'archive',
            'application/msword' => 'document',
            
            'audio/basic' => 'audio',
            'audio/L24' => 'audio',
            'audio/mp4' => 'audio',
            'audio/ogg' => 'audio',
            'audio/opus' => 'audio',
            'audio/vorbis' => 'audio',
            'audio/webm' => 'audio',
            'audio/example' => 'audio',
            'audio/mpeg' => 'audio',
            'audio/mp3' => 'audio',
            
            'image/gif' => 'image',
            'image/jpeg' => 'image',
            'image/pjpeg' => 'image',
            'image/png' => 'image',
            'image/svg+xml' => 'code',
            'image/vnd.djvu' => 'image',
            'image/example' => 'image',
            
            'text/cmd' => 'code',
            'text/css' => 'code',
            'text/javascript' => 'code',
            'text/plain' => 'document',
            'text/rtf' => 'file',
            'text/vcard' => 'file',
            'text/xml' => 'code',
            'text/csv' => 'document',
            
            'video/avi' => 'video',
            'video/mpeg' => 'video',
            'video/mp4' => 'video',
            'video/ogg' => 'video',
            'video/quicktime' => 'video',
            'video/webm' => 'video',
            'video/mpeg' => 'video',
            'video/x-matroska' => 'video',
            'video/x-ms-wmv' => 'video',
            'video/x-flv' => 'video',
            
            'application/vnd.oasis.opendocument.text' => 'document',
            'application/vnd.oasis.opendocument.spreadsheet' => 'document',
            'application/vnd.oasis.opendocument.presentation' => 'document',
            'application/vnd.oasis.opendocument.graphics' => 'document',
            'application/vnd.ms-excel' => 'document',
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' => 'document',
            'application/vnd.ms-powerpoint' => 'document',
            'application/vnd.openxmlformats-officedocument.presentationml.presentation' => 'document',
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document' => 'document',
            'application/vnd.mozilla.xul+xml' => 'file',
            'application/vnd.google-earth.kml+xml' => 'file',
            'application/vnd.google-earth.kmz' => 'file',
            'application/dart' => 'file',
            'application/vnd.android.package-archive' => 'file',
            'application/vnd.ms-xpsdocument' => 'document',
            'text/vnd.abc' => 'file',
            
            'application/x-7z-compressed' => 'archive',
            'application/x-font-ttf' => 'file',
            'application/x-javascript' => 'code',
            'application/x-latex' => 'file',
            'application/x-rar-compressed' => 'archive',
            'application/x-shockwave-flash' => 'file',
            'audio/x-aac' => 'audio',
            'audio/x-caf' => 'audio'
        };   
}