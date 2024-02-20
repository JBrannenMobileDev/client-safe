import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Question.dart';
import 'NewQuestionActions.dart';

class NewQuestionPageState{
  final Question question;
  final XFile webImage;
  final XFile mobileImage;
  final Function(String) onQuestionChanged;
  final Function(bool) isRequiredChanged;
  final Function(String) onMultipleChoiceAdded;
  final Function(String) onMultipleChoiceRemoved;
  final Function(bool) onIncludeOtherMultipleChoiceChanged;
  final Function(String) onCheckBoxChoiceAdded;
  final Function(String) onCheckBoxChoiceRemoved;
  final Function(bool) onIncludeOtherCheckBoxChoiceChanged;
  final Function(bool) onIncludeFirstNameChanged;
  final Function(bool) onIncludeLastNameChanged;
  final Function(bool) onIncludePhoneChanged;
  final Function(bool) onIncludeEmailChanged;
  final Function(bool) onIncludeInstagramNameChanged;
  final Function(String) onShortFormHintChanged;
  final Function(String) onLongFormHintChanged;
  final Function(int) onNumberOfStarsChanged;
  final Function(XFile) onWebImageUploaded;
  final Function(XFile) onMobileImageUploaded;
  final Function(String) onTypeChanged;
  final Function(bool) onShowImageChanged;

  NewQuestionPageState({
    @required this.question,
    @required this.onQuestionChanged,
    @required this.isRequiredChanged,
    @required this.onMultipleChoiceAdded,
    @required this.onIncludeOtherMultipleChoiceChanged,
    @required this.onCheckBoxChoiceAdded,
    @required this.onIncludeOtherCheckBoxChoiceChanged,
    @required this.onIncludeFirstNameChanged,
    @required this.onIncludeLastNameChanged,
    @required this.onIncludePhoneChanged,
    @required this.onIncludeEmailChanged,
    @required this.onIncludeInstagramNameChanged,
    @required this.onShortFormHintChanged,
    @required this.onLongFormHintChanged,
    @required this.onNumberOfStarsChanged,
    @required this.onCheckBoxChoiceRemoved,
    @required this.onMultipleChoiceRemoved,
    @required this.webImage,
    @required this.mobileImage,
    @required this.onWebImageUploaded,
    @required this.onMobileImageUploaded,
    @required this.onTypeChanged,
    @required this.onShowImageChanged,
  });

  NewQuestionPageState copyWith({
    Question question,
    XFile webImage,
    XFile mobileImage,
    Function(String) onQuestionChanged,
    Function(bool) isRequiredChanged,
    Function(String) onMultipleChoiceAdded,
    Function(String) onMultipleChoiceRemoved,
    Function(bool) onIncludeOtherMultipleChoiceChanged,
    Function(String) onCheckBoxChoiceAdded,
    Function(String) onCheckBoxChoiceRemoved,
    Function(bool) onIncludeOtherCheckBoxChoiceChanged,
    Function(bool) onIncludeFirstNameChanged,
    Function(bool) onIncludeLastNameChanged,
    Function(bool) onIncludePhoneChanged,
    Function(bool) onIncludeEmailChanged,
    Function(bool) onIncludeInstagramNameChanged,
    Function(String) onShortFormHintChanged,
    Function(String) onLongFormHintChanged,
    Function(int) onNumberOfStarsChanged,
    Function(XFile) onWebImageUploaded,
    Function(XFile) onMobileImageUploaded,
    Function(String) onTypeChanged,
    Function(bool) onShowImageChanged,
  }){
    return NewQuestionPageState(
      question: question ?? this.question,
      onQuestionChanged: onQuestionChanged ?? this.onQuestionChanged,
      isRequiredChanged: isRequiredChanged ?? this.isRequiredChanged,
      onMultipleChoiceAdded: onMultipleChoiceAdded ?? this.onMultipleChoiceAdded,
      onIncludeOtherMultipleChoiceChanged: onIncludeOtherMultipleChoiceChanged ?? this.onIncludeOtherMultipleChoiceChanged,
      onCheckBoxChoiceAdded: onCheckBoxChoiceAdded ?? this.onCheckBoxChoiceAdded,
      onIncludeOtherCheckBoxChoiceChanged: onIncludeOtherCheckBoxChoiceChanged ?? this.onIncludeOtherCheckBoxChoiceChanged,
      onIncludeFirstNameChanged: onIncludeFirstNameChanged ?? this.onIncludeFirstNameChanged,
      onIncludeLastNameChanged: onIncludeLastNameChanged ?? this.onIncludeLastNameChanged,
      onIncludePhoneChanged: onIncludePhoneChanged ?? this.onIncludePhoneChanged,
      onIncludeEmailChanged: onIncludeEmailChanged ?? this.onIncludeEmailChanged,
      onIncludeInstagramNameChanged: onIncludeInstagramNameChanged ?? this.onIncludeInstagramNameChanged,
      onShortFormHintChanged: onShortFormHintChanged ?? this.onShortFormHintChanged,
      onLongFormHintChanged: onLongFormHintChanged ?? this.onLongFormHintChanged,
      onNumberOfStarsChanged: onNumberOfStarsChanged ?? this.onNumberOfStarsChanged,
      onCheckBoxChoiceRemoved: onCheckBoxChoiceRemoved ?? this.onCheckBoxChoiceRemoved,
      onMultipleChoiceRemoved: onMultipleChoiceRemoved ?? this.onMultipleChoiceRemoved,
      webImage: webImage ?? this.webImage,
      mobileImage: mobileImage ?? this.mobileImage,
      onWebImageUploaded: onWebImageUploaded ?? this.onWebImageUploaded,
      onMobileImageUploaded: onMobileImageUploaded ?? this.onMobileImageUploaded,
      onTypeChanged: onTypeChanged ?? this.onTypeChanged,
      onShowImageChanged: onShowImageChanged ?? this.onShowImageChanged,
    );
  }

