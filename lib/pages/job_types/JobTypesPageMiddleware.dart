import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobTypeDao.dart';
import 'package:dandylight/pages/job_types/JobTypesActions.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

import '../../models/JobType.dart';

class JobTypesPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchJobTypesAction){
      fetchJobTypes(store, next);
    }
  }

  void fetchJobTypes(Store<AppState> store, NextDispatcher next) async{
      List<JobType> jobTypes = await JobTypeDao.getAll();
      next(SetJobTypesAction(store.state.jobTypesPageState, jobTypes));

      (await JobTypeDao.getJobTypeStream()).listen((snapshots) async {
        List<JobType> jobTypesToUpdate = [];
        for(RecordSnapshot jobTypesSnapshot in snapshots) {
          jobTypesToUpdate.add(JobType.fromMap(jobTypesSnapshot.value! as Map<String,dynamic>));
        }
        store.dispatch(SetJobTypesAction(store.state.jobTypesPageState, jobTypesToUpdate));
      });
  }
}