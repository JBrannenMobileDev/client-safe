import 'dart:ui';

import 'package:dandylight/models/FontTheme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';

import '../../models/Profile.dart';
import '../../utils/ColorConstants.dart';
import 'EditBrandingPageActions.dart';
import 'EditBrandingPageState.dart';

final editBrandingReducer = combineReducers<EditBrandingPageState>([
  TypedReducer<EditBrandingPageState, SetResizedLogoImageAction>(_setResizedLogoImage),
  TypedReducer<EditBrandingPageState, SetResizedBannerImageAction>(_setResizedBannerImage),
  TypedReducer<EditBrandingPageState, SetResizedBannerWebImageAction>(_setResizedBannerWebImage),
  TypedReducer<EditBrandingPageState, SetResizedBannerMobileImageAction>(_setResizedBannerMobileImage),
  TypedReducer<EditBrandingPageState, SetLogoSelectionAction>(_setLogoSelection),
  TypedReducer<EditBrandingPageState, SetBannerSelectionAction>(_setBannerSelection),
  TypedReducer<EditBrandingPageState, SaveColorAction>(_setColor),
  TypedReducer<EditBrandingPageState, ClearBrandingStateAction>(_clearBranding),
  TypedReducer<EditBrandingPageState, SetSelectedFontAction>(_SetSelectedFont),
  TypedReducer<EditBrandingPageState, SetLogoLetterAction>(_setLogoLetter),
  TypedReducer<EditBrandingPageState, SetImageUploadProgressStateAction>(_setUploadProgress),
  TypedReducer<EditBrandingPageState, InitializeBranding>(_initialize),
]);

EditBrandingPageState _initialize(EditBrandingPageState previousState, InitializeBranding action){
  EditBrandingPageState localState = EditBrandingPageState.initial();
  return localState.copyWith(
    profile: action.profile,
    currentIconColor: action.profile.selectedColorTheme != null ? ColorConstants.hexToColor(action.profile.selectedColorTheme.iconColor) : Color(ColorConstants.getPeachDark()),
    currentIconTextColor: action.profile.selectedColorTheme != null ? ColorConstants.hexToColor(action.profile.selectedColorTheme.iconTextColor) : Color(ColorConstants.getPrimaryWhite()),
    currentButtonColor: action.profile.selectedColorTheme != null ? ColorConstants.hexToColor(action.profile.selectedColorTheme.buttonColor) : Color(ColorConstants.getPeachDark()),
    currentButtonTextColor: action.profile.selectedColorTheme != null ? ColorConstants.hexToColor(action.profile.selectedColorTheme.buttonTextColor) : Color(ColorConstants.getPrimaryWhite()),
    currentBannerColor: action.profile.selectedColorTheme != null ? ColorConstants.hexToColor(action.profile.selectedColorTheme.bannerColor) : Color(ColorConstants.getBlueDark()),
    logoImageSelected: action.profile.logoSelected,
    bannerImageSelected: action.profile.bannerImageSelected,
    bannerImage: null,
    resizedLogoImage: null,
    bannerMobileImage: null,
    bannerWebImage: null,
    showPublishButton: false,
    currentIconFont: action.profile.selectedFontTheme != null ? action.profile.selectedFontTheme.iconFont : FontTheme.SIGNATURE2,
    currentFont: action.profile.selectedFontTheme != null ? action.profile.selectedFontTheme.mainFont : FontTheme.OPEN_SANS,
    logoCharacter: action.profile.logoCharacter,
  );
}

EditBrandingPageState _setUploadProgress(EditBrandingPageState previousState, SetImageUploadProgressStateAction action){
  return previousState.copyWith(
    uploadProgress: action.progress,
    uploadInProgress: action.inProgress,
  );
}

EditBrandingPageState _setLogoLetter(EditBrandingPageState previousState, SetLogoLetterAction action){
  bool showPublishButton = showPublishChangesButton(
    action.pageState.currentIconColor,
    action.pageState.currentIconTextColor,
    action.pageState.currentButtonColor,
    action.pageState.currentButtonTextColor,
    action.pageState.currentBannerColor,
    action.pageState.currentIconFont,
    action.pageState.currentFont,
    action.pageState.profile,
    action.pageState.profile.logoSelected, action.pageState.logoImageSelected,
    action.pageState.profile.bannerImageSelected, action.pageState.bannerImageSelected,
    action.pageState.profile.logoCharacter ?? 'M', action.logoLetter,
    action.pageState.resizedLogoImage, action.pageState.resizedLogoImage,
    action.pageState.bannerImage, action.pageState.bannerImage,
  );
  return previousState.copyWith(
    logoCharacter: action.logoLetter,
    showPublishButton: showPublishButton,
  );
}

