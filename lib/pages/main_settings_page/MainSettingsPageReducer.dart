import 'dart:ui';

import 'package:dandylight/models/ColorTheme.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageActions.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:redux/redux.dart';

import '../../utils/ColorConstants.dart';

final mainSettingsPageReducer = combineReducers<MainSettingsPageState>([
  TypedReducer<MainSettingsPageState, UpdatePushNotificationEnabled>(_setPushNotificationsState),
  TypedReducer<MainSettingsPageState, UpdateCalendarEnabled>(_setCalendarState),
  TypedReducer<MainSettingsPageState, LoadUserProfileDataAction>(_setUserProfileInfo),
  TypedReducer<MainSettingsPageState, SetFirstNameAction>(_updateFirstName),
  TypedReducer<MainSettingsPageState, SetLastNameAction>(_updateLastName),
  TypedReducer<MainSettingsPageState, SetBusinessNameAction>(_updateBusinessName),
  TypedReducer<MainSettingsPageState, SetDeleteProgressAction>(_updateDeleteProgress),
  TypedReducer<MainSettingsPageState, SavePasswordAction>(_updatePassword),
  TypedReducer<MainSettingsPageState, SetPasswordErrorAction>(_passwordError),
  TypedReducer<MainSettingsPageState, SetDiscountCodeAction>(_setDiscountCode),
  TypedReducer<MainSettingsPageState, SetIsAdminAction>(_setIsAdmin),
  TypedReducer<MainSettingsPageState, SetUrlToStateAction>(_setInstaUrl),
  TypedReducer<MainSettingsPageState, SetResizedLogoImageAction>(_setResizedLogoImage),
  TypedReducer<MainSettingsPageState, SetLogoSelectionAction>(_setLogoSelection),
  TypedReducer<MainSettingsPageState, SaveColorAction>(_setColor),
  TypedReducer<MainSettingsPageState, SetColorThemeAction>(_colorThemeSaved),
  TypedReducer<MainSettingsPageState, ResetColorsAction>(_resetColors),
  TypedReducer<MainSettingsPageState, SetSelectedColorThemeAction>(_setSelectedTheme),
  TypedReducer<MainSettingsPageState, RemoveDeletedThemeAction>(_removeDeletedTheme),
  TypedReducer<MainSettingsPageState, ClearBrandingStateAction>(_clearBranding),
]);

MainSettingsPageState _clearBranding(MainSettingsPageState previousState, ClearBrandingStateAction action){
  List<ColorTheme> themes = action.profile.savedColorThemes;
  ColorTheme defaultTheme = ColorTheme(
    themeName: 'DandyLight Theme',
    iconColor: ColorConstants.getString(ColorConstants.getPeachDark()),
    iconTextColor: ColorConstants.getString(ColorConstants.getPrimaryWhite()),
    buttonColor: ColorConstants.getString(ColorConstants.getPeachDark()),
    buttonTextColor: ColorConstants.getString(ColorConstants.getPrimaryWhite()),
    bannerColor: ColorConstants.getString(ColorConstants.getBlueDark()),
  );

  if(themes != null && !containsTheme(themes, defaultTheme)) {
    themes.add(defaultTheme);
  } if(themes != null) {
    //do nothing
  } else {
    themes = [defaultTheme];
  }

  ColorTheme selectedTheme = action.profile.selectedColorTheme ?? defaultTheme;

  return previousState.copyWith(
    selectedColorTheme: selectedTheme,
    saveColorThemeEnabled: false,
    savedColorThemes: themes,
    currentIconColor: ColorConstants.hexToColor(selectedTheme.iconColor),
    currentIconTextColor: ColorConstants.hexToColor(selectedTheme.iconTextColor),
    currentButtonColor: ColorConstants.hexToColor(selectedTheme.buttonColor),
    currentButtonTextColor: ColorConstants.hexToColor(selectedTheme.buttonTextColor),
    currentBannerColor: ColorConstants.hexToColor(selectedTheme.bannerColor),
    logoImageSelected: action.profile.logoSelected,
    resizedLogoImage: null,
    showPublishButton: false,
  );
}

bool containsTheme(List<ColorTheme> themes, ColorTheme defaultTheme) {
  for(ColorTheme theme in themes) {
    if(theme.themeName == defaultTheme.themeName) {
      return true;
    }
  }
  return false;
}

MainSettingsPageState _removeDeletedTheme(MainSettingsPageState previousState, RemoveDeletedThemeAction action){
  List<ColorTheme> themes = action.pageState.savedColorThemes;
  themes.removeWhere((theme) => theme.themeName == action.themeToDelete.themeName);
  ColorTheme theme = themes.elementAt(0);
  return previousState.copyWith(
    selectedColorTheme: theme,
    saveColorThemeEnabled: false,
    savedColorThemes: themes,
    currentIconColor: ColorConstants.hexToColor(theme.iconColor),
    currentIconTextColor: ColorConstants.hexToColor(theme.iconTextColor),
    currentButtonColor: ColorConstants.hexToColor(theme.buttonColor),
    currentButtonTextColor: ColorConstants.hexToColor(theme.buttonTextColor),
    currentBannerColor: ColorConstants.hexToColor(theme.bannerColor),
  );
}

