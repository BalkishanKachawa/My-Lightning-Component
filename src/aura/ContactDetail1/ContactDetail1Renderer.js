({
	render: function(cmp, helper) {
       console.log('render');
       //helper.changeValue(cmp);
       return this.superRender()
    },
    afterRender: function(cmp, helper) {
        console.log('afterRender'); 
        //helper.changeValue2(cmp);
        return this.superAfterRender()
    },
    rerender: function(cmp, helper) {
        console.log('rerender of one'); 
        return this.superRerender()
    }
    
})