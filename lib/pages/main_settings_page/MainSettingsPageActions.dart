import 'dart:ui';

import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/ColorTheme.dart';

class UpdatePushNotificationEnabled{
  final MainSettingsPageState pageState;
  final bool enabled;
  UpdatePushNotificationEnabled(this.pageState, this.enabled);
}

class UpdateCalendarEnabled{
  final MainSettingsPageState pageState;
  final bool enabled;
  UpdateCalendarEnabled(this.pageState, this.enabled);
}

class LoadUserProfileDataAction{
  final MainSettingsPageState pageState;
  final Profile profile;
  LoadUserProfileDataAction(this.pageState, this.profile);
}

class RemoveDeletedThemeAction {
  final MainSettingsPageState pageState;
  final ColorTheme themeToDelete;
  RemoveDeletedThemeAction(this.pageState, this.themeToDelete);
}

class SetLogoSelectionAction {
  final MainSettingsPageState pageState;
  final bool isLogoSelected;
  SetLogoSelectionAction(this.pageState, this.isLogoSelected);
}

class SaveColorAction {
  final MainSettingsPageState pageState;
  final Color color;
  final String id;
  SaveColorAction(this.pageState, this.color, this.id);
}

class SaveColorThemeAction {
  final MainSettingsPageState pageState;
  final String themeName;
  SaveColorThemeAction(this.pageState, this.themeName);
}

class DeleteColorThemeAction {
  final MainSettingsPageState pageState;
  final ColorTheme theme;
  DeleteColorThemeAction(this.pageState, this.theme);
}

class SetSelectedColorThemeAction {
  final MainSettingsPageState pageState;
  final ColorTheme theme;
  SetSelectedColorThemeAction(this.pageState, this.theme);
}

class ClearBrandingStateAction {
  final MainSettingsPageState pageState;
  final Profile profile;
  ClearBrandingStateAction(this.pageState, this.profile);
}

class ResetColorsAction {
  final MainSettingsPageState pageState;
  ResetColorsAction(this.pageState);
}

class SetSelectedFontAction {
  final MainSettingsPageState pageState;
  final String fontFamily;
  final String id;
  SetSelectedFontAction(this.pageState, this.fontFamily, this.id);
}

class ResetFontsAction {
  final MainSettingsPageState pageState;
  ResetFontsAction(this.pageState);
}

class SetColorThemeAction {
  final MainSettingsPageState pageState;
  final ColorTheme theme;
  SetColorThemeAction(this.pageState, this.theme);
}

class ResizeLogoImageAction {
  final MainSettingsPageState pageState;
  final XFile image;
  ResizeLogoImageAction(this.pageState, this.image);
}

class SaveBrandingAction {
  final MainSettingsPageState pageState;
  SaveBrandingAction(this.pageState);
}

class SetResizedLogoImageAction {
  final MainSettingsPageState pageState;
  final XFile resizedLogoImage;
  SetResizedLogoImageAction(this.pageState, this.resizedLogoImage);
}

class LoadSettingsFromProfile{
  final MainSettingsPageState pageState;
  LoadSettingsFromProfile(this.pageState);
}

class SavePushNotificationSettingAction{
  final MainSettingsPageState pageState;
  final bool enabled;
  SavePushNotificationSettingAction(this.pageState, this.enabled);
}

class SaveCalendarSettingAction{
  final MainSettingsPageState pageState;
  final bool enabled;
  SaveCalendarSettingAction(this.pageState, this.enabled);
}

class SetFirstNameAction{
  final MainSettingsPageState pageState;
  final String name;
  SetFirstNameAction(this.pageState, this.name);
}

class SetLastNameAction{
  final MainSettingsPageState pageState;
  final String name;
  SetLastNameAction(this.pageState, this.name);
}

class SetBusinessNameAction{
  final MainSettingsPageState pageState;
  final String name;
  SetBusinessNameAction(this.pageState, this.name);
}

class SaveUpdatedUserProfileAction{
  final MainSettingsPageState pageState;
  SaveUpdatedUserProfileAction(this.pageState);
}

class RemoveDeviceTokenAction{
  final MainSettingsPageState pageState;
  RemoveDeviceTokenAction(this.pageState);
}

class SendSuggestionAction{
  final MainSettingsPageState pageState;
  final String suggestion;
  SendSuggestionAction(this.pageState, this.suggestion);
}

class DeleteAccountAction {
  final MainSettingsPageState pageState;
  DeleteAccountAction(this.pageState);
}

class SetDeleteProgressAction {
  final MainSettingsPageState pageState;
  final bool isInProgressDeleting;
  SetDeleteProgressAction(this.pageState, this.isInProgressDeleting);
}

class SetPasswordErrorAction {
  final MainSettingsPageState pageState;
  SetPasswordErrorAction(this.pageState);
}

class SavePasswordAction {
  final MainSettingsPageState pageState;
  final String password;
  SavePasswordAction(this.pageState, this.password);
}

class Generate50DiscountCodeAction {
  final MainSettingsPageState pageState;
  Generate50DiscountCodeAction(this.pageState);
}

class GenerateFreeDiscountCodeAction {
  final MainSettingsPageState pageState;
  GenerateFreeDiscountCodeAction(this.pageState);
}

class SetDiscountCodeAction {
  final MainSettingsPageState pageState;
  final String discountCode;
  SetDiscountCodeAction(this.pageState, this.discountCode);
}

class SetIsAdminAction {
  final MainSettingsPageState pageState;
  final bool isAdmin;
  SetIsAdminAction(this.pageState, this.isAdmin);
}

class SetUrlToStateAction {
  final MainSettingsPageState pageState;
  final String instaUrl;
  SetUrlToStateAction(this.pageState, this.instaUrl);
}

