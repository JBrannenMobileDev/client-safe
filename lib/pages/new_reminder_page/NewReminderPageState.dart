import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_reminder_page/NewReminderActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import 'NewReminderPage.dart';

@immutable
class NewReminderPageState {
  static const String NO_ERROR = "noError";
  static const String ERROR_PROFILE_NAME_MISSING = "missingProfileName";

  final int id;
  final String documentId;
  final String when;
  final bool saveButtonEnabled;
  final bool shouldClear;
  final String reminderDescription;
  final String daysWeeksMonths;
  final int daysWeeksMonthsAmount;
  final Function() onSavePressed;
  final Function() onCancelPressed;
  final Function() onDeleteReminderSelected;
  final Function(String) whenSelected;
  final Function(String) onReminderDescriptionChanged;
  final Function(String) onDaysWeeksMonthsChanged;
  final Function(int) onDaysWeeksMonthsAmountChanged;

  NewReminderPageState({
    @required this.id,
  @required this.documentId,
  @required this.when,
  @required this.saveButtonEnabled,
  @required this.shouldClear,
  @required this.reminderDescription,
  @required this.daysWeeksMonths,
  @required this.daysWeeksMonthsAmount,
  @required this.onSavePressed,
  @required this.onCancelPressed,
  @required this.onDeleteReminderSelected,
  @required this.whenSelected,
  @required this.onReminderDescriptionChanged,
  @required this.onDaysWeeksMonthsChanged,
  @required this.onDaysWeeksMonthsAmountChanged,
});

  NewReminderPageState copyWith({
    int id,
    String documentId,
    String when,
    saveButtonEnabled,
    bool shouldClear,
    String reminderDescription,
    String daysWeeksMonths,
    int daysWeeksMonthsAmount,
    Function() onSavePressed,
    Function() onCancelPressed,
    Function() onDeleteReminderSelected,
    Function(String) whenSelected,
    Function(String) onReminderDescriptionChanged,
    Function(String) onDaysWeeksMonthsChanged,
    Function(int) onDaysWeeksMonthsAmountChanged,
  }){
    return NewReminderPageState(
      id: id?? this.id,
      when: when?? this.when,
      saveButtonEnabled: saveButtonEnabled?? this.saveButtonEnabled,
      shouldClear: shouldClear?? this.shouldClear,
      daysWeeksMonthsAmount: daysWeeksMonthsAmount ?? this.daysWeeksMonthsAmount,
      reminderDescription: reminderDescription?? this.reminderDescription,
      daysWeeksMonths: daysWeeksMonths ?? this.daysWeeksMonths,
      onSavePressed: onSavePressed?? this.onSavePressed,
      onCancelPressed: onCancelPressed?? this.onCancelPressed,
      onDeleteReminderSelected: onDeleteReminderSelected?? this.onDeleteReminderSelected,
      documentId: documentId ?? this.documentId,
      whenSelected: whenSelected ?? this.whenSelected,
      onReminderDescriptionChanged: onReminderDescriptionChanged ?? this.onReminderDescriptionChanged,
      onDaysWeeksMonthsChanged: onDaysWeeksMonthsChanged ?? this.onDaysWeeksMonthsChanged,
      onDaysWeeksMonthsAmountChanged: onDaysWeeksMonthsAmountChanged ?? this.onDaysWeeksMonthsAmountChanged,
    );
  }

  factory NewReminderPageState.initial() => NewReminderPageState(
        id: null,
        documentId: '',
        saveButtonEnabled: false,
        shouldClear: true,
        reminderDescription: "",
        daysWeeksMonths: NewReminderPage.DAYS,
        daysWeeksMonthsAmount: 2,
        onSavePressed: null,
        onCancelPressed: null,
        onDeleteReminderSelected: null,
        whenSelected: null,
        onReminderDescriptionChanged: null,
        onDaysWeeksMonthsChanged: null,
        onDaysWeeksMonthsAmountChanged: null,
        when: NewReminderPage.BEFORE,
      );

  factory NewReminderPageState.fromStore(Store<AppState> store) {
    return NewReminderPageState(
      id: store.state.newReminderPageState.id,
      when: store.state.newReminderPageState.when,
      saveButtonEnabled: store.state.newReminderPageState.saveButtonEnabled,
      shouldClear: store.state.newReminderPageState.shouldClear,
      reminderDescription: store.state.newReminderPageState.reminderDescription,
      documentId: store.state.newReminderPageState.documentId,
      daysWeeksMonths: store.state.newReminderPageState.daysWeeksMonths,
      daysWeeksMonthsAmount: store.state.newReminderPageState.daysWeeksMonthsAmount,
      onSavePressed: () => store.dispatch(SaveNewReminderAction(store.state.newReminderPageState)),
      onCancelPressed: () => store.dispatch(ClearNewReminderStateAction(store.state.newReminderPageState)),
      onDeleteReminderSelected: () => store.dispatch(DeleteReminderAction(store.state.newReminderPageState)),
      whenSelected: (when) => store.dispatch(UpdateWhenAction(store.state.newReminderPageState, when)),
      onReminderDescriptionChanged: (description) => store.dispatch(UpdateDescription(store.state.newReminderPageState, description)),
      onDaysWeeksMonthsChanged: (selection) => store.dispatch(UpdateDaysWeeksMonthsAction(store.state.newReminderPageState, selection)),
      onDaysWeeksMonthsAmountChanged: (amount) => store.dispatch(UpdateDaysWeeksMonthsAmountAction(store.state.newReminderPageState, amount)),
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      documentId.hashCode ^
      when.hashCode ^
      saveButtonEnabled.hashCode ^
      shouldClear.hashCode ^
      reminderDescription.hashCode ^
      daysWeeksMonths.hashCode ^
      daysWeeksMonthsAmount.hashCode ^
      onDeleteReminderSelected.hashCode ^
      whenSelected.hashCode ^
      onReminderDescriptionChanged.hashCode ^
      onDaysWeeksMonthsChanged.hashCode ^
      onDaysWeeksMonthsAmountChanged.hashCode ^
      onSavePressed.hashCode ^
      onCancelPressed.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewReminderPageState &&
          id == other.id &&
          documentId == other.documentId &&
          when == other.when &&
          saveButtonEnabled == other.saveButtonEnabled &&
          shouldClear == other.shouldClear &&
          reminderDescription == other.reminderDescription &&
          daysWeeksMonthsAmount == other.daysWeeksMonthsAmount &&
          daysWeeksMonths == other.daysWeeksMonths &&
          onDeleteReminderSelected == other.onDeleteReminderSelected &&
          whenSelected == other.whenSelected &&
          onReminderDescriptionChanged == other.onReminderDescriptionChanged &&
          onDaysWeeksMonthsAmountChanged == other.onDaysWeeksMonthsAmountChanged &&
          onDaysWeeksMonthsChanged == other.onDaysWeeksMonthsChanged &&
          onSavePressed == other.onSavePressed &&
          onCancelPressed == other.onCancelPressed;
}
