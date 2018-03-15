/**
    @ Name            StockUpdatesWrapperClass
    
    @ Author          Balkishan Kachawa
    
    @ Desctiption     StockUpdatesWrapperClass to wrap stock data.
    
* */
public class StockUpdatesWrapperClass{
    @AuraEnabled
    public String Change_PercentChange;
     
    @AuraEnabled
    public String LastTradeDate;
    
    @AuraEnabled
    public String DaysLow;
    
    @AuraEnabled
    public String DaysHigh;
    
    @AuraEnabled
    public String YearLow;
    
    @AuraEnabled
    public String YearHigh;
    
    @AuraEnabled
    public String MarketCapitalization;
    
    @AuraEnabled
    public String LastTradePriceOnly;
    
    @AuraEnabled
    public String Name;
     
    @AuraEnabled
    public String Symbol;
    
    @AuraEnabled
    public String LastTradeTime;
    
    @AuraEnabled
    public String stockChange;
    
    @AuraEnabled
    public String stockChangePercent;
    
    @AuraEnabled
    public String stockChangeDirection;
}