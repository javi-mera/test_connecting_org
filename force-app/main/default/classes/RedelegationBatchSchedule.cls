public with sharing class RedelegationBatchSchedule implements Schedulable {

    public void execute(SchedulableContext schedulableContext) {
        Database.executeBatch(new RedelgationBatch(), 200);
    }

    public static void initializeSchedule() {
        RedelegationBatchSchedule scheduleJob = new RedelegationBatchSchedule();
        String schedule = '0 0 6 ? * * *';
        String jobID = System.schedule('Redelegation Batch', schedule, scheduleJob);
    }

}