  factory NewQuestionPageState.initial() => NewQuestionPageState(
    question: Question(),
    onQuestionChanged: null,
    isRequiredChanged: null,
    onMultipleChoiceAdded: null,
    onIncludeOtherMultipleChoiceChanged: null,
    onCheckBoxChoiceAdded: null,
    onIncludeOtherCheckBoxChoiceChanged: null,
    onIncludeFirstNameChanged: null,
    onIncludeLastNameChanged: null,
    onIncludePhoneChanged: null,
    onIncludeEmailChanged: null,
    onIncludeInstagramNameChanged: null,
    onShortFormHintChanged: null,
    onLongFormHintChanged: null,
    onNumberOfStarsChanged: null,
    onCheckBoxChoiceRemoved: null,
    onMultipleChoiceRemoved: null,
    webImage: null,
    mobileImage: null,
    onWebImageUploaded: null,
    onMobileImageUploaded: null,
    onTypeChanged: null,
    onShowImageChanged: null,
  );

  factory NewQuestionPageState.fromStore(Store<AppState> store) {
    return NewQuestionPageState(
      question: store.state.newQuestionPageState.question,
      webImage: store.state.newQuestionPageState.webImage,
      mobileImage: store.state.newQuestionPageState.mobileImage,
      onQuestionChanged: (question) => store.dispatch(UpdateQuestionAction(store.state.newQuestionPageState, question)),
      isRequiredChanged: (required) => store.dispatch(UpdateRequiredAction(store.state.newQuestionPageState, required)),
      onMultipleChoiceAdded: (choice) => store.dispatch(AddMultipleChoiceChoicesAction(store.state.newQuestionPageState, choice)),
      onMultipleChoiceRemoved: (choice) => store.dispatch(DeleteMultipleChoiceChoicesAction(store.state.newQuestionPageState, choice)),
      onIncludeOtherMultipleChoiceChanged: (include) => store.dispatch(UpdateIncludeMCAction(store.state.newQuestionPageState, include)),
      onCheckBoxChoiceAdded: (choice) => store.dispatch(AddCheckboxChoicesAction(store.state.newQuestionPageState, choice)),
      onCheckBoxChoiceRemoved: (choice) => store.dispatch(DeleteCheckboxChoicesAction(store.state.newQuestionPageState, choice)),
      onIncludeOtherCheckBoxChoiceChanged: (include) => store.dispatch(UpdateIncludeCBAction(store.state.newQuestionPageState, include)),
      onIncludeFirstNameChanged: (include) => store.dispatch(UpdateIncludeFirstNameAction(store.state.newQuestionPageState, include)),
      onIncludeLastNameChanged: (include) => store.dispatch(UpdateIncludeLastNameAction(store.state.newQuestionPageState, include)),
      onIncludePhoneChanged: (include) => store.dispatch(UpdateIncludePhoneAction(store.state.newQuestionPageState, include)),
      onIncludeEmailChanged: (include) => store.dispatch(UpdateIncludeEmailAction(store.state.newQuestionPageState, include)),
      onIncludeInstagramNameChanged: (include) => store.dispatch(UpdateIncludeInstagramNameAction(store.state.newQuestionPageState, include)),
      onShortFormHintChanged: (hintMessage) => store.dispatch(UpdateShortHintAction(store.state.newQuestionPageState, hintMessage)),
      onLongFormHintChanged: (hintMessage) => store.dispatch(UpdateLongHintAction(store.state.newQuestionPageState, hintMessage)),
      onNumberOfStarsChanged: (numOfStars) => store.dispatch(UpdateNumOfStarsAction(store.state.newQuestionPageState, numOfStars)),
      onWebImageUploaded: (xfileImage) => store.dispatch(ResizeQuestionWebImageAction(store.state.newQuestionPageState, xfileImage)),
      onMobileImageUploaded: (xfileImage) => store.dispatch(ResizeQuestionMobileImageAction(store.state.newQuestionPageState, xfileImage)),
      onTypeChanged: (newType) => store.dispatch(SetNewTypeAction(store.state.newQuestionPageState, newType)),
      onShowImageChanged: (showImage) => store.dispatch(SetShowImageAction(store.state.newQuestionPageState, showImage)),
    );
  }

