@isTest
public class TestSheduledBatchCloseOpportunityMonth {
	
    private static final String CRON_EXP = '0 0 23 * * ?';
    private static final String SOQLQUERY = 'SELECT Id, Name, CloseDate, StageName FROM Opportunity ' +
        'WHERE CloseDate = THIS_MONTH AND IsClosed = false';
    
    @isTest public static void testSheduledBatchNoParameters(){
        List<Opportunity> opptys = new List<Opportunity>();
        opptys.add(new Opportunity(Name = 'Opportunity Next Day', 
                                   CloseDate = Date.today().addDays(1), StageName = 'Prospecting'));
        
        for (Integer i = 0; i < 10; i++){
            Opportunity opps = new Opportunity(Name = 'Opportunity' + i, 
                                              CloseDate = Date.today(), StageName = 'Prospecting');
            opptys.add(opps);            
        }
        Insert opptys;
        
        Test.startTest();        
        System.schedule('Test ScheduleBatch No Parameters', CRON_EXP, new BatchCloseOpportunityMonth()); 
        Test.stopTest();
        
        List<Opportunity> opps =  [SELECT Id FROM Opportunity WHERE Id IN :opptys AND StageName = 'Closed Lost'];       
        System.assertEquals(0, opps.size(), 'Fail in Batch with no parameters');
    }
    
    @isTest public static void testSheduledBatchWithStringParameter(){
        List<Opportunity> opptys = new List<Opportunity>();
        opptys.add(new Opportunity(Name = 'Opportunity Next Day', 
                                   CloseDate = Date.today().addDays(1), StageName = 'Prospecting'));
        
        for (Integer i = 0; i < 10; i++){
            Opportunity opps = new Opportunity(Name = 'Opportunity' + i, 
                                              CloseDate = Date.today(), 
                                              StageName = 'Prospecting');
            opptys.add(opps);            
        }
        Insert opptys;
        
        Test.startTest();        
        System.schedule('Test ScheduleBatch With String Parameter', CRON_EXP, new BatchCloseOpportunityMonth(SOQLQUERY)); 
        Test.stopTest();
        
        List<Opportunity> opps =  [SELECT Id FROM Opportunity WHERE Id IN :opptys AND StageName = 'Closed Lost'];       
        System.assertEquals(0, opps.size(), 'Fail in Batch with String parameter');
    }
}