import 'package:dandylight/data_layer/local_db/SembastDb.dart';
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
  final String password;
  final String passwordErrorMessage;
  final String instaUrl;
  final XFile resizedLogoImage;
  final XFile bannerImage;
  final XFile bannerWebImage;
  final XFile bannerMobileImage;
  final bool logoImageSelected;
  final bool bannerImageSelected;
  final Color currentBannerColor;
  final Color currentButtonColor;
  final Color currentButtonTextColor;
  final Color currentIconColor;
  final Color currentIconTextColor;
  final String currentIconFont;
  final String currentFont;
  final String logoCharacter;
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
  final Function(XFile) onBannerUploaded;
  final Function(XFile) onBannerWebUploaded;
  final Function(XFile) onBannerMobileUploaded;
  final Function(bool) onLogoImageSelected;
  final Function(Color, String) onColorSaved;
  final Function(String, String) onFontSaved;
  final Function(String) onLogoLetterChanged;
  final Function(bool) onBannerImageSelected;
  final Function() onPublishChangesSelected;

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
    @required this.currentFont,
    @required this.onColorSaved,
    @required this.currentIconTextColor,
    @required this.showPublishButton,
    @required this.onFontSaved,
    @required this.logoCharacter,
    @required this.onLogoLetterChanged,
    @required this.bannerImage,
    @required this.onBannerUploaded,
    @required this.bannerImageSelected,
    @required this.onBannerImageSelected,
    @required this.onPublishChangesSelected,
    @required this.bannerMobileImage,
    @required this.bannerWebImage,
    @required this.onBannerWebUploaded,
    @required this.onBannerMobileUploaded,
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
    String password,
    String passwordErrorMessage,
    String discountCode,
    String instaUrl,
    XFile resizedLogoImage,
    XFile bannerImage,
    XFile bannerWebImage,
    XFile bannerMobileImage,
    bool logoImageSelected,
    bool bannerImageSelected,
    Color currentBannerColor,
    Color currentButtonColor,
    Color currentButtonTextColor,
    Color currentIconColor,
    Color currentIconTextColor,
    String currentIconFont,
    String currentFont,
    String logoCharacter,
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
    Function(XFile) onBannerUploaded,
    Function(XFile) onBannerWebUploaded,
    Function(XFile) onBannerMobileUploaded,
    Function(bool) onLogoImageSelected,
    Function(Color, String) onColorSaved,
    Function(String, String) onFontSaved,
    Function(String) onLogoLetterChanged,
    Function(bool) onBannerImageSelected,
    Function() onPublishChangesSelected,
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
      currentFont: currentFont ?? this.currentFont,
      onColorSaved: onColorSaved ?? this.onColorSaved,
      currentIconTextColor: currentIconTextColor ?? this.currentIconTextColor,
      showPublishButton: showPublishButton ?? this.showPublishButton,
      onFontSaved: onFontSaved ?? this.onFontSaved,
      logoCharacter: logoCharacter ?? this.logoCharacter,
      onLogoLetterChanged: onLogoLetterChanged ?? this.onLogoLetterChanged,
      onBannerUploaded: onBannerUploaded ?? this.onBannerUploaded,
      bannerImage: bannerImage ?? this.bannerImage,
      bannerImageSelected: bannerImageSelected ?? this.bannerImageSelected,
      onBannerImageSelected: onBannerImageSelected ?? this.onBannerImageSelected,
      onPublishChangesSelected: onPublishChangesSelected ?? this.onPublishChangesSelected,
      bannerWebImage: bannerWebImage ?? this.bannerWebImage,
      bannerMobileImage: bannerMobileImage ?? this.bannerMobileImage,
      onBannerWebUploaded: onBannerWebUploaded ?? this.onBannerWebUploaded,
      onBannerMobileUploaded: onBannerMobileUploaded ?? this.onBannerMobileUploaded,
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
    logoCharacter: null,
    currentBannerColor: Color(ColorConstants.getBlueDark()),
    currentIconTextColor: Color(ColorConstants.getPrimaryWhite()),
    currentIconColor: Color(ColorConstants.getPeachDark()),
    currentButtonColor: Color(ColorConstants.getPeachDark()),
    currentButtonTextColor: Color(ColorConstants.getPrimaryWhite()),
    currentIconFont: FontTheme.SIGNATURE2,
    currentFont: FontTheme.OPEN_SANS,
    onColorSaved: null,
    showPublishButton: false,
    onFontSaved: null,
    onLogoLetterChanged: null,
    bannerImage: null,
    onBannerUploaded: null,
    bannerImageSelected: false,
    onBannerImageSelected: null,
    onPublishChangesSelected: null,
    bannerWebImage: null,
    bannerMobileImage: null,
    onBannerMobileUploaded: null,
    onBannerWebUploaded: null,
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
      currentFont: store.state.mainSettingsPageState.currentFont,
      currentIconTextColor: store.state.mainSettingsPageState.currentIconTextColor,
      showPublishButton: store.state.mainSettingsPageState.showPublishButton,
      logoCharacter: store.state.mainSettingsPageState.logoCharacter,
      bannerImage: store.state.mainSettingsPageState.bannerImage,
      bannerImageSelected: store.state.mainSettingsPageState.bannerImageSelected,
      bannerWebImage: store.state.mainSettingsPageState.bannerWebImage,
      bannerMobileImage: store.state.mainSettingsPageState.bannerMobileImage,
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
      onLogoUploaded: (imageFile) async {
        await store.dispatch(ResizeLogoImageAction(store.state.mainSettingsPageState, imageFile));
        store.dispatch(SavePreviewBrandingAction(store.state.mainSettingsPageState));
      },
      onLogoImageSelected: (isLogoImageSelected) async {
        await store.dispatch(SetLogoSelectionAction(store.state.mainSettingsPageState, isLogoImageSelected));
        store.dispatch(SavePreviewBrandingAction(store.state.mainSettingsPageState));
      },
      onColorSaved: (color, id) async {
        await store.dispatch(SaveColorAction(store.state.mainSettingsPageState, color, id));
        store.dispatch(SavePreviewBrandingAction(store.state.mainSettingsPageState));
      },
      onFontSaved: (fontFamily, id) async {
        store.dispatch(SetSelectedFontAction(store.state.mainSettingsPageState, fontFamily, id));
        store.dispatch(SavePreviewBrandingAction(store.state.mainSettingsPageState));
      },
      onLogoLetterChanged: (logoLetter) async {
        await store.dispatch(SetLogoLetterAction(store.state.mainSettingsPageState, logoLetter));
        store.dispatch(SavePreviewBrandingAction(store.state.mainSettingsPageState));
      },
      onBannerUploaded: (imageFile) async {
        await store.dispatch(ResizeBannerImageAction(store.state.mainSettingsPageState, imageFile));
        store.dispatch(SavePreviewBrandingAction(store.state.mainSettingsPageState));
      },
      onBannerImageSelected: (isBannerImageSelected) async {
        await store.dispatch(SetBannerSelectionAction(store.state.mainSettingsPageState, isBannerImageSelected));
        store.dispatch(SavePreviewBrandingAction(store.state.mainSettingsPageState));
      },
      onPublishChangesSelected: () => store.dispatch(SaveBrandingAction(store.state.mainSettingsPageState)),
      onBannerWebUploaded: (imageFile) async {
        await store.dispatch(ResizeBannerWebImageAction(store.state.mainSettingsPageState, imageFile));
        store.dispatch(SavePreviewBrandingAction(store.state.mainSettingsPageState));
      },
      onBannerMobileUploaded: (imageFile) async {
        await store.dispatch(ResizeBannerMobileImageAction(store.state.mainSettingsPageState, imageFile));
        store.dispatch(SavePreviewBrandingAction(store.state.mainSettingsPageState));
      },
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
      bannerImage.hashCode ^
      onBannerUploaded.hashCode ^
      logoImageSelected.hashCode ^
      lastName.hashCode ^
      showPublishButton.hashCode ^
      businessName.hashCode ^
      onFirstNameChanged.hashCode ^
      onLastNameChanged.hashCode ^
      onBusinessNameChanged.hashCode ^
      onSaveUpdatedProfile.hashCode ^
      bannerImageSelected.hashCode ^
      onBannerImageSelected.hashCode ^
      profile.hashCode ^
      onSendSuggestionSelected.hashCode ^
      onDeleteAccountSelected.hashCode ^
      isDeleteFinished.hashCode ^
      onPublishChangesSelected.hashCode ^
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
      onInstaUrlChanged.hashCode ^
      currentBannerColor.hashCode ^
      currentIconColor.hashCode ^
      currentButtonColor.hashCode ^
      currentButtonTextColor.hashCode ^
      currentIconFont.hashCode ^
      currentFont.hashCode ^
      onColorSaved.hashCode ^
      logoCharacter.hashCode ^
      onFontSaved.hashCode ^
      bannerWebImage.hashCode ^
      bannerMobileImage.hashCode ^
      onBannerWebUploaded.hashCode ^
      onBannerMobileUploaded.hashCode ^
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
              onPublishChangesSelected == other.onPublishChangesSelected &&
              instaUrl == other.instaUrl &&
              onFirstNameChanged == other.onFirstNameChanged &&
              onLastNameChanged == other.onLastNameChanged &&
              onBusinessNameChanged == other.onBusinessNameChanged &&
              onSaveUpdatedProfile == other.onSaveUpdatedProfile &&
              profile == other.profile &&
              bannerImageSelected == other.bannerImageSelected &&
              onBannerImageSelected == other.onBannerImageSelected &&
              bannerImage == other.bannerImage &&
              onBannerUploaded == other.onBannerUploaded &&
              currentIconTextColor == other.currentIconTextColor &&
              onSendSuggestionSelected == other.onSendSuggestionSelected &&
              onDeleteAccountSelected == other.onDeleteAccountSelected &&
              isDeleteFinished == other.isDeleteFinished &&
              isDeleteInProgress == other.isDeleteInProgress &&
              password == other.password &&
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
              currentFont == other.currentFont &&
              logoCharacter == other.logoCharacter &&
              onColorSaved == other.onColorSaved &&
              onFontSaved == other.onFontSaved &&
              bannerWebImage == other.bannerWebImage &&
              bannerMobileImage == other.bannerMobileImage &&
              onBannerWebUploaded == other.onBannerWebUploaded &&
              onBannerMobileUploaded == other.onBannerMobileUploaded &&
              onSignOutSelected == other.onSignOutSelected;
}