MainSettingsPageState _setSelectedTheme(MainSettingsPageState previousState, SetSelectedColorThemeAction action){
  List<ColorTheme> themes = action.pageState.savedColorThemes;
  if(themes == 1) {
    themes.addAll(action.pageState.profile.savedColorThemes);
  }
  bool showPublishChangesButton = action.pageState.showPublishButton;
  if(action.pageState.profile.selectedColorTheme == null) {
    showPublishChangesButton = true;
  } else if (action.pageState.profile.selectedColorTheme.themeName != action.theme.themeName) {
    showPublishChangesButton = true;
  }

  return previousState.copyWith(
    saveColorThemeEnabled: false,
    savedColorThemes: themes,
    selectedColorTheme: action.theme,
    currentIconColor: ColorConstants.hexToColor(action.theme.iconColor),
    currentIconTextColor: ColorConstants.hexToColor(action.theme.iconTextColor),
    currentButtonColor: ColorConstants.hexToColor(action.theme.buttonColor),
    currentButtonTextColor: ColorConstants.hexToColor(action.theme.buttonTextColor),
    currentBannerColor: ColorConstants.hexToColor(action.theme.bannerColor),
    showPublishButton: showPublishChangesButton,
  );
}

MainSettingsPageState _resetColors(MainSettingsPageState previousState, ResetColorsAction action){
  return previousState.copyWith(
    saveColorThemeEnabled: false,
    currentIconColor: ColorConstants.hexToColor(action.pageState.selectedColorTheme.iconColor),
    currentIconTextColor: ColorConstants.hexToColor(action.pageState.selectedColorTheme.iconTextColor),
    currentButtonColor: ColorConstants.hexToColor(action.pageState.selectedColorTheme.buttonColor),
    currentButtonTextColor: ColorConstants.hexToColor(action.pageState.selectedColorTheme.buttonTextColor),
    currentBannerColor: ColorConstants.hexToColor(action.pageState.selectedColorTheme.bannerColor),
  );
}

MainSettingsPageState _colorThemeSaved(MainSettingsPageState previousState, SetColorThemeAction action){
  ColorTheme theme = action.theme;
  List<ColorTheme> themes = action.pageState.savedColorThemes;
  themes.insert(0, theme);
  return previousState.copyWith(
    selectedColorTheme: theme,
    saveColorThemeEnabled: false,
    savedColorThemes: themes,
    currentIconColor: ColorConstants.hexToColor(theme.iconColor),
    currentIconTextColor: ColorConstants.hexToColor(theme.iconTextColor),
    currentButtonColor: ColorConstants.hexToColor(theme.buttonColor),
    currentButtonTextColor: ColorConstants.hexToColor(theme.buttonTextColor),
    currentBannerColor: ColorConstants.hexToColor(theme.bannerColor),
    showPublishButton: true,
  );
}

MainSettingsPageState _setColor(MainSettingsPageState previousState, SaveColorAction action){
  bool saveColorThemeEnabled = false;
  Color bannerColor = action.pageState.currentBannerColor;
  Color buttonColor = action.pageState.currentButtonColor;
  Color buttonTextColor = action.pageState.currentButtonTextColor;
  Color iconColor = action.pageState.currentIconColor;
  Color iconTextColor = action.pageState.currentIconTextColor;

  switch(action.id) {
    case 'banner':
      bannerColor = action.color;
      break;
    case 'button':
      buttonColor = action.color;
      break;
    case 'buttonText':
      buttonTextColor = action.color;
      break;
    case 'icon':
      iconColor = action.color;
      break;
    case 'iconText':
      iconTextColor = action.color;
      break;
  }

  if(ColorConstants.getString(action.color.value) != action.pageState.selectedColorTheme.iconTextColor) {
    saveColorThemeEnabled = true;
  }
  if(ColorConstants.getString(action.color.value) != action.pageState.selectedColorTheme.iconColor) {
    saveColorThemeEnabled = true;
  }
  if(ColorConstants.getString(action.color.value) != action.pageState.selectedColorTheme.buttonTextColor) {
    saveColorThemeEnabled = true;
  }
  if(ColorConstants.getString(action.color.value) != action.pageState.selectedColorTheme.buttonColor) {
    saveColorThemeEnabled = true;
  }
  if(ColorConstants.getString(action.color.value) != action.pageState.selectedColorTheme.bannerColor) {
    saveColorThemeEnabled = true;
  }

  return previousState.copyWith(
    currentBannerColor: bannerColor,
    currentButtonColor: buttonColor,
    currentButtonTextColor: buttonTextColor,
    currentIconColor: iconColor,
    currentIconTextColor: iconTextColor,
    saveColorThemeEnabled: saveColorThemeEnabled,
  );
}

MainSettingsPageState _setLogoSelection(MainSettingsPageState previousState, SetLogoSelectionAction action){
  bool hasColorThemeChange = false;
  if(action.pageState.profile.selectedColorTheme != null && action.pageState.selectedColorTheme.themeName != action.pageState.profile.selectedColorTheme) {
    hasColorThemeChange = true;
  }
  if(action.pageState.profile.selectedColorTheme == null && action.pageState.selectedColorTheme.themeName != 'DandyLight Theme') {
    hasColorThemeChange = true;
  }
  return previousState.copyWith(
    logoImageSelected: action.isLogoSelected,
    showPublishButton: action.isLogoSelected != action.pageState.profile.logoSelected ? true : hasColorThemeChange,
  );
}

MainSettingsPageState _setResizedLogoImage(MainSettingsPageState previousState, SetResizedLogoImageAction action){
  return previousState.copyWith(
    resizedLogoImage: action.resizedLogoImage,
    logoImageSelected: true,
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
    profile: action.profile,
  );
}

bool showPublishChangesButton(MainSettingsPageState pageState, Profile profile) {
  bool showPublishButton = false;
  //TODO dont forget to set the logoUrl to the tempLogoUrl if user decides not to publish changes.
  if(profile.logoUrl != profile.tempLogoUrl) {
    showPublishButton = true;
  }
  if(profile.logoSelected != pageState.logoImageSelected) {
    showPublishButton = true;
  }
  if(profile.selectedColorTheme.themeName != pageState.selectedColorTheme.themeName) {
    showPublishButton = true;
  }
  return showPublishButton;
}
