import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/JobDao.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/calendar_page/CalendarPageActions.dart';
import 'package:redux/redux.dart';

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
  }
}