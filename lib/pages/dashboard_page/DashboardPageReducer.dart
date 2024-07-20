import 'package:dandylight/models/Charge.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/models/RecurringExpense.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/pages/dashboard_page/JobTypePieChartRowData.dart';
import 'package:dandylight/pages/dashboard_page/LeadSourcePieChartRowData.dart';
import 'package:dandylight/pages/dashboard_page/widgets/LineChartMonthData.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/JobUtil.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

import '../../models/JobStage.dart';
import '../../models/JobType.dart';
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
  TypedReducer<DashboardPageState, SetJobTypeChartData>(_setJobTypesChartData),
  TypedReducer<DashboardPageState, SetProfileDashboardAction>(_setProfile),
  TypedReducer<DashboardPageState, SetSubscriptionStateAction>(_setSubscriptionState),
  TypedReducer<DashboardPageState, SetGoToPosesJob>(_setGoToJobPoses),
  TypedReducer<DashboardPageState, SetGoToAsSeenAction>(_setGoToAsSeen),
  TypedReducer<DashboardPageState, SetUnseenFeaturedPosesAction>(_setUnseenFeaturedPoses),
  TypedReducer<DashboardPageState, SetShouldShowPMF>(_setShouldShowPMF),
  TypedReducer<DashboardPageState, SetShouldAppReview>(setShouldShowAppReview),
  TypedReducer<DashboardPageState, SetShouldShowUpdateAction>(setShouldShowUpdate),
  TypedReducer<DashboardPageState, SetQuestionnairesToDashboardAction>(setQuestionnaires),
  TypedReducer<DashboardPageState, SetIncomeInfoAction>(setIncomeInfo),
]);

DashboardPageState setQuestionnaires(DashboardPageState previousState, SetQuestionnairesToDashboardAction action) {
  return previousState.copyWith(
    completedQuestionnaires: action.complete.reversed.toList(),
    notCompleteQuestionnaires: action.notComplete.reversed.toList(),
    allQuestionnaires: action.allQuestionnaires.reversed.toList(),
  );
}

DashboardPageState setIncomeInfo(DashboardPageState previousState, SetIncomeInfoAction action) {
  return previousState.copyWith(
    lineChartMonthData: action.netProfitChartData.reversed.toList(),
  );
}

DashboardPageState setShouldShowUpdate(DashboardPageState previousState, SetShouldShowUpdateAction action) {
  return previousState.copyWith(
    shouldShowAppUpdate: action.shouldShow,
    appSettings: action.appSettings,
  );
}

DashboardPageState _setShouldShowPMF(DashboardPageState previousState, SetShouldShowPMF action) {
  return previousState.copyWith(
    shouldShowPMFRequest: action.shouldShow,
  );
}

DashboardPageState setShouldShowAppReview(DashboardPageState previousState, SetShouldAppReview action) {
  return previousState.copyWith(
    shouldShowRequestReview: action.shouldShow,
  );
}

DashboardPageState _setUnseenFeaturedPoses(DashboardPageState previousState, SetUnseenFeaturedPosesAction action) {
  return previousState.copyWith(
    unseenFeaturedPoses: action.unseenFeaturedPoses,
  );
}

DashboardPageState _setGoToAsSeen(DashboardPageState previousState, SetGoToAsSeenAction action) {
  return previousState.copyWith(
    goToSeen: true,
  );
}

DashboardPageState _setGoToJobPoses(DashboardPageState previousState, SetGoToPosesJob action) {
  return previousState.copyWith(
    goToPosesJob: action.goToPosesJob,
  );
}

DashboardPageState _setSubscriptionState(DashboardPageState previousState, SetSubscriptionStateAction action) {
  return previousState.copyWith(
    subscriptionState: action.subscriptionState,
  );
}

DashboardPageState _setProfile(DashboardPageState previousState, SetProfileDashboardAction action) {
  return previousState.copyWith(
    profile: action.profile,
    hasSeenShowcase: action.profile?.hasSeenShowcase,
  );
}

DashboardPageState _setMileageExpenseEvent(DashboardPageState previousState, SetShowNewMileageExpensePageAction action) {
  return previousState.copyWith(
    shouldShowNewMileageExpensePage: action.shouldShow,
  );
}

