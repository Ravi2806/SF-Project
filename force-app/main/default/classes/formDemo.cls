public with sharing class formDemo {
    @AuraEnabled
    public static void insertForm(Form_Record__c formRecord) {
        insert formRecord;
    }
    @AuraEnabled(cacheable=true)
    public static List<Form_Record__c> getFormData(){
        return[Select Id, Email__c, City__c, Name from Form_Record__c order by CreatedDate DESC];
    }
}