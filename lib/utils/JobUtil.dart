import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/JobStage.dart';

class JobUtil {
  static List<Job> getJobsInProgress(List<Job> jobs) {
    List<Job> _jobsInProgress = jobs.where((job) => (_containsJobStage(JobStage.STAGE_4_PROPOSAL_SIGNED, job.completedStages))).toList();
    _jobsInProgress.sort((job1, job2) => job2.selectedDate.millisecondsSinceEpoch.compareTo(job2.selectedDate.millisecondsSinceEpoch));
    return _jobsInProgress;
  }

  static List<Job> getLeads(List<Job> jobs) {
    List<Job> _jobsInProgress = jobs.where((job) => (_containsJobStage(JobStage.STAGE_1_INQUIRY_RECEIVED, job.completedStages) && !_containsJobStage(JobStage.STAGE_4_PROPOSAL_SIGNED, job.completedStages))).toList();
    _jobsInProgress.sort((job1, job2) => job2.selectedDate.millisecondsSinceEpoch.compareTo(job2.selectedDate.millisecondsSinceEpoch));
    return _jobsInProgress;
  }

  static List<Job> getJobsCompleted(List<Job> jobs) {
    List<Job> _jobsCompleted = jobs.where((job) => (_containsJobStage(JobStage.STAGE_10_PAYMENT_RECEIVED, job.completedStages))).toList();
    _jobsCompleted.sort((job1, job2) => job2.selectedDate.millisecondsSinceEpoch.compareTo(job2.selectedDate.millisecondsSinceEpoch));
    return _jobsCompleted;
  }

  static bool _containsJobStage(String desiredStage, List<JobStage> completedStages) {
    for(JobStage jobStage in completedStages){
      if(jobStage.stage == desiredStage) return true;
    }
    return false;
  }
}


