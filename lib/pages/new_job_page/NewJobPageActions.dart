
import 'dart:io';

import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/LocationDandy.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:device_calendar/device_calendar.dart';

import '../../models/JobType.dart';
import '../../models/Profile.dart';

class UpdateErrorStateAction{
  final NewJobPageState? pageState;
  final String? errorCode;
  UpdateErrorStateAction(this.pageState, this.errorCode);
}

class SetLastKnowInitialPosition{
  final NewJobPageState? pageState;
  SetLastKnowInitialPosition(this.pageState);
}

class SetInitialMapLatLng{
  final NewJobPageState? pageState;
  final double? lat;
  final double? lng;
  SetInitialMapLatLng(this.pageState, this.lat, this.lng);
}

class SetProfileToNewJobAction {
  final NewJobPageState? pageState;
  final Profile? profile;
  SetProfileToNewJobAction(this.pageState, this.profile);
}

class FetchNewJobDeviceEvents{
  final NewJobPageState? calendarPageState;
  final DateTime? month;
  FetchNewJobDeviceEvents(this.calendarPageState, this.month);
}

class UpdateProfileToOnBoardingCompleteAction {
  final NewJobPageState? pageState;
  UpdateProfileToOnBoardingCompleteAction(this.pageState);
}

class SetClientFirstNameAction{
  final NewJobPageState? pageState;
  final String? firstName;
  SetClientFirstNameAction(this.pageState, this.firstName);
}

class SetOneTimePriceTextAction {
  final NewJobPageState? pageState;
  final String? inputText;
  SetOneTimePriceTextAction(this.pageState, this.inputText);
}

class LoadAndSelectNewContactAction{
  final NewJobPageState? pageState;
  final Client? selectedClient;
  LoadAndSelectNewContactAction(this.pageState, this.selectedClient);
}

class InitializeNewContactPageAction{
  final NewJobPageState? pageState;
  final Client? client;
  InitializeNewContactPageAction(this.pageState, this.client);
}

class SetSelectedStartTimeAction{
  final NewJobPageState? pageState;
  final DateTime? time;
  SetSelectedStartTimeAction(this.pageState, this.time);
}

class SetSelectedEndTimeAction{
  final NewJobPageState? pageState;
  final DateTime? time;
  SetSelectedEndTimeAction(this.pageState, this.time);
}

class SetSunsetTimeAction{
  final NewJobPageState? pageState;
  final DateTime? sunset;
  SetSunsetTimeAction(this.pageState, this.sunset);
}

class FetchTimeOfSunsetAction{
  final NewJobPageState? pageState;
  FetchTimeOfSunsetAction(this.pageState);
}

class SetSelectedDateAction{
  final NewJobPageState? pageState;
  final DateTime? selectedDate;
  SetSelectedDateAction(this.pageState, this.selectedDate);
}

class SetNewJobDeviceEventsAction {
  final NewJobPageState? pageState;
  final List<Event>? deviceEvents;
  SetNewJobDeviceEventsAction(this.pageState, this.deviceEvents);
}

class SetSelectedJobTypeAction{
  final NewJobPageState? pageState;
  final JobType? jobType;
  SetSelectedJobTypeAction(this.pageState, this.jobType);
}

class SetSelectedPriceProfile{
  final NewJobPageState? pageState;
  final PriceProfile? priceProfile;
  SetSelectedPriceProfile(this.pageState, this.priceProfile);
}

class SetSelectedLocation{
  final NewJobPageState? pageState;
  final LocationDandy? location;
  SetSelectedLocation(this.pageState, this.location);
}

class SetSelectedOneTimeLocation{
  final NewJobPageState? pageState;
  final LocationDandy? location;
  SetSelectedOneTimeLocation(this.pageState, this.location);
}

class ClearStateAction{
  final NewJobPageState? pageState;
  ClearStateAction(this.pageState);
}

class IncrementPageViewIndex{
  final NewJobPageState? pageState;
  IncrementPageViewIndex(this.pageState);
}

class DecrementPageViewIndex{
  final NewJobPageState? pageState;
  DecrementPageViewIndex(this.pageState);
}

class SaveNewJobAction{
  final NewJobPageState? pageState;
  SaveNewJobAction(this.pageState);
}

class ClearSearchInputActon{
  final NewJobPageState? pageState;
  ClearSearchInputActon(this.pageState);
}

class FetchAllAction{
  final NewJobPageState? pageState;
  FetchAllAction(this.pageState);
}

class SetEventListAction {
  final NewJobPageState? pageState;
  final List<Event>? deviceEvents;
  SetEventListAction(this.pageState, this.deviceEvents);
}

class SetAllToStateAction{
  final NewJobPageState? pageState;
  final List<Client>? allClients;
  final List<PriceProfile>? allPriceProfiles;
  final List<LocationDandy>? allLocations;
  final List<Job>? upcomingJobs;
  final List<File?>? imageFiles;
  final List<JobType>? jobTypes;
  SetAllToStateAction(this.pageState, this.allClients, this.allPriceProfiles, this.allLocations, this.upcomingJobs, this.imageFiles, this.jobTypes);
}

class ClientSelectedAction{
  final NewJobPageState? pageState;
  final Client? client;
  ClientSelectedAction(this.pageState, this.client);
}

class InitNewJobPageWithDateAction {
  final NewJobPageState? pageState;
  final DateTime? selectedDate;
  InitNewJobPageWithDateAction(this.pageState, this.selectedDate);
}

class SetDocumentPathAction{
  final NewJobPageState? pageState;
  final String? documentPath;
  SetDocumentPathAction(this.pageState, this.documentPath);
}

class UpdateComingFromClientDetails{
  final NewJobPageState? pageState;
  final bool? isComingFromClientDetails;
  UpdateComingFromClientDetails(this.pageState, this.isComingFromClientDetails);
}

class UpdateWithNewPricePackageAction{
  final NewJobPageState? pageState;
  final PriceProfile? priceProfile;
  UpdateWithNewPricePackageAction(this.pageState, this.priceProfile);
}

class SetPriceProfilesAndSelectedAction{
  final NewJobPageState? pageState;
  final PriceProfile? priceProfile;
  final List<PriceProfile>? priceProfiles;
  SetPriceProfilesAndSelectedAction(this.pageState, this.priceProfile, this.priceProfiles);
}

class UpdateWithNewJobTypeAction{
  final NewJobPageState? pageState;
  final JobType? jobType;
  UpdateWithNewJobTypeAction(this.pageState, this.jobType);
}

class SetJobTypeAndSelectedAction{
  final NewJobPageState? pageState;
  final JobType? jobType;
  final List<JobType>? jobTypes;
  SetJobTypeAndSelectedAction(this.pageState, this.jobType, this.jobTypes);
}

