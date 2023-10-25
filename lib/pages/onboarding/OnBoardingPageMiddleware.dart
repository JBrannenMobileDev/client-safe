import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:redux/redux.dart';

import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import 'OnBoardingActions.dart';

class OnBoardingPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SetJobForDetailsPage){
      _setSampleJob(store, action, next);
    }
    if(action is SetSelectedLeadSourceAction) {
      _setLeadSource(store, action, next);
    }
  }

  void _setLeadSource(Store<AppState> store, SetSelectedLeadSourceAction action, NextDispatcher next) async{
    EventSender().sendEvent(eventName: EventNames.ON_BOARDING_LEAD_SOURCE_SELECTED, properties: {
      EventNames.ON_BOARDING_LEAD_SOURCE_SELECTED_PARAM : action.leadSource,
    });
  }

  void _setSampleJob(Store<AppState> store, SetJobForDetailsPage action, NextDispatcher next) async{
    List<Job> jobs = await JobDao.getAllJobs();
    if(jobs.length == 0) {
      await JobDao.syncAllFromFireStore();
      jobs = await JobDao.getAllJobs();
    }
    if(jobs.length > 0) {
      store.dispatch(SetJobInfo(store.state.jobDetailsPageState, (await JobDao.getAllJobs()).first.documentId));
    }
  }
}