({
    doInit : function(component, event, helper) {
        helper.doInitHelper(component);
    },
    
    saveContact:function(component, event, helper) {
        helper.handleSaveContact(component);
    },
    onChange:function(component, event, helper) {
        helper.handelonChange(component);
    },
    cancel: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
})