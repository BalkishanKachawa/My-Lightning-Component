({
    doInit : function(component, event, helper) {
        helper.doInitHelper(component,event,helper);
    },
    
    saveContact:function(component, event, helper) {
        helper.handleSaveContact(component);
    },
    
    cancel: function(component, event, helper) {
        helper.handleCancel(component, event, helper);
    }, 
    
    recordUpdated :function(component, event, helper){
        helper.handleRecordUpdated(component, event);
    }
})