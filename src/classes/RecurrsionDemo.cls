public class RecurrsionDemo{
 
    @AuraEnabled
    public static Integer getCountN(Integer i){
        System.debug('#### '+i);
        return i;
    }   
}