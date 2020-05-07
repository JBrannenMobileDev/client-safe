import 'dart:collection';
import 'dart:io';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/ClientDao.dart';
import 'package:client_safe/data_layer/local_db/daos/JobDao.dart';
import 'package:client_safe/data_layer/local_db/daos/LocationDao.dart';
import 'package:client_safe/data_layer/local_db/daos/PriceProfileDao.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/Location.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageActions.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageActions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:sunrise_sunset/sunrise_sunset.dart';

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
  }

  void _saveNewJob(Store<AppState> store, action, NextDispatcher next) async {
    Job jobToSave = Job(
      id: store.state.newJobPageState.id,
      clientId: store.state.newJobPageState.selectedClient.id,
      clientName: store.state.newJobPageState.selectedClient.getClientFullName(),
      jobTitle: store.state.newJobPageState.jobTitle,
      selectedDate: store.state.newJobPageState.selectedDate,
      selectedTime: store.state.newJobPageState.selectedTime,
      type: store.state.newJobPageState.jobType,
      stage: store.state.newJobPageState.currentJobStage,
      completedStages: store.state.newJobPageState.selectedJobStages,
      location: store.state.newJobPageState.selectedLocation,
      priceProfile: store.state.newJobPageState.selectedPriceProfile,
      depositAmount: store.state.newJobPageState.depositAmount,
      createdDate: DateTime.now(),
      );
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(ClearStateAction(store.state.newJobPageState));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    store.dispatch(InitializeClientDetailsAction(store.state.clientDetailsPageState, store.state.clientDetailsPageState.client));
  }
}