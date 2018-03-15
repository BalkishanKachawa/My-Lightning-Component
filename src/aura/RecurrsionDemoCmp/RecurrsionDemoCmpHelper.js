({
	getCountResult : function(component,i) {
        var action = component.get("c.getCountN");
        action.setParams({
            "i": i
        });
        action.setCallback(this, function(actionResult) {
            var tmpStr = actionResult.getReturnValue();
            if(i < 10)
            	this.getCountResult(component,i);
        });        
        i++;
        $A.enqueueAction(action);    
        
	}
})