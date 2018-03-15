public class fetchExpenseTypesController {
    
    @AuraEnabled
    public static List<String> fetchExpenseTypes() {
        List<String> options = new list<String>();
        Schema.sObjectType objType = Expense__c.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get('Expense_Type__c').getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            options.add(a.getValue());
        }
        
        options.sort();
        return options;
    }
}