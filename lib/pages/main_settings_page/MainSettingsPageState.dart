import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/models/ColorTheme.dart';
import 'package:dandylight/models/FontTheme.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/login_page/LoginPageActions.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageActions.dart';
import 'package:dandylight/utils/analytics/EventSender.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../utils/ColorConstants.dart';

class MainSettingsPageState{
  final bool pushNotificationsEnabled;
  final bool calendarEnabled;
  final String firstName;
  final String lastName;
  final String businessName;
  final String discountCode;
  final Profile profile;
  final bool isDeleteInProgress;
  final bool isDeleteFinished;
  final bool isAdmin;
  final bool saveColorThemeEnabled;
  final bool saveFontThemeEnabled;
  final String password;
  final String passwordErrorMessage;
  final String instaUrl;
  final XFile resizedLogoImage;
  final bool logoImageSelected;
  final Color currentBannerColor;
  final Color currentButtonColor;
  final Color currentButtonTextColor;
  final Color currentIconColor;
  final Color currentIconTextColor;
  final String currentIconFont;
  final String currentTitleFont;
  final String currentBodyFont;
  final ColorTheme selectedColorTheme;
  final FontTheme selectedFontTheme;
  final List<ColorTheme> savedColorThemes;
  final List<FontTheme> savedFontThemes;
  final bool showPublishButton;
  final Function() onSignOutSelected;
  final Function(bool) onPushNotificationsChanged;
  final Function(bool) onCalendarChanged;
  final Function(String) onFirstNameChanged;
  final Function(String) onLastNameChanged;
  final Function(String) onBusinessNameChanged;
  final Function() onSaveUpdatedProfile;
  final Function(String) onSendSuggestionSelected;
  final Function() onDeleteAccountSelected;
  final Function(String) onPasswordChanged;
  final Function() generate50DiscountCode;
  final Function() generateFreeDiscountCode;
  final Function(String) onInstaUrlChanged;
  final Function(XFile) onLogoUploaded;
  final Function(bool) onLogoImageSelected;
  final Function(Color, String) onColorSaved;
  final Function(String) onColorThemeSaved;
  final Function(ColorTheme) onColorThemeDeleted;
  final Function(ColorTheme) onColorThemeSelected;
  final Function() onResetColors;
  final Function(String, String) onFontSaved;
  final Function(String) onFontThemeSaved;
  final Function(FontTheme) onFontThemeSelected;
  final Function() onResetFonts;

  MainSettingsPageState({
    @required this.pushNotificationsEnabled,
    @required this.calendarEnabled,
    @required this.onSignOutSelected,
    @required this.onPushNotificationsChanged,
    @required this.onCalendarChanged,
    @required this.firstName,
    @required this.lastName,
    @required this.businessName,
    @required this.onFirstNameChanged,
    @required this.onLastNameChanged,
    @required this.onBusinessNameChanged,
    @required this.onSaveUpdatedProfile,
    @required this.profile,
    @required this.onSendSuggestionSelected,
    @required this.onDeleteAccountSelected,
    @required this.isDeleteInProgress,
    @required this.isDeleteFinished,
    @required this.password,
    @required this.onPasswordChanged,
    @required this.passwordErrorMessage,
    @required this.discountCode,
    @required this.generate50DiscountCode,
    @required this.isAdmin,
    @required this.generateFreeDiscountCode,
    @required this.onInstaUrlChanged,
    @required this.instaUrl,
    @required this.onLogoUploaded,
    @required this.resizedLogoImage,
    @required this.logoImageSelected,
    @required this.onLogoImageSelected,
    @required this.currentBannerColor,
    @required this.currentButtonColor,
    @required this.currentButtonTextColor,
    @required this.currentIconColor,
    @required this.currentIconFont,
    @required this.currentTitleFont,
    @required this.currentBodyFont,
    @required this.selectedColorTheme,
    @required this.selectedFontTheme,
    @required this.onColorSaved,
    @required this.currentIconTextColor,
    @required this.saveColorThemeEnabled,
    @required this.saveFontThemeEnabled,
    @required this.onColorThemeSaved,
    @required this.onColorThemeDeleted,
    @required this.onColorThemeSelected,
    @required this.onResetColors,
    @required this.savedColorThemes,
    @required this.showPublishButton,
    @required this.onFontSaved,
    @required this.onFontThemeSaved,
    @required this.onFontThemeSelected,
    @required this.onResetFonts,
    @required this.savedFontThemes,
  });

