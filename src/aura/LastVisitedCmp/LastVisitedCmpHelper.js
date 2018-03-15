({
	getViewerList : function(component) {
		var action = component.get("c.getViewersList");
        action.setParams({
            "recordId" : component.get("v.recordId"),
            "objectName" : component.get("v.sObjectName")
        });
        action.setCallback(this, function(action) {
        	component.set("v.visitorsList",action.getReturnValue());
        });
        
        $A.enqueueAction(action);
	},
    updateRecord : function(component) {
		var action = component.get("c.updateRecord");
        action.setParams({
            "recordId" : component.get("v.recordId"),
            "objectName" : component.get("v.sObjectName")
        });
        $A.enqueueAction(action);
	},
})