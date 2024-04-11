import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/utils/JobUtil.dart';

import '../../../models/Job.dart';
import '../../../models/JobStage.dart';

class IncomeDao {
  static Future<double> getIncomeForYear(int year) async {
    double result = 0;
    List<Job> allJobsForSelectedYear = filterJobsForYear((await JobDao.getAllJobs()) ?? [], year);
    List<Job> jobsWithoutInvoiceThatAreComplete = filterJobsWithoutInvoiceThatAreComplete(allJobsForSelectedYear);
    List<Job> jobsWithoutInvoiceThatAreNotCompleteWithJustDepositMarkedAsReceived = filterJobsWithoutInvoiceThatAreNotCompleteWithJustDepositMarkedAsReceived(allJobsForSelectedYear);
    List<Job> jobsWithoutInvoiceThatAreNotCompleteButHavePaymentReceivedStageChecked = filterJobsWithoutInvoiceThatAreNotCompleteButHavePaymentReceivedStageChecked(allJobsForSelectedYear);
    List<Job> jobsWithInvoiceAndJustDepositPaid = filterJobsWithInvoiceAndJustDepositPaid(allJobsForSelectedYear);
    List<Job> jobsWithInvoiceAndInvoicePaid = filterJobsWithInvoiceAndInvoicePaid(allJobsForSelectedYear);

    for(Job job in jobsWithoutInvoiceThatAreComplete) {
      if(job.invoice == null && JobUtil.containsJobStage(JobStage.STAGE_14_JOB_COMPLETE, job.completedStages!) && job.priceProfile != null) {
        result = result + (job.priceProfile!.flatRate ?? 0.0);
      }
    }

    for(Job job in jobsWithoutInvoiceThatAreNotCompleteWithJustDepositMarkedAsReceived) {
      if(job.invoice == null &&
          !JobUtil.containsJobStage(JobStage.STAGE_14_JOB_COMPLETE, job.completedStages!) &&
          !JobUtil.containsJobStage(JobStage.STAGE_9_PAYMENT_RECEIVED, job.completedStages!) &&
          JobUtil.containsJobStage(JobStage.STAGE_5_DEPOSIT_RECEIVED, job.completedStages!) &&
          job.priceProfile != null
      ) {
        result = result + (job.priceProfile!.deposit ?? 0.0)
      }
    }

    return result;
  }

  static Future<double> getIncomeForYearAndMonth(int year, int month) async {
    double result = 0;
    List<Job> allJobsForSelectedYearAndMonth = filterJobsForYearAndMonth((await JobDao.getAllJobs()) ?? [], year, month);

    return result;
  }

  static List<Job> filterJobsForYear(List<Job> jobs, int year) {
    List<Job> result = [];
    for(Job job in jobs) {
      if(job.depositReceivedDate != null && job.paymentReceivedDate == null && job.depositReceivedDate!.year == year) {
        result.add(job);
      } else if(job.paymentReceivedDate != null && job.paymentReceivedDate!.year == year) {
        result.add(job);
      } else if(job.invoice != null && job.invoice!.depositPaid! && job.invoice!.depositPaidDate != null && job.invoice!.depositPaidDate!.year == year) {
        result.add(job);
      } else if(job.invoice != null && job.invoice!.invoicePaid! && job.invoice!.depositPaidDate != null && job.invoice!.depositPaidDate!.year == year) {
        result.add(job);
      }
    }
    return result;
  }

  static List<Job> filterJobsForYearAndMonth(List<Job> jobs, int year, int month) {
    List<Job> result = [];
    for(Job job in jobs) {
      if(job.depositReceivedDate != null && job.paymentReceivedDate == null && job.depositReceivedDate!.year == year && job.depositReceivedDate!.month == month) {
        result.add(job);
      } else if(job.paymentReceivedDate != null && job.paymentReceivedDate!.year == year && job.depositReceivedDate!.month == month) {
        result.add(job);
      } else if(job.invoice != null && job.invoice!.depositPaid! && job.invoice!.depositPaidDate != null && job.invoice!.depositPaidDate!.year == year && job.depositReceivedDate!.month == month) {
        result.add(job);
      } else if(job.invoice != null && job.invoice!.invoicePaid! && job.invoice!.depositPaidDate != null && job.invoice!.depositPaidDate!.year == year && job.depositReceivedDate!.month == month) {
        result.add(job);
      }
    }
    return result;
  }

  static List<Job> filterJobsWithoutInvoiceThatAreComplete(List<Job> jobs) {
    List<Job> result = [];
    for(Job job in jobs) {
      if(job.invoice == null && JobUtil.containsJobStage(JobStage.STAGE_14_JOB_COMPLETE, job.completedStages!)) {
        result.add(job);
      }
    }
    return result;
  }

  static List<Job> filterJobsWithoutInvoiceThatAreNotCompleteButHavePaymentReceivedStageChecked(List<Job> jobs) {
    List<Job> result = [];
    for(Job job in jobs) {
      if(job.invoice == null && !JobUtil.containsJobStage(JobStage.STAGE_14_JOB_COMPLETE, job.completedStages!) && JobUtil.containsJobStage(JobStage.STAGE_9_PAYMENT_RECEIVED, job.completedStages!)) {
        result.add(job);
      }
    }
    return result;
  }

  static List<Job> filterJobsWithoutInvoiceThatAreNotCompleteWithJustDepositMarkedAsReceived(List<Job> jobs) {
    List<Job> result = [];
    for(Job job in jobs) {
      if(job.invoice == null && !JobUtil.containsJobStage(JobStage.STAGE_14_JOB_COMPLETE, job.completedStages!) && !JobUtil.containsJobStage(JobStage.STAGE_9_PAYMENT_RECEIVED, job.completedStages!) && JobUtil.containsJobStage(JobStage.STAGE_5_DEPOSIT_RECEIVED, job.completedStages!)) {
        result.add(job);
      }
    }
    return result;
  }

  static List<Job> filterJobsWithInvoiceAndJustDepositPaid(List<Job> jobs) {
    List<Job> result = [];
    for(Job job in jobs) {
      if(job.invoice != null && job.invoice!.depositPaid! && !job.invoice!.invoicePaid!) {
        result.add(job);
      }
    }
    return result;
  }

  static List<Job> filterJobsWithInvoiceAndInvoicePaid(List<Job> jobs) {
    List<Job> result = [];
    for(Job job in jobs) {
      if(job.invoice != null && job.invoice!.invoicePaid!) {
        result.add(job);
      }
    }
    return result;
  }
}