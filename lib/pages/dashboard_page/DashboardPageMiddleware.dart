import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ClientDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageActions.dart';
import 'package:dandylight/pages/jobs_page/JobsPageActions.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

class DashboardPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    if(action is LoadJobsAction) {
      await _loadAllJobs(store, action, next);
      await _loadClients(store, action, next);
    }
  }

  Future<void> _loadAllJobs(Store<AppState> store, action, NextDispatcher next) async {
    List<Job> allJobs = await JobDao.getAllJobs();
    if(allJobs.length > 0) {
      store.dispatch(SetJobsDataAction(store.state.jobsPageState, allJobs));
      store.dispatch(SetJobToStateAction(store.state.dashboardPageState, allJobs));
    }

    (await JobDao.getJobsStream()).listen((jobSnapshots) async {
      List<Job> jobs = [];
      for(RecordSnapshot clientSnapshot in jobSnapshots) {
        jobs.add(Job.fromMap(clientSnapshot.value));
      }
      if(jobs.length > 0) {
        store.dispatch(SetJobsDataAction(store.state.jobsPageState, jobs));
        store.dispatch(SetJobToStateAction(store.state.dashboardPageState, jobs));
      }
    });
  }

  Future<void> _loadClients(Store<AppState> store, action, NextDispatcher next) async {
    List<Client> clients = await ClientDao.getAll();
    store.dispatch(SetClientsDashboardAction(store.state.dashboardPageState, clients));

    (await ClientDao.getClientsStream()).listen((clientSnapshots) {
      List<Client> clients = List();
      for(RecordSnapshot clientSnapshot in clientSnapshots) {
        clients.add(Client.fromMap(clientSnapshot.value));
      }
      store.dispatch(SetClientsDashboardAction(store.state.dashboardPageState, clients));
    });
  }
}