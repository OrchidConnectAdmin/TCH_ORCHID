@isTest
public class UpdateAccountTotalDepositSchedulerTEST {
    
    @isTest static void executeTest(){
        
        SchedulableContext sc = null;
        UpdateAccountTotalDepositScheduler tsc = new UpdateAccountTotalDepositScheduler();
        tsc.execute(sc);
         
    }  
    
}