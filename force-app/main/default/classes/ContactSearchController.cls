public with sharing class ContactSearchController {
    @AuraEnabled(cacheable = true)
public static List<Contact> searchContacts(String firstName, String lastName, String email) {
    
            String fNamePattern = '%' + firstName + '%';
            String lNamePattern = '%' + lastName + '%';
            String eMailPattern = '%' + email + '%';
        
            String baseQuery = 'SELECT Id, FirstName, LastName, Email FROM Contact';
            List<String> conditions = new List<String>();
        
            if (!String.isBlank(firstName)) {
                conditions.add('FirstName LIKE :fNamePattern');
            }
            if (!String.isBlank(lastName)) {
                conditions.add('LastName LIKE :lNamePattern');
            }
            if (!String.isBlank(email)) {
                conditions.add('Email LIKE :emailPattern');
            }
        
            String whereClause = conditions.isEmpty() ? '' : ' WHERE ' + String.join(conditions, ' OR ');
            String finalQuery = baseQuery + whereClause + ' LIMIT 20';
        
            return Database.query(finalQuery);


            /*String query = 'Select Id, FirstName, LastName, Email from Contact where';
        

            if(!String.isEmpty(firstName)){
                query += 'FirstName LIKE : '%' + firstName + '%'';
            }
            if(!String.isEmpty(lastName)){
                query += 'LastName LIKE : '%' + lastName + '%'';
            }
            if(!String.isEmpty(email)){
                query += 'Email LIKE : '%' + email + '%'';
            }
            
            String finalQuery = conditions.isEmpty() ? '' : String.join(conditionns, ' OR ');

            return Database.query(finalQuery);*/
        }
        @AuraEnabled
        public static Void deleteContacts(List<String> contactIds){
            system.debug('inside deleteContacts');
            List<Contact> conList = [SELECT Id, FirstName, LastName, Email, AccountId FROM Contact WHERE Id IN: contactIds];
            delete conList;
            
}
}