  MainSettingsPageState copyWith({
    bool pushNotificationsEnabled,
    bool calendarEnabled,
    String firstName,
    String lastName,
    String businessName,
    Profile profile,
    bool isDeleteInProgress,
    bool isDeleteFinished,
    bool isAdmin,
    bool saveColorThemeEnabled,
    bool saveFontThemeEnabled,
    String password,
    String passwordErrorMessage,
    String discountCode,
    String instaUrl,
    XFile resizedLogoImage,
    bool logoImageSelected,
    Color currentBannerColor,
    Color currentButtonColor,
    Color currentButtonTextColor,
    Color currentIconColor,
    Color currentIconTextColor,
    String currentIconFont,
    String currentTitleFont,
    String currentBodyFont,
    ColorTheme selectedColorTheme,
    FontTheme selectedFontTheme,
    List<ColorTheme> savedColorThemes,
    List<FontTheme> savedFontThemes,
    bool showPublishButton,
    Function(String) onFirstNameChanged,
    Function(String) onLastNameChanged,
    Function(String) onBusinessNameChanged,
    Function() onSignOutSelected,
    Function(bool) onPushNotificationsChanged,
    Function(bool) onCalendarChanged,
    Function() onSaveUpdatedProfile,
    Function(String) onSendSuggestionSelected,
    Function() onDeleteAccountSelected,
    Function(String) onPasswordChanged,
    Function() generate50DiscountCode,
    Function() generateFreeDiscountCode,
    Function(String) onInstaUrlChanged,
    Function(XFile) onLogoUploaded,
    Function(bool) onLogoImageSelected,
    Function(Color, String) onColorSaved,
    Function(String) onColorThemeSaved,
    Function(ColorTheme) onColorThemeDeleted,
    Function(ColorTheme) onColorThemeSelected,
    Function() onResetColors,
    Function(String, String) onFontSaved,
    Function(String) onFontThemeSaved,
    Function(FontTheme) onFontThemeSelected,
    Function() onResetFonts,
  }){
    return MainSettingsPageState(
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      calendarEnabled: calendarEnabled ?? this.calendarEnabled,
      onSignOutSelected: onSignOutSelected?? this.onSignOutSelected,
      onPushNotificationsChanged: onPushNotificationsChanged ?? this.onPushNotificationsChanged,
      onCalendarChanged: onCalendarChanged ?? this.onCalendarChanged,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      businessName: businessName ?? this.businessName,
      onFirstNameChanged: onFirstNameChanged ?? this.onFirstNameChanged,
      onLastNameChanged: onLastNameChanged ?? this.onLastNameChanged,
      onBusinessNameChanged: onBusinessNameChanged ?? this.onBusinessNameChanged,
      onSaveUpdatedProfile: onSaveUpdatedProfile ?? this.onSaveUpdatedProfile,
      profile: profile ?? this.profile,
      onSendSuggestionSelected: onSendSuggestionSelected ?? this.onSendSuggestionSelected,
      onDeleteAccountSelected: onDeleteAccountSelected ?? this.onDeleteAccountSelected,
      isDeleteFinished: isDeleteFinished ?? this.isDeleteFinished,
      isDeleteInProgress: isDeleteInProgress ?? this.isDeleteInProgress,
      password: password ?? this.password,
      onPasswordChanged: onPasswordChanged ?? this.onPasswordChanged,
      passwordErrorMessage: passwordErrorMessage ?? this.passwordErrorMessage,
      discountCode: discountCode ?? this.discountCode,
      generate50DiscountCode: generate50DiscountCode ?? this.generate50DiscountCode,
      isAdmin: isAdmin ?? this.isAdmin,
      generateFreeDiscountCode: generateFreeDiscountCode ?? this.generateFreeDiscountCode,
      onInstaUrlChanged: onInstaUrlChanged?? this.onInstaUrlChanged,
      instaUrl: instaUrl ?? this.instaUrl,
      onLogoUploaded: onLogoUploaded ?? this.onLogoUploaded,
      resizedLogoImage: resizedLogoImage ?? this.resizedLogoImage,
      logoImageSelected: logoImageSelected ?? this.logoImageSelected,
      onLogoImageSelected: onLogoImageSelected ?? this.onLogoImageSelected,
      currentBannerColor: currentBannerColor ?? this.currentBannerColor,
      currentIconColor: currentIconColor ?? this.currentIconColor,
      currentButtonColor: currentButtonColor ?? this.currentButtonColor,
      currentButtonTextColor: currentButtonTextColor ?? this.currentButtonTextColor,
      currentIconFont: currentIconFont ?? this.currentIconFont,
      currentTitleFont: currentTitleFont ?? this.currentTitleFont,
      currentBodyFont: currentBodyFont ?? this.currentBodyFont,
      selectedFontTheme: selectedFontTheme ?? this.selectedFontTheme,
      selectedColorTheme: selectedColorTheme ?? this.selectedColorTheme,
      onColorSaved: onColorSaved ?? this.onColorSaved,
      currentIconTextColor: currentIconTextColor ?? this.currentIconTextColor,
      saveColorThemeEnabled: saveColorThemeEnabled ?? this.saveColorThemeEnabled,
      saveFontThemeEnabled: saveFontThemeEnabled ?? this.saveFontThemeEnabled,
      onColorThemeSaved: onColorThemeSaved ?? this.onColorThemeSaved,
      onColorThemeSelected: onColorThemeSelected ?? this.onColorThemeSelected,
      onColorThemeDeleted: onColorThemeDeleted ?? this.onColorThemeDeleted,
      onResetColors: onResetColors ?? this.onResetColors,
      savedColorThemes: savedColorThemes ?? this.savedColorThemes,
      showPublishButton: showPublishButton ?? this.showPublishButton,
      onFontSaved: onFontSaved ?? this.onFontSaved,
      onFontThemeSaved: onFontThemeSaved ?? this.onFontThemeSaved,
      onFontThemeSelected: onFontThemeSelected ?? this.onFontThemeSelected,
      onResetFonts: onResetFonts ?? this.onResetFonts,
      savedFontThemes: savedFontThemes ?? this.savedFontThemes,
    );
  }

