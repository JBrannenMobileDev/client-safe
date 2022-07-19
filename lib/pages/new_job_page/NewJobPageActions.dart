
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';

import '../../models/Reminder.dart';

class UpdateErrorStateAction{
  final NewJobPageState pageState;
  final String errorCode;
  UpdateErrorStateAction(this.pageState, this.errorCode);
}

class InitializeNewContactPageAction{
  final NewJobPageState pageState;
  final Client client;
  InitializeNewContactPageAction(this.pageState, this.client);
}

class SetSelectedTimeAction{
  final NewJobPageState pageState;
  final DateTime time;
  SetSelectedTimeAction(this.pageState, this.time);
}

class SetSunsetTimeAction{
  final NewJobPageState pageState;
  final DateTime sunset;
  SetSunsetTimeAction(this.pageState, this.sunset);
}

class FetchTimeOfSunsetAction{
  final NewJobPageState pageState;
  FetchTimeOfSunsetAction(this.pageState);
}

class SetSelectedDateAction{
  final NewJobPageState pageState;
  final DateTime selectedDate;
  SetSelectedDateAction(this.pageState, this.selectedDate);
}

class SetSelectedJobStageAction{
  final NewJobPageState pageState;
  final JobStage jobStage;
  SetSelectedJobStageAction(this.pageState, this.jobStage);
}

class SetSelectedJobReminderAction{
  final NewJobPageState pageState;
  final Reminder reminder;
  SetSelectedJobReminderAction(this.pageState, this.reminder);
}

class SetAllRemindersAction{
  final NewJobPageState pageState;
  final List<Reminder> reminders;
  SetAllRemindersAction(this.pageState, this.reminders);
}

class SetDefaultRemindersAction{
  final NewJobPageState pageState;
  final List<Reminder> defaultReminders;
  SetDefaultRemindersAction(this.pageState, this.defaultReminders);
}

class FetchAllRemindersAction{
  final NewJobPageState pageState;
  FetchAllRemindersAction(this.pageState);
}

class SetSelectedJobTypeAction{
  final NewJobPageState pageState;
  final String jobType;
  SetSelectedJobTypeAction(this.pageState, this.jobType);
}

class SetJobTitleAction{
  final NewJobPageState pageState;
  final String jobTitle;
  SetJobTitleAction(this.pageState, this.jobTitle);
}

class SetSelectedPriceProfile{
  final NewJobPageState pageState;
  final PriceProfile priceProfile;
  SetSelectedPriceProfile(this.pageState, this.priceProfile);
}

class SetSelectedLocation{
  final NewJobPageState pageState;
  final Location location;
  SetSelectedLocation(this.pageState, this.location);
}

class ClearStateAction{
  final NewJobPageState pageState;
  ClearStateAction(this.pageState);
}

class IncrementPageViewIndex{
  final NewJobPageState pageState;
  IncrementPageViewIndex(this.pageState);
}

class DecrementPageViewIndex{
  final NewJobPageState pageState;
  DecrementPageViewIndex(this.pageState);
}

class SaveNewJobAction{
  final NewJobPageState pageState;
  SaveNewJobAction(this.pageState);
}

class FilterClientList{
  final NewJobPageState pageState;
  final String textInput;
  FilterClientList(this.pageState, this.textInput);
}

class ClearSearchInputActon{
  final NewJobPageState pageState;
  ClearSearchInputActon(this.pageState);
}

class FetchAllClientsAction{
  final NewJobPageState pageState;
  FetchAllClientsAction(this.pageState);
}

class SetAllToStateAction{
  final NewJobPageState pageState;
  final List<Client> allClients;
  final List<PriceProfile> allPriceProfiles;
  final List<Location> allLocations;
  final List<Job> upcomingJobs;
  SetAllToStateAction(this.pageState, this.allClients, this.allPriceProfiles, this.allLocations, this.upcomingJobs);
}

class ClientSelectedAction{
  final NewJobPageState pageState;
  final Client client;
  ClientSelectedAction(this.pageState, this.client);
}

class InitNewJobPageWithDateAction{
  final NewJobPageState pageState;
  final DateTime selectedDate;
  InitNewJobPageWithDateAction(this.pageState, this.selectedDate);
}

class AddToDepositAmountAction{
  final NewJobPageState pageState;
  final int amountToAdd;
  AddToDepositAmountAction(this.pageState, this.amountToAdd);
}

class ClearDepositAction{
  final NewJobPageState pageState;
  ClearDepositAction(this.pageState);
}

class SetDocumentPathAction{
  final NewJobPageState pageState;
  final String documentPath;
  SetDocumentPathAction(this.pageState, this.documentPath);
}

class UpdateComingFromClientDetails{
  final NewJobPageState pageState;
  final bool isComingFromClientDetails;
  UpdateComingFromClientDetails(this.pageState, this.isComingFromClientDetails);
}

