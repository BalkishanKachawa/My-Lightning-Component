({
    doInit: function(component, event, helper) {
        helper.handleDoInit(component);
    },
	handleSaveExpense: function(component, event, helper) {
        helper.saveExpenseData(component);
    },
    handleGasExpense: function(component, event, helper) {
        helper.gasExpense(component);
    }
})