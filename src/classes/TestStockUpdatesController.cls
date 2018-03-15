@isTest
public class TestStockUpdatesController{
    
    @isTest
    private static void testGetTickerSymbol(){
        StockSymbal__c ss = new StockSymbal__c();
        ss.Symbol__c = 'CRM';
        insert ss;
        
        String symbol = StockUpdatesController.getTickerSymbol('CRM');
        System.assert(symbol == 'CRM');
        
        symbol = StockUpdatesController.getTickerSymbol('CRMM');
        System.assert(symbol == 'Error');
    
    }
    
    @isTest
    private static void testGetStockData(){
        
        StockUpdatesWrapperClass suwObj = StockUpdatesController.getStockData('Error');
        System.assert(suwObj == null);     
        
        StockUpdatesController.checkTest();
        
        suwObj = StockUpdatesController.getStockData('CRM');
        System.assert(suwObj != null);
        
    }
    
    @isTest
    private static void testGetChartData(){
    
        StockUpdatesController.checkTest();
        
        String symbol = StockUpdatesController.getChartData('CRM');
        System.assert(symbol == null);     
                
    }
}