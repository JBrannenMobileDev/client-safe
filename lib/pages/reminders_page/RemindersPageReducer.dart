import 'package:dandylight/pages/reminders_page/RemindersActions.dart';
import 'package:dandylight/pages/reminders_page/RemindersPageState.dart';
import 'package:redux/redux.dart';

final remindersReducer = combineReducers<RemindersPageState>([
  TypedReducer<RemindersPageState, SetRemindersAction>(_setReminders),
]);

RemindersPageState _setReminders(RemindersPageState previousState, SetRemindersAction action){
  return previousState.copyWith(
    reminders: action.reminders
  );
}
