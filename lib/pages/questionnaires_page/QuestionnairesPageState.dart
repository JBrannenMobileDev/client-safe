import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Questionnaire.dart';
import 'QuestionnairesActions.dart';

class QuestionnairesPageState{
  final List<Questionnaire> questionnaires;
  final Function(Questionnaire, String) onSaveToJobSelected;

  QuestionnairesPageState({
    @required this.questionnaires,
    @required this.onSaveToJobSelected,
  });

  QuestionnairesPageState copyWith({
    List<Questionnaire> questionnaires,
    Function(Questionnaire, String) onSaveToJobSelected,
  }){
    return QuestionnairesPageState(
      questionnaires: questionnaires?? this.questionnaires,
      onSaveToJobSelected: onSaveToJobSelected ?? this.onSaveToJobSelected,
    );
  }

  factory QuestionnairesPageState.initial() => QuestionnairesPageState(
    questionnaires: [],
    onSaveToJobSelected: null,
  );

  factory QuestionnairesPageState.fromStore(Store<AppState> store) {
    return QuestionnairesPageState(
      questionnaires: store.state.questionnairesPageState.questionnaires,
      onSaveToJobSelected: (questionnaire, jobDocumentId) => store.dispatch(SaveQuestionnaireToJobAction(store.state.questionnairesPageState, questionnaire, jobDocumentId)),
    );
  }

  @override
  int get hashCode =>
      questionnaires.hashCode ^
      onSaveToJobSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is QuestionnairesPageState &&
              questionnaires == other.questionnaires &&
              onSaveToJobSelected == other.onSaveToJobSelected;
}