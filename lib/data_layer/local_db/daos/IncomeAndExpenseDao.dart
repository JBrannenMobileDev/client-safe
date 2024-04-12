import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/SingleExpenseDao.dart';
import 'package:dandylight/models/Charge.dart';
import 'package:dandylight/utils/JobUtil.dart';
import 'package:intl/intl.dart';

import '../../../models/Job.dart';
import '../../../models/JobStage.dart';
import '../../../models/RecurringExpense.dart';
import '../../../models/SingleExpense.dart';
import '../../../pages/dashboard_page/widgets/LineChartMonthData.dart';
import '../../../utils/DateTimeUtil.dart';
import 'RecurringExpenseDao.dart';

class IncomeAndExpenseDao {
  static Future<double> getIncomeForYear(int year) async {
    List<Job> allJobsForSelectedYear = _filterJobsForYear((await JobDao.getAllJobs()) ?? [], year);
    return _getTotalForJobs(allJobsForSelectedYear);
  }

  static Future<double> getIncomeForYearAndMonth(int year, int month) async {
    List<Job> allJobsForSelectedYearAndMonth = _filterJobsForYearAndMonth((await JobDao.getAllJobs()) ?? [], year, month);
    return _getTotalForJobs(allJobsForSelectedYearAndMonth);
  }

  static Future<double> getNetProfitForYearAndMonth(int year, int month) async {
    List<Job> allJobsForSelectedYearAndMonth = _filterJobsForYearAndMonth((await JobDao.getAllJobs()) ?? [], year, month);
    double income = _getTotalForJobs(allJobsForSelectedYearAndMonth);
    double expenses = await _getTotalExpensesForYearAndMonth(year, month);
    return income - expenses;
  }

  static Future<List<LineChartMonthData>> getIncomeChartData() async {
    List<LineChartMonthData> chartItems = [];
    DateTime now = DateTime.now();

    String name5 = DateFormat.MMMM().format(now);
    int income5 = (await IncomeAndExpenseDao.getIncomeForYearAndMonth(now.year, now.month)).toInt();
    LineChartMonthData data5 = LineChartMonthData(name: name5, income: income5, monthInt: now.month);
    chartItems.add(data5);

    DateTime nowMinus1 = DateTimeUtil.subtractMonths(now, 1);
    String name4 = DateFormat.MMMM().format(nowMinus1);
    int income4 = (await IncomeAndExpenseDao.getIncomeForYearAndMonth(nowMinus1.year, nowMinus1.month)).toInt();
    LineChartMonthData data4 = LineChartMonthData(name: name4, income: income4, monthInt: nowMinus1.month);
    chartItems.add(data4);

    DateTime nowMinus2 = DateTimeUtil.subtractMonths(now, 2);
    String name3 = DateFormat.MMMM().format(nowMinus2);
    int income3 = (await IncomeAndExpenseDao.getIncomeForYearAndMonth(nowMinus2.year, nowMinus2.month)).toInt();
    LineChartMonthData data3 = LineChartMonthData(name: name3, income: income3, monthInt: nowMinus2.month);
    chartItems.add(data3);

    DateTime nowMinus3 = DateTimeUtil.subtractMonths(now, 3);
    String name2 = DateFormat.MMMM().format(nowMinus3);
    int income2 = (await IncomeAndExpenseDao.getIncomeForYearAndMonth(nowMinus3.year, nowMinus3.month)).toInt();
    LineChartMonthData data2 = LineChartMonthData(name: name2, income: income2, monthInt: nowMinus3.month);
    chartItems.add(data2);

    DateTime nowMinus4 = DateTimeUtil.subtractMonths(now, 4);
    String name1 = DateFormat.MMMM().format(nowMinus4);
    int income1 = (await IncomeAndExpenseDao.getIncomeForYearAndMonth(nowMinus4.year, nowMinus4.month)).toInt();
    LineChartMonthData data1 = LineChartMonthData(name: name1, income: income1, monthInt: nowMinus4.month);
    chartItems.add(data1);

    DateTime nowMinus5 = DateTimeUtil.subtractMonths(now, 5);
    String name0 = DateFormat.MMMM().format(nowMinus5);
    int income0 = (await IncomeAndExpenseDao.getIncomeForYearAndMonth(nowMinus5.year, nowMinus5.month)).toInt();
    LineChartMonthData data = LineChartMonthData(name: name0, income: income0, monthInt: nowMinus5.month);
    chartItems.add(data);

    return chartItems;
  }

