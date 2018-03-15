({
	getTickerSymbol: function(component) {   
        var symbol = component.find("ticker").get("v.value");
        var cId = component.find("ticker").getLocalId();
        console.log(cId);
        document.getElementById(cId).focus();
        
        var action = component.get("c.getTickerSymbol");
        //Set up the callback        
        action.setParams({
            "symbol": symbol
        });
        var self = this;
        action.setCallback(this, function(actionResult) {
            
            component.set("v.symbol", actionResult.getReturnValue()); 
            var symbol = component.get("v.symbol");
            var msgSuccess = component.find("msgSuccess");
            var msgErr = component.find("msgErr");
            if(symbol=="Error"){
                $A.util.addClass(msgSuccess, 'hide');
                $A.util.removeClass(msgErr, 'hide');                
            }else{
                $A.util.addClass(msgErr, 'hide');
                $A.util.removeClass(msgSuccess, 'hide');                
            }
            this.setSymbolAppEvent(component,symbol);
        });        
        $A.enqueueAction(action); 
    }, 
    setSymbolAppEvent: function(component, symbol) { 
        var appEvent = $A.get("e.c:StockUpdatesAppEvent");
        appEvent.setParams({"tickerSymbol":symbol});
        appEvent.fire();
    }, 
})