EditBrandingPageState _SetSelectedFont(EditBrandingPageState previousState, SetSelectedFontAction action){
  String iconFont = action.pageState.currentIconFont;
  String mainFont = action.pageState.currentFont;

  switch(action.id) {
    case FontTheme.MAIN_FONT_ID:
      mainFont = action.fontFamily;
      break;
    case FontTheme.ICON_FONT_ID:
      iconFont = action.fontFamily;
      break;
  }

  bool showPublishButton = showPublishChangesButton(
    action.pageState.currentIconColor,
    action.pageState.currentIconTextColor,
    action.pageState.currentButtonColor,
    action.pageState.currentButtonTextColor,
    action.pageState.currentBannerColor,
    iconFont,
    mainFont,
    action.pageState.profile,
    action.pageState.profile.logoSelected, action.pageState.logoImageSelected,
    action.pageState.profile.bannerImageSelected, action.pageState.bannerImageSelected,
    action.pageState.profile.logoCharacter ?? 'M', action.pageState.logoCharacter,
    action.pageState.resizedLogoImage, action.pageState.resizedLogoImage,
    action.pageState.bannerImage, action.pageState.bannerImage,
  );

  return previousState.copyWith(
    currentIconFont: iconFont,
    currentFont: mainFont,
    showPublishButton: showPublishButton
  );
}

EditBrandingPageState _clearBranding(EditBrandingPageState previousState, ClearBrandingStateAction action){
  return previousState.copyWith(
    profile: action.profile,
    currentIconColor: action.profile.selectedColorTheme != null ? ColorConstants.hexToColor(action.profile.selectedColorTheme.iconColor) : Color(ColorConstants.getPeachDark()),
    currentIconTextColor: action.profile.selectedColorTheme != null ? ColorConstants.hexToColor(action.profile.selectedColorTheme.iconTextColor) : Color(ColorConstants.getPrimaryWhite()),
    currentButtonColor: action.profile.selectedColorTheme != null ? ColorConstants.hexToColor(action.profile.selectedColorTheme.buttonColor) : Color(ColorConstants.getPeachDark()),
    currentButtonTextColor: action.profile.selectedColorTheme != null ? ColorConstants.hexToColor(action.profile.selectedColorTheme.buttonTextColor) : Color(ColorConstants.getPrimaryWhite()),
    currentBannerColor: action.profile.selectedColorTheme != null ? ColorConstants.hexToColor(action.profile.selectedColorTheme.bannerColor) : Color(ColorConstants.getBlueDark()),
    logoImageSelected: action.profile.logoSelected,
    bannerImageSelected: action.profile.bannerImageSelected,
    bannerImage: null,
    resizedLogoImage: null,
    bannerMobileImage: null,
    bannerWebImage: null,
    showPublishButton: false,
    currentIconFont: action.profile.selectedFontTheme != null ? action.profile.selectedFontTheme.iconFont : FontTheme.SIGNATURE2,
    currentFont: action.profile.selectedFontTheme != null ? action.profile.selectedFontTheme.mainFont : FontTheme.OPEN_SANS,
    logoCharacter: action.profile.logoCharacter,
  );
}

EditBrandingPageState _setColor(EditBrandingPageState previousState, SaveColorAction action){
  Color bannerColorToSave = action.pageState.currentBannerColor;
  Color buttonColorToSave = action.pageState.currentButtonColor;
  Color buttonTextColorToSave = action.pageState.currentButtonTextColor;
  Color iconColorToSave = action.pageState.currentIconColor;
  Color iconTextColorToSave = action.pageState.currentIconTextColor;

  switch(action.id) {
    case ColorConstants.banner:
      bannerColorToSave = action.color;
      break;
    case ColorConstants.button:
      buttonColorToSave = action.color;
      break;
    case ColorConstants.buttonText:
      buttonTextColorToSave = action.color;
      break;
    case ColorConstants.icon:
      iconColorToSave = action.color;
      break;
    case ColorConstants.iconText:
      iconTextColorToSave = action.color;
      break;
  }

  bool showPublishButton = showPublishChangesButton(
    iconColorToSave,
    iconTextColorToSave,
    buttonColorToSave,
    buttonTextColorToSave,
    bannerColorToSave,
    action.pageState.currentIconFont,
    action.pageState.currentFont,
    action.pageState.profile,
    action.pageState.profile.logoSelected, action.pageState.logoImageSelected,
    action.pageState.profile.bannerImageSelected, action.pageState.bannerImageSelected,
    action.pageState.profile.logoCharacter ?? 'M', action.pageState.logoCharacter,
    action.pageState.resizedLogoImage, action.pageState.resizedLogoImage,
    action.pageState.bannerImage, action.pageState.bannerImage,
  );

  return previousState.copyWith(
    currentIconColor: iconColorToSave,
    currentIconTextColor: iconTextColorToSave,
    currentButtonColor: buttonColorToSave,
    currentButtonTextColor: buttonTextColorToSave,
    currentBannerColor: bannerColorToSave,
    showPublishButton: showPublishButton,
  );
}

