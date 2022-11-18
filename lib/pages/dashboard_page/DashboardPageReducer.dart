import 'package:dandylight/models/Charge.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/models/RecurringExpense.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/pages/dashboard_page/widgets/LineChartMonthData.dart';
import 'package:dandylight/utils/JobUtil.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

import '../../models/JobStage.dart';
import 'DashboardPageActions.dart';
import 'DashboardPageState.dart';

final dashboardPageReducer = combineReducers<DashboardPageState>([
  TypedReducer<DashboardPageState, InitDashboardPageAction>(_setupDataListeners),
  TypedReducer<DashboardPageState, SetJobToStateAction>(_setJobs),
  TypedReducer<DashboardPageState, SetClientsDashboardAction>(_setClients),
  TypedReducer<DashboardPageState, UpdateShowHideState>(_updateShowHideState),
  TypedReducer<DashboardPageState, UpdateShowHideLeadsState>(_updateShowHideLeadsState),
  TypedReducer<DashboardPageState, SetUnseenReminderCount>(_setUnseenCount),
  TypedReducer<DashboardPageState, SetShowNewMileageExpensePageAction>(_setMileageExpenseEvent),
]);

DashboardPageState _setMileageExpenseEvent(DashboardPageState previousState, SetShowNewMileageExpensePageAction action) {
  return previousState.copyWith(
    shouldShowNewMileageExpensePage: action.shouldShow,
  );
}

DashboardPageState _setUnseenCount(DashboardPageState previousState, SetUnseenReminderCount action) {
  List<JobReminder> orderedResult = action.reminders.reversed.toList();
  return previousState.copyWith(
      unseenNotificationCount: action.count,
      reminders: orderedResult,
  );
}

DashboardPageState _setupDataListeners(DashboardPageState previousState, InitDashboardPageAction action) {
  return previousState.copyWith(jobsProfitTotal: "\$50");
}

DashboardPageState _updateShowHideState(DashboardPageState previousState, UpdateShowHideState action) {
  return previousState.copyWith(
      isMinimized: !previousState.isMinimized,
  );
}

DashboardPageState _updateShowHideLeadsState(DashboardPageState previousState, UpdateShowHideLeadsState action) {
  return previousState.copyWith(
    isLeadsMinimized: !previousState.isLeadsMinimized,
  );
}

DashboardPageState _setJobs(DashboardPageState previousState, SetJobToStateAction action) {
  List<Job> activeJobs = JobUtil.getActiveJobs(action.allJobs);
  List<Job> jobsThisWeek = [];

  List<JobStage> allStagesFromAllJobs = [];
  for(Job job in activeJobs) {
    allStagesFromAllJobs.addAll(job.type.stages);
  }

  DateTime now = DateTime.now();
  now.subtract(Duration(days: 1));
  DateTime oneWeekInFuture = DateTime.now();
  oneWeekInFuture.add(Duration(days: 7));
  for(Job job in activeJobs) {
    if(job.selectedDate != null && job.selectedDate.isBefore(oneWeekInFuture) && job.selectedDate.isAfter(now)) {
      jobsThisWeek.add(job);
    }
  }

  var seen = Set<String>();
  List<JobStage> uniqueList = allStagesFromAllJobs.where((stage) => seen.add(stage.stage)).toList();

  List<JobStage> activeStages = [];
  for(JobStage stage in uniqueList) {
    List<Job> jobsForStage = JobUtil.getJobsForStage(activeJobs, stage);
    if(jobsForStage.length > 0) activeStages.add(stage);
  }


  List<Job> jobsWithPaymentReceived = action.allJobs.where((job) => job.isPaymentReceived() == true).toList();
  List<Job> jobsWithOnlyDepositReceived = action.allJobs.where((job) => job.isPaymentReceived() == false && job.isDepositPaid() == true).toList();
  List<LineChartMonthData> chartItems = buildChartData(jobsWithPaymentReceived, action.singleExpenses, action.recurringExpense, action.mileageExpenses, jobsWithOnlyDepositReceived);

  return previousState.copyWith(
      currentJobs: JobUtil.getUpComingJobs(action.allJobs),
      allJobs: action.allJobs,
      activeJobs: activeJobs,
      allUserStages: activeStages,
      lineChartMonthData: chartItems.reversed.toList(),
      jobsThisWeek: jobsThisWeek,
  );
}

