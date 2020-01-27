import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/JobDao.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageActions.dart';
import 'package:redux/redux.dart';

class DashboardPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is LoadJobsAction) {
      _loadAllJobs(store, action, next);
    }
  }

  void _loadAllJobs(Store<AppState> store, action, NextDispatcher next) async {
    JobDao jobDao = JobDao();
    List<Job> upcomingJobs = await jobDao.getAllUpcomingJobs();
    store.dispatch(SetJobToStateAction(store.state.dashboardPageState, upcomingJobs));
  }
}