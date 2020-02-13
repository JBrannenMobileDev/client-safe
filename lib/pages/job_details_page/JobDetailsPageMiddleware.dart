import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/JobDao.dart';
import 'package:redux/redux.dart';

class JobDetailsPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
//    if(action is FetchJobsAction){
//      fetchJobs(store, next);
//    }
  }

//  void fetchJobs(Store<AppState> store, NextDispatcher next) async{
//      store.dispatch(SetJobsDataAction(store.state.jobsPageState, await JobDao.getAllJobs()));
//  }
}