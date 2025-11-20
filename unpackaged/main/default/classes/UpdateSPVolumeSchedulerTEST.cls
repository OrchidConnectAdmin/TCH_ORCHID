@isTest
public class UpdateSPVolumeSchedulerTEST {
    
    @isTest static void executeTest(){
        
        SchedulableContext sc = null;
        UpdateSPVolumeScheduler tsc = new UpdateSPVolumeScheduler();
        tsc.execute(sc);
         
    }  
    
}