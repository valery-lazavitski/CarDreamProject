trigger InActiveProductTrigger on Product2 (after update) {

    Product2TriggerHandler handler = new Product2TriggerHandler();
    
    /* After update */
    if(Trigger.isUpdate && Trigger.isAfter){
        handler.OnAfterUpdate(Trigger.new);
    }    
}