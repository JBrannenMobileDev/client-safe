import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ClientDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobReminderDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobTypeDao.dart';
import 'package:dandylight/data_layer/local_db/daos/LocationDao.dart';
import 'package:dandylight/data_layer/local_db/daos/PriceProfileDao.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/models/JobType.dart';
import 'package:dandylight/models/LocationDandy.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageActions.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart';
import 'package:dandylight/utils/analytics/EventNames.dart';
import 'package:dandylight/utils/analytics/EventSender.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

import '../../data_layer/local_db/daos/ProfileDao.dart';
import '../../data_layer/repositories/FileStorage.dart';
import '../../models/JobStage.dart';
import '../../models/Profile.dart';
import '../../models/Proposal.dart';
import '../../models/ReminderDandyLight.dart';
import '../../utils/CalendarSyncUtil.dart';
import '../../utils/GlobalKeyUtil.dart';
import '../../utils/ImageUtil.dart';
import '../../utils/TextFormatterUtil.dart';
import '../../utils/UidUtil.dart';
import '../../utils/permissions/UserPermissionsUtil.dart';
import '../../utils/sunrise_sunset_library/sunrise_sunset.dart';
import '../calendar_page/CalendarPageActions.dart' as calendar;
import '../job_details_page/JobDetailsActions.dart' as jobDetails;
import '../new_reminder_page/WhenSelectionWidget.dart';

class NewJobPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchAllAction) {
      _loadAll(store, action, next);
    }

    if(action is SaveNewJobAction) {
      _saveNewJob(store, action, next);
    }

    if(action is FetchTimeOfSunsetAction) {
      _fetchSunsetTime(store, action, next);
    }
    if(action is SetSelectedDateAction || action is SetSelectedLocation){
      next(action);
    }
    if(action is FetchNewJobDeviceEvents) {
      _fetchDeviceEventsForMonth(store, action, next);
    }
    if(action is SetLastKnowInitialPosition){
      setLocationData(store, next, action);
    }
    if(action is UpdateWithNewPricePackageAction){
      fetchPriceProfilesAndSetSelected(store, action, next);
    }
    if(action is UpdateWithNewJobTypeAction){
      fetchJobTypeAndSetSelected(store, action, next);
    }
    if(action is UpdateProfileToOnBoardingCompleteAction) {
      updateProfileWithOnBoardingComplete(store, action, next);
    }
  }

  void updateProfileWithOnBoardingComplete(Store<AppState> store, UpdateProfileToOnBoardingCompleteAction action, NextDispatcher next) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.onBoardingComplete = true;
    await ProfileDao.update(profile);
    await ProfileDao.update(profile);
  }

  void fetchJobTypeAndSetSelected(Store<AppState> store, UpdateWithNewJobTypeAction action, NextDispatcher next) async {
    List<JobType> jobTypes = await JobTypeDao.getAll();
    store.dispatch(SetJobTypeAndSelectedAction(store.state.newJobPageState, action.jobType, jobTypes));
  }

  void fetchPriceProfilesAndSetSelected(Store<AppState> store, UpdateWithNewPricePackageAction action, NextDispatcher next) async {
    List<PriceProfile> priceProfiles = await PriceProfileDao.getAllSortedByName();
    store.dispatch(SetPriceProfilesAndSelectedAction(store.state.newJobPageState, action.priceProfile, priceProfiles));
  }

  void _fetchDeviceEventsForMonth(Store<AppState> store, FetchNewJobDeviceEvents action, NextDispatcher next) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    DateTime monthToUse = null;
    if(action != null) {
      monthToUse = action.month;
    } else {
      monthToUse = store.state.jobDetailsPageState.selectedDate;
    }

    if((await UserPermissionsUtil.getPermissionStatus(Permission.calendar)).isGranted) {
      DateTime startDate = DateTime(monthToUse.year, monthToUse.month - 1, 1);
      DateTime endDate = DateTime(monthToUse.year, monthToUse.month + 1, 1);

      List<Event> deviceEvents = await CalendarSyncUtil.getDeviceEventsForDateRange(startDate, endDate);
      store.dispatch(SetNewJobDeviceEventsAction(store.state.newJobPageState, deviceEvents));
    }
    store.dispatch(SetSelectedDateAction(store.state.newJobPageState, monthToUse));
  }

  void _fetchSunsetTime(Store<AppState> store, action, NextDispatcher next) async{
    LocationDandy selectedLocation = store.state.newJobPageState.selectedLocation;
    DateTime selectedDate = store.state.newJobPageState.selectedDate;
    if(selectedLocation != null && selectedDate != null) {
      final response = await SunriseSunset.getResults(date: selectedDate, latitude: selectedLocation.latitude, longitude: selectedLocation.longitude);
      store.dispatch(SetSunsetTimeAction(store.state.newJobPageState, response.data.sunset.toLocal()));
    }
  }

  void _loadAll(Store<AppState> store, action, NextDispatcher next) async {
    List<PriceProfile> allPriceProfiles = await PriceProfileDao.getAllSortedByName();
    List<Client> allClients = await ClientDao.getAllSortedByFirstName();
    List<LocationDandy> allLocations = await LocationDao.getAllSortedMostFrequent();
    List<Job> upcomingJobs = await JobDao.getAllJobs();
    List<JobType> jobTypes = await JobTypeDao.getAll();
    List<File> imageFiles = [];

    for(LocationDandy location in allLocations) {
      try{
        imageFiles.add(await FileStorage.getLocationImageFile(location));
      } on Exception {

      }
    }


    store.dispatch(SetAllToStateAction(store.state.newJobPageState, allClients, allPriceProfiles, allLocations, upcomingJobs, imageFiles, jobTypes));
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = appDocDir.path;
    store.dispatch(SetDocumentPathAction(store.state.newJobPageState, path));

    (await PriceProfileDao.getPriceProfilesStream()).listen((snapshots) async {
      List<PriceProfile> priceProfilesToUpdate = [];
      for(RecordSnapshot clientSnapshot in snapshots) {
        priceProfilesToUpdate.add(PriceProfile.fromMap(clientSnapshot.value));
      }
      store.dispatch(SetAllToStateAction(store.state.newJobPageState, allClients, priceProfilesToUpdate, allLocations, upcomingJobs, imageFiles, jobTypes));
    });

    (await LocationDao.getLocationsStream()).listen((locationSnapshots) async {
      List<LocationDandy> locations = [];
      List<File> imageFiles = [];

      for(RecordSnapshot locationSnapshot in locationSnapshots) {
        locations.add(LocationDandy.fromMap(locationSnapshot.value));
      }

      for(LocationDandy location in locations) {
        try{
          imageFiles.add(await FileStorage.getLocationImageFile(location));
        } on Exception {

        }
      }

      store.dispatch(SetAllToStateAction(store.state.newJobPageState, allClients, allPriceProfiles, locations, upcomingJobs, imageFiles, jobTypes));
    });

    (await JobDao.getJobsStream()).listen((jobSnapshots) async {
      List<Job> jobs = [];
      for(RecordSnapshot clientSnapshot in jobSnapshots) {
        jobs.add(Job.fromMap(clientSnapshot.value));
      }
      store.dispatch(SetAllToStateAction(store.state.newJobPageState, allClients, allPriceProfiles, allLocations, jobs, imageFiles, jobTypes));
    });
  }

  void _saveNewJob(Store<AppState> store, SaveNewJobAction action, NextDispatcher next) async {
    Client resultClient = store.state.newJobPageState.selectedClient;
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());

    String jobTitle = '';
    if(store.state.newJobPageState.selectedJobType != null) {
      jobTitle = resultClient.firstName + ' - ' + store.state.newJobPageState.selectedJobType.title;
    } else {
      jobTitle = resultClient.firstName + ' - Job';
    }

    Job jobToSave = Job(
      id: store.state.newJobPageState.id,
      documentId: store.state.newJobPageState.documentId,
      clientDocumentId: resultClient.documentId,
      client: resultClient,
      clientName: resultClient.getClientFullName(),
      jobTitle: jobTitle,
      selectedDate: store.state.newJobPageState.selectedDate,
      selectedTime: store.state.newJobPageState.selectedStartTime,
      selectedEndTime: store.state.newJobPageState.selectedEndTime,
      type: store.state.newJobPageState.selectedJobType,
      stage: JobStage.getNextStage(JobStage(stage: JobStage.STAGE_1_INQUIRY_RECEIVED), store.state.newJobPageState.selectedJobType.stages),
      completedStages: [JobStage(stage: JobStage.STAGE_1_INQUIRY_RECEIVED)],
      location: store.state.newJobPageState.selectedLocation,
      priceProfile: store.state.newJobPageState.selectedPriceProfile != null && store.state.newJobPageState.oneTimePrice.isEmpty ? store.state.newJobPageState.selectedPriceProfile
          : store.state.newJobPageState.oneTimePrice.isNotEmpty ? PriceProfile(
          rateType: Invoice.RATE_TYPE_FLAT_RATE,
          profileName: TextFormatterUtil.formatDecimalCurrencyFromString(store.state.newJobPageState.oneTimePrice),
          flatRate: double.parse(store.state.newJobPageState.oneTimePrice),
          icon: 'assets/images/icons/income_received.png',
          deposit: 0.0,
          salesTaxPercent: 0.0,
      ) : null,
      createdDate: DateTime.now(),
      depositAmount: store.state.newJobPageState.selectedPriceProfile != null ? store.state.newJobPageState.selectedPriceProfile.deposit?.toInt() : 0,
      proposal: Proposal(
        detailsMessage: "(Example client portal message)\n\nHi ${resultClient.firstName},\nI wanted to thank you again for choosing our photography services. We're excited to work with you to capture your special moments.\n\nTo make things official, kindly review and sign the contract. It outlines our agreement's essential details.\n\nIf you have any questions, please don't hesitate to ask.\n\nBest regards,\n\n${profile.firstName} ${profile.lastName ?? ''}\n${profile.businessName ?? ''}"
      )
      );

    await JobDao.insertOrUpdate(jobToSave);
    await _createJobReminders(store, resultClient);

    EventSender().sendEvent(eventName: EventNames.CREATED_JOB, properties: _buildEventProperties(jobToSave));

    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    store.dispatch(InitializeClientDetailsAction(store.state.clientDetailsPageState, store.state.clientDetailsPageState.client));
    store.dispatch(calendar.FetchAllCalendarJobsAction(store.state.calendarPageState));

    Job jobWithDocumentId = await JobDao.getJobBycreatedDate(jobToSave.createdDate);
    if(jobWithDocumentId != null) {
      store.dispatch(jobDetails.SetJobInfo(store.state.jobDetailsPageState, jobWithDocumentId.documentId));
    } else {
      GlobalKeyUtil.instance.navigatorKey.currentState.pop();
    }
  }

  void _createJobReminders(Store<AppState> store, Client jobClient) async {
    List<JobReminder> jobReminders = [];
    List<Job> jobs = await JobDao.getAllJobs();
    Job thisJob = null;
    String clientName = jobClient.firstName + " " + jobClient.lastName;
    String jobTitle = '';
    if(store.state.newJobPageState.selectedJobType != null) {
      jobTitle = store.state.newJobPageState.selectedClient.firstName + ' - ' + store.state.newJobPageState.selectedJobType.title;
    } else {
      jobTitle = store.state.newJobPageState.selectedClient.firstName + ' - Job';
    }
    DateTime selectedDate = store.state.newJobPageState.selectedDate;

    for (Job job in jobs) {
      if (job.clientName == clientName && job.jobTitle == jobTitle &&
          job.selectedDate == selectedDate) {
        thisJob = job;
      }
    }

    for (ReminderDandyLight reminder in store.state.newJobPageState.selectedJobType.reminders) {
      jobReminders.add(JobReminder(
        jobDocumentId: thisJob.documentId,
        reminder: reminder,
        hasBeenSeen: false,
        payload: thisJob.documentId,
      ));
    }

    if(thisJob.selectedDate != null && (thisJob.selectedEndTime != null || thisJob.selectedTime != null)) {
      jobReminders.add(JobReminder(
        id: JobReminder.MILEAGE_EXPENSE,
        jobDocumentId: thisJob.documentId,
        payload: JobReminder.MILEAGE_EXPENSE_ID,
        reminder: ReminderDandyLight(
          description: 'Have you entered your mileage expense?',
          when: WhenSelectionWidget.ON,
          time: thisJob.selectedEndTime != null ? thisJob.selectedEndTime.add(Duration(hours: 1)) : thisJob.selectedTime.add(Duration(hours: 1)),
        ),
        hasBeenSeen: false,
      ));
    }

    if(jobReminders.isNotEmpty) {
      await JobReminderDao.insertAll(jobReminders);
    }
  }

  void setLocationData(Store<AppState> store, NextDispatcher next, SetLastKnowInitialPosition action) async {
      Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
      store.dispatch(SetProfileToNewJobAction(store.state.newJobPageState, profile));
      Position positionLastKnown = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if(positionLastKnown != null) {
        store.dispatch(SetInitialMapLatLng(store.state.newJobPageState, positionLastKnown.latitude, positionLastKnown.longitude));
    }
  }

  Map<String, Object> _buildEventProperties(Job jobToSave) {
    Map<String, Object> result = Map();
    if(jobToSave.type != null) result.putIfAbsent(EventNames.JOB_PARAM_TYPE, () => jobToSave.type.title);
    if(jobToSave.selectedDate != null) result.putIfAbsent(EventNames.JOB_PARAM_JOB_DATE, () => jobToSave.selectedDate.toUtc().toString());
    if(jobToSave.selectedTime != null) result.putIfAbsent(EventNames.JOB_PARAM_START_TIME, () => jobToSave.selectedTime.toUtc().toString());
    if(jobToSave.selectedEndTime != null) result.putIfAbsent(EventNames.JOB_PARAM_END_TIME, () => jobToSave.selectedEndTime.toUtc().toString());
    if(jobToSave.priceProfile != null) result.putIfAbsent(EventNames.JOB_PARAM_PRICE_PACKAGE, () => jobToSave.priceProfile.profileName);
    if(jobToSave.location != null) result.putIfAbsent(EventNames.JOB_PARAM_TYPE, () => jobToSave.location.locationName);
    if(jobToSave.type != null) result.putIfAbsent(EventNames.JOB_PARAM_TYPE, () => jobToSave.type.title);
    return result;
  }
}