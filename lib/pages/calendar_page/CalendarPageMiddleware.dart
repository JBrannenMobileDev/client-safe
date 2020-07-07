import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/calendar_page/CalendarPageActions.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

class CalendarPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchAllJobsAction) {
      _loadAll(store, action, next);
    }
  }

  void _loadAll(Store<AppState> store, action, NextDispatcher next) async {
    List<Job> allJobs = await JobDao.getAllJobs();
    store.dispatch(SetJobsCalendarStateAction(store.state.calendarPageState, allJobs));

    (await JobDao.getJobsStream()).listen((jobSnapshots) async {
      List<Job> jobs = List();
      for(RecordSnapshot clientSnapshot in jobSnapshots) {
        jobs.add(Job.fromMap(clientSnapshot.value));
      }
      store.dispatch(SetJobsCalendarStateAction(store.state.calendarPageState, jobs));
    });
  }
}