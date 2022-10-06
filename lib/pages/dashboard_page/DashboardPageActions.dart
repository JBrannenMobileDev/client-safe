import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/home_page/HomePageState.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';

import '../../models/JobReminder.dart';


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
  SetJobToStateAction(this.pageState, this.allJobs);
}

class SetUnseenReminderCount{
  final DashboardPageState pageState;
  final int count;
  final List<JobReminder> reminders;
  SetUnseenReminderCount(this.pageState, this.count, this.reminders);
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
