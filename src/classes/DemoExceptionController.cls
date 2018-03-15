public class DemoExceptionController{

    @AuraEnabled
    public static String getServerErrorMessage(){
    
        //Callout Exception
        /*
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://google.com');
        req.setMethod('GET');
        HttpResponse res = h.send(req); 
        */
        
        //DML Exception
        /*
        Contact con = [select id,FirstName,LastName from contact limit 1];
        con.FirstName = 'test';
        con.LastName = null;
        update con;
        */
        
        //SObjectException
        /*
        Contact con = [select id,FirstName,LastName from contact limit 1];
        String name = con.Name;
        */
        
        //DML Exception
        /*contact con = new contact();
        insert con;*/
        
        //List Exception        
        
            List<Integer> li = new List<Integer>();
            li.add(15);
            Integer i2 = li[1]; // Causes a ListException
        
        
        //LimitException    
        /*
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'balkishan.kachawa@gmail.com'}; 
        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('Salesforce Support');
        mail.setSubject('New Case Created : ' );
        mail.setPlainTextBody('Your Case:  has been created.');
        mail.setHtmlBody('Your case:<b>hello </b>has been created.<p>');
        for(Integer i=0;i<11;i++)
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        */
         
        //SOQL Exception    
        //Contact con = [select id from contact]; 
        
        //Null Pointer Exception
        /*String str = null;
        str.length();*/
        
        
        return 'true';

    }
}