import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/ClientDao.dart';
import 'package:client_safe/data_layer/local_db/daos/JobDao.dart';
import 'package:client_safe/data_layer/local_db/daos/LocationDao.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/JobStage.dart';
import 'package:client_safe/models/Location.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageActions.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsActions.dart';
import 'package:client_safe/utils/GlobalKeyUtil.dart';
import 'package:client_safe/utils/IntentLauncherUtil.dart';
import 'package:redux/redux.dart';
import 'package:sunrise_sunset/sunrise_sunset.dart';

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
    if(action is UpdateNewLocationAction){
      _updateJobLocation(store, action, next);
    }
    if(action is SaveJobNameChangeAction){
      _updateJobName(store, action, next);
    }
  }

  void _updateJobName(Store<AppState> store, SaveJobNameChangeAction action, NextDispatcher next) async{
    Job jobToSave = Job(
      id: store.state.jobDetailsPageState.job.id,
      clientId: store.state.jobDetailsPageState.job.clientId,
      clientName: store.state.jobDetailsPageState.job.clientName,
      jobTitle: action.pageState.jobTitleText,
      selectedDate: store.state.jobDetailsPageState.job.selectedDate,
      selectedTime: store.state.jobDetailsPageState.job.selectedTime,
      type: store.state.jobDetailsPageState.job.type,
      stage: store.state.jobDetailsPageState.job.stage,
      completedStages: store.state.jobDetailsPageState.job.completedStages,
      location: store.state.jobDetailsPageState.selectedLocation,
      priceProfile: store.state.jobDetailsPageState.job.priceProfile,
    );
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, jobToSave));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void _updateJobLocation(Store<AppState> store, action, NextDispatcher next) async{
    Job jobToSave = Job(
      id: store.state.jobDetailsPageState.job.id,
      clientId: store.state.jobDetailsPageState.job.clientId,
      clientName: store.state.jobDetailsPageState.job.clientName,
      jobTitle: store.state.jobDetailsPageState.job.jobTitle,
      selectedDate: store.state.jobDetailsPageState.job.selectedDate,
      selectedTime: store.state.jobDetailsPageState.job.selectedTime,
      type: store.state.jobDetailsPageState.job.type,
      stage: store.state.jobDetailsPageState.job.stage,
      completedStages: store.state.jobDetailsPageState.job.completedStages,
      location: action.location,
      priceProfile: store.state.jobDetailsPageState.job.priceProfile,
    );
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, jobToSave));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void _fetchLocations(Store<AppState> store, action, NextDispatcher next) async{
    List<Location> locations = await LocationDao.getAllSortedMostFrequent();
    store.dispatch(SetLocationsAction(store.state.jobDetailsPageState, locations));
  }

  void _fetchAllJobs(Store<AppState> store, action, NextDispatcher next) async{
    List<Job> upcomingJobs = await JobDao.getAllJobs();
    store.dispatch(SetEventMapAction(store.state.jobDetailsPageState, upcomingJobs));
  }

  void _updateJobWithNewTime(Store<AppState> store, UpdateJobTimeAction action, NextDispatcher next) async{
    Job jobToSave = Job(
      id: store.state.jobDetailsPageState.job.id,
      clientId: store.state.jobDetailsPageState.job.clientId,
      clientName: store.state.jobDetailsPageState.job.clientName,
      jobTitle: store.state.jobDetailsPageState.job.jobTitle,
      selectedDate: store.state.jobDetailsPageState.job.selectedDate,
      selectedTime: action.newTime,
      type: store.state.jobDetailsPageState.job.type,
      stage: store.state.jobDetailsPageState.job.stage,
      completedStages: store.state.jobDetailsPageState.job.completedStages,
      location: store.state.jobDetailsPageState.job.location,
      priceProfile: store.state.jobDetailsPageState.job.priceProfile,
    );
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(SaveUpdatedJobAction(store.state.jobDetailsPageState, jobToSave));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void _updateJobWithNewDate(Store<AppState> store, UpdateJobDateAction action, NextDispatcher next) async{
    Job jobToSave = Job(
      id: store.state.jobDetailsPageState.job.id,
      clientId: store.state.jobDetailsPageState.job.clientId,
      clientName: store.state.jobDetailsPageState.job.clientName,
      jobTitle: store.state.jobDetailsPageState.job.jobTitle,
      selectedDate: action.newDate,
      selectedTime: store.state.jobDetailsPageState.job.selectedTime,
      type: store.state.jobDetailsPageState.job.type,
      stage: store.state.jobDetailsPageState.job.stage,
      completedStages: store.state.jobDetailsPageState.job.completedStages,
      location: store.state.jobDetailsPageState.job.location,
      priceProfile: store.state.jobDetailsPageState.job.priceProfile,
    );
    JobDao.insertOrUpdate(jobToSave);
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

  void fetchClientForJob(Store<AppState> store, NextDispatcher next, SetJobInfo action)async{
    Client client = await ClientDao.getClientById(action.job.clientId);
    next(action);
    store.dispatch(SetClientAction(store.state.jobDetailsPageState, client));
  }

  void deleteJob(Store<AppState> store, NextDispatcher next, DeleteJobAction action)async{
    await JobDao.delete(store.state.jobDetailsPageState.job);
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }

  void updateJobInDb(Store<AppState> store, NextDispatcher next, SaveStageCompleted action) async{
    List<JobStage> completedJobStages = action.job.completedStages.toList();
    JobStage stageToComplete = JobStage.getStageFromIndex(action.stageIndex);
    completedJobStages.add(stageToComplete);
    action.job.completedStages = completedJobStages;
    action.job.stage = _getNextUncompletedStage(action.stageIndex, action.job.completedStages);
    Job jobToSave = Job(
      id: action.job.id,
      clientId: action.job.clientId,
      clientName: action.job.clientName,
      jobTitle: action.job.jobTitle,
      selectedDate: action.job.selectedDate,
      selectedTime: action.job.selectedTime,
      type: action.job.type,
      stage: action.job.stage,
      completedStages: completedJobStages,
      location: action.job.location,
      priceProfile: action.job.priceProfile,
    );
    store.dispatch(SaveStageCompleted(store.state.jobDetailsPageState, jobToSave, action.stageIndex));
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void undoStage(Store<AppState> store, NextDispatcher next, UndoStageAction action) async{
    List<JobStage> completedJobStages = action.job.completedStages.toList();
    JobStage stageToRemove = JobStage.getStageFromIndex(action.stageIndex);
    completedJobStages = _removeStage(stageToRemove, completedJobStages);
    action.job.completedStages = completedJobStages;
    JobStage highestCompletedState;
    for(JobStage completedStage in action.job.completedStages){
      if(highestCompletedState == null) highestCompletedState = completedStage;
      if(completedStage.value > highestCompletedState.value) highestCompletedState = completedStage;
    }
    if(highestCompletedState != null){
      action.job.stage = JobStage.getNextStage(highestCompletedState);
    }else{
      action.job.stage = JobStage.getStageFromIndex(1);
    }
    Job jobToSave = Job(
      id: action.job.id,
      clientId: action.job.clientId,
      clientName: action.job.clientName,
      jobTitle: action.job.jobTitle,
      selectedDate: action.job.selectedDate,
      selectedTime: action.job.selectedTime,
      type: action.job.type,
      stage: action.job.stage,
      completedStages: completedJobStages,
      location: action.job.location,
      priceProfile: action.job.priceProfile,
    );
    store.dispatch(SaveStageCompleted(store.state.jobDetailsPageState, jobToSave, action.stageIndex));
     await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  List<JobStage> _removeStage(JobStage stageToRemove, List<JobStage> completedJobStages) {
    List<JobStage> resultList = List();
    for(JobStage completedStage in completedJobStages){
      if(completedStage.value != stageToRemove.value)resultList.add(completedStage);
    }
    return resultList;
  }

  JobStage _getNextUncompletedStage(int stageIndex, List<JobStage> completedStages) {
    JobStage currentStage = JobStage.getStageFromIndex(stageIndex);
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
      if(completedStage.value == nextStage.value) return true;
    }
    return containsNextStage;
  }
}