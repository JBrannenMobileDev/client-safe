import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Job.dart';
import '../../models/Questionnaire.dart';
import 'QuestionnairesActions.dart';

class QuestionnairesPageState{
  final List<Questionnaire>? questionnaires;
  final List<Job>? activeJobs;
  final String? shareMessage;
  final Function(Questionnaire, String?)? onSaveToJobSelected;
  final Function()? unsubscribe;
  final Function(String)? onShareMessageChanged;

  QuestionnairesPageState({
    @required this.questionnaires,
    @required this.onSaveToJobSelected,
    @required this.unsubscribe,
    @required this.activeJobs,
    @required this.shareMessage,
    @required this.onShareMessageChanged,
  });

  QuestionnairesPageState copyWith({
    List<Questionnaire>? questionnaires,
    List<Job>? activeJobs,
    String? shareMessage,
    Function(Questionnaire, String?)? onSaveToJobSelected,
    Function()? unsubscribe,
    Function(String)? onShareMessageChanged,
  }){
    return QuestionnairesPageState(
      questionnaires: questionnaires?? this.questionnaires,
      onSaveToJobSelected: onSaveToJobSelected ?? this.onSaveToJobSelected,
      unsubscribe: unsubscribe ?? this.unsubscribe,
      activeJobs: activeJobs ?? this.activeJobs,
      shareMessage: shareMessage ?? this.shareMessage,
      onShareMessageChanged: onShareMessageChanged ?? this.onShareMessageChanged,
    );
  }

  factory QuestionnairesPageState.initial() => QuestionnairesPageState(
    questionnaires: [],
    onSaveToJobSelected: null,
    unsubscribe: null,
    activeJobs: [],
    shareMessage: '',
    onShareMessageChanged: null,
  );

  factory QuestionnairesPageState.fromStore(Store<AppState> store) {
    return QuestionnairesPageState(
      questionnaires: store.state.questionnairesPageState.questionnaires,
      activeJobs: store.state.questionnairesPageState.activeJobs,
      shareMessage: store.state.questionnairesPageState.shareMessage,
      onSaveToJobSelected: (questionnaire, jobDocumentId) => store.dispatch(SaveQuestionnaireToJobAction(store.state.questionnairesPageState, questionnaire, jobDocumentId)),
      unsubscribe: () => store.dispatch(CancelSubscriptionsAction(store.state.questionnairesPageState)),
      onShareMessageChanged: (message) => store.dispatch(UpdateShareMessageAction(store.state.questionnairesPageState, message)),
    );
  }

  @override
  int get hashCode =>
      questionnaires.hashCode ^
      unsubscribe.hashCode ^
      activeJobs.hashCode ^
      shareMessage.hashCode ^
      onShareMessageChanged.hashCode ^
      onSaveToJobSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is QuestionnairesPageState &&
              questionnaires == other.questionnaires &&
              unsubscribe == other.unsubscribe &&
              activeJobs == other.activeJobs &&
              shareMessage == other.shareMessage &&
              onShareMessageChanged == other.onShareMessageChanged &&
              onSaveToJobSelected == other.onSaveToJobSelected;
}