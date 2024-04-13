import 'package:dandylight/pages/new_reminder_page/NewReminderActions.dart';
import 'package:redux/redux.dart';
import 'NewReminderPageState.dart';

final newReminderPageReducer = combineReducers<NewReminderPageState>([
  TypedReducer<NewReminderPageState, ClearNewReminderStateAction>(_clearState),
  TypedReducer<NewReminderPageState, UpdateWhenAction>(_updateWhen),
  TypedReducer<NewReminderPageState, UpdateDescription>(_updateDescription),
  TypedReducer<NewReminderPageState, UpdateDaysWeeksMonthsAction>(_updateDaysWeeksMonths),
  TypedReducer<NewReminderPageState, UpdateDaysWeeksMonthsAmountAction>(_updateDaysWeeksMonthsAmount),
  TypedReducer<NewReminderPageState, LoadExistingReminderData>(_loadExistingReminder),
  TypedReducer<NewReminderPageState, SetSelectedTimeAction>(_setSelectedTime),
]);

NewReminderPageState _setSelectedTime(NewReminderPageState previousState, SetSelectedTimeAction action) {
  return previousState.copyWith(
    selectedTime: action.time,
  );
}

NewReminderPageState _loadExistingReminder(NewReminderPageState previousState, LoadExistingReminderData action){
  return previousState.copyWith(
    shouldClear: false,
    daysWeeksMonths: action.reminder!.daysWeeksMonths,
    daysWeeksMonthsAmount: action.reminder!.amount,
    when: action.reminder!.when,
    documentId: action.reminder!.documentId,
    reminderDescription: action.reminder!.description,
    selectedTime: action.reminder!.time
  );
}

NewReminderPageState _clearState(NewReminderPageState previousState, ClearNewReminderStateAction action){
  return NewReminderPageState.initial();
}

NewReminderPageState _updateWhen(NewReminderPageState previousState, UpdateWhenAction action){
  return previousState.copyWith(
    when: action.when,
  );
}

NewReminderPageState _updateDescription(NewReminderPageState previousState, UpdateDescription action){
  return previousState.copyWith(
    reminderDescription: action.description,
  );
}

NewReminderPageState _updateDaysWeeksMonths(NewReminderPageState previousState, UpdateDaysWeeksMonthsAction action){
  return previousState.copyWith(
    daysWeeksMonths: action.daysWeeksMonthsSelection,
  );
}

NewReminderPageState _updateDaysWeeksMonthsAmount(NewReminderPageState previousState, UpdateDaysWeeksMonthsAmountAction action){
  return previousState.copyWith(
    daysWeeksMonthsAmount: action.amount,
  );
}

