trigger InActiveProductTrigger on Product2(after update) {
	Product2TriggerHandler handler = new Product2TriggerHandler();

	if (handler.IS_FIRST_TIME) {
		handler.IS_FIRST_TIME = false;
		/* After update */
		if (Trigger.isUpdate && Trigger.isAfter) {
			handler.OnAfterUpdate(Trigger.new);
		}
	}

}
