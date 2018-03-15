public class ContactWrapper{
    public String FirstName{get;set;}
    public String LastName{get;set;}
    public Integer Phone{get;set;}
    public Account account{get;set;}
    public Opportunity opp{get;set;}
    
    public ContactWrapper(String FirstName, String LastName, Integer Phone, Account account, Opportunity opp){
        this.FirstName = FirstName;
        this.LastName = LastName;
        this.Phone = Phone;
        this.account = account;
        this.opp = opp;
    }
    
}