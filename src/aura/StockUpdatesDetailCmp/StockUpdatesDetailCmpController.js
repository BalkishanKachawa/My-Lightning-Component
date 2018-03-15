({
	getStockDetail: function(component, event, helper) {        
        var symbol = event.getParam("tickerSymbol");
        jQuery(".tb").html("");
        //Calling getResult helper method        
        helper.getStockDetailResult(component, symbol);	
    },
    
    handleSetSymbolCmpEvent : function(component, event, helper) {
        var symbol = event.getParam("symbolTicker");
        jQuery(".tb").html("");
        helper.getChartData(component, symbol);
        
    }
})