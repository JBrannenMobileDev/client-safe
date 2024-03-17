import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/jobs_page/JobsPageActions.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

class JobsPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchJobsAction){
      fetchJobs(store, next);
    }
  }

  void fetchJobs(Store<AppState> store, NextDispatcher next) async{
    List<Job> allJobs = await JobDao.getAllJobs();
    if(allJobs.length > 0) {
      store.dispatch(SetJobsDataAction(store.state.jobsPageState, allJobs));
    }

      (await JobDao.getJobsStream()).listen((jobSnapshots) async {
        List<Job> jobs = [];
        for(RecordSnapshot clientSnapshot in jobSnapshots) {
          jobs.add(Job.fromMap(clientSnapshot.value! as Map<String,dynamic>));
        }
        store.dispatch(SetJobsDataAction(store.state.jobsPageState, jobs));
      });
  }
}