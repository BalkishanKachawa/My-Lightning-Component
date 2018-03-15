({
    handleDoInit : function(component) {
        component.find("ExpenseRecordCreator").getNewRecord(
            "Expense__c", 
            null,      
            false,     
            $A.getCallback(function() {
                var rec = component.get("v.newExpense");
                var error = component.get("v.newExpenseError");
                if(error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                }else {
                    console.log("Record template initialized: " + rec.sobjectType);
                }
            })
        );
        this.fetchExpenseType(component);
        
    },
	fetchExpenseType : function(component) {
		var action = component.get("c.fetchExpenseTypes");
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
 				for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
	},
    saveExpenseData : function(component){
        
        component.find("ExpenseRecordCreator").saveRecord(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record has been saved successfully."
                });
                toastEvent.fire();
                
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": saveResult.recordId
                });
                navEvt.fire();
                
            } else if (saveResult.state === "INCOMPLETE") {
                console.log('User is offline, device does not support drafts.');
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving Expense, error: ' + JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        });
        
    },
    gasExpense : function(component){
        var gastype = component.find("expensetype").get("v.value");
        if(gastype === 'Gas'){
            component.set("v.showAddress","Gas");
        }else{
            component.set("v.showAddress","");
        }
    },
    
    
})