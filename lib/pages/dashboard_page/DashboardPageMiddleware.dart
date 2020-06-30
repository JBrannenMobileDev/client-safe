import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ClientDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageActions.dart';
import 'package:dandylight/pages/jobs_page/JobsPageActions.dart';
import 'package:redux/redux.dart';

class DashboardPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is LoadJobsAction) {
      _loadAllJobs(store, action, next);
      _loadClients(store, action, next);
    }
  }

  void _loadAllJobs(Store<AppState> store, action, NextDispatcher next) async {
    List<Job> allJobs = await JobDao.getAllJobs();
    store.dispatch(SetJobsDataAction(store.state.jobsPageState, allJobs));
    store.dispatch(SetJobToStateAction(store.state.dashboardPageState, allJobs));
  }

  void _loadClients(Store<AppState> store, action, NextDispatcher next) async {
    List<Client> clients = await ClientDao.getAll();
    store.dispatch(SetClientsDashboardAction(store.state.dashboardPageState, clients));
  }
}