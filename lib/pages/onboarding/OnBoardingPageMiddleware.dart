import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:redux/redux.dart';
import '../../data_layer/local_db/daos/ProfileDao.dart';
import '../../models/Profile.dart';
import '../../utils/UidUtil.dart';
import 'OnBoardingActions.dart';

class OnBoardingPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SetJobForDetailsPage){
      _setSampleJob(store, action, next);
    }
    if(action is SetOnBoardingFinishedAction) {
      updateProfileWithOnBoardingComplete(store, action, next);
    }
  }

  void updateProfileWithOnBoardingComplete(Store<AppState> store, SetOnBoardingFinishedAction action, NextDispatcher next) async {
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.onBoardingComplete = true;
    await ProfileDao.update(profile);
  }

  void _setSampleJob(Store<AppState> store, SetJobForDetailsPage action, NextDispatcher next) async{
    List<Job>? jobs = await JobDao.getAllJobs();
    if(jobs!.length == 0) {
      await JobDao.syncAllFromFireStore();
      jobs = await JobDao.getAllJobs();
    }
    if(jobs!.length > 0) {
      store.dispatch(SetJobInfo(store.state.jobDetailsPageState, (await JobDao.getAllJobs())!.first.documentId));
    }
  }
}