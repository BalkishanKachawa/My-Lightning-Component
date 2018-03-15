({
    setSymbolCmpEvent : function(component, event) {
        // Get the component event by using the name value from aura:registerEvent
        var regCmpEvent = component.getEvent("regCmpEvent");
        var symbol = component.get("v.TickerSymbol");
        regCmpEvent.setParams({"symbolTicker" : symbol});
        regCmpEvent.fire();
    }
})