List<LineChartMonthData> buildChartData(List<Job> jobsWithPaymentReceived, List<SingleExpense> singleExpenses, List<RecurringExpense> recurringExpenses, List<MileageExpense> mileageExpenses, List<Job> jobsWithOnlyDepositReceived) {
  List<LineChartMonthData> chartItems = [];
  DateTime now = DateTime.now();
  int currentYear = now.year;

  String name5 = DateFormat.MMMM().format(now);
  LineChartMonthData data5 = LineChartMonthData(name: name5, income: 0, monthInt: now.month);
  chartItems.add(data5);

  DateTime nowMinus1 = DateTime(now.year, now.month - 1, now.day);
  String name4 = DateFormat.MMMM().format(nowMinus1);
  LineChartMonthData data4 = LineChartMonthData(name: name4, income: 0, monthInt: nowMinus1.month);
  chartItems.add(data4);

  DateTime nowMinus2 = DateTime(now.year, now.month - 2, now.day);
  String name3 = DateFormat.MMMM().format(nowMinus2);
  LineChartMonthData data3 = LineChartMonthData(name: name3, income: 0, monthInt: nowMinus2.month);
  chartItems.add(data3);

  DateTime nowMinus3 = DateTime(now.year, now.month - 3, now.day);
  String name2 = DateFormat.MMMM().format(nowMinus3);
  LineChartMonthData data2 = LineChartMonthData(name: name2, income: 0, monthInt: nowMinus3.month);
  chartItems.add(data2);

  DateTime nowMinus4 = DateTime(now.year, now.month - 4, now.day);
  String name1 = DateFormat.MMMM().format(nowMinus4);
  LineChartMonthData data1 = LineChartMonthData(name: name1, income: 0, monthInt: nowMinus4.month);
  chartItems.add(data1);

  DateTime nowMinus5 = DateTime(now.year, now.month - 5, now.day);
  String name0 = DateFormat.MMMM().format(nowMinus5);
  LineChartMonthData data = LineChartMonthData(name: name0, income: 0, monthInt: nowMinus5.month);
  chartItems.add(data);

  for(SingleExpense expense in singleExpenses) {
    if(expense.charge.chargeDate != null && expense.charge.chargeDate.year == currentYear) {
      if(expense.charge.chargeDate.month == chartItems.elementAt(0).monthInt) {
        chartItems.elementAt(0).income -= expense.charge.chargeAmount.toInt();
      }

      if(expense.charge.chargeDate.month == chartItems.elementAt(1).monthInt) {
        chartItems.elementAt(1).income -= expense.charge.chargeAmount.toInt();
      }

      if(expense.charge.chargeDate.month == chartItems.elementAt(2).monthInt) {
        chartItems.elementAt(2).income -= expense.charge.chargeAmount.toInt();
      }

      if(expense.charge.chargeDate.month == chartItems.elementAt(3).monthInt) {
        chartItems.elementAt(3).income -= expense.charge.chargeAmount.toInt();
      }

      if(expense.charge.chargeDate.month == chartItems.elementAt(4).monthInt) {
        chartItems.elementAt(4).income -= expense.charge.chargeAmount.toInt();
      }

      if(expense.charge.chargeDate.month == chartItems.elementAt(5).monthInt) {
        chartItems.elementAt(5).income -= expense.charge.chargeAmount.toInt();
      }
    }
  }

  for(MileageExpense expense in mileageExpenses) {
    if(expense.charge.chargeDate != null && expense.charge.chargeDate.year == currentYear) {
      if(expense.charge.chargeDate.month == chartItems.elementAt(0).monthInt) {
        chartItems.elementAt(0).income -= expense.charge.chargeAmount.toInt();
      }

      if(expense.charge.chargeDate.month == chartItems.elementAt(1).monthInt) {
        chartItems.elementAt(1).income -= expense.charge.chargeAmount.toInt();
      }

      if(expense.charge.chargeDate.month == chartItems.elementAt(2).monthInt) {
        chartItems.elementAt(2).income -= expense.charge.chargeAmount.toInt();
      }

      if(expense.charge.chargeDate.month == chartItems.elementAt(3).monthInt) {
        chartItems.elementAt(3).income -= expense.charge.chargeAmount.toInt();
      }

      if(expense.charge.chargeDate.month == chartItems.elementAt(4).monthInt) {
        chartItems.elementAt(4).income -= expense.charge.chargeAmount.toInt();
      }

      if(expense.charge.chargeDate.month == chartItems.elementAt(5).monthInt) {
        chartItems.elementAt(5).income -= expense.charge.chargeAmount.toInt();
      }
    }
  }

  for(RecurringExpense expense in recurringExpenses) {
    Charge chargeForMonthAndYear = getCharge(expense.charges, currentYear, chartItems.elementAt(0).monthInt);
    bool isPaid = isChargeRecurringChargePaid(expense.charges, currentYear, chartItems.elementAt(0).monthInt);
    if(chargeForMonthAndYear != null && isPaid) {
      chartItems.elementAt(0).income -= chargeForMonthAndYear.chargeAmount.toInt();
    }

    chargeForMonthAndYear = getCharge(expense.charges, currentYear, chartItems.elementAt(1).monthInt);
    isPaid = isChargeRecurringChargePaid(expense.charges, currentYear, chartItems.elementAt(1).monthInt);
    if(chargeForMonthAndYear != null && isPaid) {
      chartItems.elementAt(1).income -= chargeForMonthAndYear.chargeAmount.toInt();
    }

    chargeForMonthAndYear = getCharge(expense.charges, currentYear, chartItems.elementAt(2).monthInt);
    isPaid = isChargeRecurringChargePaid(expense.charges, currentYear, chartItems.elementAt(2).monthInt);
    if(chargeForMonthAndYear != null && isPaid) {
      chartItems.elementAt(2).income -= chargeForMonthAndYear.chargeAmount.toInt();
    }

    chargeForMonthAndYear = getCharge(expense.charges, currentYear, chartItems.elementAt(3).monthInt);
    isPaid = isChargeRecurringChargePaid(expense.charges, currentYear, chartItems.elementAt(3).monthInt);
    if(chargeForMonthAndYear != null && isPaid) {
      chartItems.elementAt(3).income -= chargeForMonthAndYear.chargeAmount.toInt();
    }

    chargeForMonthAndYear = getCharge(expense.charges, currentYear, chartItems.elementAt(4).monthInt);
    isPaid = isChargeRecurringChargePaid(expense.charges, currentYear, chartItems.elementAt(4).monthInt);
    if(chargeForMonthAndYear != null && isPaid) {
      chartItems.elementAt(4).income -= chargeForMonthAndYear.chargeAmount.toInt();
    }

    chargeForMonthAndYear = getCharge(expense.charges, currentYear, chartItems.elementAt(5).monthInt);
    isPaid = isChargeRecurringChargePaid(expense.charges, currentYear, chartItems.elementAt(5).monthInt);
    if(chargeForMonthAndYear != null && isPaid) {
      chartItems.elementAt(5).income -= chargeForMonthAndYear.chargeAmount.toInt();
    }
  }

  for(Job job in jobsWithOnlyDepositReceived) {
    DateTime depositReceivedDate = job.depositReceivedDate;

    if(depositReceivedDate != null && depositReceivedDate.year == currentYear) {
      int depositMonth = depositReceivedDate.month;

      if(depositMonth == chartItems.elementAt(0).monthInt) {
        chartItems.elementAt(0).income += (job.depositAmount != null ? job.depositAmount : 0);
      }

      if(depositMonth == chartItems.elementAt(1).monthInt) {
        chartItems.elementAt(1).income += (job.depositAmount != null ? job.depositAmount : 0);
      }

      if(depositMonth == chartItems.elementAt(2).monthInt) {
        chartItems.elementAt(2).income += (job.depositAmount != null ? job.depositAmount : 0);
      }

      if(depositMonth == chartItems.elementAt(3).monthInt) {
        chartItems.elementAt(3).income += (job.depositAmount != null ? job.depositAmount : 0);
      }

      if(depositMonth == chartItems.elementAt(4).monthInt) {
        chartItems.elementAt(4).income += (job.depositAmount != null ? job.depositAmount : 0);
      }

      if(depositMonth == chartItems.elementAt(5).monthInt) {
        chartItems.elementAt(5).income += (job.depositAmount != null ? job.depositAmount : 0);
      }
    }
  }

  for(Job job in jobsWithPaymentReceived) {
    DateTime paymentReceivedDate = job.paymentReceivedDate != null ? job.paymentReceivedDate : job.selectedDate;

    if(paymentReceivedDate != null && paymentReceivedDate.year == currentYear) {
      int jobMonth = paymentReceivedDate.month;

      if(jobMonth == chartItems.elementAt(0).monthInt) {
        chartItems.elementAt(0).income += (job.tipAmount != null ? job.tipAmount : 0);

        if(job.invoice != null) {
          chartItems.elementAt(0).income += (job.invoice.total - job.invoice.discount - job.invoice.salesTaxAmount).toInt();
        } else {
          chartItems.elementAt(0).income += job.priceProfile.flatRate.toInt();
        }
      }

      if(jobMonth == chartItems.elementAt(1).monthInt) {
        chartItems.elementAt(1).income += (job.tipAmount != null ? job.tipAmount : 0);

        if(job.invoice != null) {
          chartItems.elementAt(1).income += (job.invoice.total - job.invoice.discount - job.invoice.salesTaxAmount).toInt();
        } else {
          chartItems.elementAt(1).income += job.priceProfile.flatRate.toInt();
        }
      }

      if(jobMonth == chartItems.elementAt(2).monthInt) {
        chartItems.elementAt(2).income += (job.tipAmount != null ? job.tipAmount : 0);

        if(job.invoice != null) {
          chartItems.elementAt(2).income += (job.invoice.total - job.invoice.discount - job.invoice.salesTaxAmount).toInt();
        } else {
          chartItems.elementAt(2).income += job.priceProfile.flatRate.toInt();
        }
      }

      if(jobMonth == chartItems.elementAt(3).monthInt) {
        chartItems.elementAt(3).income += (job.tipAmount != null ? job.tipAmount : 0);

        if(job.invoice != null) {
          chartItems.elementAt(3).income += (job.invoice.total - job.invoice.discount - job.invoice.salesTaxAmount).toInt();
        } else {
          chartItems.elementAt(3).income += job.priceProfile.flatRate.toInt();
        }
      }

      if(jobMonth == chartItems.elementAt(4).monthInt) {
        chartItems.elementAt(4).income += (job.tipAmount != null ? job.tipAmount : 0);

        if(job.invoice != null) {
          chartItems.elementAt(4).income += (job.invoice.total - job.invoice.discount - job.invoice.salesTaxAmount).toInt();
        } else {
          chartItems.elementAt(4).income += job.priceProfile.flatRate.toInt();
        }
      }

      if(jobMonth == chartItems.elementAt(5).monthInt) {
        chartItems.elementAt(5).income += (job.tipAmount != null ? job.tipAmount : 0);

        if(job.invoice != null) {
          chartItems.elementAt(5).income += (job.invoice.total - job.invoice.discount - job.invoice.salesTaxAmount).toInt();
        } else {
          chartItems.elementAt(5).income += job.priceProfile.flatRate.toInt();
        }
      }
    }
  }
  return chartItems;
}

bool isChargeRecurringChargePaid(List<Charge> charges, int currentYear, int monthInt) {
  for(Charge charge in charges) {
    if(charge.chargeDate.year == currentYear && charge.chargeDate.month == monthInt) {
      return charge.isPaid;
    }
  }
  return null;
}

Charge getCharge(List<Charge> charges, int currentYear, int monthInt) {
  for(Charge charge in charges) {
    if(charge.chargeDate.year == currentYear && charge.chargeDate.month == monthInt) {
      return charge;
    }
  }
  return null;
}

DashboardPageState _setClients(DashboardPageState previousState, SetClientsDashboardAction action) {
  List<Client> leads = action.clients.where((client) => (!_hasAJob(client.documentId, previousState.allJobs))).toList();
  return previousState.copyWith(
      recentLeads: leads.reversed.toList());
}

bool _hasAJob(String clientDocumentId, List<Job> jobs) {
  List<Job> clientJobs = jobs.where((job) => job.clientDocumentId == clientDocumentId).toList();
  if(clientJobs.length > 0) return true;
  return false;
}