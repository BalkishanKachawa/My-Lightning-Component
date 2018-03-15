public with sharing class ContactController{
    public List<Contact> conList{get;set;}
    public Contact cont{get;set;}
    public String colorcode{get;set;}
    
    public ContactController(){
        colorcode = '#FB58';
        String conId = ApexPages.CurrentPage().getParameters().get('conId');
        
        conList = [select id,name,phone,email from Contact];
        
        if(conId != null){
            cont = [select id,name,phone,email from Contact where id =: conId];
        }else{
            cont = new Contact();
        }
    }
    
    @AuraEnabled
    public static Contact getContact(){
        Contact con = [Select FirstName,LastName,Email,Phone From Contact LIMIT 1];
        return con;
    }
}