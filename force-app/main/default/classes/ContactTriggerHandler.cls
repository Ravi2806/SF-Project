public class ContactTriggerHandler {
    
    public static void handleActivitiesBeforeInsert(List<Contact> newRecord){
        for(Contact conRecord : newRecord){
            if(conRecord.Accountid == null){
                conRecord.addError('Parent Information is mandatory for contact creation');
            }
        }
    }
    
    public static void handleActivitiesAfterInsertUpdate(List<Contact> newRecord, Map<Id,Contact> oldMap){
     	Set<Id> accIds = new Set<Id>();
        for(Contact conRecord : newRecord){
            if(conRecord.AccountId != Null){
                accIds.add(conRecord.AccountId);
            }
            Contact oldContact = oldMap.get(conRecord.Id);
				if(oldContact.AccountId != null && oldContact.AccountId != conRecord.AccountId){
    			accIds.add(oldContact.AccountId);
}

        }
            Map<Id, Integer> countMap = new Map<Id, Integer>();
        List<AggregateResult> result = [Select AccountId, Count(Id) val from Contact where AccountId in : accIds group by AccountId];
        for(AggregateResult ar : result){
            countMap.put((Id) ar.get('AccountId'), (Integer) ar.get('val'));
        }
       	List<Account> accList = [Select id, Number_of_Related_Contacts__c from Account where id in : countMap.keySet()];
        for(Account accRecord : accList){
            accRecord.Number_of_Related_Contacts__c = countMap.get(AccRecord.Id);
        }
        if(!accList.isEmpty()){
            update accList;
        }  
}
}