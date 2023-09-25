import 'dart:ui';

import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/ColorTheme.dart';
import '../../models/FontTheme.dart';

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

class SetBannerSelectionAction {
  final MainSettingsPageState pageState;
  final bool isBannerSelected;
  SetBannerSelectionAction(this.pageState, this.isBannerSelected);
}

class SaveColorAction {
  final MainSettingsPageState pageState;
  final Color color;
  final String id;
  SaveColorAction(this.pageState, this.color, this.id);
}

class SetSelectedFontThemeAction {
  final MainSettingsPageState pageState;
  final FontTheme theme;
  SetSelectedFontThemeAction(this.pageState, this.theme);
}

class ClearBrandingStateAction {
  final MainSettingsPageState pageState;
  final Profile profile;
  ClearBrandingStateAction(this.pageState, this.profile);
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

class SetLogoLetterAction {
  final MainSettingsPageState pageState;
  final String logoLetter;
  SetLogoLetterAction(this.pageState, this.logoLetter);
}

class SetColorThemeAction {
  final MainSettingsPageState pageState;
  final ColorTheme theme;
  SetColorThemeAction(this.pageState, this.theme);
}

class SetFontThemeAction {
  final MainSettingsPageState pageState;
  final FontTheme theme;
  SetFontThemeAction(this.pageState, this.theme);
}

class ResizeLogoImageAction {
  final MainSettingsPageState pageState;
  final XFile image;
  ResizeLogoImageAction(this.pageState, this.image);
}

class ResizeBannerImageAction {
  final MainSettingsPageState pageState;
  final XFile image;
  ResizeBannerImageAction(this.pageState, this.image);
}

class ResizeBannerWebImageAction {
  final MainSettingsPageState pageState;
  final XFile image;
  ResizeBannerWebImageAction(this.pageState, this.image);
}

class ResizeBannerMobileImageAction {
  final MainSettingsPageState pageState;
  final XFile image;
  ResizeBannerMobileImageAction(this.pageState, this.image);
}

class SavePreviewBrandingAction {
  final MainSettingsPageState pageState;
  SavePreviewBrandingAction(this.pageState);
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

class SetResizedBannerImageAction {
  final MainSettingsPageState pageState;
  final XFile resizedBannerImage;
  SetResizedBannerImageAction(this.pageState, this.resizedBannerImage);
}

class SetResizedBannerWebImageAction {
  final MainSettingsPageState pageState;
  final XFile resizedImage;
  SetResizedBannerWebImageAction(this.pageState, this.resizedImage);
}

class SetResizedBannerMobileImageAction {
  final MainSettingsPageState pageState;
  final XFile resizedImage;
  SetResizedBannerMobileImageAction(this.pageState, this.resizedImage);
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

class SetBusinessEmailAction{
  final MainSettingsPageState pageState;
  final String email;
  SetBusinessEmailAction(this.pageState, this.email);
}

class SetBusinessPhoneAction{
  final MainSettingsPageState pageState;
  final String phone;
  SetBusinessPhoneAction(this.pageState, this.phone);
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

class SetImageUploadProgressStateAction{
  final MainSettingsPageState pageState;
  final bool inProgress;
  final double progress;
  SetImageUploadProgressStateAction(this.pageState, this.inProgress, this.progress);
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

