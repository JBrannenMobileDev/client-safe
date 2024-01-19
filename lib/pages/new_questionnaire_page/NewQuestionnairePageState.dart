import 'package:dandylight/models/Contract.dart';
import 'package:dandylight/models/Questionnaire.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Profile.dart';
import 'NewQuestionnaireActions.dart';

class NewQuestionnairePageState{
  final String questionnaireName;
  final Questionnaire questionnaire;
  final Profile profile;
  final bool isNew;
  final String newFromName;
  final Function(String) onQuestionnaireSaved;
  final Function() onDeleteSelected;
  final Function(String) onNameChanged;
  final Function() deleteFromJob;

  NewQuestionnairePageState({
    @required this.questionnaire,
    @required this.onQuestionnaireSaved,
    @required this.questionnaireName,
    @required this.onNameChanged,
    @required this.onDeleteSelected,
    @required this.profile,
    @required this.isNew,
    @required this.deleteFromJob,
    @required this.newFromName,
  });

  NewQuestionnairePageState copyWith({
    String questionnaireName,
    Questionnaire questionnaire,
    Profile profile,
    bool isNew,
    String newFromName,
    Function(String) onQuestionnaireSaved,
    Function(String) onNameChanged,
    Function() onDeleteSelected,
    Function() deleteFromJob,
  }){
    return NewQuestionnairePageState(
      questionnaire: questionnaire?? this.questionnaire,
      onQuestionnaireSaved: onQuestionnaireSaved?? this.onQuestionnaireSaved,
      questionnaireName: questionnaireName ?? this.questionnaireName,
      onNameChanged: onNameChanged ?? this.onNameChanged,
      onDeleteSelected: onDeleteSelected ?? this.onDeleteSelected,
      profile: profile ?? this.profile,
      isNew: isNew ?? this.isNew,
      deleteFromJob: deleteFromJob ?? this.deleteFromJob,
      newFromName: newFromName ?? this.newFromName,
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
    deleteFromJob: null,
  );

  factory NewQuestionnairePageState.fromStore(Store<AppState> store) {
    return NewQuestionnairePageState(
      questionnaire: store.state.newQuestionnairePageState.questionnaire,
      questionnaireName: store.state.newQuestionnairePageState.questionnaireName,
      profile: store.state.newQuestionnairePageState.profile,
      isNew: store.state.newQuestionnairePageState.isNew,
      deleteFromJob: store.state.newQuestionnairePageState.deleteFromJob,
      newFromName: store.state.newQuestionnairePageState.newFromName,
      onQuestionnaireSaved: (jobDocumentId) => store.dispatch(SaveQuestionnaireAction(store.state.newQuestionnairePageState, jobDocumentId)),
      onNameChanged: (name) => store.dispatch(SetQuestionnaireNameAction(store.state.newQuestionnairePageState, name)),
      onDeleteSelected: () => store.dispatch(DeleteQuestionnaireAction(store.state.newQuestionnairePageState)),
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
              deleteFromJob == other.deleteFromJob &&
              onQuestionnaireSaved == other.onQuestionnaireSaved;
}