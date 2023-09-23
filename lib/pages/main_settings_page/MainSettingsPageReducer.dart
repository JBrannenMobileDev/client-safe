import 'dart:ui';

import 'package:dandylight/models/ColorTheme.dart';
import 'package:dandylight/models/FontTheme.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageActions.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';

import '../../models/Profile.dart';
import '../../utils/ColorConstants.dart';

final mainSettingsPageReducer = combineReducers<MainSettingsPageState>([
  TypedReducer<MainSettingsPageState, UpdatePushNotificationEnabled>(_setPushNotificationsState),
  TypedReducer<MainSettingsPageState, UpdateCalendarEnabled>(_setCalendarState),
  TypedReducer<MainSettingsPageState, LoadUserProfileDataAction>(_setUserProfileInfo),
  TypedReducer<MainSettingsPageState, SetFirstNameAction>(_updateFirstName),
  TypedReducer<MainSettingsPageState, SetLastNameAction>(_updateLastName),
  TypedReducer<MainSettingsPageState, SetBusinessNameAction>(_updateBusinessName),
  TypedReducer<MainSettingsPageState, SetBusinessEmailAction>(_updateBusinessEmail),
  TypedReducer<MainSettingsPageState, SetBusinessPhoneAction>(_updateBusinessPhone),
  TypedReducer<MainSettingsPageState, SetDeleteProgressAction>(_updateDeleteProgress),
  TypedReducer<MainSettingsPageState, SavePasswordAction>(_updatePassword),
  TypedReducer<MainSettingsPageState, SetPasswordErrorAction>(_passwordError),
  TypedReducer<MainSettingsPageState, SetDiscountCodeAction>(_setDiscountCode),
  TypedReducer<MainSettingsPageState, SetIsAdminAction>(_setIsAdmin),
  TypedReducer<MainSettingsPageState, SetUrlToStateAction>(_setInstaUrl),
  TypedReducer<MainSettingsPageState, SetResizedLogoImageAction>(_setResizedLogoImage),
  TypedReducer<MainSettingsPageState, SetResizedBannerImageAction>(_setResizedBannerImage),
  TypedReducer<MainSettingsPageState, SetResizedBannerWebImageAction>(_setResizedBannerWebImage),
  TypedReducer<MainSettingsPageState, SetResizedBannerMobileImageAction>(_setResizedBannerMobileImage),
  TypedReducer<MainSettingsPageState, SetLogoSelectionAction>(_setLogoSelection),
  TypedReducer<MainSettingsPageState, SetBannerSelectionAction>(_setBannerSelection),
  TypedReducer<MainSettingsPageState, SaveColorAction>(_setColor),
  TypedReducer<MainSettingsPageState, ClearBrandingStateAction>(_clearBranding),
  TypedReducer<MainSettingsPageState, SetSelectedFontAction>(_SetSelectedFont),
  TypedReducer<MainSettingsPageState, SetLogoLetterAction>(_setLogoLetter),

]);

