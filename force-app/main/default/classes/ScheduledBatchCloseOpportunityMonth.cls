public class ScheduledBatchCloseOpportunityMonth implements Schedulable{
    public void execute(SchedulableContext ctx){
        BatchCloseOpportunityMonth schBatch = new BatchCloseOpportunityMonth();
        Database.executeBatch(schBatch);
    }
}