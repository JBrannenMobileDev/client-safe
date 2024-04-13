import 'package:dandylight/models/Questionnaire.dart';

import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Profile.dart';
import '../../models/Question.dart';
import 'AnswerQuestionnaireActions.dart';

class AnswerQuestionnairePageState{
  final Questionnaire? questionnaire;
  final Profile? profile;
  final bool? isNew;

  //Short form
  final Function(String, Question)? onShortFormAnswerChanged;

  AnswerQuestionnairePageState({
    @required this.questionnaire,
    @required this.profile,
    @required this.isNew,
    @required this.onShortFormAnswerChanged,
  });

  AnswerQuestionnairePageState copyWith({
    Questionnaire? questionnaire,
    Profile? profile,
    bool? isNew,
    Function(String, Question)? onShortFormAnswerChanged,
  }){
    return AnswerQuestionnairePageState(
      questionnaire: questionnaire?? this.questionnaire,
      profile: profile ?? this.profile,
      isNew: isNew ?? this.isNew,
      onShortFormAnswerChanged: onShortFormAnswerChanged ?? this.onShortFormAnswerChanged,
    );
  }

  factory AnswerQuestionnairePageState.initial() => AnswerQuestionnairePageState(
    questionnaire: null,
    profile: null,
    isNew: false,
    onShortFormAnswerChanged: null,
  );

  factory AnswerQuestionnairePageState.fromStore(Store<AppState> store) {
    return AnswerQuestionnairePageState(
      questionnaire: store.state.newQuestionnairePageState.questionnaire,
      profile: store.state.newQuestionnairePageState.profile,
      isNew: store.state.newQuestionnairePageState.isNew,
      onShortFormAnswerChanged: (answer, question) => store.dispatch(SaveShortFormAnswerAction(store.state.answerQuestionnairePageState, answer, question)),
    );
  }

  @override
  int get hashCode =>
      questionnaire.hashCode ^
      profile.hashCode^
      isNew.hashCode ^
      onShortFormAnswerChanged.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AnswerQuestionnairePageState &&
              questionnaire == other.questionnaire &&
              profile == other.profile &&
              isNew == other.isNew &&
              onShortFormAnswerChanged == other.onShortFormAnswerChanged;
}