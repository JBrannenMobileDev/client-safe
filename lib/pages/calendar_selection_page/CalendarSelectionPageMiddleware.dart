import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/calendar_selection_page/CalendarSelectionActions.dart';
import 'package:dandylight/utils/CalendarSyncUtil.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:redux/redux.dart';

import '../calendar_page/CalendarPageActions.dart';

class CalendarSelectionPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchWritableCalendars){
      fetchCalendars(store, next);
    }
    if(action is SaveSelectedAction) {
      saveSelectedCalendars(store, next, action);
    }
    if(action is SetCalendarPermissionFalse) {
      setCalendarPermission(store, next);
    }
  }

  void saveSelectedCalendars(Store<AppState> store, NextDispatcher next, SaveSelectedAction action) async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.calendarIdsToSync = action.pageState!.selectedCalendars!.map((calendar) => calendar.id).toList();
    profile.calendarEnabled = true;
    await ProfileDao.update(profile);
    CalendarSyncUtil.syncJobsToDeviceCalendars();
    store.dispatch(FetchDeviceEvents(store.state.calendarPageState!, DateTime.now(), true));
  }

  void fetchCalendars(Store<AppState> store, NextDispatcher next) async{
      List<Calendar> writableCalendars = await CalendarSyncUtil.getWritableCalendars();
      store.dispatch(SetWritableCalendars(store.state.calendarSelectionPageState, writableCalendars));
  }

  void setCalendarPermission(Store<AppState> store, NextDispatcher next) async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.calendarEnabled = false;
    await ProfileDao.update(profile);
  }
}