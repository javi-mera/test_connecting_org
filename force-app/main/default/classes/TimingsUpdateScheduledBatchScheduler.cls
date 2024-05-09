/**
 * @author - Darya Rykhlik
 * @date - 22 Apr 2024
 * @description - The Batch Scheduler class to schedule the TimingsUpdateScheduledBatch
 */

public class TimingsUpdateScheduledBatchScheduler implements Schedulable {
    public void execute(SchedulableContext schedulableContext) {
        Database.executeBatch(new TimingsUpdateScheduledBatch(), 200);
    }

    public static void initializeSchedule() {
        TimingsUpdateScheduledBatchScheduler scheduleJob = new TimingsUpdateScheduledBatchScheduler();
        String schedule = '0 0 2 ? * * *';
        String jobID = System.schedule('Timings Update', schedule, scheduleJob);
    }
}