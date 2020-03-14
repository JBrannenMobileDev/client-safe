
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/JobStage.dart';
import 'package:client_safe/models/Location.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageState.dart';

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