  @override
  int get hashCode =>
      onQuestionChanged.hashCode ^
      isRequiredChanged.hashCode ^
      onMultipleChoiceAdded.hashCode ^
      onIncludeOtherMultipleChoiceChanged.hashCode ^
      onCheckBoxChoiceAdded.hashCode ^
      onIncludeOtherCheckBoxChoiceChanged.hashCode ^
      onIncludeFirstNameChanged.hashCode ^
      onIncludeLastNameChanged.hashCode ^
      onIncludePhoneChanged.hashCode ^
      onIncludeEmailChanged.hashCode ^
      onIncludeInstagramNameChanged.hashCode ^
      onShortFormHintChanged.hashCode ^
      onLongFormHintChanged.hashCode ^
      onNumberOfStarsChanged.hashCode ^
      onCheckBoxChoiceRemoved.hashCode ^
      onMultipleChoiceRemoved.hashCode ^
      webImage.hashCode ^
      mobileImage.hashCode ^
      onWebImageUploaded.hashCode ^
      onMobileImageUploaded.hashCode ^
      onTypeChanged.hashCode ^
      onShowImageChanged.hashCode ^
      question.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is NewQuestionPageState &&
              onQuestionChanged == other.onQuestionChanged &&
              isRequiredChanged == other.isRequiredChanged &&
              onMultipleChoiceAdded == other.onMultipleChoiceAdded &&
              onIncludeOtherMultipleChoiceChanged == other.onIncludeOtherMultipleChoiceChanged &&
              onCheckBoxChoiceAdded == other.onCheckBoxChoiceAdded &&
              onIncludeOtherCheckBoxChoiceChanged == other.onIncludeOtherCheckBoxChoiceChanged &&
              onIncludeFirstNameChanged == other.onIncludeFirstNameChanged &&
              onIncludeLastNameChanged == other.onIncludeLastNameChanged &&
              onIncludePhoneChanged == other.onIncludePhoneChanged &&
              onIncludeEmailChanged == other.onIncludeEmailChanged &&
              onIncludeInstagramNameChanged == other.onIncludeInstagramNameChanged &&
              onShortFormHintChanged == other.onShortFormHintChanged &&
              onLongFormHintChanged == other.onLongFormHintChanged &&
              onNumberOfStarsChanged == other.onNumberOfStarsChanged &&
              onCheckBoxChoiceRemoved == other.onCheckBoxChoiceRemoved &&
              onMultipleChoiceRemoved == other.onMultipleChoiceRemoved &&
              webImage == other.webImage &&
              mobileImage == other.mobileImage &&
              onWebImageUploaded == other.onWebImageUploaded &&
              onMobileImageUploaded == other.onMobileImageUploaded &&
              onTypeChanged == other.onTypeChanged &&
              onShowImageChanged == other.onShowImageChanged &&
              question == other.question;
}