({
    doInitHelper: function(component) {
        component.find("forceRecord").getNewRecord(
            "Contact",
            null,
            false,
            $A.getCallback(function() {
                var record = component.get("v.simpleRecord");
                console.log(record);
                var error = component.get("v.errorRecord");
                if(error || (record === null)) {
                    console.log("Error initializing record template: " + error);
                }
                else {
                    console.log("Record template initialized: " + record.sobjectType);
                }
            })
        );		
    },
    
    handleSaveContact: function(component){
        var allValid = component.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if (allValid) {
            component.find("forceRecord").saveRecord(function(saveResult) {
                    if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {               
                        var detailEvent = $A.get("e.force:navigateToSObject");
                        detailEvent .setParams({
                            "recordId": component.get("v.simpleRecord.Id")  ,
                            "slideDevName": "detail"
                        });
                        detailEvent.fire();
                    }                    
                });  
            } 
    },
    
    handelonChange : function(component){
        var isCheck = component.find("checkbox").get("v.checked");
        component.set("v.showFields",isCheck);
        
        console.log(isCheck);
    }
    
})

/* record type*/