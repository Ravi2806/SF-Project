public class CloseOldOpportunity {

    public static void invokeflow(){
		 Map<String, Object> inputParams = new Map<String, Object>();
        Flow.Interview.Opportnuties_Stage_Name_Updation flow = new Flow.Interview.Opportnuties_Stage_Name_Updation(inputParams);
        flow.start();
        
    }
}