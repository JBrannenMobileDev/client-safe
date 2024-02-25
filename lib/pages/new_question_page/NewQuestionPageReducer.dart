import 'package:redux/redux.dart';
import '../../utils/UUID.dart';
import 'NewQuestionActions.dart';
import 'NewQuestionPageState.dart';

final newQuestionReducer = combineReducers<NewQuestionPageState>([
  TypedReducer<NewQuestionPageState, ClearNewQuestionState>(_clear),
  TypedReducer<NewQuestionPageState, SetQuestionAction>(_setQuestion),
  TypedReducer<NewQuestionPageState, UpdateQuestionAction>(_setMessage),
  TypedReducer<NewQuestionPageState, UpdateRequiredAction>(_setRequired),
  TypedReducer<NewQuestionPageState, AddCheckboxChoicesAction>(_addCBChoice),
  TypedReducer<NewQuestionPageState, DeleteCheckboxChoicesAction>(_deleteCBChoice),
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
  TypedReducer<NewQuestionPageState, SetNewTypeAction>(_setNewType),
  TypedReducer<NewQuestionPageState, SetShowImageAction>(_setShowImage),
  TypedReducer<NewQuestionPageState, SetMultipleSelectionAction>(_setMultipleSelected),
  TypedReducer<NewQuestionPageState, SetAddressRequiredAction>(_setAddressRequired),
  TypedReducer<NewQuestionPageState, SetCityTownRequiredAction>(_setCityTownRequired),
  TypedReducer<NewQuestionPageState, SetStateRegionProvinceRequiredAction>(_setStateRegionProvinceRequired),
  TypedReducer<NewQuestionPageState, SetZipPostCodeRequiredAction>(_setZipPostCodeRequired),
  TypedReducer<NewQuestionPageState, SetCountryRequiredAction>(_setCountryRequired),
]);

NewQuestionPageState _setAddressRequired(NewQuestionPageState previousState, SetAddressRequiredAction action){
  action.pageState.question.addressRequired = action.selected;
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _setCityTownRequired(NewQuestionPageState previousState, SetCityTownRequiredAction action){
  action.pageState.question.cityTownRequired = action.selected;
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _setStateRegionProvinceRequired(NewQuestionPageState previousState, SetStateRegionProvinceRequiredAction action){
  action.pageState.question.stateRegionProvinceRequired = action.selected;
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _setZipPostCodeRequired(NewQuestionPageState previousState, SetZipPostCodeRequiredAction action){
  action.pageState.question.zipPostCodeRequired = action.selected;
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _setCountryRequired(NewQuestionPageState previousState, SetCountryRequiredAction action){
  action.pageState.question.countryRequired = action.selected;
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _setMultipleSelected(NewQuestionPageState previousState, SetMultipleSelectionAction action){
  action.pageState.question.multipleSelection = action.selected;
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _setShowImage(NewQuestionPageState previousState, SetShowImageAction action){
  action.pageState.question.showImage = action.showImage;
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _setNewType(NewQuestionPageState previousState, SetNewTypeAction action){
  action.pageState.question.type = action.newType;
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _setResizedWebImage(NewQuestionPageState previousState, SetResizedQuestionWebImageAction action){
  action.pageState.question.webImage = action.resizedImage;
  return previousState.copyWith(
    webImage: action.resizedImage,
    question: action.pageState.question,
  );
}

NewQuestionPageState _setResizedMobileImage(NewQuestionPageState previousState, SetResizedQuestionMobileImageAction action){
  action.pageState.question.mobileImage = action.resizedImage;
  return previousState.copyWith(
    mobileImage: action.resizedImage,
    question: action.pageState.question,
  );
}

NewQuestionPageState _clear(NewQuestionPageState previousState, ClearNewQuestionState action){
  NewQuestionPageState initialState = NewQuestionPageState.initial();
  initialState.question.id = Uuid().generateV4();
  return initialState;
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

NewQuestionPageState _deleteCBChoice(NewQuestionPageState previousState, DeleteCheckboxChoicesAction action){
  List<dynamic> options = action.pageState.question.choicesCheckBoxes.toList();
  options.removeWhere((choice) => choice == action.choice);
  action.pageState.question.choicesCheckBoxes = options;
  return previousState.copyWith(
    question: action.pageState.question,
  );
}

NewQuestionPageState _addCBChoice(NewQuestionPageState previousState, AddCheckboxChoicesAction action){
  List<dynamic> options = action.pageState.question.choicesCheckBoxes?.toList() ?? [];
  options.add(action.choice);
  action.pageState.question.choicesCheckBoxes = options;
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