  static Future<List<LineChartMonthData>> getNetProfitChartData() async {
    List<LineChartMonthData> chartItems = [];
    DateTime now = DateTime.now();

    String name5 = DateFormat.MMMM().format(now);
    int income5 = (await IncomeAndExpenseDao.getNetProfitForYearAndMonth(now.year, now.month)).toInt();
    LineChartMonthData data5 = LineChartMonthData(name: name5, income: income5, monthInt: now.month);
    chartItems.add(data5);

    DateTime nowMinus1 = DateTimeUtil.subtractMonths(now, 1);
    String name4 = DateFormat.MMMM().format(nowMinus1);
    int income4 = (await IncomeAndExpenseDao.getNetProfitForYearAndMonth(nowMinus1.year, nowMinus1.month)).toInt();
    LineChartMonthData data4 = LineChartMonthData(name: name4, income: income4, monthInt: nowMinus1.month);
    chartItems.add(data4);

    DateTime nowMinus2 = DateTimeUtil.subtractMonths(now, 2);
    String name3 = DateFormat.MMMM().format(nowMinus2);
    int income3 = (await IncomeAndExpenseDao.getNetProfitForYearAndMonth(nowMinus2.year, nowMinus2.month)).toInt();
    LineChartMonthData data3 = LineChartMonthData(name: name3, income: income3, monthInt: nowMinus2.month);
    chartItems.add(data3);

    DateTime nowMinus3 = DateTimeUtil.subtractMonths(now, 3);
    String name2 = DateFormat.MMMM().format(nowMinus3);
    int income2 = (await IncomeAndExpenseDao.getNetProfitForYearAndMonth(nowMinus3.year, nowMinus3.month)).toInt();
    LineChartMonthData data2 = LineChartMonthData(name: name2, income: income2, monthInt: nowMinus3.month);
    chartItems.add(data2);

    DateTime nowMinus4 = DateTimeUtil.subtractMonths(now, 4);
    String name1 = DateFormat.MMMM().format(nowMinus4);
    int income1 = (await IncomeAndExpenseDao.getNetProfitForYearAndMonth(nowMinus4.year, nowMinus4.month)).toInt();
    LineChartMonthData data1 = LineChartMonthData(name: name1, income: income1, monthInt: nowMinus4.month);
    chartItems.add(data1);

    DateTime nowMinus5 = DateTimeUtil.subtractMonths(now, 5);
    String name0 = DateFormat.MMMM().format(nowMinus5);
    int income0 = (await IncomeAndExpenseDao.getNetProfitForYearAndMonth(nowMinus5.year, nowMinus5.month)).toInt();
    LineChartMonthData data = LineChartMonthData(name: name0, income: income0, monthInt: nowMinus5.month);
    chartItems.add(data);

    return chartItems;
  }

  static double _getTotalForJobs(List<Job> jobs) {
    double result = 0;
    List<Job> jobsWithoutInvoiceThatAreComplete = _filterJobsWithoutInvoiceThatAreComplete(jobs);
    List<Job> jobsWithoutInvoiceThatAreNotCompleteWithJustDepositMarkedAsReceived = _filterJobsWithoutInvoiceThatAreNotCompleteWithJustDepositMarkedAsReceived(jobs);
    List<Job> jobsWithoutInvoiceThatAreNotCompleteButHavePaymentReceivedStageChecked = _filterJobsWithoutInvoiceThatAreNotCompleteButHavePaymentReceivedStageChecked(jobs);
    List<Job> jobsWithInvoiceAndJustDepositPaid = _filterJobsWithInvoiceAndJustDepositPaid(jobs);
    List<Job> jobsWithInvoiceAndInvoicePaid = _filterJobsWithInvoiceAndInvoicePaid(jobs);

    for(Job job in jobsWithoutInvoiceThatAreComplete) {
      if(job.invoice == null && JobUtil.containsJobStage(JobStage.STAGE_14_JOB_COMPLETE, job.completedStages!) && job.priceProfile != null) {
        result = result + (job.priceProfile?.flatRate ?? 0.0);
      }
    }

    for(Job job in jobsWithoutInvoiceThatAreNotCompleteWithJustDepositMarkedAsReceived) {
      if(job.invoice == null &&
          !JobUtil.containsJobStage(JobStage.STAGE_14_JOB_COMPLETE, job.completedStages!) &&
          !JobUtil.containsJobStage(JobStage.STAGE_9_PAYMENT_RECEIVED, job.completedStages!) &&
          JobUtil.containsJobStage(JobStage.STAGE_5_DEPOSIT_RECEIVED, job.completedStages!) &&
          job.priceProfile != null
      ) {
        result = result + (job.priceProfile?.deposit ?? 0.0);
      }
    }

    for(Job job in jobsWithoutInvoiceThatAreNotCompleteButHavePaymentReceivedStageChecked) {
      if(job.invoice == null && !JobUtil.containsJobStage(JobStage.STAGE_14_JOB_COMPLETE, job.completedStages!) && JobUtil.containsJobStage(JobStage.STAGE_9_PAYMENT_RECEIVED, job.completedStages!)) {
        result = result + (job.priceProfile?.flatRate ?? 0.0);
      }
    }

    for(Job job in jobsWithInvoiceAndJustDepositPaid) {
      if(job.invoice != null && job.invoice!.depositPaid! && !job.invoice!.invoicePaid!) {
        result = result + (job.invoice?.depositAmount ?? 0.0);
      }
    }

    for(Job job in jobsWithInvoiceAndInvoicePaid) {
      if(job.invoice != null && job.invoice!.invoicePaid!) {
        result = result + (job.invoice?.total ?? 0.0);
      }
    }

    return result;
  }

