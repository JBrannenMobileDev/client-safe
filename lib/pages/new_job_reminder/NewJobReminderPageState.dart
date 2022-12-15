import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:dandylight/pages/new_job_reminder/NewJobReminderPageActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

@immutable
class NewJobReminderPageState {
  final int id;
  final String documentId;
  final int pageViewIndex;
  final bool comingFromJobDetails;
  final bool isFinishedFetchingReminders;
  final bool hasNotCreatedAnyReminders;
  final ReminderDandyLight selectedReminder;
  final DateTime selectedTime;
  final List<ReminderDandyLight> allReminders;
  final Function(Job) onSavePressed;
  final Function() onCancelPressed;
  final Function() onNextPressed;
  final Function() onBackPressed;
  final Function(ReminderDandyLight) onReminderSelected;
  final Function(DateTime) onTimeSelected;

  NewJobReminderPageState({
    @required this.id,
    @required this.documentId,
    @required this.comingFromJobDetails,
    @required this.pageViewIndex,
    @required this.isFinishedFetchingReminders,
    @required this.selectedTime,
    @required this.onSavePressed,
    @required this.onCancelPressed,
    @required this.onNextPressed,
    @required this.onBackPressed,
    @required this.selectedReminder,
    @required this.allReminders,
    @required this.onReminderSelected,
    @required this.onTimeSelected,
    @required this.hasNotCreatedAnyReminders,
  });

  NewJobReminderPageState copyWith({
    int id,
    String documentId,
    int pageViewIndex,
    bool comingFromJobDetails,
    bool isFinishedFetchingReminders,
    ReminderDandyLight selectedReminder,
    DateTime selectedTime,
    List<ReminderDandyLight> allReminders,
    Function() onSavePressed,
    Function() onCancelPressed,
    Function() onNextPressed,
    Function() onBackPressed,
    Function(ReminderDandyLight) onReminderSelected,
    Function(DateTime) onTimeSelected,
    bool hasNotCreatedAnyReminders,
  }){
    return NewJobReminderPageState(
      id: id?? this.id,
      documentId: documentId ?? this.documentId,
      pageViewIndex: pageViewIndex?? this.pageViewIndex,
      comingFromJobDetails: comingFromJobDetails ?? this.comingFromJobDetails,
      isFinishedFetchingReminders: isFinishedFetchingReminders?? this.isFinishedFetchingReminders,
      selectedReminder: selectedReminder ?? this.selectedReminder,
      selectedTime: selectedTime?? this.selectedTime,
      onSavePressed: onSavePressed?? this.onSavePressed,
      onCancelPressed: onCancelPressed?? this.onCancelPressed,
      onNextPressed: onNextPressed?? this.onNextPressed,
      onBackPressed: onBackPressed?? this.onBackPressed,
      onReminderSelected:  onReminderSelected?? this.onReminderSelected,
      onTimeSelected: onTimeSelected?? this.onTimeSelected,
      allReminders: allReminders ?? this.allReminders,
        hasNotCreatedAnyReminders: hasNotCreatedAnyReminders ?? this.hasNotCreatedAnyReminders,
    );
  }

  factory NewJobReminderPageState.initial() {
    List<JobStage> selectedStagesInitial = [];
    selectedStagesInitial.add(JobStage(stage: JobStage.STAGE_1_INQUIRY_RECEIVED));
    return NewJobReminderPageState(
        id: null,
        documentId: '',
        pageViewIndex: 0,
        allReminders: [],
        isFinishedFetchingReminders: false,
        selectedReminder: null,
        selectedTime: null,
        onSavePressed: null,
        onCancelPressed: null,
        onNextPressed: null,
        onBackPressed: null,
        onReminderSelected: null,
        onTimeSelected: null,
        comingFromJobDetails: false,
        hasNotCreatedAnyReminders: true,
      );
  }

  factory NewJobReminderPageState.fromStore(Store<AppState> store) {
    return NewJobReminderPageState(
      id: store.state.newJobReminderPageState.id,
      documentId: store.state.newJobReminderPageState.documentId,
      pageViewIndex: store.state.newJobReminderPageState.pageViewIndex,
      isFinishedFetchingReminders: store.state.newJobReminderPageState.isFinishedFetchingReminders,
      selectedTime: store.state.newJobReminderPageState.selectedTime,
      comingFromJobDetails: store.state.newJobReminderPageState.comingFromJobDetails,
      allReminders: store.state.newJobReminderPageState.allReminders,
      selectedReminder: store.state.newJobReminderPageState.selectedReminder,
      hasNotCreatedAnyReminders: store.state.newJobReminderPageState.hasNotCreatedAnyReminders,
      onSavePressed: (job) => store.dispatch(SaveNewJobReminderAction(store.state.newJobReminderPageState, job)),
      onCancelPressed: () => store.dispatch(ClearNewJobReminderStateAction(store.state.newJobReminderPageState)),
      onNextPressed: () => store.dispatch(IncrementPageViewIndex(store.state.newJobReminderPageState)),
      onBackPressed: () => store.dispatch(DecrementPageViewIndex(store.state.newJobReminderPageState)),
      onReminderSelected: (reminder) => store.dispatch(ReminderSelectedAction(store.state.newJobReminderPageState, reminder)),
      onTimeSelected: (time) => store.dispatch(SetSelectedTimeAction(store.state.newJobReminderPageState, time)),
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      documentId.hashCode ^
      pageViewIndex.hashCode ^
      isFinishedFetchingReminders.hashCode ^
      selectedReminder.hashCode ^
      hasNotCreatedAnyReminders.hashCode ^
      selectedTime.hashCode ^
      onSavePressed.hashCode ^
      onCancelPressed.hashCode ^
      onNextPressed.hashCode ^
      onBackPressed.hashCode ^
      onReminderSelected.hashCode ^
      onTimeSelected.hashCode ^
      allReminders.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewJobReminderPageState &&
          id == other.id &&
          documentId == other.documentId &&
          pageViewIndex == other.pageViewIndex &&
          isFinishedFetchingReminders == other.isFinishedFetchingReminders &&
          selectedReminder == other.selectedReminder &&
          selectedTime == other.selectedTime &&
          onSavePressed == other.onSavePressed &&
          onCancelPressed == other.onCancelPressed &&
          onNextPressed == other.onNextPressed &&
          onBackPressed == other.onBackPressed &&
          onReminderSelected == other.onReminderSelected &&
          onTimeSelected == other.onTimeSelected &&
          hasNotCreatedAnyReminders == other.hasNotCreatedAnyReminders &&
          allReminders == other.allReminders;
}