DashboardPageState _setUnseenCount(DashboardPageState previousState, SetUnseenReminderCount action) {
  List<JobReminder> orderedResult = action.reminders!.reversed.toList();
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
      isMinimized: !previousState.isMinimized!,
  );
}

DashboardPageState _updateShowHideLeadsState(DashboardPageState previousState, UpdateShowHideLeadsState action) {
  return previousState.copyWith(
    isLeadsMinimized: !previousState.isLeadsMinimized!,
  );
}

DashboardPageState _setJobs(DashboardPageState previousState, SetJobToStateAction action) {
  List<Job> activeJobs = JobUtil.getActiveJobs(action.allJobs!);
  List<Job> jobsThisWeek = [];

  List<JobStage> allStagesFromAllJobs = [];
  for(Job job in activeJobs) {
    allStagesFromAllJobs.addAll(job.sessionType!.stages!);
  }

  DateTime now = DateTime.now();
  now.subtract(const Duration(days: 1));
  DateTime oneWeekInFuture = DateTime.now().add(const Duration(days: 7));
  for(Job job in activeJobs) {
    if(job.selectedDate != null && job.selectedDate!.isBefore(oneWeekInFuture) && job.selectedDate!.isAfter(now)) {
      jobsThisWeek.add(job);
    }
  }

  var seen = Set<String>();
  List<JobStage> uniqueList = allStagesFromAllJobs.where((stage) => seen.add(stage.stage!)).toList();

  List<JobStage> activeStages = [];
  for(JobStage stage in uniqueList) {
    List<Job> jobsForStage = JobUtil.getJobsForStage(activeJobs, stage);
    if(jobsForStage.isNotEmpty) activeStages.add(stage);
  }

  return previousState.copyWith(
      upcomingJobs: JobUtil.getUpComingJobs(action.allJobs!),
      allJobs: action.allJobs,
      activeJobs: activeJobs,
      allUserStages: activeStages,
      jobsThisWeek: jobsThisWeek,
      areJobsLoaded: true,
      activeUnsignedContract: JobUtil.getJobsWithUnsignedContracts(activeJobs),
      activeSignedContract: JobUtil.getJobsWithSignedContracts(activeJobs),
      allUnsignedContract: JobUtil.getJobsWithUnsignedContracts(action.allJobs!),
      allSignedContract: JobUtil.getJobsWithSignedContracts(action.allJobs!),
  );
}

DashboardPageState _setJobTypesChartData(DashboardPageState previousState, SetJobTypeChartData action) {
  List<Job> jobsWithPaymentReceived = action.allJobs!.where((job) => job.isPaymentReceived() == true).toList();

  List<PieChartSectionData> jobTypeBreakdownData = buildJobTypeData(jobsWithPaymentReceived, action.allJobTypes!);
  List<JobTypePieChartRowData> jobTypeRowData = buildJobTypeRowData(jobsWithPaymentReceived, action.allJobTypes!);

  return previousState.copyWith(
    jobTypeBreakdownData: jobTypeBreakdownData,
    jobTypePieChartRowData: jobTypeRowData.reversed.toList(),
  );
}

