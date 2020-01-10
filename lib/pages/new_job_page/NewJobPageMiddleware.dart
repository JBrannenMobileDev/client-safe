import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/ClientDao.dart';
import 'package:client_safe/data_layer/local_db/daos/JobDao.dart';
import 'package:client_safe/data_layer/local_db/daos/LocationDao.dart';
import 'package:client_safe/data_layer/local_db/daos/PriceProfileDao.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/Location.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageActions.dart';
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
  }

  void _fetchSunsetTime(Store<AppState> store, action, NextDispatcher next) async{
    Location selectedLocation = store.state.newJobPageState.selectedLocation;
    DateTime selectedDate = store.state.newJobPageState.selectedDate;
    final response = await SunriseSunset.getResults(date: selectedDate, latitude: selectedLocation.latitude, longitude: selectedLocation.longitude);
    store.dispatch(SetSunsetTimeAction(store.state.newJobPageState, response.data.sunset.toLocal()));
  }

  void _loadAll(Store<AppState> store, action, NextDispatcher next) async {
    PriceProfileDao priceProfileDao = PriceProfileDao();
    ClientDao clientDao = ClientDao();
    LocationDao locationDao = LocationDao();
    JobDao jobDao = JobDao();
    List<PriceProfile> allPriceProfiles = await priceProfileDao.getAllSortedByName();
    List<Client> allClients = await clientDao.getAllSortedByFirstName();
    List<Location> allLocations = await locationDao.getAllSortedMostFrequent();
    List<Job> upcomingJobs = await jobDao.getAllUpcomingJobs();
    store.dispatch(SetAllToStateAction(store.state.newJobPageState, allClients, allPriceProfiles, allLocations, upcomingJobs));
  }

  void _saveNewJob(Store<AppState> store, action, NextDispatcher next) async {
    JobDao jobDao = JobDao();
    Job jobToSave = Job(
      id: store.state.newJobPageState.id,
      clientId: store.state.newJobPageState.selectedClient.id,
      clientName: store.state.newJobPageState.selectedClient.getClientFullName(),
      jobTitle: store.state.newJobPageState.jobTitle,
      dateTime: store.state.newJobPageState.selectedDate,
      type: store.state.newJobPageState.jobType,
      stage: store.state.newJobPageState.currentJobStage,
      completedStages: store.state.newJobPageState.selectedJobStages
      );
    await jobDao.insertOrUpdate(jobToSave);
  }
}