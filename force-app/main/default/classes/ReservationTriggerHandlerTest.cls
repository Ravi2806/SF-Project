@isTest
public class ReservationTriggerHandlerTest {
	@isTest
    public static void testhandleActivitiesBeforeUpdateInsert(){
        Resource__c res = new Resource__c();
        res.Name = 'Test1';
        insert res;
        
        Reservation__c rev1 = new Reservation__c();
        rev1.Name = 'Existing Reservation';
        rev1.Status__c = 'Confirmed';
        rev1.Start_DateTime__c = DateTime.now().addHours(2);
        rev1.End_DateTime__c = DateTime.now().addHours(8);
        rev1.Resource__c = res.Id;
        insert rev1;
        
        Reservation__c rev2 = new Reservation__c();
        rev2.Name = 'New Reservation';
        rev2.Status__c = 'Confirmed';
        rev2.Start_DateTime__c = DateTime.now().addHours(6);
        rev2.End_DateTime__c = DateTime.now().addHours(15);
        rev2.Resource__c = res.Id;
        
        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            insert rev2;
        }
        catch(Exception e){
            exceptionThrown = true;
            Boolean expectedExceptionThrown = (e.getmessage().contains('Reservation overlaps with another confirmed reservation.'));
            System.assertEquals(true, expectedExceptionThrown, e.getmessage());                               
        }
        Test.stopTest(); 
    }
    
    @isTest
    public static void testhandleActivitiesAfterUpdateInsertDeleteUndelete1(){
        Resource__c res = new Resource__C();
        res.Name = 'Test';
        res.Max_Concurrent_Bookings__c = 4;
        res.Current_Status__c = 'Available';
        insert res;
        
        List<Reservation__c> revList = new List<Reservation__c>();
        for(Integer i = 1; i <= 16; i = i+3){
        Reservation__c rev = new Reservation__c();
        rev.Name = 'Reservation No. -' + i;
        rev.Status__c = 'Confirmed';
        rev.Start_DateTime__c = DateTime.now().addHours(2 + i);
        rev.End_DateTime__c = DateTime.now().addHours(4+ i);
        rev.Resource__c = res.Id;
            revList.add(rev);
        }
        test.startTest();
        insert revList;
        test.stopTest();
        
        List<Resource__c> resList = [Select Id, Max_Concurrent_Bookings__c, Current_Status__c from Resource__c where Id = : res.Id ];
        	System.assertEquals('Overbooked', resList[0].Current_Status__c);
        
    }
    
        @isTest
    public static void testhandleActivitiesAfterUpdateInsertDeleteUndelete2(){
        Resource__c res = new Resource__C();
        res.Name = 'Test';
        res.Max_Concurrent_Bookings__c = 1;
        res.Current_Status__c = 'Overbooked';
        insert res;
        
        Reservation__c rev1 = new Reservation__c();
        rev1.Name = 'Existing Reservation';
        rev1.Status__c = 'Pending';
        rev1.Start_DateTime__c = DateTime.now().addHours(2);
        rev1.End_DateTime__c = DateTime.now().addHours(4);
        rev1.Resource__c = res.Id;
        
         Reservation__c rev2 = new Reservation__c();
        rev2.Name = 'Existing Reservation';
        rev2.Status__c = 'Confirmed';
        rev2.Start_DateTime__c = DateTime.now().addHours(2);
        rev2.End_DateTime__c = DateTime.now().addHours(4);
        rev2.Resource__c = res.Id;
        
       test.startTest();
        insert rev1;
        insert rev2;
        rev1.Status__c = 'Cancelled';
        update rev1;
        rev2.Status__c = 'Cancelled';
        update rev2;
        test.stopTest();
        
         List<Resource__c> resList = [Select Id, Max_Concurrent_Bookings__c, Current_Status__c from Resource__c where Id = : res.Id ];
        	System.assertEquals('Available', resList[0].Current_Status__c);
    }
    
    
}