import 'package:dandylight/models/FontTheme.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../utils/ColorConstants.dart';
import 'EditBrandingPageActions.dart';

class EditBrandingPageState{
  final Profile profile;
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
  final double uploadProgress;
  final bool uploadInProgress;
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
  final Function() clearBrandingState;

  EditBrandingPageState({
    @required this.profile,
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
    @required this.uploadInProgress,
    @required this.uploadProgress,
    @required this.clearBrandingState,
  });

  EditBrandingPageState copyWith({
    Profile profile,
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
    double uploadProgress,
    bool uploadInProgress,
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
    Function() clearBrandingState,
  }){
    return EditBrandingPageState(
      profile: profile ?? this.profile,
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
      uploadProgress: uploadProgress ?? this.uploadProgress,
      uploadInProgress: uploadInProgress ?? this.uploadInProgress,
      clearBrandingState: clearBrandingState ?? this.clearBrandingState,
    );
  }

  factory EditBrandingPageState.initial() => EditBrandingPageState(
    profile: null,
    onLogoUploaded: null,
    resizedLogoImage: null,
    logoImageSelected: false,
    onLogoImageSelected: null,
    logoCharacter: ' ',
    currentBannerColor: Color(ColorConstants.getBlueDark()),
    currentIconTextColor: Color(ColorConstants.getWhiteWhite()),
    currentIconColor: Color(ColorConstants.getPeachDark()),
    currentButtonColor: Color(ColorConstants.getPeachDark()),
    currentButtonTextColor: Color(ColorConstants.getPrimaryWhite()),
    currentIconFont: FontTheme.Moredya,
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
    uploadProgress: 0.0,
    uploadInProgress: false,
    clearBrandingState: null,
  );

  factory EditBrandingPageState.fromStore(Store<AppState> store) {
    return EditBrandingPageState(
      profile: store.state.editBrandingPageState.profile,
      logoImageSelected: store.state.editBrandingPageState.logoImageSelected,
      resizedLogoImage: store.state.editBrandingPageState.resizedLogoImage,
      currentBannerColor: store.state.editBrandingPageState.currentBannerColor,
      currentButtonColor: store.state.editBrandingPageState.currentButtonColor,
      currentButtonTextColor: store.state.editBrandingPageState.currentButtonTextColor,
      currentIconColor: store.state.editBrandingPageState.currentIconColor,
      currentIconFont: store.state.editBrandingPageState.currentIconFont,
      currentFont: store.state.editBrandingPageState.currentFont,
      currentIconTextColor: store.state.editBrandingPageState.currentIconTextColor,
      showPublishButton: store.state.editBrandingPageState.showPublishButton,
      logoCharacter: store.state.editBrandingPageState.logoCharacter,
      bannerImage: store.state.editBrandingPageState.bannerImage,
      bannerImageSelected: store.state.editBrandingPageState.bannerImageSelected,
      bannerWebImage: store.state.editBrandingPageState.bannerWebImage,
      bannerMobileImage: store.state.editBrandingPageState.bannerMobileImage,
      uploadProgress: store.state.editBrandingPageState.uploadProgress,
      uploadInProgress: store.state.editBrandingPageState.uploadInProgress,
      clearBrandingState: () => store.dispatch(ClearBrandingPreviewStateAction(store.state.editBrandingPageState)),
      onLogoUploaded: (imageFile) async {
        await store.dispatch(ResizeLogoImageAction(store.state.editBrandingPageState, imageFile));
      },
      onLogoImageSelected: (isLogoImageSelected) async {
        await store.dispatch(SetLogoSelectionAction(store.state.editBrandingPageState, isLogoImageSelected));
        store.dispatch(SavePreviewBrandingAction(store.state.editBrandingPageState));
      },
      onColorSaved: (color, id) async {
        await store.dispatch(SaveColorAction(store.state.editBrandingPageState, color, id));
        store.dispatch(SavePreviewBrandingAction(store.state.editBrandingPageState));
      },
      onFontSaved: (fontFamily, id) async {
        store.dispatch(SetSelectedFontAction(store.state.editBrandingPageState, fontFamily, id));
        store.dispatch(SavePreviewBrandingAction(store.state.editBrandingPageState));
      },
      onLogoLetterChanged: (logoLetter) async {
        await store.dispatch(SetLogoLetterAction(store.state.editBrandingPageState, logoLetter));
        store.dispatch(SavePreviewBrandingAction(store.state.editBrandingPageState));
      },
      onBannerUploaded: (imageFile) async {
        await store.dispatch(ResizeBannerImageAction(store.state.editBrandingPageState, imageFile));
        store.dispatch(SavePreviewBrandingAction(store.state.editBrandingPageState));
      },
      onBannerImageSelected: (isBannerImageSelected) async {
        await store.dispatch(SetBannerSelectionAction(store.state.editBrandingPageState, isBannerImageSelected));
        store.dispatch(SavePreviewBrandingAction(store.state.editBrandingPageState));
      },
      onPublishChangesSelected: () => store.dispatch(SaveBrandingAction(store.state.editBrandingPageState)),
      onBannerWebUploaded: (imageFile) async {
        await store.dispatch(ResizeBannerWebImageAction(store.state.editBrandingPageState, imageFile));
        store.dispatch(SavePreviewBrandingAction(store.state.editBrandingPageState));
      },
      onBannerMobileUploaded: (imageFile) async {
        await store.dispatch(ResizeBannerMobileImageAction(store.state.editBrandingPageState, imageFile));
        store.dispatch(SavePreviewBrandingAction(store.state.editBrandingPageState));
      },
    );
  }

  @override
  int get hashCode =>
      onLogoUploaded.hashCode ^
      resizedLogoImage.hashCode ^
      bannerImage.hashCode ^
      onBannerUploaded.hashCode ^
      clearBrandingState.hashCode ^
      logoImageSelected.hashCode ^
      showPublishButton.hashCode ^
      bannerImageSelected.hashCode ^
      onBannerImageSelected.hashCode ^
      profile.hashCode ^
      onPublishChangesSelected.hashCode ^
      currentIconTextColor.hashCode ^
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
      uploadProgress.hashCode ^
      uploadInProgress.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is EditBrandingPageState &&
              onLogoUploaded == other.onLogoUploaded &&
              resizedLogoImage == other.resizedLogoImage &&
              showPublishButton == other.showPublishButton &&
              onPublishChangesSelected == other.onPublishChangesSelected &&
              profile == other.profile &&
              clearBrandingState == other.clearBrandingState &&
              bannerImageSelected == other.bannerImageSelected &&
              onBannerImageSelected == other.onBannerImageSelected &&
              bannerImage == other.bannerImage &&
              onBannerUploaded == other.onBannerUploaded &&
              currentIconTextColor == other.currentIconTextColor &&
              logoImageSelected == other.logoImageSelected &&
              currentBannerColor == other.currentBannerColor &&
              currentIconColor == other.currentIconColor &&
              currentButtonColor == other.currentButtonColor &&
              currentButtonTextColor == other.currentButtonTextColor &&
              currentIconFont == other.currentIconFont &&
              currentFont == other.currentFont &&
              uploadProgress == other.uploadProgress &&
              uploadInProgress == other.uploadInProgress &&
              logoCharacter == other.logoCharacter &&
              onColorSaved == other.onColorSaved &&
              onFontSaved == other.onFontSaved &&
              bannerWebImage == other.bannerWebImage &&
              bannerMobileImage == other.bannerMobileImage &&
              onBannerWebUploaded == other.onBannerWebUploaded &&
              onBannerMobileUploaded == other.onBannerMobileUploaded;
}