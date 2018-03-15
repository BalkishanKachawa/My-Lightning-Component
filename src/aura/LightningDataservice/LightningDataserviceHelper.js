({
    doInitHelper: function(component, event, helper) {
        component.find("forceRecord").getNewRecord(
            "Contact", //sObject name
            this.getUlrParam("recordTypeId"),//Getting record type id
            false,
            $A.getCallback(function() {
                var record = component.get("v.simpleRecord");
                var error = component.get("v.errorRecord");
                if(error || (record === null)) {
                    console.log("Error initializing record template: " + error);
                }
                else {
                    //Reload data to edit existing record
                    if(component.get("v.isEditData")){
                        component.set("v.simpleRecord",record);
                        component.find("forceRecord").reloadRecord();
                    }
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
                    detailEvent.setParams({
                        "recordId": component.get("v.simpleRecord.Id")  ,
                        "slideDevName": "detail"
                    });
                    detailEvent.fire();
                }                    
            }); 
        } 
    },
    
    handleRecordUpdated : function(component, event){ 
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            var contact = component.get("v.simpleRecord");       
            if(contact != null){
                component.set("v.simpleRecord",contact);
                if(contact.Id != null){
                    //To edit existing record
                    component.set("v.isEditData",true);
                }
            }else{
                component.set("v.simpleRecord",contact);
                component.set("v.isEditData",false);  
            }
        }else if(eventParams.changeType === "CHANGED") {
            component.find("forceRecord").reloadRecord();
        }  
    },
    //Get recordtype Id from URL
    getUlrParam: function(param){
        param = param.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
        var regexS = "[\\?&]"+param+"=([^&#]*)";
        var regex = new RegExp( regexS );
        var results = regex.exec( window.location.href );
        if( results == null )
            return null;
        else
            return results[1];
    },
    
    handleCancel : function(component, event, helper){
        if(!component.get("v.isEditData")){
            //When you are coming from list view, It will redirct you back to list view
            var homeEvent = $A.get("e.force:navigateToObjectHome");
            homeEvent.setParams({
                "scope": "Contact"
            });
            homeEvent.fire();
        }else{
            //When you are editing a record from detail view, It will redirect you to detail view
            var detailEvent = $A.get("e.force:navigateToSObject");
            detailEvent.setParams({
                "recordId": component.get("v.simpleRecord.Id")  ,
                "slideDevName": "detail"
            });
            detailEvent.fire();
        }
    }
    
    
    
})