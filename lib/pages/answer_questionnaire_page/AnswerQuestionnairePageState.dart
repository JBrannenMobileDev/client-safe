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

  //Long form
  final Function(String, Question)? onLongFormAnswerChanged;

  //Contact info
  final Function(String, Question)? onFirstNameAnswerChanged;
  final Function(String, Question)? onLastNameAnswerChanged;
  final Function(String, Question)? onPhoneNumberAnswerChanged;
  final Function(String, Question)? onEmailAnswerChanged;
  final Function(String, Question)? onInstagramNameAnswerChanged;

  //Address
  final Function(String, Question)? onAddressAnswerChanged;
  final Function(String, Question)? onAddressLine2AnswerChanged;
  final Function(String, Question)? onCityTownAnswerChanged;
  final Function(String, Question)? onStateRegionAnswerChanged;
  final Function(String, Question)? onZipAnswerChanged;
  final Function(String, Question)? onCountryAnswerChanged;

  //Number
  final Function(String, Question)? onNumberAnswerChanged;

  //Yes No
  final Function(bool, Question)? onYesNoAnswerChanged;

  //Checkboxes
  final Function(int, bool, Question)? onCheckboxItemSelected;

  //Rating
  final Function(int, Question)? onRatingSelected;

  //Date
  final Function(DateTime?, Question)? onDateChanged;

  AnswerQuestionnairePageState({
    @required this.questionnaire,
    @required this.profile,
    @required this.isNew,
    @required this.onShortFormAnswerChanged,
    @required this.onLongFormAnswerChanged,
    @required this.onFirstNameAnswerChanged,
    @required this.onLastNameAnswerChanged,
    @required this.onPhoneNumberAnswerChanged,
    @required this.onEmailAnswerChanged,
    @required this.onInstagramNameAnswerChanged,
    @required this.onNumberAnswerChanged,
    @required this.onYesNoAnswerChanged,
    @required this.onCheckboxItemSelected,
    @required this.onRatingSelected,
    @required this.onDateChanged,
    @required this.onAddressAnswerChanged,
    @required this.onAddressLine2AnswerChanged,
    @required this.onCityTownAnswerChanged,
    @required this.onStateRegionAnswerChanged,
    @required this.onZipAnswerChanged,
    @required this.onCountryAnswerChanged,
  });

  AnswerQuestionnairePageState copyWith({
    Questionnaire? questionnaire,
    Profile? profile,
    bool? isNew,
    Function(String, Question)? onShortFormAnswerChanged,
    Function(String, Question)? onLongFormAnswerChanged,
    Function(String, Question)? onFirstNameAnswerChanged,
    Function(String, Question)? onLastNameAnswerChanged,
    Function(String, Question)? onPhoneNumberAnswerChanged,
    Function(String, Question)? onEmailAnswerChanged,
    Function(String, Question)? onInstagramNameAnswerChanged,
    Function(String, Question)? onNumberAnswerChanged,
    Function(bool, Question)? onYesNoAnswerChanged,
    Function(int index, bool, Question)? onCheckboxItemSelected,
    Function(int, Question)? onRatingSelected,
    Function(DateTime?, Question)? onDateChanged,
    Function(String, Question)? onAddressAnswerChanged,
    Function(String, Question)? onAddressLine2AnswerChanged,
    Function(String, Question)? onCityTownAnswerChanged,
    Function(String, Question)? onStateRegionAnswerChanged,
    Function(String, Question)? onZipAnswerChanged,
    Function(String, Question)? onCountryAnswerChanged
  }){
    return AnswerQuestionnairePageState(
      questionnaire: questionnaire?? this.questionnaire,
      profile: profile ?? this.profile,
      isNew: isNew ?? this.isNew,
      onShortFormAnswerChanged: onShortFormAnswerChanged ?? this.onShortFormAnswerChanged,
      onLongFormAnswerChanged: onLongFormAnswerChanged ?? this.onLongFormAnswerChanged,
      onFirstNameAnswerChanged: onFirstNameAnswerChanged ?? this.onFirstNameAnswerChanged,
      onLastNameAnswerChanged: onLastNameAnswerChanged ?? this.onLastNameAnswerChanged,
      onPhoneNumberAnswerChanged: onPhoneNumberAnswerChanged ?? this.onPhoneNumberAnswerChanged,
      onEmailAnswerChanged: onEmailAnswerChanged ?? this.onEmailAnswerChanged,
      onInstagramNameAnswerChanged: onInstagramNameAnswerChanged ?? this.onInstagramNameAnswerChanged,
      onNumberAnswerChanged: onNumberAnswerChanged ?? this.onNumberAnswerChanged,
      onYesNoAnswerChanged: onYesNoAnswerChanged ?? this.onYesNoAnswerChanged,
      onCheckboxItemSelected: onCheckboxItemSelected ?? this.onCheckboxItemSelected,
      onRatingSelected: onRatingSelected ?? this.onRatingSelected,
      onDateChanged: onDateChanged ?? this.onDateChanged,
      onAddressAnswerChanged: onAddressAnswerChanged ?? this.onAddressAnswerChanged,
      onAddressLine2AnswerChanged: onAddressLine2AnswerChanged ?? this.onAddressLine2AnswerChanged,
      onCityTownAnswerChanged: onCityTownAnswerChanged ?? this.onCityTownAnswerChanged,
      onStateRegionAnswerChanged: onStateRegionAnswerChanged ?? this.onStateRegionAnswerChanged,
      onZipAnswerChanged: onZipAnswerChanged ?? this.onZipAnswerChanged,
      onCountryAnswerChanged: onCountryAnswerChanged ?? this.onCountryAnswerChanged,
    );
  }

  factory AnswerQuestionnairePageState.initial() => AnswerQuestionnairePageState(
    questionnaire: null,
    profile: null,
    isNew: false,
    onShortFormAnswerChanged: null,
    onLongFormAnswerChanged: null,
    onFirstNameAnswerChanged: null,
    onLastNameAnswerChanged: null,
    onPhoneNumberAnswerChanged: null,
    onEmailAnswerChanged: null,
    onInstagramNameAnswerChanged: null,
    onNumberAnswerChanged: null,
    onYesNoAnswerChanged: null,
    onCheckboxItemSelected: null,
    onRatingSelected: null,
    onDateChanged: null,
    onAddressAnswerChanged: null,
    onAddressLine2AnswerChanged: null,
    onCityTownAnswerChanged: null,
    onStateRegionAnswerChanged: null,
    onZipAnswerChanged: null,
    onCountryAnswerChanged: null,
  );

  factory AnswerQuestionnairePageState.fromStore(Store<AppState> store) {
    return AnswerQuestionnairePageState(
      questionnaire: store.state.answerQuestionnairePageState!.questionnaire,
      profile: store.state.answerQuestionnairePageState!.profile,
      isNew: store.state.answerQuestionnairePageState!.isNew,
      onShortFormAnswerChanged: (answer, question) => store.dispatch(SaveShortFormAnswerAction(store.state.answerQuestionnairePageState!, answer, question)),
      onLongFormAnswerChanged: (answer, question) => store.dispatch(SaveLongFormAnswerAction(store.state.answerQuestionnairePageState!, answer, question)),
      onFirstNameAnswerChanged: (answer, question) => store.dispatch(SaveFirstNameAnswerAction(store.state.answerQuestionnairePageState!, answer, question)),
      onLastNameAnswerChanged: (answer, question) => store.dispatch(SaveLastNameAnswerAction(store.state.answerQuestionnairePageState!, answer, question)),
      onPhoneNumberAnswerChanged: (answer, question) => store.dispatch(SavePhoneNumberAnswerAction(store.state.answerQuestionnairePageState!, answer, question)),
      onEmailAnswerChanged: (answer, question) => store.dispatch(SaveEmailAnswerAction(store.state.answerQuestionnairePageState!, answer, question)),
      onInstagramNameAnswerChanged: (answer, question) => store.dispatch(SaveInstagramNameAnswerAction(store.state.answerQuestionnairePageState!, answer, question)),
      onNumberAnswerChanged: (answer, question) => store.dispatch(SaveNumberAnswerAction(store.state.answerQuestionnairePageState!, answer, question)),
      onYesNoAnswerChanged: (answer, question) => store.dispatch(SaveYesNoAnswerAction(store.state.answerQuestionnairePageState!, answer, question)),
      onCheckboxItemSelected: (selectedIndex, answer, question) => store.dispatch(SaveCheckBoxSelectionAction(store.state.answerQuestionnairePageState!, selectedIndex, answer, question)),
      onRatingSelected: (selectedRating, question) => store.dispatch(SaveRatingSelectionAction(store.state.answerQuestionnairePageState!, selectedRating, question)),
      onDateChanged: (date, question) => store.dispatch(SaveDateSelectionAction(store.state.answerQuestionnairePageState!, date, question)),
      onAddressAnswerChanged: (answer, question) => store.dispatch(SaveAddressAnswerAction(store.state.answerQuestionnairePageState!, answer, question)),
      onAddressLine2AnswerChanged: (answer, question) => store.dispatch(SaveAddressLine2AnswerAction(store.state.answerQuestionnairePageState!, answer, question)),
      onCityTownAnswerChanged: (answer, question) => store.dispatch(SaveCityTownAnswerAction(store.state.answerQuestionnairePageState!, answer, question)),
      onStateRegionAnswerChanged: (answer, question) => store.dispatch(SaveStateRegionAnswerAction(store.state.answerQuestionnairePageState!, answer, question)),
      onZipAnswerChanged: (answer, question) => store.dispatch(SaveZipAnswerAction(store.state.answerQuestionnairePageState!, answer, question)),
      onCountryAnswerChanged: (answer, question) => store.dispatch(SaveCountryAnswerAction(store.state.answerQuestionnairePageState!, answer, question)),
    );
  }

  @override
  int get hashCode =>
      questionnaire.hashCode ^
      profile.hashCode^
      isNew.hashCode ^
      onLongFormAnswerChanged.hashCode ^
      onFirstNameAnswerChanged.hashCode ^
      onLastNameAnswerChanged.hashCode ^
      onPhoneNumberAnswerChanged.hashCode ^
      onEmailAnswerChanged.hashCode ^
      onInstagramNameAnswerChanged.hashCode ^
      onNumberAnswerChanged.hashCode ^
      onYesNoAnswerChanged.hashCode ^
      onCheckboxItemSelected.hashCode ^
      onRatingSelected.hashCode ^
      onDateChanged.hashCode ^
      onAddressAnswerChanged.hashCode ^
      onAddressLine2AnswerChanged.hashCode ^
      onCityTownAnswerChanged.hashCode ^
      onStateRegionAnswerChanged.hashCode ^
      onZipAnswerChanged.hashCode ^
      onCountryAnswerChanged.hashCode ^
      onShortFormAnswerChanged.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AnswerQuestionnairePageState &&
              questionnaire == other.questionnaire &&
              profile == other.profile &&
              isNew == other.isNew &&
              onLongFormAnswerChanged == other.onLongFormAnswerChanged &&
              onFirstNameAnswerChanged == other.onFirstNameAnswerChanged &&
              onLastNameAnswerChanged == other.onLastNameAnswerChanged &&
              onPhoneNumberAnswerChanged == other.onPhoneNumberAnswerChanged &&
              onEmailAnswerChanged == other.onEmailAnswerChanged &&
              onInstagramNameAnswerChanged == other.onInstagramNameAnswerChanged &&
              onNumberAnswerChanged == other.onNumberAnswerChanged &&
              onYesNoAnswerChanged == other.onYesNoAnswerChanged &&
              onCheckboxItemSelected == other.onCheckboxItemSelected &&
              onRatingSelected == other.onRatingSelected &&
              onDateChanged == other.onDateChanged &&
              onAddressAnswerChanged == other.onAddressAnswerChanged &&
              onAddressLine2AnswerChanged == other.onAddressLine2AnswerChanged &&
              onCityTownAnswerChanged == other.onCityTownAnswerChanged &&
              onStateRegionAnswerChanged == other.onCityTownAnswerChanged &&
              onZipAnswerChanged == other.onZipAnswerChanged &&
              onCountryAnswerChanged == other.onCountryAnswerChanged &&
              onShortFormAnswerChanged == other.onShortFormAnswerChanged;
}