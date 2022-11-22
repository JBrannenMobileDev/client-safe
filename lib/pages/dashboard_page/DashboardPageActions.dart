import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/home_page/HomePageState.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';

import '../../models/JobReminder.dart';
import '../../models/JobType.dart';
import '../../models/MileageExpense.dart';
import '../../models/RecurringExpense.dart';
import '../../models/SingleExpense.dart';


class InitDashboardPageAction{
  final DashboardPageState item;
  InitDashboardPageAction(this.item);
}

class DisposeDataListenersActions{
  final HomePageState item;
  DisposeDataListenersActions(this.item);
}

class LoadJobsAction{
  final DashboardPageState pageState;
  LoadJobsAction(this.pageState);
}

class SetJobToStateAction{
  final DashboardPageState pageState;
  final List<Job> allJobs;
  final List<SingleExpense> singleExpenses;
  final List<RecurringExpense> recurringExpense;
  final List<MileageExpense> mileageExpenses;
  SetJobToStateAction(this.pageState, this.allJobs, this.singleExpenses, this.recurringExpense, this.mileageExpenses);
}

class SetJobTypeChartData{
  final DashboardPageState pageState;
  final List<Job> allJobs;
  final List<JobType> allJobTypes;
  SetJobTypeChartData(this.pageState, this.allJobs, this.allJobTypes);
}

class SetUnseenReminderCount{
  final DashboardPageState pageState;
  final int count;
  final List<JobReminder> reminders;
  SetUnseenReminderCount(this.pageState, this.count, this.reminders);
}

class SetShowNewMileageExpensePageAction{
  final DashboardPageState pageState;
  final bool shouldShow;
  SetShowNewMileageExpensePageAction(this.pageState, this.shouldShow);
}

class SetClientsDashboardAction{
  final DashboardPageState pageState;
  final List<Client> clients;
  SetClientsDashboardAction(this.pageState, this.clients);
}

class UpdateShowHideState{
  final DashboardPageState pageState;
  UpdateShowHideState(this.pageState);
}

class UpdateShowHideLeadsState{
  final DashboardPageState pageState;
  UpdateShowHideLeadsState(this.pageState);
}

class SetNotificationsToSeen{
  final DashboardPageState pageState;
  SetNotificationsToSeen(this.pageState);
}

class UpdateNotificationIconAction {
  final DashboardPageState pageState;
  UpdateNotificationIconAction(this.pageState);
}