MainSettingsPageState _setLogoLetter(MainSettingsPageState previousState, SetLogoLetterAction action){
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

MainSettingsPageState _SetSelectedFont(MainSettingsPageState previousState, SetSelectedFontAction action){
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

MainSettingsPageState _clearBranding(MainSettingsPageState previousState, ClearBrandingStateAction action){
  return previousState.copyWith(
    currentIconColor: ColorConstants.hexToColor(action.profile.selectedColorTheme.iconColor ?? ColorConstants.getPeachDark()),
    currentIconTextColor: ColorConstants.hexToColor(action.profile.selectedColorTheme.iconTextColor ?? ColorConstants.getPrimaryWhite()),
    currentButtonColor: ColorConstants.hexToColor(action.profile.selectedColorTheme.buttonColor ?? ColorConstants.getPeachDark()),
    currentButtonTextColor: ColorConstants.hexToColor(action.profile.selectedColorTheme.buttonTextColor ?? ColorConstants.getPrimaryWhite()),
    currentBannerColor: ColorConstants.hexToColor(action.profile.selectedColorTheme.bannerColor ?? ColorConstants.getBlueDark()),
    logoImageSelected: action.profile.logoSelected,
    bannerImageSelected: action.profile.bannerImageSelected,
    bannerImage: null,
    resizedLogoImage: null,
    showPublishButton: false,
    currentIconFont: action.profile.selectedFontTheme.iconFont ?? FontTheme.SIGNATURE2,
    currentFont: action.profile.selectedFontTheme.mainFont ?? FontTheme.OPEN_SANS,
    logoCharacter: action.profile.logoCharacter != null
        ? action.profile.logoCharacter : action.profile.businessName != null && action.profile.businessName.length > 0
        ? action.profile.businessName.substring(0, 1) : 'D',
  );
}

MainSettingsPageState _setColor(MainSettingsPageState previousState, SaveColorAction action){
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

MainSettingsPageState _setLogoSelection(MainSettingsPageState previousState, SetLogoSelectionAction action){
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

MainSettingsPageState _setBannerSelection(MainSettingsPageState previousState, SetBannerSelectionAction action){
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

MainSettingsPageState _setResizedLogoImage(MainSettingsPageState previousState, SetResizedLogoImageAction action){
  return previousState.copyWith(
    resizedLogoImage: action.resizedLogoImage,
    logoImageSelected: true,
    showPublishButton: true,
  );
}

MainSettingsPageState _setResizedBannerImage(MainSettingsPageState previousState, SetResizedBannerImageAction action){
  return previousState.copyWith(
    bannerImage: action.resizedBannerImage,
    showPublishButton: true,
  );
}

MainSettingsPageState _setResizedBannerWebImage(MainSettingsPageState previousState, SetResizedBannerWebImageAction action){
  return previousState.copyWith(
    bannerWebImage: action.resizedImage,
    showPublishButton: true,
  );
}

MainSettingsPageState _setResizedBannerMobileImage(MainSettingsPageState previousState, SetResizedBannerMobileImageAction action){
  return previousState.copyWith(
    bannerMobileImage: action.resizedImage,
    showPublishButton: true,
  );
}

MainSettingsPageState _setInstaUrl(MainSettingsPageState previousState, SetUrlToStateAction action){
  return previousState.copyWith(
    instaUrl: action.instaUrl,
  );
}

MainSettingsPageState _setIsAdmin(MainSettingsPageState previousState, SetIsAdminAction action){
  return previousState.copyWith(
    isAdmin: action.isAdmin,
  );
}

MainSettingsPageState _setDiscountCode(MainSettingsPageState previousState, SetDiscountCodeAction action){
  return previousState.copyWith(
    discountCode: action.discountCode,
  );
}

MainSettingsPageState _passwordError(MainSettingsPageState previousState, SetPasswordErrorAction action){
  return previousState.copyWith(
    passwordErrorMessage: "Invalid password",
    isDeleteInProgress: false,
    isDeleteFinished: false,
  );
}

MainSettingsPageState _updatePassword(MainSettingsPageState previousState, SavePasswordAction action){
  return previousState.copyWith(
      password: action.password,
      passwordErrorMessage: '',
  );
}

MainSettingsPageState _updateDeleteProgress(MainSettingsPageState previousState, SetDeleteProgressAction action){
  return previousState.copyWith(
    isDeleteInProgress: action.isInProgressDeleting,
    isDeleteFinished: !action.isInProgressDeleting
  );
}

MainSettingsPageState _updateFirstName(MainSettingsPageState previousState, SetFirstNameAction action){
  return previousState.copyWith(
    firstName: action.name,
  );
}

MainSettingsPageState _updateLastName(MainSettingsPageState previousState, SetLastNameAction action){
  return previousState.copyWith(
    lastName: action.name,
  );
}

MainSettingsPageState _updateBusinessName(MainSettingsPageState previousState, SetBusinessNameAction action){
  return previousState.copyWith(
    businessName: action.name,
  );
}

MainSettingsPageState _updateBusinessEmail(MainSettingsPageState previousState, SetBusinessEmailAction action){
  return previousState.copyWith(
    businessEmail: action.email,
  );
}

MainSettingsPageState _updateBusinessPhone(MainSettingsPageState previousState, SetBusinessPhoneAction action){
  return previousState.copyWith(
    businessPhone: action.phone,
  );
}

MainSettingsPageState _setPushNotificationsState(MainSettingsPageState previousState, UpdatePushNotificationEnabled action){
  return previousState.copyWith(
    pushNotificationsEnabled: action.enabled,
  );
}

MainSettingsPageState _setCalendarState(MainSettingsPageState previousState, UpdateCalendarEnabled action){
  return previousState.copyWith(
    calendarEnabled: action.enabled,
  );
}

MainSettingsPageState _setUserProfileInfo(MainSettingsPageState previousState, LoadUserProfileDataAction action){
  return previousState.copyWith(
    firstName: action.profile.firstName,
    lastName: action.profile.lastName,
    businessName: action.profile.businessName,
    businessEmail: action.profile.email,
    businessPhone: action.profile.phone,
    profile: action.profile,
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
