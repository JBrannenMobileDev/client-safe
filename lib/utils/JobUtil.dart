import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';

class JobUtil {
  static List<Job> getJobsInProgress(List<Job> jobs) {
    DateTime now = DateTime.now();
    DateTime currentDate = DateTime.utc(now.year, now.month, now.day, 0,0,0,0,0);
    List<Job> _jobsInProgress = jobs.where((job) => (!_containsJobStage(JobStage.STAGE_14_JOB_COMPLETE, job.completedStages) && (currentDate.millisecondsSinceEpoch >= job.selectedDate.millisecondsSinceEpoch))).toList();
    _jobsInProgress.sort((job1, job2) => job2.selectedDate?.millisecondsSinceEpoch?.compareTo(job2.selectedDate?.millisecondsSinceEpoch ?? 0) ?? 0);
    return _jobsInProgress;
  }

  static List<Job> getUpComingJobs(List<Job> jobs) {
    DateTime now = DateTime.now();
    DateTime currentDate = DateTime.utc(now.year, now.month, now.day, 0,0,0,0,0);
    List<Job> _jobsInProgress = jobs.where((job) => (job.selectedDate.isAfter(currentDate))).toList();
    _jobsInProgress = _jobsInProgress.where((job) => (!_containsJobStage(JobStage.STAGE_14_JOB_COMPLETE, job.completedStages))).toList();
    _jobsInProgress.sort((job1, job2) => job2.selectedDate?.millisecondsSinceEpoch?.compareTo(job2.selectedDate?.millisecondsSinceEpoch ?? 0) ?? 0);
    return _jobsInProgress;
  }

  static List<Job> getActiveJobs(List<Job> jobs) {
    List<Job> _jobsCompleted = jobs.where((job) => (!_containsJobStage(JobStage.STAGE_14_JOB_COMPLETE, job.completedStages))).toList();
    _jobsCompleted.sort((job1, job2) => job2.selectedDate?.millisecondsSinceEpoch?.compareTo(job2.selectedDate?.millisecondsSinceEpoch ?? 0) ?? 0);
    return _jobsCompleted;
  }

  static List<Job> getJobsCompleted(List<Job> jobs) {
    List<Job> _jobsCompleted = jobs.where((job) => (_containsJobStage(JobStage.STAGE_14_JOB_COMPLETE, job.completedStages))).toList();
    _jobsCompleted.sort((job1, job2) => job2.selectedDate?.millisecondsSinceEpoch?.compareTo(job2.selectedDate?.millisecondsSinceEpoch ?? 0) ?? 0);
    return _jobsCompleted;
  }

  static bool _containsJobStage(String desiredStage, List<JobStage> completedStages) {
    for(JobStage jobStage in completedStages){
      if(jobStage.stage == desiredStage) return true;
    }
    return false;
  }

  static getJobsForStage(List<Job> activeJobs, JobStage stage) {
    List<Job> result = [];
    for(Job job in activeJobs) {
      if(job.stage.stage == stage.stage) {
        result.add(job);
      }
    }
    return result;
  }
}


