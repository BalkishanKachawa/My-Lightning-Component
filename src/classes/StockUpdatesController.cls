/**
    @ Name            StockUpdatesController
    
    @ Author          Balkishan Kachawa
    
    @ Desctiption     StockUpdatesController to return Stock data fetched from Yahoo Server.
    
* */
public with sharing class StockUpdatesController{
    public static Boolean isApexTest = false;
    
    @AuraEnabled
    public static String getTickerSymbol(string symbol){
    
        List<StockSymbal__c> StockSymbals =[Select id, Symbol__c from StockSymbal__c where Symbol__c=: symbol limit 1];
        
        if(StockSymbals.size()>0)
            return StockSymbals[0].Symbol__c ;
        else 
            return 'Error';
            
    }
    
    //Returning Stock Data
    @AuraEnabled
    public static StockUpdatesWrapperClass getStockData(String symbol){
        
        if(symbol=='Error'){
        
            return null;
            
        }else{
        
            StockUpdatesWrapperClass sTickerWC = new StockUpdatesWrapperClass();
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            
            req.setEndpoint(stockDataUrl(symbol, 'Stock'));
            req.setMethod('GET');
            
            Map<String, Object> mapJsonOb = new Map<String, Object>();
            
            if(!isApexTest){
            
                HttpResponse res = h.send(req);
                            
                mapJsonOb = (Map<String, Object>)  JSON.deserializeUntyped(res.getBody());
                
                mapJsonOb = (Map<String, Object>) mapJsonOb.get('query');
                mapJsonOb = (Map<String, Object>) mapJsonOb.get('results');
                mapJsonOb = (Map<String, Object>) mapJsonOb.get('quote');
            }   
            if(mapJsonOb != Null){
                sTickerWC.LastTradePriceOnly = mapJsonOb.get('LastTradePriceOnly') != null ? String.valueOf(decimal.valueOf((string)mapJsonOb.get('LastTradePriceOnly')).setscale(2)) : 'NA';
                sTickerWC.Change_PercentChange = mapJsonOb.get('Change_PercentChange') != null ? (String) mapJsonOb.get('Change_PercentChange') : 'NA';
                if(sTickerWC.Change_PercentChange != 'NA'){
                    sTickerWC.stockChange = sTickerWC.Change_PercentChange.substringBefore(' - ').trim();
                    sTickerWC.stockChangePercent =  sTickerWC.Change_PercentChange.substringAfter(' - ').trim();
                    sTickerWC.stockChangeDirection = sTickerWC.stockChange.startsWith('+')?'Up':'Down';
                }
                
                sTickerWC.LastTradeDate = mapJsonOb.get('LastTradeDate') != null ? (String) mapJsonOb.get('LastTradeDate') : 'NA';
                sTickerWC.DaysLow = mapJsonOb.get('DaysLow') != null ? (String) mapJsonOb.get('DaysLow') : 'NA';
                sTickerWC.DaysHigh = mapJsonOb.get('DaysHigh') != null ? (String) mapJsonOb.get('DaysHigh') : 'NA';
                sTickerWC.YearLow = mapJsonOb.get('YearLow') != null ? (String) mapJsonOb.get('YearLow') : 'NA';
                sTickerWC.YearHigh = mapJsonOb.get('YearHigh') != null ? (String) mapJsonOb.get('YearHigh') : 'NA';
                sTickerWC.MarketCapitalization = mapJsonOb.get('MarketCapitalization') != null ? (String) mapJsonOb.get('MarketCapitalization') : 'NA';
                sTickerWC.Name = mapJsonOb.get('Name') != null ? (String) mapJsonOb.get('Name') : 'NA';
                sTickerWC.Symbol = mapJsonOb.get('Symbol') != null ? (String) mapJsonOb.get('Symbol') : 'NA';
                sTickerWC.LastTradeTime = mapJsonOb.get('LastTradeTime') != null ? (String) mapJsonOb.get('LastTradeTime') : 'NA';
                return sTickerWC;
                    
            }else{ 
            
                return null; 
                
            }
        }          
    }
    
    private static String stockDataUrl(String symbol,String check){
        String requestStr = '';    
        if(check == 'Stock'){
        
            requestStr = 'https://query.yahooapis.com/v1/public/yql?';
            requestStr += 'q=select%20Symbol%2CName%2CDaysLow%2CDaysHigh%2CYearLow%20%2CYearHigh%2CLastTradePriceOnly%2';
            requestStr += 'CLastTradeDate%2CLastTradeTime%2CMarketCapitalization%20%2CChange_PercentChange%20%20';
            requestStr += 'from%20yahoo.finance.quotes%20where%20symbol%20%20%3D%20%22' + symbol;
            requestStr += '%22%09&format=json&diagnostics=true&%20env=http%3A%2F%2Fdatatables.org%20%2Falltables.env%22%3';
            requestStr += 'Ehttps://query.yahooapis.com/v1/public/yql?';
            requestStr += 'q=select%20Symbol%2CName%20%2CDaysLow%2CDaysHigh%2CYearLow%2CYearHigh%2CLastTradePriceOnly%20%2';
            requestStr += 'CLastTradeDate%2CLastTradeTime%20%2CMarketCapitalization%2CChange%20_PercentChange%20';
            requestStr += 'from%20yahoo.finance.quotes%20%20where%20symbol%20%3D%20%22' + symbol;
            requestStr += '%22%09&format=json&diagnostics=true%20&env=http%3A%2F%2Fdatatables.org%2Falltables.env';
            
        }
        if(check == 'Chart'){
            //Start date
            DateTime dT = System.now();
            Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
            String sdate = String.valueOf(myDate);
            //End date
            DateTime dT1 = System.today().addDays(-30);
            Date mDate = date.newinstance(dT1.year(), dT1.month(), dT1.day());
            String edate = String.valueOf(mDate);
            
            requestStr = 'https://query.yahooapis.com/v1/public/yql?q=select%20Date,Close%20';
            requestStr += 'from%20yahoo.finance.historicaldata%20where%20symbol%20%3D%20%22' + symbol;
            requestStr += '%22%20and%20startDate%20%3D%20%22' + edate;
            requestStr += '%22%20and%20endDate%20%3D%20%22' + sdate;
            requestStr += '%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys';
            
        }
        
        return requestStr;
        
    }
    
    
    //Returning Historical Stock Data
    @AuraEnabled
    public static String getChartData(String symbol) {
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(stockDataUrl(symbol, 'Chart'));
        req.setMethod('GET');
        
        if(!isApexTest){
            
            HttpResponse res = h.send(req);
            return res.getBody();
           
        }else{
            return null;
        }
    }
    
    //Check for Test running
    public static void checkTest(){
        isApexTest = true;
    }
}