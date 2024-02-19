import 'package:image_picker/image_picker.dart';

import '../../models/Question.dart';
import 'NewQuestionPageState.dart';

class ClearNewQuestionState {
  final NewQuestionPageState pageState;
  ClearNewQuestionState(this.pageState);
}

class SetQuestionAction{
  final NewQuestionPageState pageState;
  final Question question;
  SetQuestionAction(this.pageState, this.question);
}

class ResizeQuestionWebImageAction {
  final NewQuestionPageState pageState;
  final XFile image;
  ResizeQuestionWebImageAction(this.pageState, this.image);
}

class ResizeQuestionMobileImageAction {
  final NewQuestionPageState pageState;
  final XFile image;
  ResizeQuestionMobileImageAction(this.pageState, this.image);
}

class SetResizedQuestionWebImageAction {
  final NewQuestionPageState pageState;
  final XFile resizedImage;
  SetResizedQuestionWebImageAction(this.pageState, this.resizedImage);
}

class SetResizedQuestionMobileImageAction {
  final NewQuestionPageState pageState;
  final XFile resizedImage;
  SetResizedQuestionMobileImageAction(this.pageState, this.resizedImage);
}

class UpdateQuestionAction {
  final NewQuestionPageState pageState;
  final String question;
  UpdateQuestionAction(this.pageState, this.question);
}

class UpdateRequiredAction {
  final NewQuestionPageState pageState;
  final bool required;
  UpdateRequiredAction(this.pageState, this.required);
}

class AddMultipleChoiceChoicesAction {
  final NewQuestionPageState pageState;
  final String choice;
  AddMultipleChoiceChoicesAction(this.pageState, this.choice);
}

class DeleteMultipleChoiceChoicesAction {
  final NewQuestionPageState pageState;
  final String choice;
  DeleteMultipleChoiceChoicesAction(this.pageState, this.choice);
}

class UpdateIncludeMCAction {
  final NewQuestionPageState pageState;
  final bool include;
  UpdateIncludeMCAction(this.pageState, this.include);
}

class AddCheckboxChoicesAction {
  final NewQuestionPageState pageState;
  final String choice;
  AddCheckboxChoicesAction(this.pageState, this.choice);
}

class DeleteCheckboxChoicesAction {
  final NewQuestionPageState pageState;
  final String choice;
  DeleteCheckboxChoicesAction(this.pageState, this.choice);
}

class UpdateIncludeCBAction {
  final NewQuestionPageState pageState;
  final bool include;
  UpdateIncludeCBAction(this.pageState, this.include);
}

class UpdateIncludeFirstNameAction {
  final NewQuestionPageState pageState;
  final bool include;
  UpdateIncludeFirstNameAction(this.pageState, this.include);
}

class UpdateIncludeLastNameAction {
  final NewQuestionPageState pageState;
  final bool include;
  UpdateIncludeLastNameAction(this.pageState, this.include);
}

class UpdateIncludePhoneAction {
  final NewQuestionPageState pageState;
  final bool include;
  UpdateIncludePhoneAction(this.pageState, this.include);
}

class UpdateIncludeEmailAction {
  final NewQuestionPageState pageState;
  final bool include;
  UpdateIncludeEmailAction(this.pageState, this.include);
}

class UpdateIncludeInstagramNameAction {
  final NewQuestionPageState pageState;
  final bool include;
  UpdateIncludeInstagramNameAction(this.pageState, this.include);
}

class UpdateShortHintAction {
  final NewQuestionPageState pageState;
  final String hintMessage;
  UpdateShortHintAction(this.pageState, this.hintMessage);
}

class UpdateLongHintAction {
  final NewQuestionPageState pageState;
  final String hintMessage;
  UpdateLongHintAction(this.pageState, this.hintMessage);
}

class UpdateNumOfStarsAction {
  final NewQuestionPageState pageState;
  final int numOfStars;
  UpdateNumOfStarsAction(this.pageState, this.numOfStars);
}






