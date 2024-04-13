
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';

import '../../models/LocationDandy.dart';

class UpdatePushNotificationEnabled{
  final MainSettingsPageState? pageState;
  final bool? enabled;
  UpdatePushNotificationEnabled(this.pageState, this.enabled);
}

class SetHomeLocationToState {
  final MainSettingsPageState? pageState;
  final Profile? profile;
  final String?  address;
  SetHomeLocationToState(this.pageState, this.profile, this.address);
}

class SetHomeAddressNameAction {
  final MainSettingsPageState? pageState;
  final String?  homeLocationName;
  SetHomeAddressNameAction(this.pageState, this.homeLocationName);
}

class SaveMainSettingsHomeLocationAction{
  final MainSettingsPageState? pageState;
  final LocationDandy?  startLocation;
  SaveMainSettingsHomeLocationAction(this.pageState, this.startLocation);
}

class UpdateCalendarEnabled{
  final MainSettingsPageState? pageState;
  final bool? enabled;
  UpdateCalendarEnabled(this.pageState, this.enabled);
}

class LoadUserProfileDataAction{
  final MainSettingsPageState? pageState;
  final Profile? profile;
  LoadUserProfileDataAction(this.pageState, this.profile);
}

class LoadSettingsFromProfile{
  final MainSettingsPageState? pageState;
  LoadSettingsFromProfile(this.pageState);
}

class SavePushNotificationSettingAction{
  final MainSettingsPageState? pageState;
  final bool? enabled;
  SavePushNotificationSettingAction(this.pageState, this.enabled);
}

class SaveCalendarSettingAction{
  final MainSettingsPageState? pageState;
  final bool? enabled;
  SaveCalendarSettingAction(this.pageState, this.enabled);
}

class SetFirstNameAction{
  final MainSettingsPageState? pageState;
  final String?  name;
  SetFirstNameAction(this.pageState, this.name);
}

class SetLastNameAction{
  final MainSettingsPageState? pageState;
  final String?  name;
  SetLastNameAction(this.pageState, this.name);
}

class SetBusinessNameAction{
  final MainSettingsPageState? pageState;
  final String?  name;
  SetBusinessNameAction(this.pageState, this.name);
}

class SetBusinessEmailAction{
  final MainSettingsPageState? pageState;
  final String?  email;
  SetBusinessEmailAction(this.pageState, this.email);
}

class SetBusinessPhoneAction{
  final MainSettingsPageState? pageState;
  final String?  phone;
  SetBusinessPhoneAction(this.pageState, this.phone);
}

class SaveUpdatedUserProfileAction{
  final MainSettingsPageState? pageState;
  SaveUpdatedUserProfileAction(this.pageState);
}

class RemoveDeviceTokenAction{
  final MainSettingsPageState? pageState;
  RemoveDeviceTokenAction(this.pageState);
}

class SendSuggestionAction{
  final MainSettingsPageState? pageState;
  final String?  suggestion;
  SendSuggestionAction(this.pageState, this.suggestion);
}

class DeleteAccountAction {
  final MainSettingsPageState? pageState;
  DeleteAccountAction(this.pageState);
}

class SetDeleteProgressAction {
  final MainSettingsPageState? pageState;
  final bool? isInProgressDeleting;
  SetDeleteProgressAction(this.pageState, this.isInProgressDeleting);
}

class SetPasswordErrorAction {
  final MainSettingsPageState? pageState;
  SetPasswordErrorAction(this.pageState);
}

class SavePasswordAction {
  final MainSettingsPageState? pageState;
  final String?  password;
  SavePasswordAction(this.pageState, this.password);
}

class Generate50DiscountCodeAction {
  final MainSettingsPageState? pageState;
  Generate50DiscountCodeAction(this.pageState);
}

class GenerateFreeDiscountCodeAction {
  final MainSettingsPageState? pageState;
  GenerateFreeDiscountCodeAction(this.pageState);
}

class GenerateFirst3MonthsFreeCodeAction {
  final MainSettingsPageState? pageState;
  GenerateFirst3MonthsFreeCodeAction(this.pageState);
}

class SetDiscountCodeAction {
  final MainSettingsPageState? pageState;
  final String?  discountCode;
  SetDiscountCodeAction(this.pageState, this.discountCode);
}

class SetIsAdminAction {
  final MainSettingsPageState? pageState;
  final bool? isAdmin;
  SetIsAdminAction(this.pageState, this.isAdmin);
}

class SetUrlToStateAction {
  final MainSettingsPageState? pageState;
  final String?  instaUrl;
  SetUrlToStateAction(this.pageState, this.instaUrl);
}

class PopulateAccountWithData {
  final MainSettingsPageState? pageState;
  PopulateAccountWithData(this.pageState);
}

