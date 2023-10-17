import 'dart:ui';

import 'package:dandylight/models/Profile.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/ColorTheme.dart';
import '../../models/FontTheme.dart';
import 'EditBrandingPageState.dart';

class LoadUserProfileDataAction{
  final EditBrandingPageState pageState;
  final Profile profile;
  LoadUserProfileDataAction(this.pageState, this.profile);
}

class RemoveDeletedThemeAction {
  final EditBrandingPageState pageState;
  final ColorTheme themeToDelete;
  RemoveDeletedThemeAction(this.pageState, this.themeToDelete);
}

class SetLogoSelectionAction {
  final EditBrandingPageState pageState;
  final bool isLogoSelected;
  SetLogoSelectionAction(this.pageState, this.isLogoSelected);
}

class SetBannerSelectionAction {
  final EditBrandingPageState pageState;
  final bool isBannerSelected;
  SetBannerSelectionAction(this.pageState, this.isBannerSelected);
}

class SaveColorAction {
  final EditBrandingPageState pageState;
  final Color color;
  final String id;
  SaveColorAction(this.pageState, this.color, this.id);
}

class SetSelectedFontThemeAction {
  final EditBrandingPageState pageState;
  final FontTheme theme;
  SetSelectedFontThemeAction(this.pageState, this.theme);
}

class ClearBrandingPreviewStateAction {
  final EditBrandingPageState pageState;
  ClearBrandingPreviewStateAction(this.pageState);
}

class SetSelectedFontAction {
  final EditBrandingPageState pageState;
  final String fontFamily;
  final String id;
  SetSelectedFontAction(this.pageState, this.fontFamily, this.id);
}

class ResetFontsAction {
  final EditBrandingPageState pageState;
  ResetFontsAction(this.pageState);
}

class SetLogoLetterAction {
  final EditBrandingPageState pageState;
  final String logoLetter;
  SetLogoLetterAction(this.pageState, this.logoLetter);
}

class SetColorThemeAction {
  final EditBrandingPageState pageState;
  final ColorTheme theme;
  SetColorThemeAction(this.pageState, this.theme);
}

class SetFontThemeAction {
  final EditBrandingPageState pageState;
  final FontTheme theme;
  SetFontThemeAction(this.pageState, this.theme);
}

class ResizeLogoImageAction {
  final EditBrandingPageState pageState;
  final XFile image;
  ResizeLogoImageAction(this.pageState, this.image);
}

class ResizeBannerImageAction {
  final EditBrandingPageState pageState;
  final XFile image;
  ResizeBannerImageAction(this.pageState, this.image);
}

class ResizeBannerWebImageAction {
  final EditBrandingPageState pageState;
  final XFile image;
  ResizeBannerWebImageAction(this.pageState, this.image);
}

class ResizeBannerMobileImageAction {
  final EditBrandingPageState pageState;
  final XFile image;
  ResizeBannerMobileImageAction(this.pageState, this.image);
}

class SavePreviewBrandingAction {
  final EditBrandingPageState pageState;
  SavePreviewBrandingAction(this.pageState);
}

class SaveBrandingAction {
  final EditBrandingPageState pageState;
  SaveBrandingAction(this.pageState);
}

class SetResizedLogoImageAction {
  final EditBrandingPageState pageState;
  final XFile resizedLogoImage;
  SetResizedLogoImageAction(this.pageState, this.resizedLogoImage);
}

class SetResizedBannerImageAction {
  final EditBrandingPageState pageState;
  final XFile resizedBannerImage;
  SetResizedBannerImageAction(this.pageState, this.resizedBannerImage);
}

class SetResizedBannerWebImageAction {
  final EditBrandingPageState pageState;
  final XFile resizedImage;
  SetResizedBannerWebImageAction(this.pageState, this.resizedImage);
}

class SetResizedBannerMobileImageAction {
  final EditBrandingPageState pageState;
  final XFile resizedImage;
  SetResizedBannerMobileImageAction(this.pageState, this.resizedImage);
}

class SetImageUploadProgressStateAction{
  final EditBrandingPageState pageState;
  final bool inProgress;
  final double progress;
  SetImageUploadProgressStateAction(this.pageState, this.inProgress, this.progress);
}

class InitializeBranding {
  final EditBrandingPageState pageState;
  final Profile profile;
  InitializeBranding(this.pageState, this.profile);
}

