@isTest
public class TestInActiveProductTrigger {    
    @isTest static void TestCreateNewTask(){
        // Insert Product
        Product2 pr = new Product2();
        pr.Name='Product 1';
        pr.isActive=true;
        insert pr;

        // Query Standard Price Books
        Id stdPriceBookRecId = Test.getStandardPricebookId();
        
        // Create Standard PriceBookEntry
        PriceBookEntry stdPriceBookEntry = new PriceBookEntry();
        stdPriceBookEntry.Product2Id=pr.Id;
        stdPriceBookEntry.Pricebook2Id=stdPriceBookRecId;
        stdPriceBookEntry.UnitPrice=2000;
        stdPriceBookEntry.IsActive=true;
        insert stdPriceBookEntry;
        
        // Create Opportunity
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.CloseDate= System.Today();
        opp.StageName='Prospecting';
        insert opp;
        
        // Add product and Pricebook to the particular opportunity using OpportunityLineItem 
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.Id;
        oppLineItem.PricebookEntryId = stdPriceBookEntry.Id;
        oppLineItem.UnitPrice = 7000;
        oppLineItem.Quantity = 5;
        insert oppLineItem;

        Test.startTest();
        pr.IsActive = false;
        Update pr;
        Test.stopTest();
        
        List <Task> triggerTestTasks = [SELECT Id, WhatId FROM Task WHERE WhatId = :opp.Id];
        System.debug(triggerTestTasks);
        System.debug(triggerTestTasks.size());
        System.assert(triggerTestTasks.size() > 0, 'Cannot find any new Test Tasks');
    }

}