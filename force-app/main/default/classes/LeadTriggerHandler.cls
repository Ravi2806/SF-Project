public class LeadTriggerHandler {
    
    public static void handleActivitiesBeforeDelete(List<Lead> oldRecord){
        for(Lead leadRecord : oldRecord){
            System.debug(leadRecord.Status);
            if(leadRecord.Status != null && leadRecord.Status == 'Working-Contacted'){
                leadRecord.addError('You cannont delete this lead.Since its status is Working-Contacted');
            }
        }
    }
    
    public static void handleActivitiesAfterInsert(List<Lead> newRecord, Map<ID,Lead> oldMap){
        List<Task> taskListToInsert = new List<Task>();
        for(Lead leadRecord : newRecord){
            if(leadRecord.Status == 'Closed - Converted' && (oldMap == null || (oldMap != null && oldMap.get(leadRecord.Id).Status != 'Closed - Converted')) ){
            Task taskRecord = new Task();
            taskRecord.Priority = 'High';
            taskRecord.OwnerId = leadRecord.OwnerId;
            taskRecord.Description = 'Follow up with the new lead';
            taskRecord.Status = 'Not Started';
            taskRecord.Subject = 'Follow up';
            taskRecord.WhoId = leadRecord.Id;
            taskListToInsert.add(taskRecord);   
            }}
        if(taskListToInsert != null && !taskListToInsert.isEmpty()){
            insert taskListToInsert;
        }
        }

}