  factory MainSettingsPageState.initial() => MainSettingsPageState(
    onSignOutSelected: null,
    onPushNotificationsChanged: null,
    onCalendarChanged: null,
    pushNotificationsEnabled: false,
    calendarEnabled: false,
    firstName: '',
    lastName: '',
    businessName: '',
    onFirstNameChanged: null,
    onLastNameChanged: null,
    onBusinessNameChanged: null,
    onSaveUpdatedProfile: null,
    profile: null,
    onSendSuggestionSelected: null,
    onDeleteAccountSelected: null,
    isDeleteInProgress: false,
    isDeleteFinished: false,
    password: '',
    onPasswordChanged: null,
    passwordErrorMessage: '',
    generate50DiscountCode: null,
    discountCode: '',
    isAdmin: false,
    generateFreeDiscountCode: null,
    onInstaUrlChanged: null,
    instaUrl: '',
    onLogoUploaded: null,
    resizedLogoImage: null,
    logoImageSelected: false,
    onLogoImageSelected: null,
    currentBannerColor: Color(ColorConstants.getBlueDark()),
    currentIconTextColor: Color(ColorConstants.getPrimaryWhite()),
    currentIconColor: Color(ColorConstants.getPeachDark()),
    currentButtonColor: Color(ColorConstants.getPeachDark()),
    currentButtonTextColor: Color(ColorConstants.getPrimaryWhite()),
    currentIconFont: FontTheme.SIGNATURE2,
    currentTitleFont: FontTheme.MONTSERRAT,
    currentBodyFont: FontTheme.MONTSERRAT,
    selectedColorTheme: ColorTheme(
        themeName: 'DandyLight Theme',
        iconColor: ColorConstants.getString(ColorConstants.getPeachDark()),
        iconTextColor: ColorConstants.getString(ColorConstants.getPrimaryWhite()),
        buttonColor: ColorConstants.getString(ColorConstants.getPeachDark()),
        buttonTextColor: ColorConstants.getString(ColorConstants.getPrimaryWhite()),
        bannerColor: ColorConstants.getString(ColorConstants.getBlueDark()),
    ),
    selectedFontTheme: FontTheme(
      themeName: 'DandyLight Theme',
      iconFont: FontTheme.SIGNATURE2,
      titleFont: FontTheme.OPEN_SANS,
      bodyFont: FontTheme.OPEN_SANS,
    ),
    onColorSaved: null,
    saveFontThemeEnabled: false,
    saveColorThemeEnabled: false,
    onColorThemeSaved: null,
    onColorThemeDeleted: null,
    onColorThemeSelected: null,
    onResetColors: null,
    savedColorThemes: [ColorTheme(
      themeName: 'DandyLight Theme',
      iconColor: ColorConstants.getString(ColorConstants.getPeachDark()),
      iconTextColor: ColorConstants.getString(ColorConstants.getPrimaryWhite()),
      buttonColor: ColorConstants.getString(ColorConstants.getPeachDark()),
      buttonTextColor: ColorConstants.getString(
          ColorConstants.getPrimaryWhite()),
      bannerColor: ColorConstants.getString(ColorConstants.getBlueDark()),
    )],
    showPublishButton: false,
    onFontThemeSelected: null,
    onFontThemeSaved: null,
    onFontSaved: null,
    onResetFonts: null,
    savedFontThemes: [FontTheme(
      themeName: 'DandyLight Theme',
      iconFont: FontTheme.SIGNATURE2,
      titleFont: FontTheme.OPEN_SANS,
      bodyFont: FontTheme.OPEN_SANS,
    )]
  );

