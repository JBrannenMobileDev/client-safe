import 'package:dandylight/models/Questionnaire.dart';

import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Profile.dart';
import '../../models/Question.dart';

class NewQuestionPageState{
  final String questionnaireName;
  final Questionnaire questionnaire;
  final String message;
  final Profile profile;
  final bool isNew;
  final String newFromName;
  final Function(String, List<Question>) onQuestionnaireSaved;
  final Function() onDeleteSelected;
  final Function(String) onNameChanged;
  final Function() deleteFromJob;
  final Function(String) onMessageChanged;

  NewQuestionPageState({
    @required this.questionnaire,
    @required this.onQuestionnaireSaved,
    @required this.questionnaireName,
    @required this.onNameChanged,
    @required this.onDeleteSelected,
    @required this.profile,
    @required this.isNew,
    @required this.deleteFromJob,
    @required this.newFromName,
    @required this.onMessageChanged,
    @required this.message,
  });

  NewQuestionPageState copyWith({
    String questionnaireName,
    Questionnaire questionnaire,
    Profile profile,
    bool isNew,
    String newFromName,
    String message,
    Function(String, List<Question>) onQuestionnaireSaved,
    Function(String) onNameChanged,
    Function() onDeleteSelected,
    Function() deleteFromJob,
    Function(String) onMessageChanged,
  }){
    return NewQuestionPageState(
      questionnaire: questionnaire?? this.questionnaire,
      onQuestionnaireSaved: onQuestionnaireSaved?? this.onQuestionnaireSaved,
      questionnaireName: questionnaireName ?? this.questionnaireName,
      onNameChanged: onNameChanged ?? this.onNameChanged,
      onDeleteSelected: onDeleteSelected ?? this.onDeleteSelected,
      profile: profile ?? this.profile,
      isNew: isNew ?? this.isNew,
      deleteFromJob: deleteFromJob ?? this.deleteFromJob,
      newFromName: newFromName ?? this.newFromName,
      onMessageChanged: onMessageChanged ?? this.onMessageChanged,
      message: message ?? this.message,
    );
  }

  factory NewQuestionPageState.initial() => NewQuestionPageState(
    questionnaire: null,
    onQuestionnaireSaved: null,
    questionnaireName: '',
    onNameChanged: null,
    onDeleteSelected: null,
    profile: null,
    isNew: false,
    newFromName: '',
    deleteFromJob: null,
    onMessageChanged: null,
    message: '',
  );

  factory NewQuestionPageState.fromStore(Store<AppState> store) {
    return NewQuestionPageState(
      questionnaire: store.state.newQuestionnairePageState.questionnaire,
      questionnaireName: store.state.newQuestionnairePageState.questionnaireName,
      profile: store.state.newQuestionnairePageState.profile,
      isNew: store.state.newQuestionnairePageState.isNew,
      deleteFromJob: store.state.newQuestionnairePageState.deleteFromJob,
      newFromName: store.state.newQuestionnairePageState.newFromName,
      message: store.state.newQuestionnairePageState.message,
      onQuestionnaireSaved: (jobDocumentId, questions) => store.dispatch(SaveQuestionnaireAction(store.state.newQuestionnairePageState, jobDocumentId, questions)),
      onNameChanged: (name) => store.dispatch(SetQuestionnaireNameAction(store.state.newQuestionnairePageState, name)),
      onDeleteSelected: () => store.dispatch(DeleteQuestionnaireAction(store.state.newQuestionnairePageState)),
      onMessageChanged: (message) => store.dispatch(SetMessageToClientAction(store.state.newQuestionnairePageState, message)),
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
      deleteFromJob.hashCode ^
      onMessageChanged.hashCode ^
      message.hashCode ^
      onQuestionnaireSaved.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is NewQuestionPageState &&
              questionnaire == other.questionnaire &&
              questionnaireName == other.questionnaireName &&
              onNameChanged == other.onNameChanged &&
              onDeleteSelected == other.onDeleteSelected &&
              profile == other.profile &&
              isNew == other.isNew &&
              newFromName == other.newFromName &&
              deleteFromJob == other.deleteFromJob &&
              onMessageChanged == other.onMessageChanged &&
              message == other.message &&
              onQuestionnaireSaved == other.onQuestionnaireSaved;
}