public class QuoteTriggerHandler {
    
    public static void handleActivitiesAfterInsert(List<Quote> newRecords){
        Map<Id, Id> quoteMap = new Map<Id, Id>();
        for(Quote newQuote : newRecords){
            if(newQuote.Is_Primary__c){
                quoteMap.put(newQuote.OpportunityId, newQuote.Id); 
            }
        }	
        if(!quoteMap.isEmpty()){
            List<Opportunity> oppList = [Select Id, New_Quote__c, Old_Quote__c from Opportunity where Id IN : quoteMap.keySet()];
            Set<Id>otList = new Set<Id>();
            For(Opportunity op : oppList){
                if(op.New_Quote__c!= Null){
                    otList.add(op.New_Quote__c);
                }
            }
            List<Quote>nwOt = [Select Id,Is_Primary__c from Quote where Id IN : otList];
            for(Quote qt:nwOt){
                if(qt.Is_Primary__c != false){
                    qt.Is_Primary__c = false;
                }
            }
            update nwOt;
            for(Opportunity opps : oppList){
                if(opps.New_Quote__c != Null){
                    opps.Old_Quote__c = opps.New_Quote__c;
                    opps.New_Quote__c = quoteMap.get(opps.Id);
                } else{
                    opps.New_Quote__c = quoteMap.get(opps.Id);
                } 
            }    
            if(!oppList.isEmpty() ){
                update oppList;
            }
        }
    }   
    
    public static void handleActivitiesAfterUpdate(List<Quote> newRecords, Map<Id,Quote> oldRec){
        Map<Id,Id> quoteMap = new Map<Id,Id>();
        for(Quote newQuote : newRecords){
            if(newQuote.Is_Primary__c){
                quoteMap.put(newQuote.OpportunityId, newQuote.Id); 
            }
        }
        
        Map<Id,Id> oldMap = new Map<Id,Id>();
        for(Quote newQuote : newRecords){
            if(oldRec.get(newQuote.Id).Is_Primary__c && !newQuote.Is_Primary__c){
                oldMap.put(newQuote.OpportunityId, newQuote.Id);
            }
        }
        
        if(!quoteMap.isEmpty()){
            List<Opportunity> oppList = [Select Id, New_Quote__c from Opportunity where Id IN : quoteMap.keySet()];
            Set<Id> otList = new Set<Id>();
            For(Opportunity op : oppList){
                if(op.New_Quote__c!= Null){
                    otList.add(op.New_Quote__c);
                }
            }
            List<Quote>nwOt = [Select Id,Is_Primary__c from Quote where Id IN:otList];
            for(Quote qt:nwOt){
                if(qt.Is_Primary__c != false){
                    qt.Is_Primary__c = false;
                }
            }
            update nwOt;
            for(Opportunity opps : oppList){
                if(opps.New_Quote__c != Null){
                    opps.Old_Quote__c = opps.New_Quote__c;
                    opps.New_Quote__c = quoteMap.get(opps.Id);
                } else{
                    opps.New_Quote__c = quoteMap.get(opps.Id);
                } 
            }    
            
            if(!oppList.isEmpty() ){
                update oppList;
            }
        }
        
        if(!oldMap.isEmpty()){
            List<Opportunity> oppLists = [Select Id, New_Quote__c, Old_Quote__c from Opportunity where Id IN : oldMap.keySet()];
            Set<Id>otList = new Set<Id>();
            For(Opportunity op : oppLists){
                if(op.Old_Quote__c!= Null){
                    otList.add(op.Old_Quote__c);
                }
            }
            List <Quote> oldQuotes  = [Select Id,Is_Primary__c from Quote where Id IN:otList];
            for(Quote qt : oldQuotes){
                if(qt.Is_Primary__c == false){
                    qt.Is_Primary__c = True;
                }
            }
            update oldQuotes;
            for(Opportunity opps : oppLists){
                opps.New_Quote__c = opps.Old_Quote__c;
                opps.Old_Quote__c = Null;
            }
            if(!oppLists.isEmpty() ){
                update oppLists;
            }
        } 
        
        
    }
}