EditBrandingPageState _setLogoSelection(EditBrandingPageState previousState, SetLogoSelectionAction action){
  bool showPublishButton = showPublishChangesButton(
    action.pageState.currentIconColor,
    action.pageState.currentIconTextColor,
    action.pageState.currentButtonColor,
    action.pageState.currentButtonTextColor,
    action.pageState.currentBannerColor,
    action.pageState.currentIconFont,
    action.pageState.currentFont,
    action.pageState.profile,
    action.pageState.profile.logoSelected, action.isLogoSelected,
    action.pageState.profile.bannerImageSelected, action.pageState.bannerImageSelected,
    action.pageState.profile.logoCharacter ?? 'M', action.pageState.logoCharacter,
    action.pageState.resizedLogoImage, action.pageState.resizedLogoImage,
    action.pageState.bannerImage, action.pageState.bannerImage,
  );
  return previousState.copyWith(
    logoImageSelected: action.isLogoSelected,
    showPublishButton: showPublishButton,
  );
}

EditBrandingPageState _setBannerSelection(EditBrandingPageState previousState, SetBannerSelectionAction action){
  bool showPublishButton = showPublishChangesButton(
    action.pageState.currentIconColor,
    action.pageState.currentIconTextColor,
    action.pageState.currentButtonColor,
    action.pageState.currentButtonTextColor,
    action.pageState.currentBannerColor,
    action.pageState.currentIconFont,
    action.pageState.currentFont,
    action.pageState.profile,
    action.pageState.profile.logoSelected, action.pageState.logoImageSelected,
    action.pageState.profile.bannerImageSelected, action.isBannerSelected,
    action.pageState.profile.logoCharacter ?? 'M', action.pageState.logoCharacter,
    action.pageState.resizedLogoImage, action.pageState.resizedLogoImage,
    action.pageState.bannerImage, action.pageState.bannerImage,
  );
  return previousState.copyWith(
    bannerImageSelected: action.isBannerSelected,
    showPublishButton: showPublishButton,
  );
}

EditBrandingPageState _setResizedLogoImage(EditBrandingPageState previousState, SetResizedLogoImageAction action){
  return previousState.copyWith(
    resizedLogoImage: action.resizedLogoImage,
    logoImageSelected: true,
    showPublishButton: true,
  );
}

EditBrandingPageState _setResizedBannerImage(EditBrandingPageState previousState, SetResizedBannerImageAction action){
  return previousState.copyWith(
    bannerImage: action.resizedBannerImage,
    showPublishButton: true,
  );
}

EditBrandingPageState _setResizedBannerWebImage(EditBrandingPageState previousState, SetResizedBannerWebImageAction action){
  return previousState.copyWith(
    bannerWebImage: action.resizedImage,
    showPublishButton: true,
  );
}

EditBrandingPageState _setResizedBannerMobileImage(EditBrandingPageState previousState, SetResizedBannerMobileImageAction action){
  return previousState.copyWith(
    bannerMobileImage: action.resizedImage,
    showPublishButton: true,
  );
}

bool showPublishChangesButton(
    Color iconColorToSave,
    Color iconTextColorToSave,
    Color buttonColorToSave,
    Color buttonTextColorToSave,
    Color bannerColorToSave,
    String iconFont,
    String mainFont,
    Profile profile,
    bool logoImageSelected,
    bool newLogoImageSelected,
    bool bannerImageSelected,
    bool newBannerImageSelected,
    String currentLogoLetter,
    String newLogoLetter,
    XFile currentLogoImage,
    XFile newLogoImage,
    XFile currentBannerImage,
    XFile newBannerImage,
) {
  bool showPublishButton = false;

  if(profile.selectedFontTheme.iconFont != iconFont) {
    showPublishButton = true;
  }
  if(profile.selectedFontTheme.mainFont != mainFont) {
    showPublishButton = true;
  }
  if(profile.selectedColorTheme.bannerColor != ColorConstants.getHex(bannerColorToSave)) {
    showPublishButton = true;
  }
  if(profile.selectedColorTheme.buttonColor != ColorConstants.getHex(buttonColorToSave)) {
    showPublishButton = true;
  }
  if(profile.selectedColorTheme.buttonTextColor != ColorConstants.getHex(buttonTextColorToSave)) {
    showPublishButton = true;
  }
  if(profile.selectedColorTheme.iconColor != ColorConstants.getHex(iconColorToSave)) {
    showPublishButton = true;
  }
  if(profile.selectedColorTheme.iconTextColor != ColorConstants.getHex(iconTextColorToSave)) {
    showPublishButton = true;
  }

  if(logoImageSelected != newLogoImageSelected) showPublishButton = true;
  if(bannerImageSelected != newBannerImageSelected) showPublishButton = true;
  if(currentLogoLetter != newLogoLetter) showPublishButton = true;
  if(currentLogoImage != null && currentLogoImage.path != newLogoImage.path) showPublishButton = true;
  if(currentBannerImage != null && currentBannerImage.path != newBannerImage.path) showPublishButton = true;

  return showPublishButton;
}
