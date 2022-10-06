import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ClientDao.dart';
import 'package:dandylight/data_layer/local_db/daos/InvoiceDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobTypeDao.dart';
import 'package:dandylight/data_layer/local_db/daos/LocationDao.dart';
import 'package:dandylight/data_layer/local_db/daos/PriceProfileDao.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/models/JobType.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageActions.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:dandylight/pages/jobs_page/JobsPageActions.dart';
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:dandylight/utils/IntentLauncherUtil.dart';
import 'package:dandylight/utils/NotificationHelper.dart';
import 'package:dandylight/utils/sunrise_sunset_library/sunrise_sunset.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

import '../../data_layer/local_db/daos/JobReminderDao.dart';
import '../../data_layer/local_db/daos/ProfileDao.dart';
import '../../data_layer/local_db/daos/ReminderDao.dart';
import '../../data_layer/repositories/FileStorage.dart';
import '../../models/JobReminder.dart';
import '../../models/Profile.dart';
import '../../models/ReminderDandyLight.dart';
import '../../utils/CalendarSyncUtil.dart';
import '../../utils/UidUtil.dart';

class JobDetailsPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SaveStageCompleted){
      updateJobInDb(store, next, action);
    }
    if(action is UndoStageAction){
      undoStage(store, next, action);
    }
    if(action is DeleteJobAction){
      deleteJob(store, next, action);
    }
    if(action is SetJobInfo){
      fetchClientForJob(store, next, action);
    }
    if(action is SetJobInfoWithJobDocumentId){
      setJobInfoWithId(store, next, action);
    }
    if(action is JobInstagramSelectedAction){
      _launchInstagramProfile(store.state.jobDetailsPageState.client.instagramProfileUrl);
    }
    if(action is FetchTimeOfSunsetJobAction){
      _fetchSunsetTime(store, action, next);
    }
    if(action is UpdateJobTimeAction){
      _updateJobWithNewTime(store, action, next);
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
    if(action is FetchJobDetailsPricePackagesAction){
      _fetchPricePackages(store, action, next);
    }
    if(action is UpdateNewLocationAction){
      _updateJobLocation(store, action, next);
    }
    if(action is SaveJobNameChangeAction){
      _updateJobName(store, action, next);
    }
    if(action is SaveUpdatedJobTypeAction){
      _updateJobType(store, action, next);
    }
    if(action is SaveUpdatedPricePackageAction){
      _updateJobPriceProfile(store, action, next);
    }
    if(action is SaveDepositChangeAction){
      _updateJobDeposit(store, action, next);
    }
    if(action is SaveTipChangeAction){
      _updateJobTip(store, action, next);
    }
    if(action is OnDeleteInvoiceSelectedAction){
      deleteInvoice(store, action, next);
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
    if(action is FetchAllJobTypesAction) {
      _fetchJobTypes(store, action, next);
    }
  }

  void _fetchJobTypes(Store<AppState> store, FetchAllJobTypesAction action, NextDispatcher next) async {
    List<JobType> jobTypes = await JobTypeDao.getAll();
    store.dispatch(SetAllJobTypesAction(store.state.jobDetailsPageState, jobTypes));

    (await JobTypeDao.getJobTypeStream()).listen((jobSnapshots) async {
      List<JobType> jobTypes = [];
      for(RecordSnapshot clientSnapshot in jobSnapshots) {
        jobTypes.add(JobType.fromMap(clientSnapshot.value));
      }
      store.dispatch(SetAllJobTypesAction(store.state.jobDetailsPageState, jobTypes));
    });
  }

  void _fetchDeviceEventsForMonth(Store<AppState> store, FetchJobDetailsDeviceEvents action, NextDispatcher next) async {
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
      store.dispatch(SetDeviceEventsAction(store.state.jobDetailsPageState, deviceEvents));
    }
    store.dispatch(SetJobDetailsSelectedDateAction(store.state.jobDetailsPageState, monthToUse));
  }

  void updateInvoiceToSent(Store<AppState> store, InvoiceSentAction action, NextDispatcher next) async {
    action.invoice.sentDate = DateTime.now();
    await InvoiceDao.update(action.invoice, store.state.jobDetailsPageState.job);
    store.dispatch(SetAllInvoicesAction(store.state.incomeAndExpensesPageState, await InvoiceDao.getAllSortedByDueDate()));
  }

  void deleteInvoice(Store<AppState> store, OnDeleteInvoiceSelectedAction action, NextDispatcher next) async {
    await InvoiceDao.deleteByInvoice(action.invoice);
    List<JobStage> completedJobStages = store.state.jobDetailsPageState.job.completedStages.toList();
    completedJobStages.remove(JobStage(stage: JobStage.STAGE_8_PAYMENT_REQUESTED));
    Job jobToSave = store.state.jobDetailsPageState.job.copyWith(
      completedStages: completedJobStages,
    );
    jobToSave.invoice = null;
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(SetAllInvoicesAction(store.state.incomeAndExpensesPageState, await InvoiceDao.getAllSortedByDueDate()));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    store.dispatch(SetNewInvoice(store.state.jobDetailsPageState, null));
  }

  void _updateJobDeposit(Store<AppState> store, SaveDepositChangeAction action, NextDispatcher next) async{
    Job jobToSave = store.state.jobDetailsPageState.job.copyWith(
      depositAmount: action.pageState.unsavedDepositAmount,
    );
    store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, jobToSave));
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void _updateJobTip(Store<AppState> store, SaveTipChangeAction action, NextDispatcher next) async{
    Job jobToSave = store.state.jobDetailsPageState.job.copyWith(
      tipAmount: action.pageState.unsavedTipAmount,
    );
    store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, jobToSave));
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void _updateJobPriceProfile(Store<AppState> store, SaveUpdatedPricePackageAction action, NextDispatcher next) async{
    Job jobToSave = store.state.jobDetailsPageState.job.copyWith(
      priceProfile: action.pageState.selectedPriceProfile,
    );
    store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, jobToSave));
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void _updateJobType(Store<AppState> store, SaveUpdatedJobTypeAction action, NextDispatcher next) async{
    Job jobToSave = store.state.jobDetailsPageState.job.copyWith(
      type: store.state.jobDetailsPageState.jobType,
      stage: store.state.jobDetailsPageState.jobType.stages.elementAt(1),
      completedStages: [JobStage(id: 1, stage: JobStage.STAGE_1_INQUIRY_RECEIVED)],
      jobTitle: store.state.jobDetailsPageState.client.firstName + ' - ' + store.state.jobDetailsPageState.jobType.title,
    );
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, jobToSave));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void _updateJobName(Store<AppState> store, SaveJobNameChangeAction action, NextDispatcher next) async{
    Job jobToSave = store.state.jobDetailsPageState.job.copyWith(
      jobTitle: action.pageState.jobTitleText,
    );
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, jobToSave));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void _updateJobLocation(Store<AppState> store, action, NextDispatcher next) async{
    Job jobToSave = store.state.jobDetailsPageState.job.copyWith(
      location: action.location,
    );
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, jobToSave));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void _fetchLocations(Store<AppState> store, action, NextDispatcher next) async{
    List<Location> locations = await LocationDao.getAllSortedMostFrequent();
    List<File> imageFiles = [];

    for(Location location in locations) {
      imageFiles.add(await FileStorage.getLocationImageFile(location));
    }

    store.dispatch(SetLocationsAction(store.state.jobDetailsPageState, locations, imageFiles));

    (await LocationDao.getLocationsStream()).listen((locationSnapshots) async {
      List<Location> locations = [];
      List<File> imageFiles = [];
      for(RecordSnapshot locationSnapshot in locationSnapshots) {
        locations.add(Location.fromMap(locationSnapshot.value));
      }

      for(Location location in locations) {
        imageFiles.add(await FileStorage.getLocationImageFile(location));
      }
      store.dispatch(SetLocationsAction(store.state.jobDetailsPageState, locations, imageFiles));
    });
  }

  void _fetchPricePackages(Store<AppState> store, action, NextDispatcher next) async{
    List<PriceProfile> priceProfiles = await PriceProfileDao.getAllSortedByName();
    store.dispatch(SetPricingProfiles(store.state.jobDetailsPageState, priceProfiles));
  }

  void _fetchAllJobs(Store<AppState> store, action, NextDispatcher next) async{
    List<Job> upcomingJobs = await JobDao.getAllJobs();
    store.dispatch(SetEventMapAction(store.state.jobDetailsPageState, upcomingJobs));

    (await JobDao.getJobsStream()).listen((jobSnapshots) async {
      List<Job> jobs = List();
      for(RecordSnapshot clientSnapshot in jobSnapshots) {
        jobs.add(Job.fromMap(clientSnapshot.value));
      }
      store.dispatch(SetEventMapAction(store.state.jobDetailsPageState, jobs));
    });
  }

  void _updateJobWithNewTime(Store<AppState> store, UpdateJobTimeAction action, NextDispatcher next) async{
    Job jobToSave = store.state.jobDetailsPageState.job.copyWith(
      selectedTime: action.newTime,
    );
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, jobToSave));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void _updateJobWithNewDate(Store<AppState> store, UpdateJobDateAction action, NextDispatcher next) async{
    Job jobToSave = store.state.jobDetailsPageState.job.copyWith(
      selectedDate: store.state.jobDetailsPageState.selectedDate,
    );
    await JobDao.insertOrUpdate(jobToSave);
    await NotificationHelper().createAndUpdatePendingNotifications();
    store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, jobToSave));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void _fetchSunsetTime(Store<AppState> store, action, NextDispatcher next) async{
    Location selectedLocation = store.state.jobDetailsPageState.job.location;
    DateTime selectedDate = store.state.jobDetailsPageState.job.selectedDate;
    if(selectedLocation != null && selectedDate != null) {
      final response = await SunriseSunset.getResults(date: selectedDate, latitude: selectedLocation.latitude, longitude: selectedLocation.longitude);
      store.dispatch(SetSunsetTimeForJobAction(store.state.jobDetailsPageState, response.data.sunset.toLocal()));
    }
  }

  void _launchInstagramProfile(String instagramUrl){
    IntentLauncherUtil.launchURL(instagramUrl);
  }

  void fetchClientForJob(Store<AppState> store, NextDispatcher next, SetJobInfo action) async{
    store.dispatch(SetJobAction(store.state.jobDetailsPageState, action.job));
    Client client = await ClientDao.getClientById(action.job.clientDocumentId);
    store.dispatch(SetClientAction(store.state.jobDetailsPageState, client));
    _fetchDeviceEventsForMonth(store, null, next);
  }

  void setJobInfoWithId(Store<AppState> store, NextDispatcher next, SetJobInfoWithJobDocumentId action) async{
    Job job = await JobDao.getJobById(action.jobDocumentId);
    store.dispatch(SetJobAction(store.state.jobDetailsPageState, job));
    Client client = await ClientDao.getClientById(job.clientDocumentId);
    store.dispatch(SetClientAction(store.state.jobDetailsPageState, client));
    _fetchDeviceEventsForMonth(store, null, next);
  }

  void deleteJob(Store<AppState> store, NextDispatcher next, DeleteJobAction action)async{
    await JobDao.delete(store.state.jobDetailsPageState.job);
    Job job = await JobDao.getJobById(action.pageState.job.documentId);
    if(job != null) {
      await JobDao.delete(store.state.jobDetailsPageState.job);
    }

    store.dispatch(FetchJobsAction(store.state.jobsPageState));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }

  void updateJobInDb(Store<AppState> store, NextDispatcher next, SaveStageCompleted action) async{
    List<JobStage> completedJobStages = action.job.completedStages.toList();
    JobStage stageToComplete = action.job.type.stages.elementAt(action.stageIndex);
    completedJobStages.add(stageToComplete);
    action.job.completedStages = completedJobStages;
    action.job.stage = _getNextUncompletedStage(action.stageIndex, action.job.completedStages, action.job);
    Job jobToSave = action.job.copyWith(
      completedStages: completedJobStages,
      depositAmount: store.state.jobDetailsPageState.job.depositAmount,
      tipAmount: store.state.jobDetailsPageState.job.tipAmount,
      createdDate: store.state.jobDetailsPageState.job.createdDate,
    );
    if(stageToComplete.stage == JobStage.STAGE_9_PAYMENT_RECEIVED){
      if(action.job.invoice != null){
        action.job.invoice.invoicePaid = true;
        await InvoiceDao.updateInvoiceOnly(action.job.invoice);
      }
    }
    if(stageToComplete.stage == JobStage.STAGE_5_DEPOSIT_RECEIVED){
      if(action.job.invoice != null){
        action.job.invoice.depositPaid = true;
        action.job.invoice.unpaidAmount = action.job.invoice.unpaidAmount - action.job.invoice.depositAmount;
        await InvoiceDao.updateInvoiceOnly(action.job.invoice);
      }
    }
    if(stageToComplete.stage == JobStage.STAGE_9_PAYMENT_RECEIVED){
      jobToSave.paymentReceivedDate = DateTime.now();
    }
    if(stageToComplete.stage == JobStage.STAGE_14_JOB_COMPLETE && jobToSave.paymentReceivedDate == null){
      jobToSave.paymentReceivedDate = DateTime.now();
    }
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(FetchJobsAction(store.state.jobsPageState));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void undoStage(Store<AppState> store, NextDispatcher next, UndoStageAction action) async{
    List<JobStage> completedJobStages = action.job.completedStages.toList();
    JobStage stageToRemove = action.job.type.stages.elementAt(action.stageIndex);
    completedJobStages = _removeStage(stageToRemove, completedJobStages);
    action.job.completedStages = completedJobStages;
    JobStage highestCompletedState;
    for(JobStage completedStage in completedJobStages){
      if(highestCompletedState == null) highestCompletedState = completedStage;
      if(getIndexOfStageInStages(completedStage, action.job.type.stages) > getIndexOfStageInStages(highestCompletedState, action.job.type.stages)) highestCompletedState = completedStage;
    }
    if(highestCompletedState != null){
      action.job.stage = JobStage.getNextStage(highestCompletedState);
    }else{
      action.job.stage = action.job.type.stages.elementAt(1);
    }
    Job jobToSave = action.job.copyWith(
      completedStages: completedJobStages,
      depositAmount: store.state.jobDetailsPageState.job.depositAmount,
      tipAmount: store.state.jobDetailsPageState.job.tipAmount,
      createdDate: store.state.jobDetailsPageState.job.createdDate,
    );
    if(stageToRemove.stage == JobStage.STAGE_9_PAYMENT_RECEIVED){
      if(action.job.invoice != null){
        action.job.invoice.invoicePaid = false;
        await InvoiceDao.updateInvoiceOnly(action.job.invoice);
      }
    }
    if(stageToRemove.stage == JobStage.STAGE_8_PAYMENT_REQUESTED){
      if(action.job.invoice != null){
        action.job.invoice.sentDate = null;
        await InvoiceDao.updateInvoiceOnly(action.job.invoice);
      }
    }
    if(stageToRemove.stage == JobStage.STAGE_5_DEPOSIT_RECEIVED){
      if(action.job.invoice != null){
        action.job.invoice.depositPaid = false;
        action.job.invoice.unpaidAmount = action.job.invoice.unpaidAmount + action.job.invoice.depositAmount;
        await InvoiceDao.updateInvoiceOnly(action.job.invoice);
      }
    }
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(FetchJobsAction(store.state.jobsPageState));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  List<JobStage> _removeStage(JobStage stageToRemove, List<JobStage> completedJobStages) {
    List<JobStage> resultList = [];
    for(JobStage completedStage in completedJobStages){
      if(completedStage.stage != stageToRemove.stage)resultList.add(completedStage);
    }
    return resultList;
  }

  JobStage _getNextUncompletedStage(int stageIndex, List<JobStage> completedStages, Job job) {
    JobStage currentStage = JobStage.getStageFromIndex(stageIndex, job.type.stages);
    JobStage nextStage = JobStage.getNextStage(currentStage);
    while(_completedStagesContainsNextStage(completedStages, nextStage)){
      nextStage = JobStage.getNextStage(nextStage);
    }
    return nextStage;
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
    List<JobReminder> reminders = await JobReminderDao.getRemindersByJobId(action.pageState.job.documentId);
    next(SetRemindersAction(store.state.jobDetailsPageState, reminders));
  }

  void _deleteReminder(Store<AppState> store, DeleteReminderFromJobAction action, NextDispatcher next) async {
    await JobReminderDao.delete(action.reminder.documentId);
    store.dispatch(FetchJobRemindersAction(store.state.jobDetailsPageState));
  }

  getIndexOfStageInStages(JobStage completedStage, List<JobStage> stages) {
    for(int i=0 ; i <= stages.length; i++) {
      if(stages.elementAt(i).stage == completedStage.stage) return i;
    }
    return 0;
  }


}