import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_reminder_page/NewReminderActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import 'NewReminderPage.dart';
import 'WhenSelectionWidget.dart';

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
  final DateTime selectedTime;
  final bool isDefault;
  final Function() onSavePressed;
  final Function() onCancelPressed;
  final Function() onDeleteReminderSelected;
  final Function(String) whenSelected;
  final Function(String) onReminderDescriptionChanged;
  final Function(String) onDaysWeeksMonthsChanged;
  final Function(int) onDaysWeeksMonthsAmountChanged;
  final Function(bool) onDefaultSelectionChanged;
  final Function(DateTime) onTimeSelected;

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
    @required this.onDefaultSelectionChanged,
    @required this.onTimeSelected,
    @required this.selectedTime,
    @required this.isDefault,
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
    DateTime selectedTime,
    bool isDefault,
    Function() onSavePressed,
    Function() onCancelPressed,
    Function() onDeleteReminderSelected,
    Function(String) whenSelected,
    Function(String) onReminderDescriptionChanged,
    Function(String) onDaysWeeksMonthsChanged,
    Function(int) onDaysWeeksMonthsAmountChanged,
    Function(bool) onDefaultSelectionChanged,
    Function(DateTime) onTimeSelected,
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
      onDefaultSelectionChanged: onDefaultSelectionChanged ?? this.onDefaultSelectionChanged,
      onTimeSelected: onTimeSelected ?? this.onTimeSelected,
      selectedTime: selectedTime ?? this.selectedTime,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  factory NewReminderPageState.initial() => NewReminderPageState(
        id: null,
        documentId: '',
        saveButtonEnabled: false,
        shouldClear: true,
        reminderDescription: "",
        daysWeeksMonths: WhenSelectionWidget.DAYS,
        daysWeeksMonthsAmount: 1,
        onSavePressed: null,
        onCancelPressed: null,
        onDeleteReminderSelected: null,
        whenSelected: null,
        onReminderDescriptionChanged: null,
        onDaysWeeksMonthsChanged: null,
        onDaysWeeksMonthsAmountChanged: null,
        when: WhenSelectionWidget.BEFORE,
        onDefaultSelectionChanged: null,
        onTimeSelected: null,
        selectedTime: null,
        isDefault: false,
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
      selectedTime: store.state.newReminderPageState.selectedTime,
      isDefault: store.state.newReminderPageState.isDefault,
      onSavePressed: () => store.dispatch(SaveNewReminderAction(store.state.newReminderPageState)),
      onCancelPressed: () => store.dispatch(ClearNewReminderStateAction(store.state.newReminderPageState)),
      onDeleteReminderSelected: () => store.dispatch(DeleteReminderAction(store.state.newReminderPageState)),
      whenSelected: (when) => store.dispatch(UpdateWhenAction(store.state.newReminderPageState, when)),
      onReminderDescriptionChanged: (description) => store.dispatch(UpdateDescription(store.state.newReminderPageState, description)),
      onDaysWeeksMonthsChanged: (selection) => store.dispatch(UpdateDaysWeeksMonthsAction(store.state.newReminderPageState, selection)),
      onDaysWeeksMonthsAmountChanged: (amount) => store.dispatch(UpdateDaysWeeksMonthsAmountAction(store.state.newReminderPageState, amount)),
      onDefaultSelectionChanged: (isDefault) => store.dispatch(SetIsDefaultAction(store.state.newReminderPageState, isDefault)),
      onTimeSelected: (dateTime) => store.dispatch(SetSelectedTimeAction(store.state.newReminderPageState, dateTime)),
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
      onCancelPressed.hashCode ^
      onDefaultSelectionChanged.hashCode ^
      onTimeSelected.hashCode ^
      selectedTime.hashCode ^
      isDefault.hashCode;

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
          onCancelPressed == other.onCancelPressed &&
          onDefaultSelectionChanged == other.onDefaultSelectionChanged &&
          onTimeSelected == other.onTimeSelected &&
          selectedTime == other.selectedTime &&
          isDefault == other.isDefault;
}