  factory MainSettingsPageState.fromStore(Store<AppState> store) {
    return MainSettingsPageState(
      pushNotificationsEnabled: store.state.mainSettingsPageState.pushNotificationsEnabled,
      calendarEnabled: store.state.mainSettingsPageState.calendarEnabled,
      firstName: store.state.mainSettingsPageState.firstName,
      lastName: store.state.mainSettingsPageState.lastName,
      businessName: store.state.mainSettingsPageState.businessName,
      profile: store.state.mainSettingsPageState.profile,
      isDeleteFinished: store.state.mainSettingsPageState.isDeleteFinished,
      isDeleteInProgress: store.state.mainSettingsPageState.isDeleteInProgress,
      password: store.state.mainSettingsPageState.password,
      passwordErrorMessage: store.state.mainSettingsPageState.passwordErrorMessage,
      discountCode: store.state.mainSettingsPageState.discountCode,
      isAdmin: store.state.mainSettingsPageState.isAdmin,
      instaUrl: store.state.mainSettingsPageState.instaUrl,
      logoImageSelected: store.state.mainSettingsPageState.logoImageSelected,
      resizedLogoImage: store.state.mainSettingsPageState.resizedLogoImage,
      currentBannerColor: store.state.mainSettingsPageState.currentBannerColor,
      currentButtonColor: store.state.mainSettingsPageState.currentButtonColor,
      currentButtonTextColor: store.state.mainSettingsPageState.currentButtonTextColor,
      currentIconColor: store.state.mainSettingsPageState.currentIconColor,
      currentIconFont: store.state.mainSettingsPageState.currentIconFont,
      currentTitleFont: store.state.mainSettingsPageState.currentTitleFont,
      currentBodyFont: store.state.mainSettingsPageState.currentBodyFont,
      selectedColorTheme: store.state.mainSettingsPageState.selectedColorTheme,
      selectedFontTheme: store.state.mainSettingsPageState.selectedFontTheme,
      currentIconTextColor: store.state.mainSettingsPageState.currentIconTextColor,
      saveColorThemeEnabled: store.state.mainSettingsPageState.saveColorThemeEnabled,
      saveFontThemeEnabled: store.state.mainSettingsPageState.saveFontThemeEnabled,
      savedColorThemes: store.state.mainSettingsPageState.savedColorThemes,
      showPublishButton: store.state.mainSettingsPageState.showPublishButton,
      savedFontThemes: store.state.mainSettingsPageState.savedFontThemes,
      onSignOutSelected: () {
        store.dispatch(RemoveDeviceTokenAction(store.state.mainSettingsPageState));
        store.dispatch(ResetLoginState(store.state.loginPageState));
        SembastDb.instance.deleteAllLocalData();
        EventSender().reset();
      },
      onPushNotificationsChanged: (enabled) => store.dispatch(SavePushNotificationSettingAction(store.state.mainSettingsPageState, enabled)),
      onCalendarChanged: (enabled) => store.dispatch(SaveCalendarSettingAction(store.state.mainSettingsPageState, enabled)),
      onFirstNameChanged: (firstName) => store.dispatch(SetFirstNameAction(store.state.mainSettingsPageState, firstName)),
      onLastNameChanged: (lastName) => store.dispatch(SetLastNameAction(store.state.mainSettingsPageState, lastName)),
      onBusinessNameChanged: (businessName) => store.dispatch(SetBusinessNameAction(store.state.mainSettingsPageState, businessName)),
      onSaveUpdatedProfile: () => store.dispatch(SaveUpdatedUserProfileAction(store.state.mainSettingsPageState)),
      onSendSuggestionSelected: (suggestion) => store.dispatch(SendSuggestionAction(store.state.mainSettingsPageState, suggestion)),
      onDeleteAccountSelected: () => store.dispatch(DeleteAccountAction(store.state.mainSettingsPageState)),
      onPasswordChanged: (password) => store.dispatch(SavePasswordAction(store.state.mainSettingsPageState, password)),
      generate50DiscountCode: () => store.dispatch(Generate50DiscountCodeAction(store.state.mainSettingsPageState)),
      generateFreeDiscountCode: () => store.dispatch(GenerateFreeDiscountCodeAction(store.state.mainSettingsPageState)),
      onInstaUrlChanged: (url) => store.dispatch(SetUrlToStateAction(store.state.mainSettingsPageState, url)),
      onLogoUploaded: (imageFile) => store.dispatch(ResizeLogoImageAction(store.state.mainSettingsPageState, imageFile)),
      onLogoImageSelected: (isLogoImageSelected) => store.dispatch(SetLogoSelectionAction(store.state.mainSettingsPageState, isLogoImageSelected)),
      onColorSaved: (color, id) => store.dispatch(SaveColorAction(store.state.mainSettingsPageState, color, id)),
      onColorThemeSaved: (name) => store.dispatch(SaveColorThemeAction(store.state.mainSettingsPageState, name)),
      onColorThemeDeleted: (theme) => store.dispatch(DeleteColorThemeAction(store.state.mainSettingsPageState, theme)),
      onColorThemeSelected: (theme) => store.dispatch(SetSelectedColorThemeAction(store.state.mainSettingsPageState, theme)),
      onResetColors: () => store.dispatch(ResetColorsAction(store.state.mainSettingsPageState)),
      onFontSaved: (fontFamily, id) => store.dispatch(SetSelectedFontAction(store.state.mainSettingsPageState, fontFamily, id)),
      onFontThemeSaved: (name) => store.dispatch(SaveFontThemeAction(store.state.mainSettingsPageState, name)),
      onFontThemeSelected: (theme) => store.dispatch(SetSelectedFontThemeAction(store.state.mainSettingsPageState, theme)),
      onResetFonts: () => store.dispatch(ResetFontsAction(store.state.mainSettingsPageState)),
    );
  }

