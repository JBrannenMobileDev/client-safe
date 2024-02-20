import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Questionnaire.dart';
import 'QuestionnairesActions.dart';

class QuestionnairesPageState{
  final List<Questionnaire> questionnaires;
  final Function(Questionnaire, String) onSaveToJobSelected;
  final Function() unsubscribe;

  QuestionnairesPageState({
    @required this.questionnaires,
    @required this.onSaveToJobSelected,
    @required this.unsubscribe,
  });

  QuestionnairesPageState copyWith({
    List<Questionnaire> questionnaires,
    Function(Questionnaire, String) onSaveToJobSelected,
    Function() unsubscribe,
  }){
    return QuestionnairesPageState(
      questionnaires: questionnaires?? this.questionnaires,
      onSaveToJobSelected: onSaveToJobSelected ?? this.onSaveToJobSelected,
      unsubscribe: unsubscribe ?? this.unsubscribe,
    );
  }

  factory QuestionnairesPageState.initial() => QuestionnairesPageState(
    questionnaires: [],
    onSaveToJobSelected: null,
    unsubscribe: null,
  );

  factory QuestionnairesPageState.fromStore(Store<AppState> store) {
    return QuestionnairesPageState(
      questionnaires: store.state.questionnairesPageState.questionnaires,
      onSaveToJobSelected: (questionnaire, jobDocumentId) => store.dispatch(SaveQuestionnaireToJobAction(store.state.questionnairesPageState, questionnaire, jobDocumentId)),
      unsubscribe: () => store.dispatch(CancelSubscriptionsAction(store.state.questionnairesPageState)),
    );
  }

  @override
  int get hashCode =>
      questionnaires.hashCode ^
      unsubscribe.hashCode ^
      onSaveToJobSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is QuestionnairesPageState &&
              questionnaires == other.questionnaires &&
              unsubscribe == other.unsubscribe &&
              onSaveToJobSelected == other.onSaveToJobSelected;
}