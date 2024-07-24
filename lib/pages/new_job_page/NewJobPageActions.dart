
import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/LocationDandy.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:device_calendar/device_calendar.dart';

import '../../models/JobType.dart';
import '../../models/Profile.dart';
import '../../models/SessionType.dart';

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

class SetSelectedSessionTypeAction{
  final NewJobPageState? pageState;
  final SessionType? sessionType;
  SetSelectedSessionTypeAction(this.pageState, this.sessionType);
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

class LoadNewJobWithClientAction {
  final NewJobPageState? pageState;
  final Client? client;
  LoadNewJobWithClientAction(this.pageState, this.client);
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
  final List<SessionType>? sessionTypes;
  SetAllToStateAction(this.pageState, this.allClients, this.allPriceProfiles, this.allLocations, this.upcomingJobs, this.imageFiles, this.sessionTypes);
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

class UpdateWithNewSessionTypeAction{
  final NewJobPageState? pageState;
  final SessionType? sessionType;
  UpdateWithNewSessionTypeAction(this.pageState, this.sessionType);
}

class SetJobTypeAndSelectedAction{
  final NewJobPageState? pageState;
  final SessionType? sessionType;
  final List<SessionType>? sessionTypes;
  SetJobTypeAndSelectedAction(this.pageState, this.sessionType, this.sessionTypes);
}

class UpdateClientEmailAction {
  final NewJobPageState? pageState;
  final String email;
  UpdateClientEmailAction(this.pageState, this.email);
}

class UpdateClientLastNameAction {
  final NewJobPageState? pageState;
  final String lastName;
  UpdateClientLastNameAction(this.pageState, this.lastName);
}

class UpdateClientPhoneAction {
  final NewJobPageState? pageState;
  final String phone;
  UpdateClientPhoneAction(this.pageState, this.phone);
}

class UpdateClientInstagramUrlAction {
  final NewJobPageState? pageState;
  final String url;
  UpdateClientInstagramUrlAction(this.pageState, this.url);
}

class FilterDeviceContactsNewJobAction{
  final NewJobPageState? pageState;
  final String? textInput;
  FilterDeviceContactsNewJobAction(this.pageState, this.textInput);
}

class SetSelectedNewJobDeviceContactAction{
  final NewJobPageState? pageState;
  final Contact? selectedContact;
  SetSelectedNewJobDeviceContactAction(this.pageState, this.selectedContact);
}

class GetNewJobDeviceContactsAction{
  final NewJobPageState? pageState;
  GetNewJobDeviceContactsAction(this.pageState);
}

class SetDeviceContactsAction {
  final NewJobPageState? pageState;
  final List<Contact> deviceContacts;
  SetDeviceContactsAction(this.pageState, this.deviceContacts);
}

class SetLeadSourceAction {
  final NewJobPageState? pageState;
  final String? sourceName;
  SetLeadSourceAction(this.pageState, this.sourceName);
}

class SetDeviceClientFirstNameAction {
  final NewJobPageState? pageState;
  final String? firstName;
  SetDeviceClientFirstNameAction(this.pageState, this.firstName);
}

class SetCustomLeadSourceAction {
  final NewJobPageState? pageState;
  final String? customName;
  SetCustomLeadSourceAction(this.pageState, this.customName);
}