List<LineChartMonthData> buildChartData(List<Job> jobsWithPaymentReceived, List<SingleExpense> singleExpenses, List<RecurringExpense> recurringExpenses, List<MileageExpense> mileageExpenses, List<Job> jobsWithOnlyDepositReceived) {
  List<LineChartMonthData> chartItems = [];
  DateTime now = DateTime.now();
  int currentYear = now.year;

  String name5 = DateFormat.MMMM().format(now);
  LineChartMonthData data5 = LineChartMonthData(name: name5, income: 0, monthInt: now.month);
  chartItems.add(data5);

  DateTime nowMinus1 = DateTime(now.year, (now.month - 1));
  String name4 = DateFormat.MMMM().format(nowMinus1);
  LineChartMonthData data4 = LineChartMonthData(name: name4, income: 0, monthInt: nowMinus1.month);
  chartItems.add(data4);

  DateTime nowMinus2 = DateTime(now.year, now.month - 2);
  String name3 = DateFormat.MMMM().format(nowMinus2);
  LineChartMonthData data3 = LineChartMonthData(name: name3, income: 0, monthInt: nowMinus2.month);
  chartItems.add(data3);

  DateTime nowMinus3 = DateTime(now.year, now.month - 3);
  String name2 = DateFormat.MMMM().format(nowMinus3);
  LineChartMonthData data2 = LineChartMonthData(name: name2, income: 0, monthInt: nowMinus3.month);
  chartItems.add(data2);

  DateTime nowMinus4 = DateTime(now.year, now.month - 4);
  String name1 = DateFormat.MMMM().format(nowMinus4);
  LineChartMonthData data1 = LineChartMonthData(name: name1, income: 0, monthInt: nowMinus4.month);
  chartItems.add(data1);

  DateTime nowMinus5 = DateTime(now.year, now.month - 5);
  String name0 = DateFormat.MMMM().format(nowMinus5);
  LineChartMonthData data = LineChartMonthData(name: name0, income: 0, monthInt: nowMinus5.month);
  chartItems.add(data);

  for(SingleExpense expense in singleExpenses) {
    if(expense.charge!.chargeDate != null && expense.charge!.chargeDate!.year == currentYear) {
      if(expense.charge!.chargeDate!.month == chartItems.elementAt(0).monthInt) {
        chartItems.elementAt(0).income = chartItems.elementAt(0).income! - expense.charge!.chargeAmount!.toInt();
      }

      if(expense.charge!.chargeDate!.month == chartItems.elementAt(1).monthInt) {
        chartItems.elementAt(1).income = chartItems.elementAt(1).income! - expense.charge!.chargeAmount!.toInt();
      }

      if(expense.charge!.chargeDate!.month == chartItems.elementAt(2).monthInt) {
        chartItems.elementAt(2).income = chartItems.elementAt(2).income! - expense.charge!.chargeAmount!.toInt();
      }

      if(expense.charge!.chargeDate!.month == chartItems.elementAt(3).monthInt) {
        chartItems.elementAt(3).income = chartItems.elementAt(3).income! - expense.charge!.chargeAmount!.toInt();
      }

      if(expense.charge!.chargeDate!.month == chartItems.elementAt(4).monthInt) {
        chartItems.elementAt(4).income = chartItems.elementAt(4).income! - expense.charge!.chargeAmount!.toInt();
      }

      if(expense.charge!.chargeDate!.month == chartItems.elementAt(5).monthInt) {
        chartItems.elementAt(5).income = chartItems.elementAt(5).income! - expense.charge!.chargeAmount!.toInt();
      }
    }
  }

  for(RecurringExpense expense in recurringExpenses) {
    Charge? chargeForMonthAndYear = getCharge(expense.charges!, currentYear, chartItems.elementAt(0).monthInt!);
    bool? isPaid = isChargeRecurringChargePaid(expense.charges!, currentYear, chartItems.elementAt(0).monthInt!);
    if(chargeForMonthAndYear != null && isPaid!) {
      chartItems.elementAt(0).income = chartItems.elementAt(0).income! - chargeForMonthAndYear.chargeAmount!.toInt();
    }

    chargeForMonthAndYear = getCharge(expense.charges!, currentYear, chartItems.elementAt(1).monthInt!);
    isPaid = isChargeRecurringChargePaid(expense.charges!, currentYear, chartItems.elementAt(1).monthInt!);
    if(chargeForMonthAndYear != null && isPaid!) {
      chartItems.elementAt(1).income = chartItems.elementAt(1).income! - chargeForMonthAndYear.chargeAmount!.toInt();
    }

    chargeForMonthAndYear = getCharge(expense.charges!, currentYear, chartItems.elementAt(2).monthInt!);
    isPaid = isChargeRecurringChargePaid(expense.charges!, currentYear, chartItems.elementAt(2).monthInt!);
    if(chargeForMonthAndYear != null && isPaid!) {
      chartItems.elementAt(2).income = chartItems.elementAt(2).income! - chargeForMonthAndYear.chargeAmount!.toInt();
    }

    chargeForMonthAndYear = getCharge(expense.charges!, currentYear, chartItems.elementAt(3).monthInt!);
    isPaid = isChargeRecurringChargePaid(expense.charges!, currentYear, chartItems.elementAt(3).monthInt!);
    if(chargeForMonthAndYear != null && isPaid!) {
      chartItems.elementAt(3).income = chartItems.elementAt(3).income! - chargeForMonthAndYear.chargeAmount!.toInt();
    }

    chargeForMonthAndYear = getCharge(expense.charges!, currentYear, chartItems.elementAt(4).monthInt!);
    isPaid = isChargeRecurringChargePaid(expense.charges!, currentYear, chartItems.elementAt(4).monthInt!);
    if(chargeForMonthAndYear != null && isPaid!) {
      chartItems.elementAt(4).income = chartItems.elementAt(4).income! - chargeForMonthAndYear.chargeAmount!.toInt();
    }

    chargeForMonthAndYear = getCharge(expense.charges!, currentYear, chartItems.elementAt(5).monthInt!);
    isPaid = isChargeRecurringChargePaid(expense.charges!, currentYear, chartItems.elementAt(5).monthInt!);
    if(chargeForMonthAndYear != null && isPaid!) {
      chartItems.elementAt(5).income = chartItems.elementAt(5).income! - chargeForMonthAndYear.chargeAmount!.toInt();
    }
  }

  for(Job job in jobsWithOnlyDepositReceived) {
    DateTime? depositReceivedDate = job.depositReceivedDate;

    if(depositReceivedDate != null && depositReceivedDate.year == currentYear) {
      int depositMonth = depositReceivedDate.month;

      if(depositMonth == chartItems.elementAt(0).monthInt) {
        chartItems.elementAt(0).income = chartItems.elementAt(0).income! + (job.depositAmount ?? 0);
      }

      if(depositMonth == chartItems.elementAt(1).monthInt) {
        chartItems.elementAt(1).income = chartItems.elementAt(1).income! + (job.depositAmount ?? 0);
      }

      if(depositMonth == chartItems.elementAt(2).monthInt) {
        chartItems.elementAt(2).income = chartItems.elementAt(2).income! + (job.depositAmount ?? 0);
      }

      if(depositMonth == chartItems.elementAt(3).monthInt) {
        chartItems.elementAt(3).income = chartItems.elementAt(3).income! + (job.depositAmount ?? 0);
      }

      if(depositMonth == chartItems.elementAt(4).monthInt) {
        chartItems.elementAt(4).income = chartItems.elementAt(4).income! + (job.depositAmount ?? 0);
      }

      if(depositMonth == chartItems.elementAt(5).monthInt) {
        chartItems.elementAt(5).income = chartItems.elementAt(5).income! + (job.depositAmount ?? 0);
      }
    }
  }

  for(Job job in jobsWithPaymentReceived) {
    DateTime? paymentReceivedDate = job.paymentReceivedDate ?? job.selectedDate;

    if(paymentReceivedDate != null && paymentReceivedDate.year == currentYear) {
      int jobMonth = paymentReceivedDate.month;

      if(jobMonth == chartItems.elementAt(0).monthInt) {
        chartItems.elementAt(0).income = chartItems.elementAt(0).income! + (job.tipAmount ?? 0);

        if(job.invoice != null) {
          chartItems.elementAt(0).income = chartItems.elementAt(0).income! + (job.invoice!.total! - job.invoice!.discount! - job.invoice!.salesTaxAmount!).toInt();
        } else {
          chartItems.elementAt(0).income = chartItems.elementAt(0).income! + job.getJobCost().toInt();
        }
      }

      if(jobMonth == chartItems.elementAt(1).monthInt) {
        chartItems.elementAt(1).income = chartItems.elementAt(1).income! + (job.tipAmount ?? 1);

        if(job.invoice != null) {
          chartItems.elementAt(1).income = chartItems.elementAt(1).income! + (job.invoice!.total! - job.invoice!.discount! - job.invoice!.salesTaxAmount!).toInt();
        } else {
          chartItems.elementAt(1).income = chartItems.elementAt(1).income! + job.getJobCost().toInt();
        }
      }

      if(jobMonth == chartItems.elementAt(2).monthInt) {
        chartItems.elementAt(2).income = chartItems.elementAt(2).income! + (job.tipAmount ?? 2);

        if(job.invoice != null) {
          chartItems.elementAt(2).income = chartItems.elementAt(2).income! + (job.invoice!.total! - job.invoice!.discount! - job.invoice!.salesTaxAmount!).toInt();
        } else {
          chartItems.elementAt(2).income = chartItems.elementAt(2).income! + job.getJobCost().toInt();
        }
      }

      if(jobMonth == chartItems.elementAt(3).monthInt) {
        chartItems.elementAt(3).income = chartItems.elementAt(3).income! + (job.tipAmount ?? 3);

        if(job.invoice != null) {
          chartItems.elementAt(3).income = chartItems.elementAt(3).income! + (job.invoice!.total! - job.invoice!.discount! - job.invoice!.salesTaxAmount!).toInt();
        } else {
          chartItems.elementAt(3).income = chartItems.elementAt(3).income! + job.getJobCost().toInt();
        }
      }

      if(jobMonth == chartItems.elementAt(4).monthInt) {
        chartItems.elementAt(4).income = chartItems.elementAt(4).income! + (job.tipAmount ?? 4);

        if(job.invoice != null) {
          chartItems.elementAt(4).income = chartItems.elementAt(4).income! + (job.invoice!.total! - job.invoice!.discount! - job.invoice!.salesTaxAmount!).toInt();
        } else {
          chartItems.elementAt(4).income = chartItems.elementAt(4).income! + job.getJobCost().toInt();
        }
      }

      if(jobMonth == chartItems.elementAt(5).monthInt) {
        chartItems.elementAt(5).income = chartItems.elementAt(5).income! + (job.tipAmount ?? 5);

        if(job.invoice != null) {
          chartItems.elementAt(5).income = chartItems.elementAt(5).income! + (job.invoice!.total! - job.invoice!.discount! - job.invoice!.salesTaxAmount!).toInt();
        } else {
          chartItems.elementAt(5).income = chartItems.elementAt(5).income! + job.getJobCost().toInt();
        }
      }
    }
  }
  return chartItems;
}

