public with sharing class Product2TriggerHandler {
	private static final String NEW_TASK_SUBJECT = 'Old model deal!!!';
	private static final String NEW_TASK_STATUS = 'New';
	private static final String NEW_TASK_PRIORITY = 'High';
	private static final Id CALL_RECORD_TYPE_ID;

	public static Boolean IS_FIRST_TIME = true;

	public Product2TriggerHandler() {
		CALL_RECORD_TYPE_ID = [SELECT Id, Name FROM RecordType WHERE Name = 'Call' LIMIT 1].Id;
	}

	public void OnAfterUpdate(Product2[] triggerProducts) {
		List<Product2> inactiveProducts = Product2Manager.getInactiveProducts(triggerProducts);

		if (inactiveProducts.size() > 0) {
			List<Task> callTask = new List<Task>();

			List<OpportunityLineItem> oppInactiveProd = OpportunityLineItemManager.getOpportunityWithInactiveProducts(
				inactiveProducts
			);

			for (OpportunityLineItem oppLine : oppInactiveProd) {
				Task newOpportunityTask = new Task(
					RecordTypeId = CALL_RECORD_TYPE_ID,
					Subject = NEW_TASK_SUBJECT,
					Status = NEW_TASK_STATUS,
					Priority = NEW_TASK_PRIORITY,
					Auto_Created__c = true,
					WhatId = oppLine.OpportunityId,
					ActivityDate = Date.today().toStartOfMonth().addMonths(1)
				);
				callTask.add(newOpportunityTask);
			}
			insert callTask;
		}
	}
}
