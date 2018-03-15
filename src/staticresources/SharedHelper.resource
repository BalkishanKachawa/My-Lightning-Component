getContact : function(component) {
    var action = component.get("c.getContact");
    action.setCallback(this, function(action) {
        component.set("v.cont", action.getReturnValue());
    });
    $A.enqueueAction(action);
}