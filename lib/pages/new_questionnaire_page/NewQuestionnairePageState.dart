import 'package:dandylight/models/Questionnaire.dart';

import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Profile.dart';
import '../../models/Question.dart';
import 'NewQuestionnaireActions.dart';

class NewQuestionnairePageState{
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

  NewQuestionnairePageState({
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

  NewQuestionnairePageState copyWith({
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
    return NewQuestionnairePageState(
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

  factory NewQuestionnairePageState.initial() => NewQuestionnairePageState(
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

  factory NewQuestionnairePageState.fromStore(Store<AppState> store) {
    return NewQuestionnairePageState(
      questionnaire: store.state.newQuestionnairePageState.questionnaire,
      questionnaireName: store.state.newQuestionnairePageState.questionnaireName,
      profile: store.state.newQuestionnairePageState.profile,
      isNew: store.state.newQuestionnairePageState.isNew,
      newFromName: store.state.newQuestionnairePageState.newFromName,
      message: store.state.newQuestionnairePageState.message,
      onQuestionnaireSaved: (jobDocumentId, questions, isNew) => store.dispatch(SaveQuestionnaireAction(store.state.newQuestionnairePageState, jobDocumentId, questions, isNew)),
      onNameChanged: (name) => store.dispatch(SetQuestionnaireNameAction(store.state.newQuestionnairePageState, name)),
      onDeleteSelected: () => store.dispatch(DeleteQuestionnaireAction(store.state.newQuestionnairePageState)),
      onMessageChanged: (message) => store.dispatch(SetMessageToClientAction(store.state.newQuestionnairePageState, message)),
      onQuestionSaved: (question) => store.dispatch(OnAddOrUpdateQuestionSelected(store.state.newQuestionnairePageState, question)),
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
          other is NewQuestionnairePageState &&
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