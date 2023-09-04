import 'dart:ui';

import 'package:dandylight/models/ColorTheme.dart';
import 'package:dandylight/models/FontTheme.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageActions.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:image_picker/image_picker.dart';
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
  TypedReducer<MainSettingsPageState, SetResizedBannerImageAction>(_setResizedBannerImage),
  TypedReducer<MainSettingsPageState, SetLogoSelectionAction>(_setLogoSelection),
  TypedReducer<MainSettingsPageState, SetBannerSelectionAction>(_setBannerSelection),
  TypedReducer<MainSettingsPageState, SaveColorAction>(_setColor),
  TypedReducer<MainSettingsPageState, SetColorThemeAction>(_colorThemeSaved),
  TypedReducer<MainSettingsPageState, SetFontThemeAction>(_fontThemeSaved),
  TypedReducer<MainSettingsPageState, ResetColorsAction>(_resetColors),
  TypedReducer<MainSettingsPageState, SetSelectedColorThemeAction>(_setSelectedTheme),
  TypedReducer<MainSettingsPageState, SetSelectedFontThemeAction>(_setSelectedFontTheme),
  TypedReducer<MainSettingsPageState, RemoveDeletedThemeAction>(_removeDeletedTheme),
  TypedReducer<MainSettingsPageState, ClearBrandingStateAction>(_clearBranding),
  TypedReducer<MainSettingsPageState, SetSelectedFontAction>(_SetSelectedFont),
  TypedReducer<MainSettingsPageState, ResetFontsAction>(_resetFonts),
  TypedReducer<MainSettingsPageState, SetLogoLetterAction>(_setLogoLetter),

]);

MainSettingsPageState _setLogoLetter(MainSettingsPageState previousState, SetLogoLetterAction action){
  bool showPublishButton = showPublishChangesButton(
      action.pageState.profile.selectedColorTheme, action.pageState.selectedColorTheme,
      action.pageState.profile.selectedFontTheme, action.pageState.selectedFontTheme,
      action.pageState.profile.logoSelected, action.pageState.logoImageSelected,
      action.pageState.profile.bannerImageSelected, action.pageState.bannerImageSelected,
      action.pageState.profile.logoCharacter ?? 'M', action.logoLetter,
      action.pageState.resizedLogoImage, action.pageState.resizedLogoImage,
      action.pageState.resizedBannerImage, action.pageState.resizedBannerImage,
  );
  return previousState.copyWith(
    logoCharacter: action.logoLetter,
    showPublishButton: showPublishButton,
  );
}

MainSettingsPageState _resetFonts(MainSettingsPageState previousState, ResetFontsAction action){
  return previousState.copyWith(
    saveFontThemeEnabled: false,
    currentIconFont: action.pageState.selectedFontTheme.iconFont,
    currentTitleFont: action.pageState.selectedFontTheme.titleFont,
    currentBodyFont: action.pageState.selectedFontTheme.bodyFont,
  );
}

