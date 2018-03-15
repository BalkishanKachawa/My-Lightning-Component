public class contactWrapperDemo{
    public String FirstName{get;set;}
    public String LastName{get;set;}
    public Integer Phone{get;set;}
    public Account account{get;set;}
    public Opportunity Opportunity{get;set;}
    public List<ContactWrapper> conWList{get;set;}
    
    public contactWrapperDemo(){
        conWList = new List<ContactWrapper>();
        conWList.add(new ContactWrapper('Vivek','Kumar',9999999,new Account(Name='test'),new Opportunity()));
    }
}