import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/firebase/FirebaseAuthentication.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobTypeDao.dart';
import 'package:dandylight/data_layer/local_db/daos/PriceProfileDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/DiscountCodes.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobType.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/Suggestion.dart';
import 'package:dandylight/pages/share_with_client_page/ShareWithClientActions.dart';
import 'package:dandylight/utils/AdminCheckUtil.dart';
import 'package:dandylight/utils/CalendarSyncUtil.dart';
import 'package:dandylight/utils/EnvironmentUtil.dart';
import 'package:dandylight/utils/NotificationHelper.dart';
import 'package:dandylight/utils/PushNotificationsManager.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:dandylight/utils/analytics/EventNames.dart';
import 'package:dandylight/utils/analytics/EventSender.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as purchases;
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

import '../../credentials.dart';
import '../../data_layer/local_db/SembastDb.dart';
import '../../data_layer/local_db/daos/ClientDao.dart';
import '../../data_layer/repositories/DiscountCodesRepository.dart';
import '../../models/Client.dart';
import '../../models/JobStage.dart';
import '../../models/Proposal.dart';
import '../login_page/LoginPageActions.dart';
import 'MainSettingsPageActions.dart';

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
    if(action is GenerateFirst3MonthsFreeCodeAction) {
      generateFirst3MonthsFreeCode(store, action, next);
    }
    if(action is PopulateAccountWithData) {
      _generateAccountData(store, action, next);
    }
    if(action is SaveMainSettingsHomeLocationAction) {
      saveHomeLocation(store, action, next);
    }
  }

  void saveHomeLocation(Store<AppState> store, SaveMainSettingsHomeLocationAction action, NextDispatcher next) async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.latDefaultHome = action.startLocation!.latitude;
    profile.lngDefaultHome = action.startLocation!.longitude;
    await ProfileDao.insertOrUpdate(profile);
    store.dispatch(SetHomeLocationToState(store.state.mainSettingsPageState, profile, (await getAddress(profile.latDefaultHome!, profile.lngDefaultHome!)).address));
  }

  Future<GeoData> getAddress(double lat, double lng) async {
    return await Geocoder2.getDataFromCoordinates(
        latitude: lat,
        longitude: lng,
        googleMapApiKey: PLACES_API_KEY
    );
  }

  void generate50DiscountCode(Store<AppState> store, Generate50DiscountCodeAction action, NextDispatcher next) async{
    String newCode = await DiscountCodesRepository().generateAndSaveCode(DiscountCodes.FIFTY_PERCENT_TYPE, action.pageState!.instaUrl!);
    store.dispatch(SetDiscountCodeAction(store.state.mainSettingsPageState, newCode));
  }

  void generateFreeDiscountCode(Store<AppState> store, GenerateFreeDiscountCodeAction action, NextDispatcher next) async{
    String newCode = await DiscountCodesRepository().generateAndSaveCode(DiscountCodes.LIFETIME_FREE, action.pageState!.instaUrl!);
    store.dispatch(SetDiscountCodeAction(store.state.mainSettingsPageState, newCode));
  }

  void generateFirst3MonthsFreeCode(Store<AppState> store, GenerateFirst3MonthsFreeCodeAction action, NextDispatcher next) async{
    String newCode = await DiscountCodesRepository().generateAndSaveCode(DiscountCodes.FIRST_3_MONTHS_FREE, action.pageState!.instaUrl!);
    store.dispatch(SetDiscountCodeAction(store.state.mainSettingsPageState, newCode));
  }

  void loadSettings(Store<AppState> store, NextDispatcher next) async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    bool isAdmin = AdminCheckUtil.isAdmin(profile);
    store.dispatch(SetIsAdminAction(store.state.mainSettingsPageState, isAdmin));

    (await ProfileDao.getProfileStream()).listen((snapshots) async {
        Profile? profile;
        for(RecordSnapshot profileSnapshot in snapshots) {
          Profile newProfile = Profile.fromMap(profileSnapshot.value! as Map<String,dynamic>);
          if(newProfile.uid == UidUtil().getUid()) {
            profile = newProfile;
          }
        }
        if(profile != null) {
          store.dispatch(UpdatePushNotificationEnabled(store.state.mainSettingsPageState, profile.pushNotificationsEnabled ?? false));
          store.dispatch(UpdateCalendarEnabled(store.state.mainSettingsPageState, profile.calendarEnabled ?? false));
          store.dispatch(LoadUserProfileDataAction(store.state.mainSettingsPageState, profile));
          if(profile.hasDefaultHome()) {
            store.dispatch(SetHomeAddressNameAction(store.state.mainSettingsPageState, (await getAddress(profile.latDefaultHome!, profile.lngDefaultHome!)).address));
          } else {
            store.dispatch(SetHomeAddressNameAction(store.state.mainSettingsPageState, 'Select a home location'));
          }

        }
      }
    );
  }

  void savePushNotificationSetting(Store<AppState> store, SavePushNotificationSettingAction action, NextDispatcher next) async{
    Profile? profile = (await ProfileDao.getAll())!.elementAt(0);
    profile.pushNotificationsEnabled = action.enabled;
    if(profile!.pushNotificationsEnabled!) {
      await PushNotificationsManager().init();
      NotificationHelper().createAndUpdatePendingNotifications();
    } else {
      NotificationHelper().clearAll();
      // profile.removeDeviceToken(await PushNotificationsManager().getToken());
    }
    await ProfileDao.update(profile);
    EventSender().setUserProfileData(EventNames.NOTIFICATIONS_ENABLED, action.enabled!);
    store.dispatch(UpdatePushNotificationEnabled(store.state.mainSettingsPageState, profile.pushNotificationsEnabled ?? false));
  }

  void removeDeviceToken(Store<AppState> store, RemoveDeviceTokenAction action, NextDispatcher next) async{
    List<Profile?>? profiles = await ProfileDao.getAll();
    if(profiles != null && profiles.isNotEmpty) {
      await purchases.Purchases.logIn(profiles.elementAt(0)!.uid!);
      Profile profile = profiles.elementAt(0)!;
      // profile.removeDeviceToken(await PushNotificationsManager().getToken());
      await ProfileDao.update(profile);
    }
  }

  void saveCalendarSetting(Store<AppState> store, SaveCalendarSettingAction action, NextDispatcher next) async{
    Profile profile = (await ProfileDao.getAll())!.elementAt(0);
    profile.calendarEnabled = action.enabled;
    await ProfileDao.update(profile);
    EventSender().setUserProfileData(EventNames.CALENDAR_SYNC_ENABLED, action.enabled!);
    store.dispatch(UpdateCalendarEnabled(store.state.mainSettingsPageState, profile.calendarEnabled ?? false));
    if(!action.enabled!) {
      CalendarSyncUtil.removeJobsFromDeviceCalendars();
    }
  }

  void saveUpdatedUserProfile(Store<AppState> store, SaveUpdatedUserProfileAction action, NextDispatcher next) async{
    Profile profile = (await ProfileDao.getAll())!.elementAt(0);
    await ProfileDao.update(profile.copyWith(
      firstName: store.state.mainSettingsPageState!.firstName,
      lastName: store.state.mainSettingsPageState!.lastName,
      businessName: store.state.mainSettingsPageState!.businessName,
      phone: TextFormatterUtil.formatPhoneNum(store.state.mainSettingsPageState!.businessPhone!),
      email: store.state.mainSettingsPageState!.businessEmail,
    ));
    if(store.state.mainSettingsPageState!.firstName!.isNotEmpty && store.state.mainSettingsPageState!.lastName!.isNotEmpty && store.state.mainSettingsPageState!.businessName!.isNotEmpty && (store.state.mainSettingsPageState!.businessPhone!.isNotEmpty || store.state.mainSettingsPageState!.businessEmail!.isNotEmpty)) {
      EventSender().setUserProfileData(EventNames.IS_PROFILE_SETUP_COMPLETE, true);
    } else {
      EventSender().setUserProfileData(EventNames.IS_PROFILE_SETUP_COMPLETE, false);
    }
    store.dispatch(FetchProfileAction(store.state.shareWithClientPageState!));
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
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if(profile != null) {
      String email = profile.email!;
      if(await FirebaseAuthentication().reAuthenticateUser(action.pageState!.password!, email)) {
        CalendarSyncUtil.removeJobsFromDeviceCalendars();
        await SembastDb.instance.deleteAllLocalData();
        await FirebaseAuthentication().deleteFirebaseData();
        FirebaseAuthentication().deleteAccount(action.pageState!.password!, email);
        store.dispatch(ResetLoginState(store.state.loginPageState));
        store.dispatch(SetDeleteProgressAction(store.state.mainSettingsPageState, false));
      } else {
        store.dispatch(SetPasswordErrorAction(store.state.mainSettingsPageState));
      }
    } else {
      store.dispatch(SetPasswordErrorAction(store.state.mainSettingsPageState));
    }
  }

  void _generateAccountData(Store<AppState> store, PopulateAccountWithData action, NextDispatcher next) async {
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
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

    names.forEach((name) async {
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
          jobTitle: resultClient.firstName! + ' - ' + jobType.title!,
          selectedDate: months.elementAt(Random().nextInt(months.length)),
          selectedTime: null,
          selectedEndTime: null,
          paymentReceivedDate: months.elementAt(randomMonth),
          type: jobType,
          stage: JobStage.getNextStage(JobStage(stage: JobStage.STAGE_1_INQUIRY_RECEIVED), jobType.stages!),
          completedStages: [JobStage(stage: JobStage.STAGE_1_INQUIRY_RECEIVED), JobStage(stage: JobStage.STAGE_9_PAYMENT_RECEIVED), JobStage(stage:  JobStage.STAGE_14_JOB_COMPLETE)],
          location: null,
          priceProfile: priceProfile,
          createdDate: months.elementAt(randomMonth),
          depositAmount: 0,
          proposal: Proposal(
              detailsMessage: "(Example client portal message)\n\nHi ${resultClient.firstName},\nI wanted to thank you again for choosing our photography services. We're excited to work with you to capture your special moments.\n\nTo make things official, kindly review and sign the contract. It outlines our agreement's essential details.\n\nIf you have any questions, please don't hesitate to ask.\n\nBest regards,\n\n${profile!.firstName} ${profile.lastName ?? ''}\n${profile.businessName ?? ''}"
          )
      );
      await JobDao.insert(jobToSave);
      jobs.add(jobToSave);
    };
  }
}