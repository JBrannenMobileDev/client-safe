import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/utils/CalendarSyncUtil.dart';
import 'package:dandylight/utils/StringUtils.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

import '../../models/Profile.dart';
import 'WeeklyCalendarPageActions.dart';

class WeeklyCalendarPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchAllWeeklyCalendarJobsAction) {
      _loadAll(store, action, next);
    }
    if(action is FetchWeeklyDeviceEvents) {
      _fetchDeviceEventsForMonth(store, action, next);
    }
  }

  void _fetchDeviceEventsForMonth(Store<AppState> store, FetchWeeklyDeviceEvents action, NextDispatcher next) async {
    DateTime startDate = DateTime(action.focusedDay.year, action.focusedDay.month - 1, 1);
    DateTime endDate = DateTime(action.focusedDay.year, action.focusedDay.month + 1, 1);
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if((profile != null && profile.calendarEnabled != null && profile.calendarEnabled!)) {
      print('Start date = ${DateFormat('yyyy-MM-dd').format(startDate)}');
      print('End date = ${DateFormat('yyyy-MM-dd').format(endDate)}');
      List<Event> deviceEvents = await CalendarSyncUtil.getDeviceEventsForDateRange(startDate, endDate);
      print('Device events = ${deviceEvents.elementAt(0).title}');
      store.dispatch(SetDeviceEventsAction(store.state.weeklyCalendarPageState!, deviceEvents));
    }
    store.dispatch(SetSelectedDateAction(store.state.weeklyCalendarPageState!, action.focusedDay));
  }

  void _loadAll(Store<AppState> store, action, NextDispatcher next) async {
    List<Job>? allJobs = await JobDao.getAllJobs();
    store.dispatch(SetJobsCalendarStateAction(store.state.weeklyCalendarPageState!, allJobs!));

    (await JobDao.getJobsStream()).listen((jobSnapshots) async {
      List<Job> jobs = [];
      for(RecordSnapshot clientSnapshot in jobSnapshots) {
        jobs.add(Job.fromMap(clientSnapshot.value! as Map<String, dynamic>));
      }
      store.dispatch(SetJobsCalendarStateAction(store.state.weeklyCalendarPageState!, jobs));
    });
  }
}