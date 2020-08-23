import 'package:dandylight/pages/new_job_reminder/NewJobReminderPageActions.dart';
import 'package:dandylight/pages/new_job_reminder/NewJobReminderPageState.dart';
import 'package:redux/redux.dart';

final newJobReminderPageReducer = combineReducers<NewJobReminderPageState>([
  TypedReducer<NewJobReminderPageState, ClearNewJobReminderStateAction>(_clearState),
  TypedReducer<NewJobReminderPageState, SetSelectedTimeAction>(_setSelectedTime),
  TypedReducer<NewJobReminderPageState, IncrementPageViewIndex>(_incrementPageView),
  TypedReducer<NewJobReminderPageState, DecrementPageViewIndex>(_decrementPageView),
  TypedReducer<NewJobReminderPageState, ReminderSelectedAction>(_setSelectedReminder),
  TypedReducer<NewJobReminderPageState, SetAllRemindersAction>(_setAllReminders),
]);

NewJobReminderPageState _clearState(NewJobReminderPageState previousState, ClearNewJobReminderStateAction action) {
  return NewJobReminderPageState.initial();
}

NewJobReminderPageState _setSelectedTime(NewJobReminderPageState previousState, SetSelectedTimeAction action) {
  return previousState.copyWith(
    selectedTime: action.time,
  );
}

NewJobReminderPageState _incrementPageView(NewJobReminderPageState previousState, IncrementPageViewIndex action) {
  return previousState.copyWith(
    pageViewIndex: previousState.pageViewIndex + 1,
  );
}

NewJobReminderPageState _decrementPageView(NewJobReminderPageState previousState, DecrementPageViewIndex action) {
  return previousState.copyWith(
    pageViewIndex: previousState.pageViewIndex - 1,
  );
}

NewJobReminderPageState _setSelectedReminder(NewJobReminderPageState previousState, ReminderSelectedAction action) {
  return previousState.copyWith(
    selectedReminder: action.reminder,
  );
}

NewJobReminderPageState _setAllReminders(NewJobReminderPageState previousState, SetAllRemindersAction action) {
  return previousState.copyWith(
    allReminders: action.allReminders,
  );
}