bool? isChargeRecurringChargePaid(List<Charge> charges, int currentYear, int monthInt) {
  for(Charge charge in charges) {
    if(charge.chargeDate!.year == currentYear && charge.chargeDate!.month == monthInt) {
      return charge.isPaid!;
    }
  }
  return null;
}

Charge? getCharge(List<Charge> charges, int currentYear, int monthInt) {
  for(Charge charge in charges) {
    if(charge.chargeDate!.year == currentYear && charge.chargeDate!.month == monthInt) {
      return charge;
    }
  }
  return null;
}

DashboardPageState _setClients(DashboardPageState previousState, SetClientsDashboardAction action) {
  List<Client> clientsWithAJob = action.clients!.where((client) => (_hasAJob(client.documentId!, previousState.allJobs!)) && client.createdDate!.year == DateTime.now().year).toList();
  List<Client> allClientsFromThisYear = action.clients!.where((client) => client.createdDate!.year == DateTime.now().year).toList();
  double rate = (clientsWithAJob.length/allClientsFromThisYear.length) * 100;

  var groupedList = <String, List<Client>>{};
  List<PieChartSectionData> chartData = [];
  List<LeadSourcePieChartRowData> rowData = [];

  for(Client client in allClientsFromThisYear) {
    String newLeadSource = '';
    if(Client.isOldSource(client.leadSource!)) {
      newLeadSource = Client.mapOldLeadSourceToNew(client.leadSource!);
      client.leadSource = newLeadSource;
    } else {
      newLeadSource = client.leadSource!;
    }
    groupedList.putIfAbsent(client.customLeadSourceName != null && client.customLeadSourceName!.isNotEmpty ? client.customLeadSourceName! : newLeadSource, () => <Client>[]).add(client);
  }

  var seen = Set<String>();
  List<Client> allLeadSourceNames = allClientsFromThisYear.where((client) => seen.add(client.customLeadSourceName != null && client.customLeadSourceName!.isNotEmpty ? client.customLeadSourceName! : client.leadSource!)).toList();

  int index = 0;
  for(Client client in allLeadSourceNames) {
    String leadSourceName = client.customLeadSourceName != null && client.customLeadSourceName!.isNotEmpty ? client.customLeadSourceName! : client.leadSource!;
    if(Client.isOldSource(leadSourceName)) {
      leadSourceName = Client.mapOldLeadSourceToNew(leadSourceName);
    }
    List<Client>? clientsForLeadName = groupedList[leadSourceName];

    if(clientsForLeadName != null) {
      int count = clientsForLeadName.length;

      List<Client> groupLeads = clientsForLeadName.where((client) => (_hasAJob(client.documentId!, previousState.allJobs!))).toList();
      int conversionRate = ((groupLeads.length/clientsForLeadName.length) * 100).toInt();

      rowData.add(LeadSourcePieChartRowData(
        sourceName: leadSourceName,
        count: count,
        conversionRate: conversionRate,
        color: ColorConstants.getPieChartColor(index),
      ));

      chartData.add(PieChartSectionData(
        color: Color(ColorConstants.getPieChartColor(index)),
        value: (count/allClientsFromThisYear.length*100).roundToDouble(),
        title: '${(count/allClientsFromThisYear.length*100).round()}%',
        radius: 54,
        titleStyle: TextStyle(
          fontSize: 18,
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: FontWeight.w500,
          color: const Color(0xffffffff),
        ),
      ));

    }
    index++;
  }

  rowData.sort((a, b) => a.count!.compareTo(b.count!));

  return previousState.copyWith(
      leadConversionRate: !rate.isNaN ? rate.toInt() : 0,
      unconvertedLeadCount: allClientsFromThisYear.length - clientsWithAJob.length,
      leadSourcesData: chartData,
      leadSourcePieChartRowData: rowData.reversed.toList(),
  );
}

