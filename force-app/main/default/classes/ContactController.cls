public with sharing class ContactController {
    @AuraEnabled(cacheable = true)
    public static List<Contact> getContacts(String accIds){
        return [SELECT Id, FirstName, LastName, Phone, Email, AccountId FROM Contact WHERE AccountId = :accIds with SECURITY_ENFORCED];
    }
    }