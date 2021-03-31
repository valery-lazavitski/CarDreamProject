public class BatchCloseOpportunityMonth implements Database.Batchable<sObject>, Schedulable{
    
    private final String STAGE_NAME_CLOSED_LOST = 'Closed Lost';
    private String soqlQuery = '';
    
    public BatchCloseOpportunityMonth(){}
    
    public BatchCloseOpportunityMonth(String soqlQuery){ 
        this.soqlQuery = soqlQuery;
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        if (String.isBlank(soqlQuery)){
            Date startOfMonth = Date.today().toStartOfMonth();
            Date startOfNextMonth = startOfMonth.addMonths(1);
            this.soqlQuery = 'SELECT Id, Name, CloseDate, StageName FROM Opportunity ' +
                'WHERE CloseDate = THIS_MONTH AND IsClosed = false'; 
        }
        return Database.getQueryLocator(this.soqlQuery);
    }
    
    public void execute(Database.BatchableContext bc, List<Opportunity> notClosed){
        List <Opportunity> opportunities = new List<Opportunity>();
        for (Opportunity opp : notClosed){
            if (opp.CloseDate == Date.today()){
                opp.StageName = STAGE_NAME_CLOSED_LOST;

            }
        }
        update opportunities;
    }
    
    public void execute(SchedulableContext ctx){
        Database.executeBatch(this);
    }    
    public void finish(Database.BatchableContext bc){
        
    }
}