import 'package:dandylight/pages/reminders_page/RemindersActions.dart';
import 'package:redux/redux.dart';
import 'ContractsPageState.dart';

final contractsReducer = combineReducers<ContractsPageState>([
  TypedReducer<ContractsPageState, SetRemindersAction>(_setReminders),
]);

ContractsPageState _setReminders(ContractsPageState previousState, SetRemindersAction action){
  return previousState.copyWith(
    reminders: action.reminders
  );
}