List<PieChartSectionData> buildJobTypeData(List<Job> jobsWithPaymentReceived, List<JobType> allJobTypes) {
  List<Job> jobsThisYearPaid = jobsWithPaymentReceived.where((job) => job.paymentReceivedDate?.year == DateTime.now().year).toList();
  var groupedList = <String, List<Job>>{};
  List<PieChartSectionData> result = [];

  for(Job job in jobsThisYearPaid) {
    groupedList.putIfAbsent(job.sessionType!.title!, () => <Job>[]).add(job);
  }

  int index = 0;
  for(JobType jobType in allJobTypes) {
    List<Job>? jobsForType = groupedList[jobType.title];
    if(jobsForType != null) {
      int count = jobsForType.length;
      int totalIncome = 0;

      for(Job groupJob in jobsForType) {
        totalIncome = totalIncome + (groupJob.invoice != null ? groupJob.invoice!.total!.toInt() : groupJob.getJobCost().toInt());
      }

      result.add(PieChartSectionData(
        color: Color(ColorConstants.getPieChartColor(index)),
        value: (count/jobsThisYearPaid.length*100).roundToDouble(),
        title: '${(count/jobsThisYearPaid.length*100).round()}%',
        radius: 50,
        titleStyle: TextStyle(
          fontSize: 20,
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: FontWeight.w500,
          color: const Color(0xffffffff),
        ),
      ));
    }
    index++;
  }

  return result;
}

