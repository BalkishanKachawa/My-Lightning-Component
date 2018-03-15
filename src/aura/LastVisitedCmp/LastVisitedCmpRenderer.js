({
    afterRender : function(component,helper){
        this.superAfterRender();
        helper.updateRecord(component);
    }	
})