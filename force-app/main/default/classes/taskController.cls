public with sharing class taskController {
    @AuraEnabled(cacheable = true)
    public static List<Task> getTaskList(){
        return [Select Id, Subject, Status from Task];
    }
  @AuraEnabled(cacheable=true)
    public static List<Task> getTasksBySubject(String subject) {
        if (String.isNotBlank(subject)) {
            String keyword = '%' + subject + '%';
            return [SELECT Id, Subject, Status FROM Task WHERE Subject LIKE :keyword];
        }else {
            return [SELECT Id, Subject, Status FROM Task];
        }
    }
}