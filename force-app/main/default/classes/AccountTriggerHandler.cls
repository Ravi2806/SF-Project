public class AccountTriggerHandler {
    
    public static void handleActivitiesBeforeUpdate(List<Account> newRecord, Map<id,Account> oldMap){
        
       for(Account accRecord : newRecord){
            if(accRecord.Industry == 'Agriculture' && accRecord.Type == 'Prospect'){
                if(oldMap.get(accRecord.id).Ownership != accRecord.Ownership && accRecord.Ownership == 'Private'){
                    accRecord.addError('Ownership cannot be modified');
                }
            }
        }
    }
    
  public static void handleActivitiesBeforeInsertUpdate(List<Account> newRecord){
        for(Account accRecord : newRecord){
            if(accRecord.AnnualRevenue != Null){
            	if(accRecord.AnnualRevenue >= 0 && accRecord.AnnualRevenue < 1000){
                accRecord.Status__c = 'Low';
            	}else if(accRecord.AnnualRevenue >= 1000 && accRecord.AnnualRevenue < 10000 ){
                accRecord.Status__c = 'Medium';
            	}else if(accRecord.AnnualRevenue >= 10000){
                accRecord.Status__c = 'High';
                }
			}else{
				accRecord.Status__c = Null;
				}
			}
      	for(Account accRecord : newrecord){
            if(accRecord.US_Number__c != Null && accRecord.US_Number__c.length() == 10){
                String usFormat = accRecord.US_Number__c;
                accRecord.US_Number__c = '+1 (' + usFormat.subString(0,3) + ') ' + usFormat.subString(3,6) + '-' + usFormat.subString(6,10);
            }else if (accRecord.US_Number__c.length() != 17) {
            accRecord.addError('Enter a valid 10-digit number.');
            }
      }
        }
    
    
    /*public static void handleActivitiesAfterUpdate(List<Account> newRecord, Map<id, Account> oldMap){
        Map<id, String> accToWebsiteMap = new Map<id, String>();
        for(Account accRecord : newRecord){
            if(oldMap.get(accRecord.id).Website != accRecord.Website){
                accToWebsiteMap.put(accRecord.id, accRecord.Website);
                
            }
        }
        
        if(accToWebsiteMap.keyset().size() > 0){
            List<Contact> addConToUpdate = new List<Contact>();
            List<Contact> conRecords = [Select id,Website__c, Accountid from Contact where Accountid in : accToWebsiteMap.keyset()];
            for(Contact con : conRecords){
                if(accToWebsiteMap.containskey(con.AccountId)){
                    con.Website__c = accToWebsiteMap.get(con.AccountId);
                    addConToUpdate.add(con);
                }
            }
            
            
        }
    }
    
    public static void handleActivitiesAfterInsert(List<Account> newRecord){
        
        List<Contact> conList = new List<Contact>();
        for(Account accRecord : newRecord){
            if(accRecord.Create_N_Contacts__c != null){
                for(Integer i = 0; i < accRecord.Create_N_Contacts__c; i++){
                Contact con = new Contact();
                con.LastName = accRecord.Name + i;
                con.AccountId = accRecord.Id;  
                    conList.add(con);
                } 
            }
        }
        if(!conList.isEmpty()){
           insert conList; 
        }
    }*/
   /* public static void handleActivitiesAfterInsertUpdate(List<Account> newRecord){
        Set<Id> accIds = new Set<Id>();
        for(Account accRecord : newRecord){
            if(accRecord.Id != Null && accRecord.Create_Contact__c){
                accIds.add(accrecord.Id);
            }
        }
        if(!accIds.isEmpty()){
            Map<Id, Set<String>> existingContacts = new Map<Id, Set<String>>();
            List<Contact> conList = [Select Id, AccountId, FirstName, Phone from Contact where AccountId in : accIds];
            for(Contact con : conList){
                String uniqueKey = con.FirstName + '-' + con.Phone;
                if(!existingContacts.containsKey(con.AccountId)){
                    existingContacts.put(con.AccountId, new Set<String>());
                }
                	existingContacts.get(con.AccountId).add(uniqueKey);
                
            }
            List<Contact> conLists = new List<Contact>();
            for(Account accRecord : newRecord){
                if(accRecord.Id != Null && accrecord.Create_Contact__c){
                    String newUniqueKey = accrecord.Name + '-' + accrecord.Phone;
                if(!existingContacts.containsKey(accrecord.Id) || !existingContacts.get(accrecord.Id).contains(newUniqueKey)){
                    Contact conRecord = new Contact();
                    conRecord.FirstName = accRecord.Name;
                    conRecord.LastName = 'Contact';
                    conRecord.Phone = accrecord.Phone;
                    conRecord.AccountId = accRecord.Id;
                    conLists.add(conRecord); 
                }
                }
            }
            if(!conLists.isEmpty()){
                insert conLists;
            }
        }
    }*/
    
}