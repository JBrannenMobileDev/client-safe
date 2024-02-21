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

class SetNewTypeAction {
  final NewQuestionPageState pageState;
  final String newType;
  SetNewTypeAction(this.pageState, this.newType);
}

class SetShowImageAction {
  final NewQuestionPageState pageState;
  final bool showImage;
  SetShowImageAction(this.pageState, this.showImage);
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

class AddCheckboxChoicesAction {
  final NewQuestionPageState pageState;
  final String choice;
  AddCheckboxChoicesAction(this.pageState, this.choice);
}

class SetMultipleSelectionAction {
  final NewQuestionPageState pageState;
  final bool selected;
  SetMultipleSelectionAction(this.pageState, this.selected);
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

class SetAddressRequiredAction {
  final NewQuestionPageState pageState;
  final bool selected;
  SetAddressRequiredAction(this.pageState, this.selected);
}

class SetCityTownRequiredAction {
  final NewQuestionPageState pageState;
  final bool selected;
  SetCityTownRequiredAction(this.pageState, this.selected);
}

class SetStateRegionProvinceRequiredAction {
  final NewQuestionPageState pageState;
  final bool selected;
  SetStateRegionProvinceRequiredAction(this.pageState, this.selected);
}

class SetZipPostCodeRequiredAction {
  final NewQuestionPageState pageState;
  final bool selected;
  SetZipPostCodeRequiredAction(this.pageState, this.selected);
}

class SetCountryRequiredAction {
  final NewQuestionPageState pageState;
  final bool selected;
  SetCountryRequiredAction(this.pageState, this.selected);
}






