/**
 * @description Helper class for Onboarding object operations
 * CRM-RITM2399335: Lock RTO Release Date once OR is in Complete status
 */
public class OnboardingHelper {

    /**
     * @description Get Onboarding records with NULL RTO Release Date, excluding Complete status
     * @param accIdSet Set of Account IDs to filter
     * @return List of Onboarding records
     *
     * Fix: Added Status__c != 'Complete' to prevent updating RTO Release Date
     * once the OR is completed, even during temporary holds
     */
    public static List<Onboarding__c> getRTOOnboarding(Set<Id> accIdSet){
        return [SELECT Id, Name, Account_Name__c, RTO_Release_Date__c, Status__c
                FROM Onboarding__c
                WHERE Account_Name__c IN :accIdSet
                AND RTO_Release_Date__c = NULL
                AND Status__c != 'Complete'];
    }
}
