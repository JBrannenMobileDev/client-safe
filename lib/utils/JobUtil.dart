import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';

import '../models/Contract.dart';

class JobUtil {
  static List<Job> getJobsInProgress(List<Job> jobs) {
    DateTime now = DateTime.now();
    DateTime currentDate = DateTime.utc(now.year, now.month, now.day, 0,0,0,0,0);
    List<Job> _jobsInProgress = jobs.where((job) => (!containsJobStage(JobStage.STAGE_14_JOB_COMPLETE, job.completedStages!) && (currentDate.millisecondsSinceEpoch >= job.selectedDate!.millisecondsSinceEpoch!))).toList();
    _jobsInProgress.sort((job1, job2) => job2.selectedDate?.millisecondsSinceEpoch.compareTo(job2.selectedDate?.millisecondsSinceEpoch ?? 0) ?? 0);
    return _jobsInProgress;
  }

  static List<Job> getUpComingJobs(List<Job> jobs) {
    DateTime now = DateTime.now();
    DateTime currentDate = DateTime.utc(now.year, now.month, now.day, 0,0,0,0,0);
    List<Job> _jobsInProgress = jobs.where((job) => (job.selectedDate != null && job.selectedDate!.isAfter(currentDate))).toList();
    _jobsInProgress = _jobsInProgress.where((job) => (!containsJobStage(JobStage.STAGE_14_JOB_COMPLETE, job.completedStages!))).toList();
    _jobsInProgress.sort((job1, job2) => job2.selectedDate?.millisecondsSinceEpoch.compareTo(job2.selectedDate?.millisecondsSinceEpoch ?? 0) ?? 0);
    return _jobsInProgress;
  }

  static List<Job> getActiveJobs(List<Job> jobs) {
    List<Job> _jobsCompleted = jobs.where((job) => (!containsJobStage(JobStage.STAGE_14_JOB_COMPLETE, job.completedStages!))).toList();
    _jobsCompleted.sort((job1, job2) => job2.selectedDate?.millisecondsSinceEpoch.compareTo(job2.selectedDate?.millisecondsSinceEpoch ?? 0) ?? 0);
    return _jobsCompleted;
  }

  static List<Job> getJobsCompleted(List<Job> jobs) {
    List<Job> _jobsCompleted = jobs.where((job) => (containsJobStage(JobStage.STAGE_14_JOB_COMPLETE, job.completedStages!))).toList();
    _jobsCompleted.sort((job1, job2) => job2.selectedDate?.millisecondsSinceEpoch.compareTo(job2.selectedDate?.millisecondsSinceEpoch ?? 0) ?? 0);
    return _jobsCompleted;
  }

  static bool containsJobStage(String desiredStage, List<JobStage> completedStages) {
    for(JobStage jobStage in completedStages){
      if(jobStage.stage == desiredStage) return true;
    }
    return false;
  }

  static getJobsForStage(List<Job> activeJobs, JobStage stage) {
    List<Job> result = [];
    for(Job job in activeJobs) {
      if(job.stage!.stage! == stage.stage) {
        result.add(job);
      }
    }
    return result;
  }

  static List<Contract> getJobsWithSignedContracts(List<Job> jobs) {
    List<Contract> signedContracts = [];
    for(Job loopJob in jobs) {
      for(Contract loopContract in loopJob.proposal?.contracts ?? []) {
        if(loopContract.signedByClient ?? false) {
          signedContracts.add(loopContract);
        }
      }
    }
    return signedContracts;
  }

  static List<Contract> getJobsWithUnsignedContracts(List<Job> jobs) {
    List<Contract> unsignedContracts = [];
    for(Job loopJob in jobs) {
      for(Contract loopContract in loopJob.proposal?.contracts ?? []) {
        if(!(loopContract.signedByClient ?? false)) {
          unsignedContracts.add(loopContract);
        }
      }
    }
    return unsignedContracts;
  }

  static getJobsWithQuestionnaires(List<Job> jobs) {
    return jobs.where((job) => job.proposal != null && job.proposal?.questionnaires != null && job.proposal!.questionnaires!.isNotEmpty).toList();
  }

  static Future<Job?> getJob(Contract contract) async {
    List<Job> allJobs = await JobDao.getAllJobs();
    for(Job loopJob in allJobs) {
      for(Contract loopContract in loopJob.proposal!.contracts ?? []) {
        if(loopContract.documentId == contract.documentId) {
          return loopJob;
        }
      }
    }
    return null;
  }
}


