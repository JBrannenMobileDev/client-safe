import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ClientDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobReminderDao.dart';
import 'package:dandylight/data_layer/local_db/daos/LocationDao.dart';
import 'package:dandylight/data_layer/local_db/daos/PriceProfileDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ReminderDao.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageActions.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

import '../../data_layer/local_db/daos/ProfileDao.dart';
import '../../models/JobStage.dart';
import '../../models/Profile.dart';
import '../../models/ReminderDandyLight.dart';
import '../../utils/CalendarSyncUtil.dart';
import '../../utils/ImageUtil.dart';
import '../../utils/UidUtil.dart';
import '../../utils/sunrise_sunset_library/sunrise_sunset.dart';

class NewJobPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchAllClientsAction) {
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
      _fetchSunsetTime(store, action, next);
    }
    if(action is FetchAllRemindersAction) {
      _fetchAllReminders(store, action, next);
    }
    if(action is FetchNewJobDeviceEvents) {
      _fetchDeviceEventsForMonth(store, action, next);
    }
  }

  void _fetchDeviceEventsForMonth(Store<AppState> store, FetchNewJobDeviceEvents action, NextDispatcher next) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    DateTime monthToUse = null;
    if(action != null) {
      monthToUse = action.month;
    } else {
      monthToUse = store.state.jobDetailsPageState.selectedDate;
    }

    if(profile.calendarEnabled) {
      DateTime startDate = DateTime(monthToUse.year, monthToUse.month - 1, 1);
      DateTime endDate = DateTime(monthToUse.year, monthToUse.month + 1, 1);

      List<Event> deviceEvents = await CalendarSyncUtil.getDeviceEventsForDateRange(startDate, endDate);
      store.dispatch(SetNewJobDeviceEventsAction(store.state.newJobPageState, deviceEvents));
    }
    store.dispatch(SetSelectedDateAction(store.state.newJobPageState, monthToUse));
  }

  void _fetchSunsetTime(Store<AppState> store, action, NextDispatcher next) async{
    Location selectedLocation = store.state.newJobPageState.selectedLocation;
    DateTime selectedDate = store.state.newJobPageState.selectedDate;
    if(selectedLocation != null && selectedDate != null) {
      final response = await SunriseSunset.getResults(date: selectedDate, latitude: selectedLocation.latitude, longitude: selectedLocation.longitude);
      store.dispatch(SetSunsetTimeAction(store.state.newJobPageState, response.data.sunset.toLocal()));
    }
  }

  void _loadAll(Store<AppState> store, action, NextDispatcher next) async {
    List<PriceProfile> allPriceProfiles = await PriceProfileDao.getAllSortedByName();
    List<Client> allClients = await ClientDao.getAllSortedByFirstName();
    List<Location> allLocations = await LocationDao.getAllSortedMostFrequent();
    List<Job> upcomingJobs = await JobDao.getAllJobs();
    store.dispatch(SetAllToStateAction(store.state.newJobPageState, allClients, allPriceProfiles, allLocations, upcomingJobs));
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = appDocDir.path;
    store.dispatch(SetDocumentPathAction(store.state.newJobPageState, path));

    (await PriceProfileDao.getPriceProfilesStream()).listen((snapshots) async {
      List<PriceProfile> priceProfilesToUpdate = List();
      for(RecordSnapshot clientSnapshot in snapshots) {
        priceProfilesToUpdate.add(PriceProfile.fromMap(clientSnapshot.value));
      }
      store.dispatch(SetAllToStateAction(store.state.newJobPageState, allClients, priceProfilesToUpdate, allLocations, upcomingJobs));
    });

    (await LocationDao.getLocationsStream()).listen((locationSnapshots) {
      List<Location> locations = List();
      for(RecordSnapshot locationSnapshot in locationSnapshots) {
        locations.add(Location.fromMap(locationSnapshot.value));
      }
      store.dispatch(SetAllToStateAction(store.state.newJobPageState, allClients, allPriceProfiles, locations, upcomingJobs));
    });

    (await JobDao.getJobsStream()).listen((jobSnapshots) async {
      List<Job> jobs = [];
      for(RecordSnapshot clientSnapshot in jobSnapshots) {
        jobs.add(Job.fromMap(clientSnapshot.value));
      }
      store.dispatch(SetAllToStateAction(store.state.newJobPageState, allClients, allPriceProfiles, allLocations, jobs));
    });
  }

  void _saveNewJob(Store<AppState> store, action, NextDispatcher next) async {
    Client resultClient = store.state.newJobPageState.selectedClient;
    if(store.state.newJobPageState.selectedClient == null) {
      String clientId = await ClientDao.insert(
        Client(
          firstName: store.state.newJobPageState.clientFirstName,
          lastName: store.state.newJobPageState.clientLastName,
          iconUrl: ImageUtil.getRandomPersonIcon().assetName
        )
      );
      resultClient = await ClientDao.getClientById(clientId);
    }

    Job jobToSave = Job(
      id: store.state.newJobPageState.id,
      documentId: store.state.newJobPageState.documentId,
      clientDocumentId: resultClient.documentId,
      clientName: resultClient.getClientFullName(),
      jobTitle: store.state.newJobPageState.jobTitle,
      selectedDate: store.state.newJobPageState.selectedDate,
      selectedTime: store.state.newJobPageState.selectedTime,
      type: store.state.newJobPageState.jobType,
      stage: JobStage(stage: JobStage.STAGE_2_FOLLOWUP_SENT, value: 2),
      completedStages: [JobStage(stage: JobStage.STAGE_1_INQUIRY_RECEIVED, value: 1)],
      location: store.state.newJobPageState.selectedLocation,
      priceProfile: store.state.newJobPageState.selectedPriceProfile,
      depositAmount: store.state.newJobPageState.depositAmount,
      createdDate: DateTime.now(),
      );
    await JobDao.insertOrUpdate(jobToSave);
    await _createJobReminders(store, resultClient);
    store.dispatch(ClearStateAction(store.state.newJobPageState));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    store.dispatch(InitializeClientDetailsAction(store.state.clientDetailsPageState, store.state.clientDetailsPageState.client));
  }

  void _fetchAllReminders(Store<AppState> store, FetchAllRemindersAction action, NextDispatcher next) async {
    List<ReminderDandyLight> allReminders = await ReminderDao.getAll();
    List<ReminderDandyLight> defaultReminders = [];
    for(ReminderDandyLight reminder in allReminders) {
      if(reminder.isDefault) defaultReminders.add(reminder);
    }
    store.dispatch(SetAllRemindersAction(store.state.newJobPageState, allReminders));
    store.dispatch(SetDefaultRemindersAction(store.state.newJobPageState, defaultReminders));
  }

  void _createJobReminders(Store<AppState> store, Client jobClient) async {
    List<JobReminder> jobReminders = [];
    List<Job> jobs = await JobDao.getAllJobs();
    Job thisJob = null;
    String clientName = jobClient.firstName +
        " " + jobClient.lastName;
    String jobTitle = store.state.newJobPageState.jobTitle;
    DateTime selectedDate = store.state.newJobPageState.selectedDate;

    for (Job job in jobs) {
      if (job.clientName == clientName && job.jobTitle == jobTitle &&
          job.selectedDate == selectedDate) {
        thisJob = job;
      }
    }

    for (ReminderDandyLight reminder in store.state.newJobPageState.selectedReminders) {
      jobReminders.add(JobReminder(
        jobDocumentId: thisJob.documentId,
        reminder: reminder,
      ));
    }

    if(jobReminders.isNotEmpty) {
      await JobReminderDao.insertAll(jobReminders);
    }
  }
}