  @override
  int get hashCode =>
      pushNotificationsEnabled.hashCode ^
      calendarEnabled.hashCode ^
      onLogoUploaded.hashCode ^
      resizedLogoImage.hashCode ^
      onPushNotificationsChanged.hashCode ^
      onCalendarChanged.hashCode ^
      firstName.hashCode ^
      logoImageSelected.hashCode ^
      lastName.hashCode ^
      showPublishButton.hashCode ^
      businessName.hashCode ^
      onFirstNameChanged.hashCode ^
      onLastNameChanged.hashCode ^
      onBusinessNameChanged.hashCode ^
      onSaveUpdatedProfile.hashCode ^
      profile.hashCode ^
      savedColorThemes.hashCode ^
      saveColorThemeEnabled.hashCode ^
      saveFontThemeEnabled.hashCode ^
      onSendSuggestionSelected.hashCode ^
      onDeleteAccountSelected.hashCode ^
      isDeleteFinished.hashCode ^
      isDeleteInProgress.hashCode ^
      password.hashCode ^
      onPasswordChanged.hashCode ^
      instaUrl.hashCode ^
      passwordErrorMessage.hashCode ^
      generate50DiscountCode.hashCode ^
      discountCode.hashCode ^
      currentIconTextColor.hashCode ^
      generateFreeDiscountCode.hashCode ^
      isAdmin.hashCode ^
      onResetColors.hashCode ^
      onColorThemeSelected.hashCode ^
      onColorThemeDeleted.hashCode ^
      onInstaUrlChanged.hashCode ^
      currentBannerColor.hashCode ^
      currentIconColor.hashCode ^
      currentButtonColor.hashCode ^
      currentButtonTextColor.hashCode ^
      currentIconFont.hashCode ^
      currentTitleFont.hashCode ^
      currentBodyFont.hashCode ^
      selectedFontTheme.hashCode ^
      selectedColorTheme.hashCode ^
      onColorSaved.hashCode ^
      onColorThemeSaved.hashCode ^
      onFontThemeSelected.hashCode ^
      onFontThemeSaved.hashCode ^
      onFontSaved.hashCode ^
      onResetFonts.hashCode ^
      onSignOutSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MainSettingsPageState &&
              pushNotificationsEnabled == other.pushNotificationsEnabled &&
              calendarEnabled == other.calendarEnabled &&
              onPushNotificationsChanged == other.onPushNotificationsChanged &&
              onCalendarChanged == other.onCalendarChanged &&
              firstName == other.firstName &&
              onLogoUploaded == other.onLogoUploaded &&
              resizedLogoImage == other.resizedLogoImage &&
              lastName == other.lastName &&
              showPublishButton == other.showPublishButton &&
              businessName == other.businessName &&
              onColorThemeSaved == other.onColorThemeSaved &&
              instaUrl == other.instaUrl &&
              onFirstNameChanged == other.onFirstNameChanged &&
              onLastNameChanged == other.onLastNameChanged &&
              onBusinessNameChanged == other.onBusinessNameChanged &&
              onSaveUpdatedProfile == other.onSaveUpdatedProfile &&
              profile == other.profile &&
              onResetColors == other.onResetColors &&
              savedColorThemes == other.savedColorThemes &&
              currentIconTextColor == other.currentIconTextColor &&
              onSendSuggestionSelected == other.onSendSuggestionSelected &&
              onDeleteAccountSelected == other.onDeleteAccountSelected &&
              isDeleteFinished == other.isDeleteFinished &&
              isDeleteInProgress == other.isDeleteInProgress &&
              password == other.password &&
              onColorThemeSelected == other.onColorThemeSelected &&
              onColorThemeDeleted == other.onColorThemeDeleted &&
              logoImageSelected == other.logoImageSelected &&
              onPasswordChanged == other.onPasswordChanged &&
              passwordErrorMessage == other.passwordErrorMessage &&
              generate50DiscountCode == other.generate50DiscountCode &&
              discountCode == other.discountCode &&
              isAdmin == other.isAdmin &&
              generateFreeDiscountCode == other.generateFreeDiscountCode &&
              onInstaUrlChanged == other.onInstaUrlChanged &&
              currentBannerColor == other.currentBannerColor &&
              currentIconColor == other.currentIconColor &&
              currentButtonColor == other.currentButtonColor &&
              currentButtonTextColor == other.currentButtonTextColor &&
              currentIconFont == other.currentIconFont &&
              currentTitleFont == other.currentTitleFont &&
              currentBodyFont == other.currentBodyFont &&
              selectedColorTheme == other.selectedColorTheme &&
              selectedFontTheme == other.selectedFontTheme &&
              saveColorThemeEnabled == other.saveColorThemeEnabled &&
              saveFontThemeEnabled == other.saveFontThemeEnabled &&
              onColorSaved == other.onColorSaved &&
              onFontSaved == other.onFontSaved &&
              onFontThemeSaved == other.onFontThemeSaved &&
              onFontThemeSelected == other.onFontThemeSelected &&
              onResetFonts == other.onResetFonts &&
              onSignOutSelected == other.onSignOutSelected;
}