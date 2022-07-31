import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/calendar_page/CalendarPageActions.dart';
import 'package:dandylight/utils/CalendarSyncUtil.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

import '../../models/Profile.dart';
import '../../utils/UidUtil.dart';

class CalendarPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchAllJobsAction) {
      _loadAll(store, action, next);
    }
    if(action is FetchDeviceEvents) {
      _fetchDeviceEventsForMonth(store, action, next);
    }
  }

  void _fetchDeviceEventsForMonth(Store<AppState> store, FetchDeviceEvents action, NextDispatcher next) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());

    if(profile.calendarEnabled) {
      DateTime startDate = DateTime(action.month.year, action.month.month - 1, 1);
      DateTime endDate = DateTime(action.month.year, action.month.month + 1, 1);

      List<Event> deviceEvents = await CalendarSyncUtil.getDeviceEventsForDateRange(startDate, endDate);
      store.dispatch(SetDeviceEventsAction(store.state.calendarPageState, deviceEvents));
    }
    store.dispatch(SetSelectedDateAction(store.state.calendarPageState, action.month));
  }

  void _loadAll(Store<AppState> store, action, NextDispatcher next) async {
    List<Job> allJobs = await JobDao.getAllJobs();
    store.dispatch(SetJobsCalendarStateAction(store.state.calendarPageState, allJobs));
    store.dispatch(SetDeviceEventsAction(store.state.calendarPageState, []));

    (await JobDao.getJobsStream()).listen((jobSnapshots) async {
      List<Job> jobs = [];
      for(RecordSnapshot clientSnapshot in jobSnapshots) {
        jobs.add(Job.fromMap(clientSnapshot.value));
      }
      store.dispatch(SetJobsCalendarStateAction(store.state.calendarPageState, jobs));
    });
  }
}