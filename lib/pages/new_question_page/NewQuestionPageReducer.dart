import 'package:redux/redux.dart';
import 'NewQuestionActions.dart';
import 'NewQuestionPageState.dart';

final newQuestionReducer = combineReducers<NewQuestionPageState>([
  TypedReducer<NewQuestionPageState, ClearNewQuestionState>(_clear),
  TypedReducer<NewQuestionPageState, SetQuestionAction>(_setQuestion),
  TypedReducer<NewQuestionPageState, UpdateQuestionAction>(_setMessage),
  TypedReducer<NewQuestionPageState, UpdateRequiredAction>(_setRequired),
  TypedReducer<NewQuestionPageState, AddMultipleChoiceChoicesAction>(_addMCChoice),
  TypedReducer<NewQuestionPageState, AddCheckboxChoicesAction>(_addCBChoice),
  TypedReducer<NewQuestionPageState, DeleteMultipleChoiceChoicesAction>(_deleteMCChoice),
  TypedReducer<NewQuestionPageState, DeleteCheckboxChoicesAction>(_deleteCBChoice),
  TypedReducer<NewQuestionPageState, UpdateIncludeMCAction>(_setIncludeOtherMC),
  TypedReducer<NewQuestionPageState, UpdateIncludeCBAction>(_setIncludeOtherCB),
  TypedReducer<NewQuestionPageState, UpdateIncludeFirstNameAction>(_setIncludeFirstName),
  TypedReducer<NewQuestionPageState, UpdateIncludeLastNameAction>(_setIncludeLastName),
  TypedReducer<NewQuestionPageState, UpdateIncludePhoneAction>(_setIncludePhone),
  TypedReducer<NewQuestionPageState, UpdateIncludeEmailAction>(_setIncludeEmail),
  TypedReducer<NewQuestionPageState, UpdateIncludeInstagramNameAction>(_setIncludeInstagramName),
  TypedReducer<NewQuestionPageState, UpdateShortHintAction>(_setShortHint),
  TypedReducer<NewQuestionPageState, UpdateLongHintAction>(_setLongHint),
  TypedReducer<NewQuestionPageState, UpdateNumOfStarsAction>(_setNumOfStars),
  TypedReducer<NewQuestionPageState, SetResizedQuestionWebImageAction>(_setResizedWebImage),
  TypedReducer<NewQuestionPageState, SetResizedQuestionMobileImageAction>(_setResizedMobileImage),
]);

NewQuestionPageState _setResizedWebImage(NewQuestionPageState previousState, SetResizedQuestionWebImageAction action){
  return previousState.copyWith(
    webImage: action.resizedImage,
  );
}

NewQuestionPageState _setResizedMobileImage(NewQuestionPageState previousState, SetResizedQuestionMobileImageAction action){
  return previousState.copyWith(
    mobileImage: action.resizedImage,
  );
}

NewQuestionPageState _clear(NewQuestionPageState previousState, ClearNewQuestionState action){
  return NewQuestionPageState.initial();
}

NewQuestionPageState _setNumOfStars(NewQuestionPageState previousState, UpdateNumOfStarsAction action){
  action.pageState.question.numOfStars = action.numOfStars;
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _setLongHint(NewQuestionPageState previousState, UpdateLongHintAction action){
  action.pageState.question.longHint = action.hintMessage;
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _setShortHint(NewQuestionPageState previousState, UpdateShortHintAction action){
  action.pageState.question.shortHint = action.hintMessage;
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _setIncludeInstagramName(NewQuestionPageState previousState, UpdateIncludeInstagramNameAction action){
  action.pageState.question.includeInstagramName = action.include;
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _setIncludeEmail(NewQuestionPageState previousState, UpdateIncludeEmailAction action){
  action.pageState.question.includeEmail = action.include;
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _setIncludePhone(NewQuestionPageState previousState, UpdateIncludePhoneAction action){
  action.pageState.question.includePhone = action.include;
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _setIncludeLastName(NewQuestionPageState previousState, UpdateIncludeLastNameAction action){
  action.pageState.question.includeLastName = action.include;
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _setIncludeFirstName(NewQuestionPageState previousState, UpdateIncludeFirstNameAction action){
  action.pageState.question.includeFirstName = action.include;
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _setIncludeOtherCB(NewQuestionPageState previousState, UpdateIncludeCBAction action){
  bool includesOther = action.pageState.question.choicesCheckBoxes.contains('Other');
  if(!includesOther) {
    action.pageState.question.choicesCheckBoxes.add('Other');
  }
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _setIncludeOtherMC(NewQuestionPageState previousState, UpdateIncludeMCAction action){
  bool includesOther = action.pageState.question.choicesMultipleChoice.contains('Other');
  if(!includesOther) {
    action.pageState.question.choicesMultipleChoice.add('Other');
  }
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _deleteCBChoice(NewQuestionPageState previousState, DeleteCheckboxChoicesAction action){
  action.pageState.question.choicesCheckBoxes.removeWhere((choice) => choice == action.choice);
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _deleteMCChoice(NewQuestionPageState previousState, DeleteMultipleChoiceChoicesAction action){
  action.pageState.question.choicesMultipleChoice.removeWhere((choice) => choice == action.choice);
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _addCBChoice(NewQuestionPageState previousState, AddCheckboxChoicesAction action){
  action.pageState.question.choicesCheckBoxes.add(action.choice);
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _addMCChoice(NewQuestionPageState previousState, AddMultipleChoiceChoicesAction action){
  action.pageState.question.choicesMultipleChoice.add(action.choice);
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _setRequired(NewQuestionPageState previousState, UpdateRequiredAction action){
  action.pageState.question.isRequired = action.required;
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _setQuestion(NewQuestionPageState previousState, SetQuestionAction action){
  return previousState.copyWith(
    question: action.question,
  );
}

NewQuestionPageState _setMessage(NewQuestionPageState previousState, UpdateQuestionAction action){
  action.pageState.question.question = action.question;
  return previousState.copyWith(
    question: action.pageState.question,
  );
}