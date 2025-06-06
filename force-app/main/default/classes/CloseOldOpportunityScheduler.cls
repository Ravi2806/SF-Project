public class CloseOldOpportunityScheduler implements Schedulable {

    public void execute(SchedulableContext sc) {
        CloseOldOpportunity.invokeflow();
    }
}