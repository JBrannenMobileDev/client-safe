import 'dart:io';
import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/ColorTheme.dart';
import 'package:dandylight/models/Contract.dart';
import 'package:dandylight/models/FontTheme.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/edit_branding_page/EditBrandingPageActions.dart';
import 'package:dandylight/pages/share_with_client_page/ShareWithClientActions.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:dandylight/utils/analytics/EventNames.dart';
import 'package:dandylight/utils/analytics/EventSender.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';

import '../../data_layer/local_db/daos/ContractTemplateDao.dart';
import '../../data_layer/repositories/FileStorage.dart';
import '../../utils/UUID.dart';
import '../dashboard_page/DashboardPageActions.dart';
import 'package:image/image.dart' as img;

import 'EditBrandingPageState.dart';

class EditBrandingPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is ResizeLogoImageAction) {
      _resizeImage(store, action, next);
    }
    if(action is ResizeBannerImageAction) {
      _resizeBannerImage(store, action, next);
    }
    if(action is ResizeBannerWebImageAction) {
      _resizeBannerWebImage(store, action, next);
    }
    if(action is ResizeBannerMobileImageAction) {
      _resizeBannerMobileImage(store, action, next);
    }
    if(action is SaveBrandingAction) {
      _saveBranding(store, action, next);
    }
    if(action is SavePreviewBrandingAction) {
      _savePreviewBranding(store, action, next);
    }
    if(action is ClearBrandingPreviewStateAction) {
      _resetBrandingPreviewInProfile(store, action);
    }
  }

  void _resetBrandingPreviewInProfile(Store<AppState> store, ClearBrandingPreviewStateAction action) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    await ContractTemplateDao.syncAllFromFireStore();
    Contract contractTemplate = (await ContractTemplateDao.getAll()).first;
    profile.previewJsonContract = contractTemplate.jsonTerms;
    profile.previewLogoSelected = profile.logoSelected;
    profile.previewBannerImageSelected = profile.bannerImageSelected;
    profile.previewColorTheme = profile.selectedColorTheme;
    profile.previewFontTheme = profile.selectedFontTheme;
    profile.previewLogoCharacter = profile.logoCharacter;
    profile.previewBannerWebUrl = profile.bannerWebUrl;
    profile.previewLogoUrl = profile.logoUrl;
    profile.previewBannerMobileUrl = profile.bannerMobileUrl;
    store.dispatch(InitializeBranding(store.state.editBrandingPageState, profile));
    await ProfileDao.update(profile);
  }

  void _savePreviewBranding(Store<AppState> store, SavePreviewBrandingAction action, NextDispatcher next) async {
    savePreview(action.pageState, store);
  }

  void savePreview(EditBrandingPageState pageState, Store<AppState> store) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    ColorTheme colorTheme = ColorTheme(
      themeName: 'default',
      iconColor: ColorConstants.getHex(pageState.currentIconColor),
      iconTextColor: ColorConstants.getHex(pageState.currentIconTextColor),
      buttonColor: ColorConstants.getHex(pageState.currentButtonColor),
      buttonTextColor: ColorConstants.getHex(pageState.currentButtonTextColor),
      bannerColor: ColorConstants.getHex(pageState.currentBannerColor),
    );

    FontTheme fontTheme = FontTheme(
        themeName: 'default',
        iconFont: pageState.currentIconFont,
        mainFont: pageState.currentFont
    );

    profile.previewLogoSelected = pageState.logoImageSelected;
    profile.previewBannerImageSelected = pageState.bannerImageSelected;
    profile.previewColorTheme = colorTheme;
    profile.previewFontTheme = fontTheme;
    profile.previewLogoCharacter = pageState.logoCharacter;

    await ProfileDao.update(profile);
    if(pageState.logoImageSelected && pageState.resizedLogoImage != null) {
      FileStorage.saveProfilePreviewIconImageFile(pageState.resizedLogoImage.path, profile, (taskSnapshot) => handleImageUploadProgress(taskSnapshot, store));
    }

    if(pageState.bannerImageSelected && pageState.bannerWebImage != null && pageState.bannerMobileImage != null) {
      FileStorage.savePreviewBannerWebImageFile(pageState.bannerWebImage.path, profile, (taskSnapshot) => () => {});
      FileStorage.savePreviewBannerMobileImageFile(pageState.bannerMobileImage.path, profile, (taskSnapshot) => handleImageUploadProgress(taskSnapshot, store));
    }
  }

  void _saveBranding(Store<AppState> store, SaveBrandingAction action, NextDispatcher next) async {
    ColorTheme colorTheme = ColorTheme(
      themeName: 'default',
      iconColor: ColorConstants.getHex(action.pageState.currentIconColor),
      iconTextColor: ColorConstants.getHex(action.pageState.currentIconTextColor),
      buttonColor: ColorConstants.getHex(action.pageState.currentButtonColor),
      buttonTextColor: ColorConstants.getHex(action.pageState.currentButtonTextColor),
      bannerColor: ColorConstants.getHex(action.pageState.currentBannerColor),
    );

    FontTheme fontTheme = FontTheme(
      themeName: 'default',
      iconFont: action.pageState.currentIconFont,
      mainFont: action.pageState.currentFont
    );

    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.logoSelected = action.pageState.logoImageSelected;
    profile.bannerImageSelected = action.pageState.bannerImageSelected;
    profile.selectedColorTheme = colorTheme;
    profile.selectedFontTheme = fontTheme;
    profile.logoCharacter = action.pageState.logoCharacter;
    profile.hasSetupBrand = true;
    EventSender().setUserProfileData(EventNames.IS_BRANDING_SETUP_COMPLETE, true);

    await ProfileDao.update(profile);
    if(action.pageState.logoImageSelected && action.pageState.resizedLogoImage != null) {
      FileStorage.saveProfileIconImageFile(action.pageState.resizedLogoImage.path, action.pageState.profile, (taskSnapshot) => handleImageUploadProgress(taskSnapshot, store));
    }
    if(action.pageState.bannerImageSelected && action.pageState.bannerWebImage != null && action.pageState.bannerMobileImage != null) {
      FileStorage.saveBannerWebImageFile(action.pageState.bannerWebImage.path, action.pageState.profile, (taskSnapshot) => handleImageUploadProgress(taskSnapshot, store));
      FileStorage.saveBannerMobileImageFile(action.pageState.bannerMobileImage.path, action.pageState.profile, (taskSnapshot) => handleImageUploadProgress(taskSnapshot, store));
    }

    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    store.dispatch(FetchProfileAction(store.state.shareWithClientPageState));

    EventSender().sendEvent(eventName: EventNames.BRANDING_PUBLISHED_CHANGES);
  }

  void _resizeImage(Store<AppState> store, ResizeLogoImageAction action, NextDispatcher next) async {
    final Directory appDocumentDirectory = await getApplicationDocumentsDirectory();
    final String uniqueFileName = Uuid().generateV4();
    final cmdLarge = img.Command()
      ..decodeImageFile(action.image.path)
      ..copyResize(width: 300)
      ..writeToFile(appDocumentDirectory.path + '/$uniqueFileName' + 'logo.jpg');
    await cmdLarge.execute();
    XFile resizedImage = XFile(appDocumentDirectory.path + '/$uniqueFileName' + 'logo.jpg');
    await store.dispatch(SetResizedLogoImageAction(store.state.editBrandingPageState, resizedImage));
    savePreview(store.state.editBrandingPageState, store);
  }

  void _resizeBannerImage(Store<AppState> store, ResizeBannerImageAction action, NextDispatcher next) async {
    XFile resizedImage = XFile(action.image.path);
    store.dispatch(SetResizedBannerImageAction(store.state.editBrandingPageState, resizedImage));
  }

  void _resizeBannerWebImage(Store<AppState> store, ResizeBannerWebImageAction action, NextDispatcher next) async {
    final Directory appDocumentDirectory = await getApplicationDocumentsDirectory();
    final String uniqueFileName = Uuid().generateV4();
    final cmdLarge = img.Command()
      ..decodeImageFile(action.image.path)
      ..copyResize(width: 1920)
      ..writeToFile(appDocumentDirectory.path + '/$uniqueFileName' + 'banner.jpg');
    await cmdLarge.execute();
    XFile resizedImage = XFile(appDocumentDirectory.path + '/$uniqueFileName' + 'banner.jpg');
    store.dispatch(SetResizedBannerWebImageAction(store.state.editBrandingPageState, resizedImage));
    savePreview(store.state.editBrandingPageState, store);
  }

  void _resizeBannerMobileImage(Store<AppState> store, ResizeBannerMobileImageAction action, NextDispatcher next) async {
    final Directory appDocumentDirectory = await getApplicationDocumentsDirectory();
    final String uniqueFileName = Uuid().generateV4();
    final cmdLarge = img.Command()
      ..decodeImageFile(action.image.path)
      ..copyResize(width: 1080)
      ..writeToFile(appDocumentDirectory.path + '/$uniqueFileName' + 'banner.jpg');
    await cmdLarge.execute();
    XFile resizedImage = XFile(appDocumentDirectory.path + '/$uniqueFileName' + 'banner.jpg');
    store.dispatch(SetResizedBannerMobileImageAction(store.state.editBrandingPageState, resizedImage));
    savePreview(store.state.editBrandingPageState, store);
  }

  void handleImageUploadProgress(TaskSnapshot taskSnapshot, Store<AppState> store) {
    store.dispatch(SetImageUploadProgressStateAction(
      store.state.editBrandingPageState,
        (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes) < 1.0,
      (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes)
    ));
  }
}