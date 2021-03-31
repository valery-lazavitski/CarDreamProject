@isTest
public class TestInActiveProductTrigger {
    
    List<Product2> listProducts = new List<Product2>();
    
    @isTest static void TestCreateNewTask(){
        // Insert Product
        Product2 pr = new Product2();
        pr.Name='Product 1';
        pr.isActive=true;
        insert pr;
        
        // Insert Pricebook
        PriceBook2 customPriceBook = new PriceBook2();
        customPriceBook.Name='Custom Pricebook';
        customPriceBook.IsActive=true;
        insert customPriceBook;
        
        // Query Standard Price Books
        Pricebook2 customPriceBookRec=[select Id from Pricebook2 where id=:customPriceBook.Id];
        Id stdPriceBookRecId = Test.getStandardPricebookId();
        
        // Create Standard PriceBookEntry
        PriceBookEntry stdPriceBookEntry = new PriceBookEntry();
        stdPriceBookEntry.Product2Id=pr.Id;
        stdPriceBookEntry.Pricebook2Id=stdPriceBookRecId;
        stdPriceBookEntry.UnitPrice=2000;
        stdPriceBookEntry.IsActive=true;
        insert stdPriceBookEntry;
        
        // Create Custom PriceBookEntry
        PriceBookEntry customPriceBookEntry = new PriceBookEntry();
        customPriceBookEntry.Product2Id=pr.Id;
        customPriceBookEntry.Pricebook2Id=customPriceBookRec.Id;
        customPriceBookEntry.UnitPrice=5000;
        customPriceBookEntry.IsActive=true;
        insert customPriceBookEntry;
        
        // Create Opportunity
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.CloseDate= System.Today();
        opp.StageName='Prospecting';
        insert opp;
        
        // Add product and Pricebook to the particular opportunity using OpportunityLineItem 
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.Id;
        oppLineItem.PricebookEntryId = customPriceBookEntry.Id;
        oppLineItem.UnitPrice = 7000;
        oppLineItem.Quantity = 5;
        insert oppLineItem;
    }

}