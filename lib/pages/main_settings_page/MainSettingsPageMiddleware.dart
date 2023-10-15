import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/firebase/FirebaseAuthentication.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobTypeDao.dart';
import 'package:dandylight/data_layer/local_db/daos/PriceProfileDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/ColorTheme.dart';
import 'package:dandylight/models/Contract.dart';
import 'package:dandylight/models/DiscountCodes.dart';
import 'package:dandylight/models/FontTheme.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobType.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/Suggestion.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:dandylight/pages/share_with_client_page/ShareWithClientActions.dart';
import 'package:dandylight/utils/AdminCheckUtil.dart';
import 'package:dandylight/utils/CalendarSyncUtil.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/EnvironmentUtil.dart';
import 'package:dandylight/utils/NotificationHelper.dart';
import 'package:dandylight/utils/PushNotificationsManager.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:dandylight/utils/analytics/EventNames.dart';
import 'package:dandylight/utils/analytics/EventSender.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as purchases;
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

import '../../data_layer/local_db/SembastDb.dart';
import '../../data_layer/local_db/daos/ClientDao.dart';
import '../../data_layer/local_db/daos/ContractTemplateDao.dart';
import '../../data_layer/repositories/DiscountCodesRepository.dart';
import '../../data_layer/repositories/FileStorage.dart';
import '../../models/Client.dart';
import '../../models/Invoice.dart';
import '../../models/JobStage.dart';
import '../../models/Proposal.dart';
import '../../utils/UUID.dart';
import '../dashboard_page/DashboardPageActions.dart';
import '../login_page/LoginPageActions.dart';
import 'MainSettingsPageActions.dart';
import 'package:image/image.dart' as img;

class MainSettingsPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is LoadSettingsFromProfile){
      loadSettings(store, next);
    }
    if(action is SavePushNotificationSettingAction) {
      savePushNotificationSetting(store, action, next);
    }

    if(action is SaveCalendarSettingAction) {
      saveCalendarSetting(store, action, next);
    }
    if(action is SaveUpdatedUserProfileAction) {
      saveUpdatedUserProfile(store, action, next);
    }
    if(action is RemoveDeviceTokenAction){
      removeDeviceToken(store, action, next);
    }
    if(action is SendSuggestionAction) {
      sendSuggestion(store, action, next);
    }
    if(action is DeleteAccountAction) {
      deleteAccount(store, action);
    }
    if(action is Generate50DiscountCodeAction) {
      generate50DiscountCode(store, action, next);
    }
    if(action is GenerateFreeDiscountCodeAction) {
      generateFreeDiscountCode(store, action, next);
    }
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
    if(action is SavePreviewJsonContractAction) {
      _setPreviewJsonContract(store, action, next);
    }
    if(action is PopulateAccountWithData) {
      _generateAccountData(store, action, next);
    }
  }

  void _setPreviewJsonContract(Store<AppState> store, SavePreviewJsonContractAction action, NextDispatcher next) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    Contract contractTemplate = (await ContractTemplateDao.getAll()).first;
    profile.previewJsonContract = contractTemplate.jsonTerms;
    ProfileDao.update(profile);
  }

  void _savePreviewBranding(Store<AppState> store, SavePreviewBrandingAction action, NextDispatcher next) async {
    savePreview(action.pageState, store);
  }

  void savePreview(MainSettingsPageState pageState, Store<AppState> store) async {
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
      FileStorage.saveProfilePreviewIconImageFile(pageState.resizedLogoImage.path, pageState.profile, (taskSnapshot) => handleImageUploadProgress(taskSnapshot, store));
    }

    if(pageState.bannerImageSelected && pageState.bannerWebImage != null && pageState.bannerMobileImage != null) {
      FileStorage.savePreviewBannerWebImageFile(pageState.bannerWebImage.path, pageState.profile, (taskSnapshot) => () => {});
      FileStorage.savePreviewBannerMobileImageFile(pageState.bannerMobileImage.path, pageState.profile, (taskSnapshot) => handleImageUploadProgress(taskSnapshot, store));
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

    await ProfileDao.update(profile);
    if(action.pageState.logoImageSelected && action.pageState.resizedLogoImage != null) {
      await FileStorage.saveProfileIconImageFile(action.pageState.resizedLogoImage.path, action.pageState.profile, (taskSnapshot) => handleImageUploadProgress(taskSnapshot, store));
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
    await store.dispatch(SetResizedLogoImageAction(store.state.mainSettingsPageState, resizedImage));
    savePreview(store.state.mainSettingsPageState, store);
  }

  void _resizeBannerImage(Store<AppState> store, ResizeBannerImageAction action, NextDispatcher next) async {
    XFile resizedImage = XFile(action.image.path);
    store.dispatch(SetResizedBannerImageAction(store.state.mainSettingsPageState, resizedImage));
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
    store.dispatch(SetResizedBannerWebImageAction(store.state.mainSettingsPageState, resizedImage));
    savePreview(store.state.mainSettingsPageState, store);
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
    store.dispatch(SetResizedBannerMobileImageAction(store.state.mainSettingsPageState, resizedImage));
    savePreview(store.state.mainSettingsPageState, store);
  }

  void generate50DiscountCode(Store<AppState> store, Generate50DiscountCodeAction action, NextDispatcher next) async{
    String newCode = await DiscountCodesRepository().generateAndSaveCode(DiscountCodes.FIFTY_PERCENT_TYPE, action.pageState.instaUrl);
    store.dispatch(SetDiscountCodeAction(store.state.mainSettingsPageState, newCode));
  }

  void generateFreeDiscountCode(Store<AppState> store, GenerateFreeDiscountCodeAction action, NextDispatcher next) async{
    String newCode = await DiscountCodesRepository().generateAndSaveCode(DiscountCodes.LIFETIME_FREE, action.pageState.instaUrl);
    store.dispatch(SetDiscountCodeAction(store.state.mainSettingsPageState, newCode));
  }

  void loadSettings(Store<AppState> store, NextDispatcher next) async{
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    bool isAdmin = AdminCheckUtil.isAdmin(profile);
    store.dispatch(SetIsAdminAction(store.state.mainSettingsPageState, isAdmin));

    (await ProfileDao.getProfileStream()).listen((snapshots) async {
        List<Profile> profiles = [];
        for(RecordSnapshot profileSnapshot in snapshots) {
          profiles.add(Profile.fromMap(profileSnapshot.value));
        }
        if(profiles.length > 0) {
          store.dispatch(UpdatePushNotificationEnabled(store.state.mainSettingsPageState, profiles.elementAt(0)?.pushNotificationsEnabled ?? false));
          store.dispatch(UpdateCalendarEnabled(store.state.mainSettingsPageState, profiles.elementAt(0).calendarEnabled ?? false));
          store.dispatch(LoadUserProfileDataAction(store.state.mainSettingsPageState, profiles.elementAt(0)));
        }
      }
    );

    if(profile.selectedColorTheme != null) {
      store.dispatch(SetColorThemeAction(store.state.mainSettingsPageState, profile.selectedColorTheme));
    }
  }

  void savePushNotificationSetting(Store<AppState> store, SavePushNotificationSettingAction action, NextDispatcher next) async{
    Profile profile = (await ProfileDao.getAll()).elementAt(0);
    profile.pushNotificationsEnabled = action.enabled;
    if(profile.pushNotificationsEnabled) {
      await PushNotificationsManager().init();
      NotificationHelper().createAndUpdatePendingNotifications();
    } else {
      NotificationHelper().clearAll();
      // profile.removeDeviceToken(await PushNotificationsManager().getToken());
    }
    await ProfileDao.update(profile);
    EventSender().setUserProfileData(EventNames.NOTIFICATIONS_ENABLED, action.enabled);
    store.dispatch(UpdatePushNotificationEnabled(store.state.mainSettingsPageState, profile.pushNotificationsEnabled ?? false));
  }

  void removeDeviceToken(Store<AppState> store, RemoveDeviceTokenAction action, NextDispatcher next) async{
    List<Profile> profiles = await ProfileDao.getAll();
    await purchases.Purchases.logIn(profiles.elementAt(0).uid);
    if(profiles != null && profiles.isNotEmpty) {
      Profile profile = profiles.elementAt(0);
      // profile.removeDeviceToken(await PushNotificationsManager().getToken());
      await ProfileDao.update(profile);
    }
  }

  void saveCalendarSetting(Store<AppState> store, SaveCalendarSettingAction action, NextDispatcher next) async{
    Profile profile = (await ProfileDao.getAll()).elementAt(0);
    profile.calendarEnabled = action.enabled;
    await ProfileDao.update(profile);
    EventSender().setUserProfileData(EventNames.CALENDAR_SYNC_ENABLED, action.enabled);
    store.dispatch(UpdateCalendarEnabled(store.state.mainSettingsPageState, profile.calendarEnabled ?? false));
    if(!action.enabled) {
      CalendarSyncUtil.removeJobsFromDeviceCalendars();
    }
  }

  void saveUpdatedUserProfile(Store<AppState> store, SaveUpdatedUserProfileAction action, NextDispatcher next) async{
    Profile profile = (await ProfileDao.getAll()).elementAt(0);
    await ProfileDao.update(profile.copyWith(
      firstName: store.state.mainSettingsPageState.firstName,
      lastName: store.state.mainSettingsPageState.lastName,
      businessName: store.state.mainSettingsPageState.businessName,
      phone: TextFormatterUtil.formatPhoneNum(store.state.mainSettingsPageState.businessPhone),
      email: store.state.mainSettingsPageState.businessEmail,
    ));
    store.dispatch(FetchProfileAction(store.state.shareWithClientPageState));
  }

  void sendSuggestion(Store<AppState> store, SendSuggestionAction action, NextDispatcher next) async{
    Suggestion suggestion = Suggestion(message: action.suggestion, userId: UidUtil().getUid(), dateSubmitted: DateTime.now());
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('suggestions')
        .doc(suggestion.userId)
        .set(suggestion.toMap());
  }

  void deleteAccount(Store<AppState> store, DeleteAccountAction action) async {
    store.dispatch(SetDeleteProgressAction(store.state.mainSettingsPageState, true));
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if(profile != null) {
      String email = profile.email;
      if(await FirebaseAuthentication().reAuthenticateUser(action.pageState.password, email)) {
        await CalendarSyncUtil.removeJobsFromDeviceCalendars();
        await SembastDb.instance.deleteAllLocalData();
        await FirebaseAuthentication().deleteFirebaseData();
        await FirebaseAuthentication().deleteAccount(action.pageState.password, email);
        store.dispatch(ResetLoginState(store.state.loginPageState));
        store.dispatch(SetDeleteProgressAction(store.state.mainSettingsPageState, false));
      } else {
        store.dispatch(SetPasswordErrorAction(store.state.mainSettingsPageState));
      }
    } else {
      store.dispatch(SetPasswordErrorAction(store.state.mainSettingsPageState));
    }
  }

  void handleImageUploadProgress(TaskSnapshot taskSnapshot, Store<AppState> store) {
    store.dispatch(SetImageUploadProgressStateAction(
      store.state.mainSettingsPageState,
        (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes) < 1.0,
      (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes)
    ));
  }

  void _generateAccountData(Store<AppState> store, PopulateAccountWithData action, NextDispatcher next) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    List<String> names = ['Amanda', 'Jessica', 'Sara', 'Shawna', 'Justine', 'Tony', 'Ashley', 'Meagan', 'Debbie',
      'Connie', 'Carissa', 'Christina', 'Albert', 'Samantha', 'Linda', 'Lisa', 'Sandy', 'Fiona'];
    List<String> priceProfileNames = ['Wedding Standard', 'Wedding Gold', '1 Hour', '2 Hour', 'Large Family'];
    List<double> prices = [2500, 3500, 450, 600, 500];
    List<String> jobTypeNames = ['Wedding', 'Family', 'Engagement', 'Portrait', 'Newborn'];
    List<JobType> jobTypes = [];
    List<Client> clients = [];
    List<Job> jobs = [];
    List<PriceProfile> priceProfiles = [];
    List<String> leadSources = Client.getLeadSources();
    List<DateTime> months = [
      DateTime(2023, 5, Random().nextInt(28)),
      DateTime(2023, 6, Random().nextInt(28)),
      DateTime(2023, 7, Random().nextInt(28)),
      DateTime(2023, 8, Random().nextInt(28)),
      DateTime(2023, 9, Random().nextInt(28)),
      DateTime(2023, 10, Random().nextInt(28)),
    ];

    await names.forEach((name) async {
      int randomLeadSource = Random().nextInt(leadSources.length);
      int randomMonth = Random().nextInt(months.length);
      Client client = Client(
          firstName: name,
          lastName: 'Brannen',
          email: 'support@dandylight.com',
          phone: '8888888888',
          leadSource: leadSources.elementAt(randomLeadSource),
          createdDate: months.elementAt(randomMonth)
      );
      clients.add(client);
      await ClientDao.insert(client);
    });
    clients = await ClientDao.getAll();

    for(int i = 0; i < 5; i++) {
      PriceProfile profile = PriceProfile(
        profileName: priceProfileNames.elementAt(i),
        flatRate: prices.elementAt(i),
        icon: 'assets/images/icons/income_received.png',
        includeSalesTax: false,
        salesTaxPercent: 0,
        deposit: 0,
      );
      await PriceProfileDao.insert(profile);
      priceProfiles.add(profile);
    };
    priceProfiles = await PriceProfileDao.getAllSortedByName();

    for(int i = 0; i < 5; i++) {
      JobType jobType = JobType(
        title: jobTypeNames.elementAt(Random().nextInt(jobTypeNames.length)),
        createdDate: DateTime.now(),
        stages: JobStage.AllStages(),
        reminders: [],
      );
      await JobTypeDao.insert(jobType);
      jobTypes.add(jobType);
    };
    jobTypes = await JobTypeDao.getAll();

    for(int index = 0; index < 52; index++) {
      JobType jobType = jobTypes.elementAt(Random().nextInt(jobTypes.length));
      Client resultClient = clients.elementAt(Random().nextInt(clients.length));
      PriceProfile priceProfile = priceProfiles.elementAt(Random().nextInt(priceProfiles.length));
      int randomMonth = Random().nextInt(months.length);
      Job jobToSave = Job(
          clientDocumentId: resultClient.documentId,
          client: resultClient,
          clientName: resultClient.getClientFullName(),
          jobTitle: resultClient.firstName + ' - ' + jobType.title,
          selectedDate: months.elementAt(Random().nextInt(months.length)),
          selectedTime: null,
          selectedEndTime: null,
          paymentReceivedDate: months.elementAt(randomMonth),
          type: jobType,
          stage: JobStage.getNextStage(JobStage(stage: JobStage.STAGE_1_INQUIRY_RECEIVED), jobType.stages),
          completedStages: [JobStage(stage: JobStage.STAGE_1_INQUIRY_RECEIVED), JobStage(stage: JobStage.STAGE_9_PAYMENT_RECEIVED), JobStage(stage:  JobStage.STAGE_14_JOB_COMPLETE)],
          location: null,
          priceProfile: priceProfile,
          createdDate: months.elementAt(randomMonth),
          depositAmount: 0,
          proposal: Proposal(
              detailsMessage: "(Example client portal message)\n\nHi ${resultClient.firstName},\nI wanted to thank you again for choosing our photography services. We're excited to work with you to capture your special moments.\n\nTo make things official, kindly review and sign the contract. It outlines our agreement's essential details.\n\nIf you have any questions, please don't hesitate to ask.\n\nBest regards,\n\n${profile.firstName} ${profile.lastName ?? ''}\n${profile.businessName ?? ''}"
          )
      );
      await JobDao.insert(jobToSave);
      jobs.add(jobToSave);
    };
  }
}