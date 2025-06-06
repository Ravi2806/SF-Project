@isTest
public class AccountTriggerHandlerTest {
@isTest
    public static void testSetup1(){
        Account acc = new Account();
        acc.Name = 'Test Run 236';
        acc.Industry = 'Agriculture';
        acc.Type = 'Prospect';
        acc.Ownership = 'Private';
        insert acc;
        acc.Industry = 'Apparel';
        Test.startTest();
        update acc;
        Test.stopTest();
    }
}