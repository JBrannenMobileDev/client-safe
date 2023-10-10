import 'dart:ui';

import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../models/JobReminder.dart';
import '../../models/JobType.dart';
import '../../models/LocationDandy.dart';
import '../../models/MileageExpense.dart';
import '../../models/Pose.dart';
import '../../models/Profile.dart';
import '../../models/RecurringExpense.dart';
import '../../models/SingleExpense.dart';


class InitDashboardPageAction{
  final DashboardPageState item;
  InitDashboardPageAction(this.item);
}

class UpdateProfileRestorePurchasesSeen {
  final DashboardPageState pageState;
  UpdateProfileRestorePurchasesSeen(this.pageState);
}

class SetGoToPosesJob {
  final DashboardPageState pageState;
  final Job goToPosesJob;
  SetGoToPosesJob(this.pageState, this.goToPosesJob);
}

class LoadJobsAction{
  final DashboardPageState pageState;
  LoadJobsAction(this.pageState);
}

class SetSubscriptionStateAction{
  final DashboardPageState pageState;
  final CustomerInfo subscriptionState;
  SetSubscriptionStateAction(this.pageState, this.subscriptionState);
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

class SetProfileDashboardAction{
  final DashboardPageState pageState;
  final Profile profile;
  SetProfileDashboardAction(this.pageState, this.profile);
}

class SetUnseenReminderCount{
  final DashboardPageState pageState;
  final int count;
  final List<JobReminder> reminders;
  SetUnseenReminderCount(this.pageState, this.count, this.reminders);
}

class SetUnseenFeaturedPosesAction {
  final DashboardPageState pageState;
  final List<Pose> unseenFeaturedPoses;
  SetUnseenFeaturedPosesAction(this.pageState, this.unseenFeaturedPoses);
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

class SetNotificationToSeen{
  final DashboardPageState pageState;
  final JobReminder reminder;
  SetNotificationToSeen(this.pageState, this.reminder);
}

class SetUnseenFeaturedPosesAsSeenAction {
  final DashboardPageState pageState;
  SetUnseenFeaturedPosesAsSeenAction(this.pageState);
}

class UpdateNotificationIconAction {
  final DashboardPageState pageState;
  UpdateNotificationIconAction(this.pageState);
}

class UpdateProfileWithShowcaseSeen {
  final DashboardPageState pageState;
  UpdateProfileWithShowcaseSeen(this.pageState);
}

class MarkAllAsSeenAction {
  final DashboardPageState pageState;
  MarkAllAsSeenAction(this.pageState);
}

class CheckForGoToJobAction {
  final DashboardPageState pageState;
  CheckForGoToJobAction(this.pageState);
}

class CheckForReviewRequestAction {
  final DashboardPageState pageState;
  final bool shouldShow;
  CheckForReviewRequestAction(this.pageState, this.shouldShow);
}

class CheckForPMFSurveyAction {
  final DashboardPageState pageState;
  final bool shouldShow;
  CheckForPMFSurveyAction(this.pageState, this.shouldShow);
}

class UpdateCanShowPMFSurveyAction {
  final DashboardPageState pageState;
  final bool canShow;
  final DateTime lastSeenDate;
  UpdateCanShowPMFSurveyAction(this.pageState, this.canShow, this.lastSeenDate);
}

class UpdateCanShowRequestReviewAction {
  final DashboardPageState pageState;
  final bool canShow;
  final DateTime lastSeenDate;
  UpdateCanShowRequestReviewAction(this.pageState, this.canShow, this.lastSeenDate);
}

class SetGoToAsSeenAction {
  final DashboardPageState pageState;
  SetGoToAsSeenAction(this.pageState);
}

class LaunchDrivingDirectionsAction {
  final DashboardPageState pageState;
  final LocationDandy location;
  LaunchDrivingDirectionsAction(this.pageState, this.location);
}