List<JobTypePieChartRowData> buildJobTypeRowData(List<Job> jobsWithPaymentReceived, List<JobType> allJobTypes) {
  List<Job> jobsThisYearPaid = jobsWithPaymentReceived.where((job) => ((job.paymentReceivedDate != null ? job.paymentReceivedDate!.year : job.selectedDate!.year) == DateTime.now().year)).toList();
  var groupedList = <String, List<Job>>{};
  List<JobTypePieChartRowData> jobTypePieChartRowItems = [];

  for(Job job in jobsThisYearPaid) {
    groupedList.putIfAbsent(job.sessionType!.title!, () => <Job>[]).add(job);
  }

  int index = 0;
  for(JobType jobType in allJobTypes) {
    List<Job>? jobsForType = groupedList[jobType.title];
    if(jobsForType != null) {
      int count = jobsForType.length;
      int totalIncome = 0;

      for(Job groupJob in jobsForType) {
        totalIncome = totalIncome + (groupJob.invoice != null ? groupJob.invoice!.total!.toInt() : groupJob.sessionType != null ? groupJob.getJobCost().toInt() : 0);
      }

      jobTypePieChartRowItems.add(JobTypePieChartRowData(
        jobs: jobsForType,
        count: count,
        totalIncomeForType: totalIncome,
        jobType: jobType.title!,
        color: ColorConstants.getPieChartColor(index),
      ));
    }
    index++;
  }

  jobTypePieChartRowItems.sort((a, b) => a.count!.compareTo(b.count!));
  return jobTypePieChartRowItems;
}

bool _hasAJob(String clientDocumentId, List<Job> jobs) {
  List<Job> clientJobs = jobs.where((job) => job.clientDocumentId == clientDocumentId).toList();
  if(clientJobs.isNotEmpty) return true;
  return false;
}