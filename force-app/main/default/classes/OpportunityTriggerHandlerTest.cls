@isTest
public class OpportunityTriggerHandlerTest {
@isTest
    public static void testSetup(){
        Account acc = new Account();
        acc.name = 'Test Account';
        insert acc;
        List<Opportunity> newOpps = new List<Opportunity>();
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc != null ? acc.Id :NULL;
        opp.Name = 'Test run';
        opp.CloseDate = Date.Today();
        opp.StageName = 'Prospecting';
        opp.Amount = 50;
        opp.Probability = 5;
        newOpps.add(opp);
        
        Opportunity opp3 = new Opportunity();
        opp3.AccountId = acc != null ? acc.Id :NULL;
        opp3.Name = 'Test run 3';
        opp3.CloseDate = Date.Today();
        opp3.StageName = 'Closed Won';
        newOpps.add(opp3);
        
        Opportunity opp2 = new Opportunity();
        opp2.AccountId = acc != null ? acc.Id :NULL;
        opp2.Name = 'Test run 2';
        opp2.StageName = 'Prospecting';
        opp2.CloseDate = Date.Today();
        newOpps.add(opp2);
        
        Test.startTest();
        insert newOpps;
        opp.StageName = 'Closed Won';
        update opp;
        Test.stopTest();
    }
}


/*Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
        User us = new User();
        us.FirstName = 'Test';
        us.LastName = 'User';
        us.Username = 'testuser12453@test.com';
        us.Email = 'testuser123@test.com';
        us.Alias = 'tuser';
        us.CommunityNickname = 'testuser123'; 
        us.TimeZoneSidKey = 'America/New_York';
        us.LocaleSidKey = 'en_US';
        us.EmailEncodingKey = 'UTF-8';
        us.LanguageLocaleKey = 'en_US';
        us.ProfileId = prof.Id;
        insert us;
        
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.Name = 'Test run';
        opp.CloseDate = Date.Today();
        opp.StageName = 'Prospecting';
        opp.Reviewer__c = Null;
        insert opp;
        
        Acc_Team__c accTeam = new Acc_Team__c();
        accTeam.Account__c = acc.Id;
        accTeam.IsActive__c = True;
        accTeam.Role__c = 'Reviewer';
        accTeam.QA_User__c = us.Id ;
        insert accTeam;
        
        Test.startTest();
        opp.Reviewer__c = accTeam.QA_User__c;
        update opp;
        Test.stopTest();*/