public with sharing class Product2TriggerHandler {

    private Boolean m_isExecuting = false;

    public Product2TriggerHandler(){}

    public Product2TriggerHandler(Boolean isExecuting) {
        m_isExecuting = isExecuting;
    }

    public void OnAfterUpdate(Product2[] triggerProducts){
        List<Product2> inActiveProducts = [SELECT Id, Name FROM Product2 
            WHERE Id IN :triggerProducts AND IsActive = FALSE];

        if(inActiveProducts.size()>0){
            final Id CALL_RECORD_TYPE_ID = [SELECT Id, Name FROM RecordType 
            WHERE Name = 'Call' limit 1].Id;
    
            List<Task> callTask = new List<Task>();    
        
            List<OpportunityLineItem> oppInactiveProd = [SELECT Id, Name, 
                OpportunityId, Product2Id FROM OpportunityLineItem 
                WHERE Product2Id IN :inActiveProducts];
    
            for (OpportunityLineItem oppLine : oppInactiveProd){
                Task newOpportunityTask = new Task(RecordTypeId = CALL_RECORD_TYPE_ID, 
                    Subject = 'Old model deal!!!', Status = 'New',
                    Auto_Created__c = TRUE, ActivityDate = Date.today().toStartOfMonth().addMonths(1), 
                    Priority = 'High', WhatId = oppLine.OpportunityId);
                callTask.add(newOpportunityTask);
            }
            Insert callTask;
        }
    }

    public Boolean IsTriggerContext{
        get{return m_isExecuting;}
    }
}