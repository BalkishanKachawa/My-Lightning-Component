public with sharing class LastVisitedController{
    
    @AuraEnabled
    public static sObject getViewersList(String recordId, String objectName){
        System.debug('objectName = '+objectName +' recordId = '+recordId);
        
        String query = 'SELECT Id, Name, '+
                       '(Select OldValue, NewValue, Field From Histories Where Field = \'Last_Visited_By__c\' ORDER BY CreatedDate DESC) '+
                       'FROM '+objectName +' Where Id = \''+ recordId + '\' LIMIT 1' ;
        
        sObject obj = Database.Query(query);
        
        return obj;
    }
    
    @AuraEnabled
    public static void updateRecord(String recordId, String objectName){
        Datetime sdate = System.now();        //Format the datetime value to your locale        
        String sysTime = sdate.format('dd/MM/yyyy HH:mm');
    
        String query = 'SELECT Id, Name, Last_Visited_By__c '+
                        'FROM '+objectName +' Where Id = \''+ recordId + '\' LIMIT 1' ;
        
        sObject obj = Database.Query(query);
        obj.put('Last_Visited_By__c' , System.Userinfo.getFirstName() + ' '+ System.Userinfo.getLastName() +' '+ sysTime);
        update obj;
    }
    
}