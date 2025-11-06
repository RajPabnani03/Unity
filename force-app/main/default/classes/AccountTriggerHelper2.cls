/**
 * @description Helper class for Account Trigger operations (version 2)
 * CRM-RITM2399335: Lock RTO Release Date once OR is in Complete status
 */
public class AccountTriggerHelper2 {

    private static String jobId;

    /**
     * @description Update RTO Date on Onboarding records
     * @param accIdSet Set of Account IDs
     * @param isRunAsynch Boolean flag to determine async execution
     *
     * Fix: Added Status__c != 'Complete' check to prevent updating RTO Release Date
     * once the OR is completed. This ensures temporary holds don't update the date.
     */
    public static void updateRTODateonOnboarding(Set<Id> accIdSet, Boolean isRunAsynch){
        jobId = '';
        try{
            Boolean asynchPermission = (ClassMethodPermissions__c.getinstance('updateRTODateonOnboarding') != null ?
                                       ClassMethodPermissions__c.getinstance('updateRTODateonOnboarding').Async_Permission__c : false);

            List<Onboarding__c> onbListUpdate = new List<Onboarding__c>();

            for(Onboarding__c onb : OnboardingHelper.getRTOOnboarding(accIdSet)){
                // CRM-RITM2399335: Added check to prevent updating Complete records
                // This locks the RTO Release Date once OR is completed
                if(onb.Status__c != 'Complete'){
                    onb.RTO_Release_Date__c = Date.today();
                    onbListUpdate.add(onb);
                }
            }

            if(!onbListUpdate.isEmpty()){
                if(isRunAsynch == true && asynchPermission == true && Limits.getLimitQueueableJobs() > Limits.getQueueableJobs()){
                    jobID = System.enqueuejob(new AccountAsyncHelper.ProcessAsynchSobject(onbListUpdate,
                                                                                         'AccountTriggerHelper2.updateRTODateonOnboarding',
                                                                                         false, true, false, false, false));
                }
                else {
                    update onbListUpdate;
                }
            }

        }
        catch(Exception ex){
            ExceptionHandleUtility.handleException(ex, 'AccountTriggerHelper2.updateRTODateonOnboarding', jobID);
        }
    }
}
