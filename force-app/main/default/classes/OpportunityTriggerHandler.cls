public class OpportunityTriggerHandler {
    
    public static void handleActivitiesBeforeUpdate(List<Opportunity> newRecords){
			  Set<Id> accIds = new Set<Id>();
        for(Opportunity opp : newRecords){
            if(opp.AccountId != Null && opp.StageName == 'Closed Won'){
                accIds.add(opp.AccountId);
            }
        }
        
        if(!accIds.isEmpty()){
            List<Acc_Team__c> accountMember = [Select Id, Account__c,IsActive__c,QA_User__c,Role__c from Acc_Team__c where Account__c in : accIds];
            Map<Id,String> userDetails = new map<Id,String>();
            for(Acc_Team__c accTeam : accountMember){
                if(accTeam.Id != null && accTeam.Role__c == 'Reviewer' && accTeam.IsActive__c){
                    userDetails.put(accTeam.Account__c, accTeam.QA_User__c);
                }

            }
            for(Opportunity opp : newRecords){
                if(opp.AccountId != Null && userDetails.containsKey(opp.AccountId) && opp.StageName == 'Closed Won'){
                    opp.Reviewer__c = userDetails.get(opp.AccountId);
                }
            }
           /* if(!oppList.isEmpty() && oppList.size() >0){
                update oppList;
            }*/
            
        }
    }
        /*public static void handleActivitiesBeforeUpdate(List<Opportunity> newRecords, Map<Id,Opportunity> oldMap){
			for(Opportunity newOpp : newRecords){
                if(oldMap.get(newOpp.Id).StageName != newOpp.StageName){
                    if(newOpp.ExpectedRevenue != null){
                        newOpp.Amount = newOpp.Probability * newOpp.ExpectedRevenue;
                    }
                }
            }
        }*/
    
    
    /*public static void handleActivitiesAfterUpdate(List<Opportunity> newRecord){
      List<Task> taskListToInsert = new List<Task>();
        
        for(Opportunity opp : newRecord){
            if(opp.StageName == 'Closed Won'){
                Task taskRecord = new Task();
                taskRecord.Priority = 'High';
                taskRecord.OwnerId = opp.OwnerId;
                taskRecord.Description = 'Please split the revenue amongst the team members';
                taskRecord.Status = 'Not Started';
                taskRecord.Subject = 'Split Revenue';
                taskRecord.WhatId = opp.Id;
                taskListToInsert.add(taskRecord);
            }
        }
        if(!taskListToInsert.isEmpty()){
            insert taskListToInsert;
        }
        
        
    }*/
    
   /* public static void handleActivitiesAfterInsertUpdate(List<Opportunity> newRecord){
        Set<Id> accIds = new Set<Id>();
        for(Opportunity opp : newRecord){
            if(opp.AccountId != null){
                accIds.add(opp.AccountId);
            }
        }
       		List<Opportunity> OppList = [SELECT Id, AccountId, IsClosed, StageName FROM Opportunity where AccountId IN : accIds];
        	
 			List<Id> closedWonOpportunityAccIds = new List<Id>();
            List<Id> openOpportunityAccIds = new List<Id>();
        for(Opportunity opps : OppList){
            if(opps.IsClosed){
                closedWonOpportunityAccIds.add(opps.Id);
            }else{
                openOpportunityAccIds.add(opps.Id);
            }
            
        }
        	Integer a = 0;
        	Integer b = 0;
         if (!closedWonOpportunityAccIds.isEmpty()) {
       AggregateResult ar = [SELECT COUNT(Id) val FROM Opportunity WHERE Id IN :closedWonOpportunityAccIds];
			 a = (Integer) ar.get('val');
    }

    elseif (!openOpportunityAccIds.isEmpty()) {
        AggregateResult ar = [SELECT COUNT(Id) val FROM Opportunity WHERE Id IN :openOpportunityAccIds];
        	b = (Integer) ar.get('val');
    }
        List<Account> accountToUpdate = new List<Account>();
		 List<Account> accounts = [SELECT Id, Closed_Opportunities_Count__c, Open_Opportunities_Count__c FROM Account WHERE Id IN :accIds];

        for (Account acc : accounts) {
            acc.Closed_Opportunities_Count__c = a;
        	acc.Open_Opportunities_Count__c = b;
      		  accountToUpdate.add(acc);
   }
        if(accountToUpdate.size() > 0){
            Update accountToUpdate;
        }
        
        }*/
    

   /* public static void handleActivitiesAfterInsertUpdate(List<Opportunity> newRecord){
       Map<Id,String> countStageOfOpportunity = new Map<Id,String>();
        
        for(Opportunity opp : newRecord){
            if(opp.AccountId != null && opp.StageName != null){
                countStageOfOpportunity.put(opp.AccountId,opp.StageName);
            }
        }
       Map<Id, Integer> openOpportunities = new Map<Id, Integer>();
       Map<Id, Integer> closedOpportunities = new Map<Id, Integer>();

List<AggregateResult> results =  [SELECT AccountId, COUNT(Id), IsClosed FROM Opportunity WHERE AccountId IN :countStageOfOpportunity.keySet() GROUP BY AccountId, IsClosed];



    }
    */
    /*public static void handleActivitiesAfterInsertUpdate(List<Opportunity> newRecord){
        
        Map<Id,String> closedOpportunities = new Map<id,String>();
        Map<Id,String> openOpportunities = new Map<id,String>();
        Set<Id> accIds = new Set<Id>();
    	for (Opportunity opps : newRecord) {
       	 if (opps.AccountId != null) {
            accIds.add(opps.AccountId);
         }
        }
        List<Opportunity> OppList = [SELECT Id, AccountId, IsClosed, StageName FROM Opportunity where AccountId IN : accIds];
       		 for(Opportunity opp : oppList){
            	if(opp.AccountId != null){
               	 	if(opp.IsClosed){
                    closedOpportunities.put(opp.AccountId,opp.StageName);
                	}else{
                    openOpportunities.put(opp.AccountId,opp.StageName);
                }
            }
        }   
      System.debug(closedOpportunities);
        List<Account> accToUpdate = [Select id,Closed_Opportunities_Count__c, Open_Opportunities_Count__c FROM Account where Id in : accIds];
        for (Account acc : accToUpdate) {
            acc.Closed_Opportunities_Count__c = closedOpportunities.keyset().size();
        	acc.Open_Opportunities_Count__c = openOpportunities.keyset().size();
   }
        
        if(accToUpdate.size() > 0){
            Update accToUpdate;
        }
    }*/
    

/*public static void handleActivitiesAfterInsertUpdate(List<Opportunity> newRecord){
        
        Map<Id,Integer> closedOpportunities = new Map<id,Integer>();
        Map<Id,Integer> openOpportunities = new Map<id,Integer>();
        Set<Id> accIds = new Set<Id>();
    	for (Opportunity opps : newRecord) {
       	 if (opps.AccountId != null) {
            accIds.add(opps.AccountId);
         }
        }
        List<Opportunity> OppList = [SELECT Id, AccountId, IsClosed, StageName FROM Opportunity where AccountId IN : accIds];
       		 for(Opportunity opp : oppList){
            	if(opp.AccountId != null){
               	 	if(opp.IsClosed){
                        	if(closedOpportunities.containsKey(opp.AccountId)){
                    	closedOpportunities.put(opp.AccountId,closedOpportunities.get(opp.AccountId)+1);
                			}else{
                    	closedOpportunities.put(opp.AccountId,1);
                    		}
                    }
                    	else{
                        	if(openOpportunities.containsKey(opp.AccountId)){
                        openOpportunities.put(opp.AccountId,openOpportunities.get(opp.AccountId)+1);  
                            }else{
                        openOpportunities.put(opp.AccountId,1);        
                            }
                    } 
                }
            }  

        List<Account> accToUpdate = [Select id,Closed_Opportunities_Count__c, Open_Opportunities_Count__c FROM Account where Id in : accIds];
        for (Account acc : accToUpdate) {
            acc.Closed_Opportunities_Count__c = closedOpportunities.get(acc.Id);
        	acc.Open_Opportunities_Count__c = openOpportunities.get(acc.Id);
   }
        if(accToUpdate.size() > 0){
            Update accToUpdate;
        }
    }*/
}