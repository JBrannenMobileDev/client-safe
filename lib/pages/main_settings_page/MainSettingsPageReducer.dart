import 'package:dandylight/pages/main_settings_page/MainSettingsPageActions.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:redux/redux.dart';

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
]);

MainSettingsPageState _setBannerColor(MainSettingsPageState previousState, SaveBannerColorAction action){
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
  return previousState.copyWith(
    currentBannerColor: action.pageState.currentBannerColor,
    currentButtonColor: action.pageState.currentButtonColor,
    currentButtonTextColor: action.pageState.currentButtonTextColor,
    currentIconColor: action.pageState.currentIconColor,
    currentIconTextColor: action.pageState.currentIconTextColor,
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
