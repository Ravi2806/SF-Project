public class ReservationTriggerHandler {
    
    public static void handleActivitiesBeforeUpdateInsert(List<Reservation__c> newRecord){
        Map<Id, List<Reservation__c>> newReservation = new Map<Id, List<Reservation__c>>();
        Set<Id> revIds = new Set<Id>();
        for(Reservation__c revRecord : newRecord){
            if(revRecord.Status__c == 'Confirmed' && revRecord.Start_DateTime__c != Null && revRecord.End_DateTime__c != Null && revRecord.Resource__c != Null){
                if(!newReservation.containsKey(revRecord.Resource__c)){
                    revIds.add(revRecord.Id);
                    newReservation.put(revRecord.Resource__c, new List<Reservation__c>());
                }
                newReservation.get(revRecord.Resource__c).add(revRecord);
            }
        }
        
        List<Reservation__c> oldreservationRecords = [Select Id, Status__c, Start_DateTime__c, End_DateTime__c, Resource__c from Reservation__c where Status__c = 'Confirmed' AND Resource__c IN : newReservation.keySet() AND Id NOT IN : revIds];
        for(Reservation__c oldRecords : oldreservationRecords){
            for(Reservation__c revRecords : newReservation.get(oldRecords.Resource__c)){
                if(revRecords.Start_DateTime__c < oldRecords.End_DateTime__c && revRecords.End_DateTime__c > oldRecords.Start_DateTime__c){
                    revrecords.addError('Reservation overlaps with another confirmed reservation.');
                }
            }
        }
    }
    
    
    	public static void handleActivitiesAfterUpdateInsertDeleteUndelete(List<Reservation__c> newRecord, Map<Id, Reservation__c> oldMap){
            Set<Id> revIds = new Set<Id>();
            for(Reservation__c revRecord : newRecord){
                if(revRecord.Status__c == 'Confirmed' && revRecord.Resource__c != Null){
                    revIds.add(revRecord.Resource__c);
                }
            }
                if(oldMap != Null){
                    for (Reservation__c oldReservations : oldMap.values()){
                if(oldReservations != null && oldReservations.Status__c == 'Confirmed' && oldReservations.Resource__c != Null){
                    revIds.add(oldReservations.Resource__c);
                }
            }
         } 
            if(revIds.isEmpty()){
                return;
            }
        Map<Id, Integer> countMap = new Map<Id, Integer>();
        List<AggregateResult> reservationRecords = [Select Count(Id) val, Resource__c from Reservation__c where Status__c = 'Confirmed'AND Resource__c IN : revIds group by Resource__c];
            for(AggregateResult ar : reservationRecords){
                countMap.put((Id) ar.get('Resource__c'), (Integer) ar.get('val'));
            }
            
        List<Resource__c> resourceRecords = [Select Id, Current_Status__c, Max_Concurrent_Bookings__c from Resource__c where Id In : revIds];
            for(Resource__c resRecords : resourceRecords){
                Integer confirmedCount = countMap.get(resRecords.Id);
					confirmedCount = (confirmedCount == null) ? 0 : confirmedCount;
                if(resRecords.Max_Concurrent_Bookings__c <= confirmedCount){
                    resRecords.Current_Status__c = 'Overbooked';
                }else if(confirmedCount >= 1){
                    resRecords.Current_Status__c = 'Booked';
                }else{
                    resRecords.Current_Status__c = 'Available';
                }
            }
            if (!resourceRecords.isEmpty()) {
       			 update resourceRecords;
            }
      }
}