MainSettingsPageState _SetSelectedFont(MainSettingsPageState previousState, SetSelectedFontAction action){
  bool saveFontThemeEnabled = false;
  String iconFont = action.pageState.currentIconFont;
  String titleFont = action.pageState.currentTitleFont;
  String bodyFont = action.pageState.currentBodyFont;

  switch(action.id) {
    case FontTheme.TITLE_FONT_ID:
      titleFont = action.fontFamily;
      break;
    case FontTheme.BODY_FONT_ID:
      bodyFont = action.fontFamily;
      break;
    case FontTheme.ICON_FONT_ID:
      iconFont = action.fontFamily;
      break;
  }

  if(action.fontFamily != action.pageState.selectedFontTheme.iconFont) {
    saveFontThemeEnabled = true;
  }
  if(action.fontFamily != action.pageState.selectedFontTheme.titleFont) {
    saveFontThemeEnabled = true;
  }
  if(action.fontFamily != action.pageState.selectedFontTheme.bodyFont) {
    saveFontThemeEnabled = true;
  }

  return previousState.copyWith(
    currentIconFont: iconFont,
    currentTitleFont: titleFont,
    currentBodyFont: bodyFont,
    saveFontThemeEnabled: saveFontThemeEnabled,
  );
}

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



  List<FontTheme> fontThemes = action.profile.savedFontThemes;
  FontTheme defaultFontTheme = FontTheme(
    themeName: 'DandyLight Theme',
    iconFont: FontTheme.SIGNATURE2,
    titleFont: FontTheme.OPEN_SANS,
    bodyFont: FontTheme.OPEN_SANS,
  );

  if(fontThemes != null && !containsFontTheme(fontThemes, defaultFontTheme)) {
    fontThemes.add(defaultFontTheme);
  } if(fontThemes != null) {
    //do nothing
  } else {
    fontThemes = [defaultFontTheme];
  }

  FontTheme selectedFontTheme = action.profile.selectedFontTheme ?? defaultFontTheme;

  return previousState.copyWith(
    selectedColorTheme: selectedTheme,
    selectedFontTheme: selectedFontTheme,
    saveColorThemeEnabled: false,
    saveFontThemeEnabled: false,
    savedFontThemes: fontThemes,
    savedColorThemes: themes,
    currentIconColor: ColorConstants.hexToColor(selectedTheme.iconColor),
    currentIconTextColor: ColorConstants.hexToColor(selectedTheme.iconTextColor),
    currentButtonColor: ColorConstants.hexToColor(selectedTheme.buttonColor),
    currentButtonTextColor: ColorConstants.hexToColor(selectedTheme.buttonTextColor),
    currentBannerColor: ColorConstants.hexToColor(selectedTheme.bannerColor),
    logoImageSelected: action.profile.logoSelected,
    resizedLogoImage: null,
    showPublishButton: false,
    currentIconFont: selectedFontTheme.iconFont,
    currentTitleFont: selectedFontTheme.titleFont,
    currentBodyFont: selectedFontTheme.bodyFont,
    logoCharacter: action.profile.logoCharacter != null
        ? action.profile.logoCharacter : action.profile.businessName != null && action.profile.businessName.length > 0
        ? action.profile.businessName.substring(0, 1) : 'L',
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

bool containsFontTheme(List<FontTheme> themes, FontTheme defaultTheme) {
  for(FontTheme theme in themes) {
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

  bool showPublishButton = showPublishChangesButton(
    action.pageState.profile.selectedColorTheme, action.theme,
    action.pageState.profile.selectedFontTheme, action.pageState.selectedFontTheme,
    action.pageState.profile.logoSelected, action.pageState.logoImageSelected,
    action.pageState.profile.bannerImageSelected, action.pageState.bannerImageSelected,
    action.pageState.profile.logoCharacter ?? 'M', action.pageState.logoCharacter,
    action.pageState.resizedLogoImage, action.pageState.resizedLogoImage,
    action.pageState.resizedBannerImage, action.pageState.resizedBannerImage,
  );

  return previousState.copyWith(
    saveColorThemeEnabled: false,
    savedColorThemes: themes,
    selectedColorTheme: action.theme,
    currentIconColor: ColorConstants.hexToColor(action.theme.iconColor),
    currentIconTextColor: ColorConstants.hexToColor(action.theme.iconTextColor),
    currentButtonColor: ColorConstants.hexToColor(action.theme.buttonColor),
    currentButtonTextColor: ColorConstants.hexToColor(action.theme.buttonTextColor),
    currentBannerColor: ColorConstants.hexToColor(action.theme.bannerColor),
    showPublishButton: showPublishButton,
  );
}

MainSettingsPageState _setSelectedFontTheme(MainSettingsPageState previousState, SetSelectedFontThemeAction action){
  List<FontTheme> themes = action.pageState.savedFontThemes;
  if(themes == 1) {
    themes.addAll(action.pageState.profile.savedFontThemes);
  }

  bool showPublishButton = showPublishChangesButton(
    action.pageState.profile.selectedColorTheme, action.pageState.selectedColorTheme,
    action.pageState.profile.selectedFontTheme, action.theme,
    action.pageState.profile.logoSelected, action.pageState.logoImageSelected,
    action.pageState.profile.bannerImageSelected, action.pageState.bannerImageSelected,
    action.pageState.profile.logoCharacter ?? 'M', action.pageState.logoCharacter,
    action.pageState.resizedLogoImage, action.pageState.resizedLogoImage,
    action.pageState.resizedBannerImage, action.pageState.resizedBannerImage,
  );

  return previousState.copyWith(
    saveColorThemeEnabled: false,
    savedFontThemes: themes,
    selectedFontTheme: action.theme,
    currentIconFont: action.theme.iconFont,
    currentTitleFont: action.theme.titleFont,
    currentBodyFont: action.theme.bodyFont,
    showPublishButton: showPublishButton,
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

MainSettingsPageState _fontThemeSaved(MainSettingsPageState previousState, SetFontThemeAction action){
  FontTheme theme = action.theme;
  List<FontTheme> themes = action.pageState.savedFontThemes;
  themes.insert(0, theme);
  return previousState.copyWith(
    selectedFontTheme: theme,
    saveFontThemeEnabled: false,
    savedFontThemes: themes,
    currentIconFont: theme.iconFont,
    currentTitleFont: theme.titleFont,
    currentBodyFont: theme.bodyFont,
    showPublishButton: true,
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
  bool showPublishButton = showPublishChangesButton(
    action.pageState.profile.selectedColorTheme, action.pageState.selectedColorTheme,
    action.pageState.profile.selectedFontTheme, action.pageState.selectedFontTheme,
    action.pageState.profile.logoSelected, action.isLogoSelected,
    action.pageState.profile.bannerImageSelected, action.pageState.bannerImageSelected,
    action.pageState.profile.logoCharacter ?? 'M', action.pageState.logoCharacter,
    action.pageState.resizedLogoImage, action.pageState.resizedLogoImage,
    action.pageState.resizedBannerImage, action.pageState.resizedBannerImage,
  );
  return previousState.copyWith(
    logoImageSelected: action.isLogoSelected,
    showPublishButton: showPublishButton,
  );
}

MainSettingsPageState _setBannerSelection(MainSettingsPageState previousState, SetBannerSelectionAction action){
  bool showPublishButton = showPublishChangesButton(
    action.pageState.profile.selectedColorTheme, action.pageState.selectedColorTheme,
    action.pageState.profile.selectedFontTheme, action.pageState.selectedFontTheme,
    action.pageState.profile.logoSelected, action.pageState.logoImageSelected,
    action.pageState.profile.bannerImageSelected, action.isBannerSelected,
    action.pageState.profile.logoCharacter ?? 'M', action.pageState.logoCharacter,
    action.pageState.resizedLogoImage, action.pageState.resizedLogoImage,
    action.pageState.resizedBannerImage, action.pageState.resizedBannerImage,
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
    resizedBannerImage: action.resizedBannerImage,
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

bool showPublishChangesButton(
    ColorTheme currentColorTheme,
    ColorTheme newColorTheme,
    FontTheme newFontTheme,
    FontTheme currentFontTheme,
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
  ColorTheme defaultTheme = ColorTheme(
    themeName: 'DandyLight Theme',
    iconColor: ColorConstants.getString(ColorConstants.getPeachDark()),
    iconTextColor: ColorConstants.getString(ColorConstants.getPrimaryWhite()),
    buttonColor: ColorConstants.getString(ColorConstants.getPeachDark()),
    buttonTextColor: ColorConstants.getString(ColorConstants.getPrimaryWhite()),
    bannerColor: ColorConstants.getString(ColorConstants.getBlueDark()),
  );
  FontTheme defaultFontTheme = FontTheme(
    themeName: 'DandyLight Theme',
    iconFont: FontTheme.SIGNATURE2,
    titleFont: FontTheme.OPEN_SANS,
    bodyFont: FontTheme.OPEN_SANS,
  );

  if(currentColorTheme == null) currentColorTheme = defaultTheme;
  if(currentFontTheme == null) currentFontTheme = defaultFontTheme;
  if(newColorTheme == null) newColorTheme = defaultTheme;
  if(newFontTheme == null) newFontTheme = defaultFontTheme;

  if(currentColorTheme.themeName != newColorTheme.themeName) showPublishButton = true;
  if(currentFontTheme.themeName != newFontTheme.themeName) showPublishButton = true;
  if(logoImageSelected != newLogoImageSelected) showPublishButton = true;
  if(bannerImageSelected != newBannerImageSelected) showPublishButton = true;
  if(currentLogoLetter != newLogoLetter) showPublishButton = true;
  if(currentLogoImage != null && currentLogoImage.path != newLogoImage.path) showPublishButton = true;
  if(currentBannerImage != null && currentBannerImage.path != newBannerImage.path) showPublishButton = true;

  return showPublishButton;
}
