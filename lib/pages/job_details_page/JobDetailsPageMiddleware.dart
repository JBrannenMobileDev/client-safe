import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ClientDao.dart';
import 'package:dandylight/data_layer/local_db/daos/InvoiceDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/SessionTypeDao.dart';
import 'package:dandylight/data_layer/local_db/daos/LocationDao.dart';
import 'package:dandylight/data_layer/local_db/daos/MileageExpenseDao.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/models/SessionType.dart';
import 'package:dandylight/models/LocationDandy.dart';
import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageActions.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:dandylight/pages/job_details_page/document_items/DocumentItem.dart';
import 'package:dandylight/pages/jobs_page/JobsPageActions.dart';
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:dandylight/utils/intentLauncher/IntentLauncherUtil.dart';
import 'package:dandylight/utils/NotificationHelper.dart';
import 'package:dandylight/utils/analytics/EventNames.dart';
import 'package:dandylight/utils/analytics/EventSender.dart';
import 'package:dandylight/utils/sunrise_sunset_library/sunrise_sunset.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';
import 'package:http/http.dart' as http;

import '../../credentials.dart';
import '../../data_layer/api_clients/AccuWeatherClient.dart';
import '../../data_layer/local_db/daos/JobReminderDao.dart';
import '../../data_layer/local_db/daos/ProfileDao.dart';
import '../../data_layer/repositories/FileStorage.dart';
import '../../data_layer/repositories/WeatherRepository.dart';
import '../../models/Contract.dart';
import '../../models/JobReminder.dart';
import '../../models/Pose.dart';
import '../../models/Profile.dart';
import '../../models/Progress.dart';
import '../../models/Proposal.dart';
import '../../models/rest_models/AccuWeatherModels/forecastFiveDay/ForecastFiveDayResponse.dart';
import '../../utils/CalendarSyncUtil.dart';
import '../../utils/UidUtil.dart';

class JobDetailsPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SaveStageCompleted){
      updateJobStageToNextStage(store, next, action);
    }
    if(action is UndoStageAction){
      undoStage(store, next, action);
    }
    if(action is DeleteJobAction){
      deleteJob(store, next, action);
    }
    if(action is SetJobInfo){
      setJobInfo(store, next, action);
    }
    if(action is JobInstagramSelectedAction){
      _launchInstagramProfile(store.state.jobDetailsPageState!.client!.instagramProfileUrl!);
    }
    if(action is FetchTimeOfSunsetJobAction){
      _fetchSunsetTime(store, action, next);
    }
    if(action is UpdateJobTimeAction){
      _updateJobWithNewTime(store, action, next);
    }
    if(action is UpdateJobEndTimeAction){
      _updateJobWithNewEndTime(store, action, next);
    }
    if(action is UpdateJobDateAction){
      _updateJobWithNewDate(store, action, next);
    }
    if(action is FetchJobsForDateSelection){
      _fetchAllJobs(store, action, next);
    }
    if(action is FetchJobDetailsLocationsAction){
      _fetchLocations(store, action, next);
    }
    if(action is UpdateNewLocationAction){
      _updateJobLocation(store, action, next);
    }
    if(action is SaveJobNameChangeAction){
      _updateJobName(store, action, next);
    }
    if(action is SaveUpdatedSessionTypeAction){
      _updateSessionType(store, action, next);
    }
    if(action is SaveAddOnCostAction){
      _updateJobAddOnCost(store, action, next);
    }
    if(action is SaveTipChangeAction){
      _updateJobTip(store, action, next);
    }
    if(action is OnDeleteInvoiceSelectedAction){
      deleteInvoice(store, action, next);
    }
    if(action is OnDeleteContractSelectedAction){
      deleteContract(store, action, next);
    }
    if(action is InvoiceSentAction){
      updateInvoiceToSent(store, action, next);
    }
    if(action is FetchJobRemindersAction){
      _fetchReminders(store, action, next);
    }
    if(action is DeleteReminderFromJobAction){
      _deleteReminder(store, action, next);
    }
    if(action is FetchJobDetailsDeviceEvents) {
      _fetchDeviceEventsForMonth(store, action, next);
    }
    if(action is FetchAllSessionTypesAction) {
      _fetchSessionTypes(store, action, next);
    }
    if(action is FetchJobPosesAction) {
      _fetchJobPoses(store);
    }
    if(action is DeleteJobPoseAction) {
      _deletePose(store, action, next);
    }
    if(action is SaveJobNotesAction) {
      _saveJobNotes(store, action, next);
    }
    if(action is SetOnBoardingCompleteAction) {
      updateProfileWithOnBoardingComplete(store, action, next);
    }
    if(action is DrivingDirectionsJobSelected) {
      _launchDrivingDirections(store, action);
    }
    if(action is SetShouldTrackAction) {
      _saveTrackMilesState(store, action, next);
    }
    if(action is SaveJobDetailsHomeLocationAction) {
      saveHomeLocation(store, action, next);
    }
    if(action is DeleteQuestionnaireFromJobAction) {
      deleteQuestionnaireFromJob(store, action, next);
    }
    if(action is MarkContractAsVoidAction) {
      markContractAsVoid(store, action, next);
    }
  }

  void deleteQuestionnaireFromJob(Store<AppState> store, DeleteQuestionnaireFromJobAction action, NextDispatcher next) async{
    if(action.questionnaire.jobDocumentId != null && action.questionnaire.jobDocumentId!.isNotEmpty) {
      action.pageState.job!.proposal!.questionnaires!.removeWhere((questionnaire) => questionnaire.documentId == action.questionnaire.documentId);
      JobDao.update(action.pageState.job!);
      store.dispatch(LoadJobsAction(store.state.dashboardPageState));
      store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, action.pageState.job));
      store.dispatch(SetJobAction(store.state.jobDetailsPageState, action.pageState.job));
    }
  }

  void markContractAsVoid(Store<AppState> store, MarkContractAsVoidAction action, NextDispatcher next) async{
    Contract contract = action.contract;
    contract.isVoid = true;

    int indexToUpdate = action.pageState.job!.proposal!.contracts!.indexWhere((item) => item.documentId == contract.documentId);
    action.pageState.job!.proposal!.contracts![indexToUpdate] = contract; //TODO make sure this works also add a check in client portal client signing to check for if the contract is void.

    JobDao.update(action.pageState.job!);
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, action.pageState.job));
    store.dispatch(SetJobAction(store.state.jobDetailsPageState, action.pageState.job));
  }

  void saveHomeLocation(Store<AppState> store, SaveJobDetailsHomeLocationAction action, NextDispatcher next) async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.latDefaultHome = action.startLocation!.latitude;
    profile.lngDefaultHome = action.startLocation!.longitude;
    await ProfileDao.insertOrUpdate(profile);
    store.dispatch(SetProfileToDetailsStateAction(store.state.jobDetailsPageState, profile));
  }

  Future<GeoData> getAddress(double lat, double lng) async {
    return await Geocoder2.getDataFromCoordinates(
        latitude: lat,
        longitude: lng,
        googleMapApiKey: PLACES_API_KEY
    );
  }

  void _saveTrackMilesState(Store<AppState> store, SetShouldTrackAction action, NextDispatcher next) async {
    Job jobToSave = store.state.jobDetailsPageState!.job!.copyWith(
      shouldTrackMiles: action.enabled
    );
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, jobToSave));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void _launchDrivingDirections(Store<AppState> store, DrivingDirectionsJobSelected action) async {
    IntentLauncherUtil.launchDrivingDirections(
        action.location!.latitude.toString(),
        action.location!.longitude.toString());
  }

  void fetchSunsetWeatherForSelectedDate(Store<AppState> store, NextDispatcher next, Job job) async{
    if(job.location != null) {
      final response = await SunriseSunset.getResults(
          date: job.selectedDate,
          latitude: job.location!.latitude,
          longitude: job.location!.longitude
      );
      store.dispatch(
          SetSunsetTimeAction(
            store.state.jobDetailsPageState,
            response!.data!.nauticalTwilightBegin!.toLocal(),
            response.data!.civilTwilightBegin!.toLocal(),
            response.data!.sunrise!.toLocal(),
            response.data!.sunset!.toLocal(),
            response.data!.civilTwilightEnd!.toLocal(),
            response.data!.nauticalTwilightEnd!.toLocal(),
          )
      );

      ForecastFiveDayResponse forecast5days = await WeatherRepository(
          weatherApiClient: AccuWeatherClient(httpClient: http.Client())
      ).fetch5DayForecast(job.location!.latitude!, job.location!.longitude!);

      store.dispatch(SetForecastAction(store.state.jobDetailsPageState, forecast5days));
    }
  }

  void updateProfileWithOnBoardingComplete(Store<AppState> store, SetOnBoardingCompleteAction action, NextDispatcher next) async {
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.onBoardingComplete = true;
    await ProfileDao.update(profile);
  }

  void _saveJobNotes(Store<AppState> store, SaveJobNotesAction action, NextDispatcher next) async{
    Job jobToSave = store.state.jobDetailsPageState!.job!.copyWith(
      notes: action.notes,
    );
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, jobToSave));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    next(SaveJobNotesAction(store.state.jobDetailsPageState, action.notes));
  }

  void _deletePose(Store<AppState> store, DeleteJobPoseAction action, NextDispatcher next) async {
    store.state.jobDetailsPageState!.job!.poses!.removeAt(action.imageIndex!);
    await JobDao.update(store.state.jobDetailsPageState!.job!);

    _fetchJobPoses(store);
  }

  void _fetchJobPoses(Store<AppState> store) async {

    _fetchJobPosesWithJob(store, store.state.jobDetailsPageState!.job);
  }

  void _fetchJobPosesWithJob(Store<AppState> store, Job? job) async {
    List<String> paths = [];
    if(job != null) {
      for(Pose pose in job.poses!) {
        if(pose.isLibraryPose()) {
          paths.add((await FileStorage.getPoseImageFile(pose, null, true, job))!.path);
        } else {
          paths.add((await FileStorage.getPoseImageFile(pose, null, false, job))!.path);
        }
      }
      store.dispatch(SetPoseFilePathsAction(store.state.jobDetailsPageState, paths));
    }
  }

  void _fetchSessionTypes(Store<AppState> store, FetchAllSessionTypesAction action, NextDispatcher next) async {
    List<SessionType>? sessionTypes = await SessionTypeDao.getAll();
    store.dispatch(SetAllSessionTypesAction(store.state.jobDetailsPageState, sessionTypes));

    (await SessionTypeDao.getSessionTypeStream()).listen((jobSnapshots) async {
      List<SessionType> sessionTypes = [];
      for(RecordSnapshot clientSnapshot in jobSnapshots) {
        sessionTypes.add(SessionType.fromMap(clientSnapshot.value! as Map<String,dynamic>));
      }
      store.dispatch(SetAllSessionTypesAction(store.state.jobDetailsPageState, sessionTypes));
    });
  }

  void _fetchDeviceEventsForMonth(Store<AppState> store, FetchJobDetailsDeviceEvents? action, NextDispatcher next) async {
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    DateTime? monthToUse;
    if(action != null) {
      monthToUse = action.month;
    } else {
      monthToUse = store.state.jobDetailsPageState!.selectedDate;
    }

    if(profile!.calendarEnabled! && monthToUse != null) {
      DateTime startDate = DateTime(monthToUse.year, monthToUse.month - 1, 1);
      DateTime endDate = DateTime(monthToUse.year, monthToUse.month + 1, 1);

      List<Event> deviceEvents = await CalendarSyncUtil.getDeviceEventsForDateRange(startDate, endDate);
      store.dispatch(SetDeviceEventsAction(store.state.jobDetailsPageState, deviceEvents));
      store.dispatch(SetJobDetailsSelectedDateAction(store.state.jobDetailsPageState, monthToUse));
    }
  }

  void updateInvoiceToSent(Store<AppState> store, InvoiceSentAction action, NextDispatcher next) async {
    if(action.invoice != null) {
      Job? job = await JobDao.getJobById(action.invoice!.jobDocumentId);
      List<JobStage> completedStages = job!.completedStages!;
      if(!Job.containsStage(completedStages, JobStage.STAGE_8_PAYMENT_REQUESTED)) {
        completedStages.add(JobStage(stage: JobStage.STAGE_8_PAYMENT_REQUESTED));
      }
      job.completedStages = completedStages;
      await JobDao.update(job);

      action.invoice!.sentDate = DateTime.now();
      await InvoiceDao.update(action.invoice, job);
      store.dispatch(SetAllInvoicesAction(store.state.incomeAndExpensesPageState, await InvoiceDao.getAllSortedByDueDate()));
      store.dispatch(UpdateSelectedYearAction(store.state.incomeAndExpensesPageState, store.state.incomeAndExpensesPageState!.selectedYear));
      store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    }
  }

  void deleteInvoice(Store<AppState> store, OnDeleteInvoiceSelectedAction action, NextDispatcher next) async {
    if(action.invoice != null) {
      await InvoiceDao.deleteByInvoice(action.invoice!);
    }
    List<JobStage> completedJobStages = store.state.jobDetailsPageState!.job!.completedStages!.toList();
    completedJobStages.remove(JobStage(stage: JobStage.STAGE_8_PAYMENT_REQUESTED));
    Job jobToSave = store.state.jobDetailsPageState!.job!;
    jobToSave.completedStages = completedJobStages;
    jobToSave.invoice = null;

    await JobDao.insertOrUpdate(jobToSave);
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(DeleteDocumentFromLocalStateAction(store.state.jobDetailsPageState, DocumentItem.DOCUMENT_TYPE_INVOICE));
    store.dispatch(SetAllInvoicesAction(store.state.incomeAndExpensesPageState, await InvoiceDao.getAllSortedByDueDate()));
    store.dispatch(UpdateSelectedYearAction(store.state.incomeAndExpensesPageState, store.state.incomeAndExpensesPageState!.selectedYear));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void deleteContract(Store<AppState> store, OnDeleteContractSelectedAction action, NextDispatcher next) async {
    List<JobStage> completedJobStages = store.state.jobDetailsPageState!.job!.completedStages!.toList();
    completedJobStages.remove(JobStage(stage: JobStage.STAGE_3_PROPOSAL_SENT));
    Job jobToSave = store.state.jobDetailsPageState!.job!;
    jobToSave.completedStages = completedJobStages;
    if(jobToSave.proposal?.contracts != null) {
      jobToSave.proposal!.contracts!.removeWhere((item) => item.documentId == action.contract.documentId);

      await JobDao.insertOrUpdate(jobToSave);
      await JobDao.insertOrUpdate(jobToSave);
      store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, jobToSave));
      store.dispatch(DeleteDocumentFromLocalStateAction(store.state.jobDetailsPageState, DocumentItem.DOCUMENT_TYPE_CONTRACT));
    }
  }

  void _updateJobAddOnCost(Store<AppState> store, SaveAddOnCostAction action, NextDispatcher next) async{
    Job jobToSave = store.state.jobDetailsPageState!.job!.copyWith(
      addOnCost: action.pageState!.unsavedAddOnCostAmount,
    );
    store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, jobToSave));
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    store.dispatch(UpdateSelectedYearAction(store.state.incomeAndExpensesPageState, store.state.incomeAndExpensesPageState!.selectedYear));
  }

  void _updateJobTip(Store<AppState> store, SaveTipChangeAction action, NextDispatcher next) async{
    Job jobToSave = store.state.jobDetailsPageState!.job!.copyWith(
      tipAmount: action.pageState!.unsavedTipAmount,
    );
    store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, jobToSave));
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    store.dispatch(UpdateSelectedYearAction(store.state.incomeAndExpensesPageState, store.state.incomeAndExpensesPageState!.selectedYear));
  }

  void _updateSessionType(Store<AppState> store, SaveUpdatedSessionTypeAction action, NextDispatcher next) async{
    Job jobToSave = store.state.jobDetailsPageState!.job!.copyWith(
      sessionType: store.state.jobDetailsPageState!.sessionType,
      stage: store.state.jobDetailsPageState!.sessionType!.stages.elementAt(1),
      completedStages: [JobStage(id: 1, stage: JobStage.STAGE_1_INQUIRY_RECEIVED)],
      jobTitle: store.state.jobDetailsPageState!.client!.firstName! + ' - ' + store.state.jobDetailsPageState!.sessionType!.title!,
    );

    await InvoiceDao.deleteByInvoice(jobToSave.invoice);
    jobToSave.invoice = null;

    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, jobToSave));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    store.dispatch(DeleteDocumentFromLocalStateAction(store.state.jobDetailsPageState, DocumentItem.DOCUMENT_TYPE_INVOICE));
  }

  void _updateJobName(Store<AppState> store, SaveJobNameChangeAction action, NextDispatcher next) async{
    Job jobToSave = store.state.jobDetailsPageState!.job!.copyWith(
      jobTitle: action.pageState!.jobTitleText,
    );
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, jobToSave));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void _updateJobLocation(Store<AppState> store, action, NextDispatcher next) async{
    Job jobToSave = store.state.jobDetailsPageState!.job!.copyWith(
      location: action.location,
    );
    await JobDao.insertOrUpdate(jobToSave);

    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if(profile != null && !profile.progress.addLocationToJob) {
      profile.progress.addLocationToJob = true;
      await ProfileDao.update(profile);
      EventSender().sendEvent(eventName: EventNames.GETTING_STARTED_CHECKLIST_ITEM_COMPLETED, properties: {
        EventNames.GETTING_STARTED_CHECKLIST_ITEM_COMPLETED_PARAM : Progress.ADD_LOCATION_TO_JOB,
      });
    }

    store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, jobToSave));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    store.dispatch(SetNewSelectedLocation(store.state.jobDetailsPageState, action.location));
    fetchSunsetWeatherForSelectedDate(store, next, jobToSave);
  }

  void _fetchLocations(Store<AppState> store, action, NextDispatcher next) async{
    List<LocationDandy>? locations = await LocationDao.getAllSortedMostFrequent();
    List<File?> imageFiles = [];

    for(LocationDandy location in locations!) {
      imageFiles.add(await FileStorage.getLocationImageFile(location));
    }

    store.dispatch(SetLocationsAction(store.state.jobDetailsPageState, locations, imageFiles));

    (await LocationDao.getLocationsStream()).listen((locationSnapshots) async {
      List<LocationDandy> locations = [];
      List<File?> imageFiles = [];
      for(RecordSnapshot locationSnapshot in locationSnapshots) {
        locations.add(LocationDandy.fromMap(locationSnapshot.value! as Map<String,dynamic>));
      }

      for(LocationDandy location in locations) {
        imageFiles.add(await FileStorage.getLocationImageFile(location));
      }
      store.dispatch(SetLocationsAction(store.state.jobDetailsPageState, locations, imageFiles));
    });
  }
  
  void _fetchAllJobs(Store<AppState> store, action, NextDispatcher next) async{
    List<Job>? upcomingJobs = await JobDao.getAllJobs();
    store.dispatch(SetEventMapAction(store.state.jobDetailsPageState, upcomingJobs));

    (await JobDao.getJobsStream()).listen((jobSnapshots) async {
      List<Job> jobs = [];
      for(RecordSnapshot clientSnapshot in jobSnapshots) {
        jobs.add(Job.fromMap(clientSnapshot.value! as Map<String,dynamic>));
      }
      store.dispatch(SetEventMapAction(store.state.jobDetailsPageState, jobs));
    });
  }

  void _updateJobWithNewTime(Store<AppState> store, UpdateJobTimeAction action, NextDispatcher next) async{
    Job jobToSave = store.state.jobDetailsPageState!.job!.copyWith(
      selectedTime: action.newTime,
    );

    if(jobToSave.selectedDate != null && (jobToSave.selectedEndTime != null || jobToSave.selectedTime != null)){
      List<JobReminder?>? jobReminders = await JobReminderDao.getRemindersByJobId(action.pageState!.job!.documentId!);
      JobReminder? reminderToUpdate;
      if(jobReminders != null && jobReminders.isNotEmpty) {
        for(JobReminder? reminder in jobReminders.toList()) {
          if(reminder!.payload == JobReminder.MILEAGE_EXPENSE_ID) {
            reminderToUpdate = reminder;
          }
        }
      }

      if(reminderToUpdate != null) {
        reminderToUpdate.reminder!.time = jobToSave.selectedEndTime != null ? jobToSave.selectedEndTime!.add(const Duration(hours: 1)) : jobToSave.selectedTime!.add(const Duration(hours: 2));
        JobReminderDao.update(reminderToUpdate);
      }
    }

    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, jobToSave));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void _updateJobWithNewEndTime(Store<AppState> store, UpdateJobEndTimeAction action, NextDispatcher next) async{
    Job jobToSave = store.state.jobDetailsPageState!.job!.copyWith(
      selectedEndTime: action.newTime,
    );
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, jobToSave));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void _updateJobWithNewDate(Store<AppState> store, UpdateJobDateAction action, NextDispatcher next) async{
    DateTime utc = store.state.jobDetailsPageState!.selectedDate!;
    Job jobToSave = store.state.jobDetailsPageState!.job!.copyWith(
      selectedDate: DateTime(utc.year, utc.month, utc.day)
    );
    await JobDao.insertOrUpdate(jobToSave);
    NotificationHelper().createAndUpdatePendingNotifications();
    store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, jobToSave));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    store.dispatch(UpdateSelectedYearAction(store.state.incomeAndExpensesPageState, store.state.incomeAndExpensesPageState!.selectedYear));
    fetchSunsetWeatherForSelectedDate(store, next, jobToSave);
  }

  void _fetchSunsetTime(Store<AppState> store, action, NextDispatcher next) async{
    _fetchSunsetTimeWithJob(store, store.state.jobDetailsPageState!.job!);
  }

  void _fetchSunsetTimeWithJob(Store<AppState> store, Job job) async {
    if(store.state.jobDetailsPageState!.job != null && store.state.jobDetailsPageState!.job!.location != null) {
      LocationDandy? selectedLocation = store.state.jobDetailsPageState!.job!.location;
      DateTime? selectedDate = store.state.jobDetailsPageState!.job!.selectedDate;
      if(selectedLocation != null && selectedDate != null) {
        final response = await SunriseSunset.getResults(date: selectedDate, latitude: selectedLocation.latitude, longitude: selectedLocation.longitude);
        store.dispatch(SetSunsetTimeForJobAction(store.state.jobDetailsPageState, response!.data!.sunset!.toLocal()));
      }
    }
  }

  void _launchInstagramProfile(String instagramUrl){
    IntentLauncherUtil.launchURL(instagramUrl);
  }

  void setJobInfo(Store<AppState> store, NextDispatcher next, SetJobInfo action) async{
    store.dispatch(ClearPreviousStateAction(store.state.jobDetailsPageState));
    Job? job = await JobDao.getJobById(action.jobDocumentId);
    if(job != null) {
      if(job.client == null && job.clientDocumentId != null && job.clientDocumentId!.isNotEmpty) {
        Client? client = await ClientDao.getClientById(job.clientDocumentId!);
        job.client = client;
        await JobDao.update(job);
      }

      if(job.proposal == null) {
        job.proposal = Proposal();
        await JobDao.update(job);
      }

      job.sessionType ??= SessionType.from(job.type, job.priceProfile);

      await store.dispatch(SetJobAction(store.state.jobDetailsPageState, job));

      Client? client = await ClientDao.getClientById(job.clientDocumentId!);
      store.dispatch(SetClientAction(store.state.jobDetailsPageState, client));
      _fetchDeviceEventsForMonth(store, null, next);
      fetchSunsetWeatherForSelectedDate(store, next, job);

      MileageExpense? mileageTrip = await MileageExpenseDao.getMileageExpenseByJobId(job.documentId!);
      if(mileageTrip != null) {
        await store.dispatch(SetJobMileageTripAction(store.state.jobDetailsPageState, mileageTrip));
      } else {
        await store.dispatch(SetJobMileageTripAction(store.state.jobDetailsPageState, null));
      }
    }
    _fetchSunsetTimeWithJob(store, job!);
    store.dispatch(FetchJobDetailsPricePackagesAction(store.state.jobDetailsPageState));
    store.dispatch(FetchJobDetailsLocationsAction(store.state.jobDetailsPageState));
    _fetchRemindersWithJob(store, next, job);
    store.dispatch(FetchAllSessionTypesAction(store.state.jobDetailsPageState));
    _fetchJobPosesWithJob(store, job);

    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    store.dispatch(SetProfileToDetailsStateAction(store.state.jobDetailsPageState, profile));
  }

  void deleteJob(Store<AppState> store, NextDispatcher next, DeleteJobAction action)async{
    await JobDao.delete(store.state.jobDetailsPageState!.job!);
    Job? job = await JobDao.getJobById(action.pageState!.job!.documentId);
    if(job != null) {
      await JobDao.delete(store.state.jobDetailsPageState!.job!);
    }

    store.dispatch(FetchJobsAction(store.state.jobsPageState!));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState!.pop();
    store.dispatch(UpdateSelectedYearAction(store.state.incomeAndExpensesPageState, store.state.incomeAndExpensesPageState!.selectedYear));
  }

  void updateJobStageToNextStage(Store<AppState> store, NextDispatcher next, SaveStageCompleted action) async{
    List<JobStage> completedJobStages = action.job!.completedStages!.toList();
    JobStage stageToComplete = action.job!.sessionType!.stages!.elementAt(action.stageIndex!);
    completedJobStages.add(stageToComplete);
    action.job!.completedStages = completedJobStages;
    action.job!.stage = _getNextUncompletedStage(action.stageIndex!, action.job!.completedStages!, action.job!);
    Job jobToSave = action.job!.copyWith(
      completedStages: completedJobStages,
      depositAmount: action.job!.depositAmount,
      tipAmount: action.job!.tipAmount,
      createdDate: action.job!.createdDate,
      stage: action.job!.stage,
    );
    if(stageToComplete.stage == JobStage.STAGE_9_PAYMENT_RECEIVED){
      DateTime now = DateTime.now();
      jobToSave.paymentReceivedDate = now;
      if(action.job!.invoice != null){
        jobToSave.invoice!.invoicePaid = true;
        jobToSave.invoice!.invoicePaidDate = now;
        await InvoiceDao.updateInvoiceOnly(jobToSave.invoice);
      }
    }
    if(stageToComplete.stage == JobStage.STAGE_5_DEPOSIT_RECEIVED){
      DateTime now = DateTime.now();
      jobToSave.depositReceivedDate = now;
      if(action.job!.invoice != null && !action.job!.invoice!.depositPaid!){
        DateTime now = DateTime.now();
        jobToSave.invoice!.depositPaid = true;
        jobToSave.invoice!.depositPaidDate = now;
        jobToSave.depositReceivedDate = now;
        jobToSave.invoice!.unpaidAmount = action.job!.invoice!.unpaidAmount! - action.job!.invoice!.depositAmount!;
        await InvoiceDao.updateInvoiceOnly(jobToSave.invoice);
      }
    }
    if(stageToComplete.stage == JobStage.STAGE_14_JOB_COMPLETE && jobToSave.paymentReceivedDate == null){
      jobToSave.paymentReceivedDate = DateTime.now();
    }
    await JobDao.insertOrUpdate(jobToSave);
    EventSender().sendEvent(eventName: EventNames.BT_STAGE_COMPLETE, properties: {EventNames.STAGE_COMPLETE_PARAM_STAGE : stageToComplete.stage!});
    store.dispatch(FetchJobsAction(store.state.jobsPageState!));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    store.dispatch(UpdateSelectedYearAction(store.state.incomeAndExpensesPageState, store.state.incomeAndExpensesPageState!.selectedYear));
  }

  void undoStage(Store<AppState> store, NextDispatcher next, UndoStageAction action) async{
    List<JobStage> completedJobStages = action.job!.completedStages!.toList();
    JobStage stageToRemove = action.job!.sessionType!.stages!.elementAt(action.stageIndex!);
    completedJobStages = _removeStage(stageToRemove, completedJobStages);
    action.job!.completedStages = completedJobStages;
    JobStage? highestCompletedState;
    for(JobStage completedStage in completedJobStages){
      highestCompletedState ??= completedStage;
      if(getIndexOfStageInStages(completedStage, action.job!.sessionType!.stages!) > getIndexOfStageInStages(highestCompletedState, action.job!.sessionType!.stages!)) highestCompletedState = completedStage;
    }
    if(highestCompletedState != null){
      action.job!.stage = _getNextUncompletedStage(getIndexOfStageInStages(highestCompletedState, action.job!.completedStages!), action.job!.completedStages!, action.job!);
    }else{
      action.job!.stage = action.job!.sessionType!.stages!.elementAt(1);
    }
    Job jobToSave = action.job!.copyWith(
      completedStages: completedJobStages,
      depositAmount: store.state.jobDetailsPageState!.job!.depositAmount,
      tipAmount: store.state.jobDetailsPageState!.job!.tipAmount,
      createdDate: store.state.jobDetailsPageState!.job!.createdDate,
    );
    if(stageToRemove.stage == JobStage.STAGE_9_PAYMENT_RECEIVED){
      jobToSave.paymentReceivedDate = null;
      if(jobToSave.invoice != null){
        jobToSave.invoice!.invoicePaid = false;
        jobToSave.invoice!.invoicePaidDate = null;
        await InvoiceDao.updateInvoiceOnly(jobToSave.invoice);
      }
    }

    if(stageToRemove.stage == JobStage.STAGE_8_PAYMENT_REQUESTED){
      if(jobToSave.invoice != null){
        jobToSave.invoice!.sentDate = null;
        await InvoiceDao.updateInvoiceOnly(jobToSave.invoice);
      }
    }
    if(stageToRemove.stage == JobStage.STAGE_5_DEPOSIT_RECEIVED){
      jobToSave.depositReceivedDate = null;
      if(store.state.jobDetailsPageState!.invoice != null && store.state.jobDetailsPageState!.invoice!.depositPaid!){
        jobToSave.invoice!.depositPaid = false;
        jobToSave.invoice!.depositPaidDate = null;
        jobToSave.invoice!.unpaidAmount = action.job!.invoice!.unpaidAmount! + action.job!.invoice!.depositAmount!;
        await InvoiceDao.updateInvoiceOnly(action.job!.invoice!);
      }
    }
    if(stageToRemove.stage == JobStage.STAGE_14_JOB_COMPLETE) {
      jobToSave.paymentReceivedDate = null;
    }
    if(store.state.jobDetailsPageState!.invoice == null) {
      jobToSave.invoice = null;
    }
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(FetchJobsAction(store.state.jobsPageState!));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    store.dispatch(UpdateSelectedYearAction(store.state.incomeAndExpensesPageState, store.state.incomeAndExpensesPageState!.selectedYear!));
  }

  List<JobStage> _removeStage(JobStage stageToRemove, List<JobStage> completedJobStages) {
    List<JobStage> resultList = [];
    for(JobStage completedStage in completedJobStages){
      if(completedStage.stage != stageToRemove.stage)resultList.add(completedStage);
    }
    return resultList;
  }

  JobStage _getNextUncompletedStage(int stageIndex, List<JobStage> completedStages, Job job) {
    if(job.sessionType!.stages!.elementAt(stageIndex).stage != JobStage.STAGE_14_JOB_COMPLETE) {
      JobStage nextStage = job.sessionType!.stages!.elementAt(stageIndex++);
      while(_completedStagesContainsNextStage(completedStages, nextStage)){
        nextStage = JobStage.getNextStage(nextStage, job.sessionType!.stages!);
      }
      return nextStage;
    }
    return job.sessionType!.stages!.elementAt(stageIndex);
  }

  bool _completedStagesContainsNextStage(List<JobStage> completedStages, JobStage nextStage) {
    if(nextStage.stage == JobStage.STAGE_COMPLETED_CHECK) return false;
    bool containsNextStage = false;
    for(JobStage completedStage in completedStages){
      if(completedStage.stage == nextStage.stage) return true;
    }
    return containsNextStage;
  }

  void _fetchReminders(Store<AppState> store, FetchJobRemindersAction action,NextDispatcher next) async{
    _fetchRemindersWithJob(store, next, action.pageState!.job!);
  }

  void _fetchRemindersWithJob(Store<AppState> store, NextDispatcher next, Job? job) async {
    if(job != null) {
      List<JobReminder>? reminders = await JobReminderDao.getRemindersByJobId(job.documentId!);
      next(SetRemindersAction(store.state.jobDetailsPageState, reminders));
    }
  }

  void _deleteReminder(Store<AppState> store, DeleteReminderFromJobAction action, NextDispatcher next) async {
    await JobReminderDao.delete(action.reminder!.documentId);
    if((await JobReminderDao.getReminderById(action.reminder!.documentId!)) != null) {
      await JobReminderDao.delete(action.reminder!.documentId);
    }
    store.dispatch(FetchJobRemindersAction(store.state.jobDetailsPageState));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  getIndexOfStageInStages(JobStage completedStage, List<JobStage> stages) {
    for(int i=0 ; i < stages.length; i++) {
      if(stages.elementAt(i).stage == completedStage.stage) return i;
    }
    return 0;
  }
}