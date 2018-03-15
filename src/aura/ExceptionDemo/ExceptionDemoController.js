({
	showError : function(component, event, helper) {
        debugger;
		var action = component.get("c.getServerErrorMessage");
		
        action.setCallback(this, function(a) {
            component.set("v.message", a.getReturnValue());
            
			if (a.getState() === "SUCCESS") {
				component.set("v.message", a.getReturnValue());
			} else if (a.getState() === "ERROR"){
                console.log(a.getError());
                var errors = a.getError();
                if(errors[0] && errors[0].message)// To show other type of exceptions
                    component.set("v.message", errors[0].message);
                if(errors[0] && errors[0].pageErrors) // To show DML exceptions
            		component.set("v.message", errors[0].pageErrors[0].message);    
			}
        });
		$A.enqueueAction(action);
	}
})