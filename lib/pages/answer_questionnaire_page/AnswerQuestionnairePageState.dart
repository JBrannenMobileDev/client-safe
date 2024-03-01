import 'package:dandylight/models/Questionnaire.dart';

import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Profile.dart';
import '../../models/Question.dart';
import 'AnswerQuestionnaireActions.dart';

class AnswerQuestionnairePageState{
  final String questionnaireName;
  final Questionnaire questionnaire;
  final String message;
  final Profile profile;
  final bool isNew;
  final String newFromName;
  final Function(String, List<Question>, bool isNew) onQuestionnaireSaved;
  final Function() onDeleteSelected;
  final Function(String) onNameChanged;
  final Function(String) onMessageChanged;
  final Function(Question) onQuestionSaved;

  AnswerQuestionnairePageState({
    @required this.questionnaire,
    @required this.onQuestionnaireSaved,
    @required this.questionnaireName,
    @required this.onNameChanged,
    @required this.onDeleteSelected,
    @required this.profile,
    @required this.isNew,
    @required this.newFromName,
    @required this.onMessageChanged,
    @required this.message,
    @required this.onQuestionSaved,
  });

  AnswerQuestionnairePageState copyWith({
    String questionnaireName,
    Questionnaire questionnaire,
    Profile profile,
    bool isNew,
    String newFromName,
    String message,
    Function(String, List<Question>, bool isNew) onQuestionnaireSaved,
    Function(String) onNameChanged,
    Function() onDeleteSelected,
    Function(String) onMessageChanged,
    Function(Question) onQuestionSaved,
  }){
    return AnswerQuestionnairePageState(
      questionnaire: questionnaire?? this.questionnaire,
      onQuestionnaireSaved: onQuestionnaireSaved?? this.onQuestionnaireSaved,
      questionnaireName: questionnaireName ?? this.questionnaireName,
      onNameChanged: onNameChanged ?? this.onNameChanged,
      onDeleteSelected: onDeleteSelected ?? this.onDeleteSelected,
      profile: profile ?? this.profile,
      isNew: isNew ?? this.isNew,
      newFromName: newFromName ?? this.newFromName,
      onMessageChanged: onMessageChanged ?? this.onMessageChanged,
      message: message ?? this.message,
      onQuestionSaved: onQuestionSaved ?? this.onQuestionSaved,
    );
  }

  factory AnswerQuestionnairePageState.initial() => AnswerQuestionnairePageState(
    questionnaire: null,
    onQuestionnaireSaved: null,
    questionnaireName: '',
    onNameChanged: null,
    onDeleteSelected: null,
    profile: null,
    isNew: false,
    newFromName: '',
    onMessageChanged: null,
    message: '',
    onQuestionSaved: null,
  );

  factory AnswerQuestionnairePageState.fromStore(Store<AppState> store) {
    return AnswerQuestionnairePageState(
      questionnaire: store.state.newQuestionnairePageState.questionnaire,
      questionnaireName: store.state.newQuestionnairePageState.questionnaireName,
      profile: store.state.newQuestionnairePageState.profile,
      isNew: store.state.newQuestionnairePageState.isNew,
      newFromName: store.state.newQuestionnairePageState.newFromName,
      message: store.state.newQuestionnairePageState.message,
      onQuestionnaireSaved: (jobDocumentId, questions, isNew) => store.dispatch(SaveQuestionnaireAction(store.state.answerQuestionnairePageState, jobDocumentId, questions, isNew)),
      onNameChanged: (name) => store.dispatch(SetQuestionnaireNameAction(store.state.answerQuestionnairePageState, name)),
      onDeleteSelected: () => store.dispatch(DeleteQuestionnaireAction(store.state.answerQuestionnairePageState)),
      onMessageChanged: (message) => store.dispatch(SetMessageToClientAction(store.state.answerQuestionnairePageState, message)),
      onQuestionSaved: (question) => store.dispatch(OnAddOrUpdateQuestionSelected(store.state.answerQuestionnairePageState, question)),
    );
  }

  @override
  int get hashCode =>
      questionnaire.hashCode ^
      questionnaireName.hashCode ^
      onNameChanged.hashCode ^
      onDeleteSelected.hashCode ^
      profile.hashCode^
      isNew.hashCode ^
      newFromName.hashCode ^
      onMessageChanged.hashCode ^
      message.hashCode ^
      onQuestionSaved.hashCode ^
      onQuestionnaireSaved.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AnswerQuestionnairePageState &&
              questionnaire == other.questionnaire &&
              questionnaireName == other.questionnaireName &&
              onNameChanged == other.onNameChanged &&
              onDeleteSelected == other.onDeleteSelected &&
              profile == other.profile &&
              isNew == other.isNew &&
              newFromName == other.newFromName &&
              onMessageChanged == other.onMessageChanged &&
              message == other.message &&
              onQuestionSaved == other.onQuestionSaved &&
              onQuestionnaireSaved == other.onQuestionnaireSaved;
}