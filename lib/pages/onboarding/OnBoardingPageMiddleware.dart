import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:redux/redux.dart';

import 'OnBoardingActions.dart';

class OnBoardingPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SetJobForDetailsPage){
      _setSampleJob(store, action, next);
    }
  }

  void _setSampleJob(Store<AppState> store, SetJobForDetailsPage action, NextDispatcher next) async{
    store.dispatch(SetJobInfo(store.state.jobDetailsPageState, (await JobDao.getAllJobs()).first));
  }
}