  static List<Job> _filterJobsForYear(List<Job> jobs, int year) {
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

  static List<Job> _filterJobsForYearAndMonth(List<Job> jobs, int year, int month) {
    List<Job> result = [];
    for(Job job in jobs) {
      if(job.depositReceivedDate != null && job.paymentReceivedDate == null && job.depositReceivedDate!.year == year && job.depositReceivedDate!.month == month) {
        result.add(job);
      } else if(job.paymentReceivedDate != null && job.paymentReceivedDate!.year == year && job.paymentReceivedDate!.month == month) {
        result.add(job);
      } else if(job.invoice != null && job.invoice!.depositPaid! && job.invoice!.depositPaidDate != null && job.invoice!.depositPaidDate!.year == year && job.invoice!.depositPaidDate!.month == month) {
        result.add(job);
      } else if(job.invoice != null && job.invoice!.invoicePaid! && job.invoice!.depositPaidDate != null && job.invoice!.depositPaidDate!.year == year && job.invoice!.depositPaidDate!.month == month) {
        result.add(job);
      }
    }
    return result;
  }

  static List<Job> _filterJobsWithoutInvoiceThatAreComplete(List<Job> jobs) {
    List<Job> result = [];
    for(Job job in jobs) {
      if(job.invoice == null && JobUtil.containsJobStage(JobStage.STAGE_14_JOB_COMPLETE, job.completedStages!)) {
        result.add(job);
      }
    }
    return result;
  }

  static List<Job> _filterJobsWithoutInvoiceThatAreNotCompleteButHavePaymentReceivedStageChecked(List<Job> jobs) {
    List<Job> result = [];
    for(Job job in jobs) {
      if(job.invoice == null && !JobUtil.containsJobStage(JobStage.STAGE_14_JOB_COMPLETE, job.completedStages!) && JobUtil.containsJobStage(JobStage.STAGE_9_PAYMENT_RECEIVED, job.completedStages!)) {
        result.add(job);
      }
    }
    return result;
  }

  static List<Job> _filterJobsWithoutInvoiceThatAreNotCompleteWithJustDepositMarkedAsReceived(List<Job> jobs) {
    List<Job> result = [];
    for(Job job in jobs) {
      if(job.invoice == null && !JobUtil.containsJobStage(JobStage.STAGE_14_JOB_COMPLETE, job.completedStages!) && !JobUtil.containsJobStage(JobStage.STAGE_9_PAYMENT_RECEIVED, job.completedStages!) && JobUtil.containsJobStage(JobStage.STAGE_5_DEPOSIT_RECEIVED, job.completedStages!)) {
        result.add(job);
      }
    }
    return result;
  }

  static List<Job> _filterJobsWithInvoiceAndJustDepositPaid(List<Job> jobs) {
    List<Job> result = [];
    for(Job job in jobs) {
      if(job.invoice != null && job.invoice!.depositPaid! && !job.invoice!.invoicePaid!) {
        result.add(job);
      }
    }
    return result;
  }

  static List<Job> _filterJobsWithInvoiceAndInvoicePaid(List<Job> jobs) {
    List<Job> result = [];
    for(Job job in jobs) {
      if(job.invoice != null && job.invoice!.invoicePaid!) {
        result.add(job);
      }
    }
    return result;
  }

  static Future<double> _getTotalExpensesForYearAndMonth(int year, int month) async {
    List<SingleExpense> allSingleExpenses = await SingleExpenseDao.getAll();
    List<RecurringExpense> allRecurringExpenses = await RecurringExpenseDao.getAll();
    List<Charge> allRecurringCharges = getAllCharges(allRecurringExpenses);
    List<SingleExpense> singleExpenseForSelectedYear = allSingleExpenses.where((expense) => expense.charge!.chargeDate!.year == year && expense.charge!.chargeDate!.month == month).toList();
    List<Charge> recurringExpenseForSelectedYear = allRecurringCharges.where((charge) => charge.chargeDate!.year == year && charge.chargeDate!.month == month && (charge.isPaid ?? false)).toList();
    double singleExpensesTotal = 0;
    double recurringExpenseTotal = 0;

    for(SingleExpense expense in singleExpenseForSelectedYear){
      singleExpensesTotal = singleExpensesTotal + (expense.charge?.chargeAmount ?? 0);
    }

    for(Charge charge in recurringExpenseForSelectedYear){
      recurringExpenseTotal = recurringExpenseTotal + (charge.chargeAmount ?? 0);
    }

    return singleExpensesTotal + recurringExpenseTotal;
  }

  static List<Charge> getAllCharges(List<RecurringExpense> allRecurringExpenses) {
    List<Charge> result = [];
    for(RecurringExpense expense in allRecurringExpenses) {
      if(expense.charges != null && expense.charges!.isNotEmpty) {
        result.addAll(expense.charges as Iterable<Charge>);
      }
    }
    return result;
  }
}