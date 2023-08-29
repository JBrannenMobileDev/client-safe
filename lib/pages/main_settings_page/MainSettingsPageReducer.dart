import 'package:dandylight/models/ColorTheme.dart';
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
  TypedReducer<MainSettingsPageState, SaveBannerColorAction>(_setBannerColor),
  TypedReducer<MainSettingsPageState, SetColorThemeAction>(_colorThemeSaved),
  TypedReducer<MainSettingsPageState, ResetColorsAction>(_resetColors),
  TypedReducer<MainSettingsPageState, SetSelectedColorThemeAction>(_setSelectedTheme),
]);

MainSettingsPageState _setSelectedTheme(MainSettingsPageState previousState, SetSelectedColorThemeAction action){
  ColorTheme theme = action.pageState.profile.savedColorThemes.elementAt(action.index);
  return previousState.copyWith(
    saveColorThemeEnabled: false,
    selectedColorTheme: theme,
    currentIconColor: ColorConstants.hexToColor(theme.iconColor),
    currentIconTextColor: ColorConstants.hexToColor(theme.iconTextColor),
    currentButtonColor: ColorConstants.hexToColor(theme.buttonColor),
    currentButtonTextColor: ColorConstants.hexToColor(theme.buttonTextColor),
    currentBannerColor: ColorConstants.hexToColor(theme.bannerColor),
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
  if(action.theme == null) {
    theme = ColorTheme(
      themeName: 'DandyLight Theme',
      iconColor: ColorConstants.getString(ColorConstants.getPeachDark()),
      iconTextColor: ColorConstants.getString(ColorConstants.getPrimaryWhite()),
      buttonColor: ColorConstants.getString(ColorConstants.getPeachDark()),
      buttonTextColor: ColorConstants.getString(
          ColorConstants.getPrimaryWhite()),
      bannerColor: ColorConstants.getString(ColorConstants.getBlueDark()),
    );
  }
  return previousState.copyWith(
    selectedColorTheme: theme,
    saveColorThemeEnabled: false,
    currentIconColor: ColorConstants.hexToColor(theme.iconColor),
    currentIconTextColor: ColorConstants.hexToColor(theme.iconTextColor),
    currentButtonColor: ColorConstants.hexToColor(theme.buttonColor),
    currentButtonTextColor: ColorConstants.hexToColor(theme.buttonTextColor),
    currentBannerColor: ColorConstants.hexToColor(theme.bannerColor),
  );
}

MainSettingsPageState _setBannerColor(MainSettingsPageState previousState, SaveBannerColorAction action){
  bool saveColorThemeEnabled = false;

  switch(action.id) {
    case 'banner':
      action.pageState.currentBannerColor = action.color;
      break;
    case 'button':
      action.pageState.currentButtonColor = action.color;
      break;
    case 'buttonText':
      action.pageState.currentButtonTextColor = action.color;
      break;
    case 'icon':
      action.pageState.currentIconColor = action.color;
      break;
    case 'iconText':
      action.pageState.currentIconTextColor = action.color;
      break;
  }

  if(ColorConstants.getString(action.pageState.currentIconTextColor.value) != action.pageState.selectedColorTheme.iconTextColor) {
    saveColorThemeEnabled = true;
  }
  if(ColorConstants.getString(action.pageState.currentIconColor.value) != action.pageState.selectedColorTheme.iconColor) {
    saveColorThemeEnabled = true;
  }
  if(ColorConstants.getString(action.pageState.currentButtonTextColor.value) != action.pageState.selectedColorTheme.buttonTextColor) {
    saveColorThemeEnabled = true;
  }
  if(ColorConstants.getString(action.pageState.currentButtonColor.value) != action.pageState.selectedColorTheme.buttonColor) {
    saveColorThemeEnabled = true;
  }
  if(ColorConstants.getString(action.pageState.currentBannerColor.value) != action.pageState.selectedColorTheme.bannerColor) {
    saveColorThemeEnabled = true;
  }

  return previousState.copyWith(
    currentBannerColor: action.pageState.currentBannerColor,
    currentButtonColor: action.pageState.currentButtonColor,
    currentButtonTextColor: action.pageState.currentButtonTextColor,
    currentIconColor: action.pageState.currentIconColor,
    currentIconTextColor: action.pageState.currentIconTextColor,
    saveColorThemeEnabled: saveColorThemeEnabled,
  );
}

MainSettingsPageState _setLogoSelection(MainSettingsPageState previousState, SetLogoSelectionAction action){
  return previousState.copyWith(
    logoImageSelected: action.isLogoSelected,
  );
}

MainSettingsPageState _setResizedLogoImage(MainSettingsPageState previousState, SetResizedLogoImageAction action){
  return previousState.copyWith(
    resizedLogoImage: action.resizedLogoImage,
    logoImageSelected: true,
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
