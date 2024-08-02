import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/dashboard_page/ShowSessionMigrationMessageBottomSheet.dart';
import 'package:dandylight/pages/dashboard_page/widgets/BookingActivityCard.dart';
import 'package:dandylight/pages/dashboard_page/widgets/PoseLibraryCard.dart';
import 'package:dandylight/pages/dashboard_page/widgets/RecentActivityCard.dart';
import 'package:dandylight/pages/weekly_calendar_page/WeeklyCalendarPage.dart';
import 'package:http/http.dart' as http;
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobReminderDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageActions.dart';
import 'package:dandylight/pages/dashboard_page/GoToJobPosesBottomSheet.dart';
import 'package:dandylight/pages/dashboard_page/widgets/GettingStartedProgress.dart';
import 'package:dandylight/pages/dashboard_page/widgets/JobTypeBreakdownPieChart.dart';
import 'package:dandylight/pages/dashboard_page/widgets/LeadSourcesPieChart.dart';
import 'package:dandylight/pages/dashboard_page/widgets/RestorePurchasesBottomSheet.dart';
import 'package:dandylight/pages/dashboard_page/widgets/StageStatsHomeCard.dart';
import 'package:dandylight/pages/dashboard_page/widgets/MonthlyProfitLineChart.dart';
import 'package:dandylight/pages/dashboard_page/widgets/StartAJobButton.dart';
import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPage.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPage.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/Shadows.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/permissions/UserPermissionsUtil.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redux/redux.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../data_layer/api_clients/DandylightFunctionsClient.dart';
import '../../data_layer/repositories/PendingEmailsRepository.dart';
import '../../models/Job.dart';
import '../../models/Profile.dart';
import '../../utils/NotificationHelper.dart';
import '../../utils/PushNotificationsManager.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/DandyLightNetworkImage.dart';
import '../../widgets/TextDandyLight.dart';
import '../poses_page/PosesPage.dart';
import 'AppUpdateBottomSheet.dart';
import 'RequestAppReviewBottomSheet.dart';
import 'RequestPMFSurveyBottomSheet.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key, required this.comingFromLogin}) : super(key: key);
  final bool comingFromLogin;

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onStart: (index, key) {
        // log('onStart: $index, $key');
      },
      onComplete: (index, key) {
        // log('onComplete: $index, $key');
      },
      blurValue: 2,
      builder: (context) => HolderPage(comingFromLogin: comingFromLogin),
    );
  }
}

class HolderPage extends StatefulWidget {
  final bool comingFromLogin;
  const HolderPage({Key? key, required this.comingFromLogin}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState(comingFromLogin);
}

class _DashboardPageState extends State<HolderPage> with WidgetsBindingObserver, TickerProviderStateMixin {
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();

  ScrollController? _scrollController;
  bool dialVisible = true;
  bool isFabExpanded = false;
  bool comingFromLogin;
  bool goToHasBeenSeen = false;
  bool hasSeenPMFRequest = false;
  bool hasSeenRequestReview = false;
  bool hasSeenAPpUpdate = false;
  bool hasSeenSessionMessage = false;
  bool isTablet = false;

  _DashboardPageState(this.comingFromLogin);

  AnimationController? controller;
  AnimationController? _animationController;

  Tween<Offset>? offsetUpTween;
  Tween<Offset>? offsetDownTween;

  void _startShowcase() {
    ShowCaseWidget.of(context).startShowCase([_one, _two, _three, _four]);
  }

  @override
  initState() {
    super.initState();
    isTablet = DeviceType.getDeviceType() == Type.Tablet || DeviceType.getDeviceType() ==Type.Website;

    setupInteractedMessage();

    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

    offsetUpTween = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    );
    offsetDownTween = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    );
    if (comingFromLogin) {
      controller = AnimationController(
          duration: const Duration(milliseconds: 500), vsync: this);
      controller!.forward();
    } else {
      controller = AnimationController(
          duration: const Duration(milliseconds: 0), vsync: this);
      controller!.forward();
    }
  }

  void _runAnimation() async {
    for (int i = 0; i < 4; i++) {
      await _animationController!.forward();
      await _animationController!.reverse();
    }
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  Animation<Offset> get offsetAnimationUp => offsetUpTween!.animate(
        CurvedAnimation(
          parent: controller!,
          curve: const Interval(
            0.0,
            1.0,
            curve: Curves.ease,
          ),
        ),
      );

  Animation<Offset> get offsetAnimationDown => offsetDownTween!.animate(
        CurvedAnimation(
          parent: controller!,
          curve: const Interval(
            0.0,
            1.0,
            curve: Curves.ease,
          ),
        ),
      );

  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse notificationResponse) async {
    print('notification(${notificationResponse.id}) action tapped: ''${notificationResponse.actionId} with'' payload: ${notificationResponse.payload}');

    if((notificationResponse.payload?.isNotEmpty ?? false) && notificationResponse.payload == JobReminder.MILEAGE_EXPENSE_ID) {
      Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
      profile!.showNewMileageExpensePage = true;
      ProfileDao.update(profile);
    }
  }

  void _showRestorePurchasesSheet(BuildContext context, String? restoreMessage) {
    EventSender().sendEvent(eventName: EventNames.BT_RESTORE_PURCHASES_SHEET);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return RestorePurchasesBottomSheet(restoreMessage);
      },
    );
  }

  void _showGoToJobPosesSheet(BuildContext context, Job job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return GoToJobPosesBottomSheet(job);
      },
    );
  }

  void _showRequestAppReviewBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return const RequestAppReviewBottomSheet();
      },
    );
  }

  void _showRequestPMFBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return const RequestPMFSurveyBottomSheet();
      },
    );
  }

  void _showSessionMigrationSheet(BuildContext context, DashboardPageState pageState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return const ShowSessionMigrationMessageBottomSheet();
        // doneAction: pageState.updateProfileMigrationMessageSeen
      },
    );
  }

  void _showAppUpdateBottomSheet(BuildContext context, DashboardPageState pageState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return const AppUpdateBottomSheet();
      },
    ).whenComplete( () {
      pageState.markUpdateAsSeen!(pageState.appSettings!);
    });
  }

  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['click_action'] == 'invoice') {
      NavigationUtil.onInvoiceNotificationSelected(context);
      EventSender().sendEvent(eventName: EventNames.NOTIFICATION_INVOICE_APP_LAUNCH);
    }
    if (message.data['click_action'] == 'contract') {
      String jobDocumentId = message.data['jobId'];
      NavigationUtil.onContractNotificationSelected(context, jobDocumentId);
      EventSender().sendEvent(eventName: EventNames.NOTIFICATION_CONTRACT_APP_LAUNCH);
    }
    if (message.data['click_action'] == 'new_poses') {
      NavigationUtil.onPosesSelected(context, null, false, false, false);
      EventSender().sendEvent(eventName: EventNames.NOTIFICATION_INVOICE_APP_LAUNCH);
    }
    if (message.data['click_action'] == 'next_task_reminder') {
      NavigationUtil.onPosesSelected(context, null, false, false, false);
      EventSender().sendEvent(eventName: EventNames.NOTIFICATION_INVOICE_APP_LAUNCH);
    }
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
        onInit: (store) async {
          store.dispatch(InitDashboardPageAction(store.state.dashboardPageState));
          store.dispatch(LoadJobsAction(store.state.dashboardPageState));
          store.dispatch(CheckForGoToJobAction(store.state.dashboardPageState));
          store.dispatch(CheckForPMFSurveyAction(store.state.dashboardPageState));
          store.dispatch(CheckForReviewRequestAction(store.state.dashboardPageState));
          store.dispatch(CheckForAppUpdateAction(store.state.dashboardPageState));
          if(store.state.dashboardPageState!.unseenNotificationCount! > 0) {
            _runAnimation();
          }
          List<Job>? allJobs = await JobDao.getAllJobs();
          List<JobReminder>? allReminders = await JobReminderDao.getAll();
          final notificationHelper = NotificationHelper();
          notificationHelper.setTapBackgroundMethod(notificationTapBackground);

          //If permanently denied we do not want to bug the user every time they log in.  We will prompt every time they start a job instead. Also they can change the permission from the app settings.
          Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
          if(profile!.deviceTokens != null) {
            bool isNotificationsGranted = profile.deviceTokens!.length > 1 ? (await UserPermissionsUtil.showPermissionRequest(permission: Permission.notification, context: context)) : (await UserPermissionsUtil.getPermissionStatus(Permission.notification)).isGranted;
            profile.pushNotificationsEnabled = isNotificationsGranted;
            if(isNotificationsGranted) {
              setupNotifications(notificationHelper, allJobs!, allReminders!);
              String? token = await PushNotificationsManager().getToken();
              profile.addUniqueDeviceToken(token!);
              Profile? mostRecent = await ProfileDao.getMatchingProfile(UidUtil().getUid());
              profile.hasSeenShowcase = mostRecent!.hasSeenShowcase;
              ProfileDao.update(profile);
            }
          }

          if(store.state.dashboardPageState!.profile != null && store.state.dashboardPageState!.profile!.shouldShowRestoreSubscription!) {
            String? restoreMessage;

            if(store.state.dashboardPageState!.subscriptionState != null) {
              if(store.state.dashboardPageState!.subscriptionState!.entitlements.all['standard'] != null || store.state.dashboardPageState!.subscriptionState!.entitlements.all['standard_1699'] != null) {
                if(store.state.dashboardPageState!.subscriptionState!.entitlements.all['standard']!.isActive || (store.state.dashboardPageState!.subscriptionState!.entitlements.all['standard_1699']?.isActive ?? false)) {
                  restoreMessage = ManageSubscriptionPage.SUBSCRIBED;
                  store.state.dashboardPageState!.profile!.isSubscribed = true;
                  ProfileDao.update(store.state.dashboardPageState!.profile!);
                  EventSender().setUserProfileData(EventNames.SUBSCRIPTION_STATE, ManageSubscriptionPage.SUBSCRIBED);
                } else {
                  store.state.dashboardPageState!.profile!.isSubscribed = false;
                  ProfileDao.update(store.state.dashboardPageState!.profile!);
                  EventSender().setUserProfileData(EventNames.SUBSCRIPTION_STATE, ManageSubscriptionPage.SUBSCRIPTION_EXPIRED);
                  //Subscription expired - do nothing
                }
              } else {
                store.state.dashboardPageState!.profile!.isSubscribed = false;
                ProfileDao.update(store.state.dashboardPageState!.profile!);
                restoreMessage = ManageSubscriptionPage.FREE_TRIAL;
                EventSender().setUserProfileData(EventNames.SUBSCRIPTION_STATE, ManageSubscriptionPage.FREE_TRIAL);
              }
            }

            if(restoreMessage != null) {
              Future.delayed(const Duration(seconds: 1), () {
                _showRestorePurchasesSheet(context, restoreMessage);
                store.dispatch(UpdateProfileRestorePurchasesSeen(store.state.dashboardPageState));
              });
            }
          }

          if(profile.deviceTokens != null && profile.calendarEnabled!) {
            bool isCalendarGranted = (await UserPermissionsUtil.getPermissionStatus(Permission.calendarFullAccess)).isGranted;
            if(isCalendarGranted && profile.calendarIdsToSync?.isEmpty == true) {
              UserOptionsUtil.showCalendarSelectionDialog(context, null);
            }
          }

          PendingEmailsRepository(functions: DandylightFunctionsApi(httpClient: http.Client())).sendNextStageEmail();
        },
        onDidChange: (previous, current) async {
          if(!hasSeenSessionMessage && (current.profile?.showSessionMigrationMessage ?? false)) {
            _showSessionMigrationSheet(context, current);
            hasSeenSessionMessage = true;
          }else if(!hasSeenAPpUpdate && !previous!.shouldShowAppUpdate! && current.shouldShowAppUpdate!) {
            setState(() {
              hasSeenAPpUpdate = true;
              _showAppUpdateBottomSheet(context, current);
            });
          } else if(!current.hasSeenShowcase!) {
            _startShowcase();
            current.onShowcaseSeen!();
          } else if(!goToHasBeenSeen && !current.goToSeen! && current.goToPosesJob != null){
            _showGoToJobPosesSheet(context, current.goToPosesJob!);
            setState(() {
              goToHasBeenSeen = true;
            });
            current.onGoToSeen!();
          } else if(!previous!.shouldShowNewMileageExpensePage! && current.shouldShowNewMileageExpensePage!) {
            UserOptionsUtil.showNewMileageExpenseSelected(context, null);
          } else if(!hasSeenRequestReview && !previous.shouldShowRequestReview! && current.shouldShowRequestReview!) {
            setState(() {
              hasSeenRequestReview = true;
            });
            _showRequestAppReviewBottomSheet(context);
          } else if(!hasSeenPMFRequest && !previous.shouldShowPMFRequest! && current.shouldShowPMFRequest!) {
            setState(() {
              hasSeenPMFRequest = true;
            });
            _showRequestPMFBottomSheet(context);
          }
        },

        converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
        builder: (BuildContext context, DashboardPageState pageState) {
          return Scaffold(
            backgroundColor: Color(ColorConstants.getPrimaryWhite()),
            floatingActionButton:  Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
              Showcase(
              key: _one,
              targetPadding: const EdgeInsets.only(right: 0, left: 0, bottom: 0, top: 0),
              targetShapeBorder: const CircleBorder(),
              description: 'Start a new job or \nadd a new contact here!',
              descTextStyle: TextStyle(
                fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                fontFamily: TextDandyLight.getFontFamily(),
                fontWeight: TextDandyLight.getFontWeight(),
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
              child: SpeedDial(
                    childMargin: const EdgeInsets.only(right: 18.0, bottom: 20.0),
                    child: getFabIcon(),
                    visible: dialVisible,
                    // If true user is forced to close dial manually
                    // by tapping main button and overlay is not rendered.
                    closeManually: false,
                    curve: Curves.bounceIn,
                    overlayColor: Colors.black,
                    overlayOpacity: 0.5,
                    tooltip: 'Speed Dial',
                    heroTag: 'speed-dial-hero-tag-dashboard',
                    backgroundColor: Color(ColorConstants.getPeachDark()),
                    foregroundColor: Colors.black,
                    elevation: 8.0,
                    shape: const CircleBorder(),
                    onOpen: () {
                      setState(() {
                        isFabExpanded = true;
                      });
                    },
                    onClose: () {
                      setState(() {
                        isFabExpanded = false;
                      });
                    },
                    children: [
                      SpeedDialChild(
                        child: const Icon(Icons.business_center),
                        shape: const CircleBorder(),
                        backgroundColor: Color(ColorConstants.getBlueLight()),
                        labelWidget: Container(
                          alignment: Alignment.center,
                          height: 42.0,
                          width: 156.0,
                          decoration: BoxDecoration(
                            boxShadow: ElevationToShadow[4],
                            color: Color(ColorConstants.getPrimaryWhite()),
                            borderRadius: BorderRadius.circular(21.0),
                          ),
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Start new job',
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                        onTap: () {
                          NavigationUtil.showNewJobPage(context);
                          EventSender().sendEvent(eventName: EventNames.BT_START_NEW_JOB, properties: {EventNames.JOB_PARAM_COMING_FROM : "Dashboard"});
                        },
                      ),
                      SpeedDialChild(
                        child: const Icon(Icons.person_add),
                        shape: const CircleBorder(),
                        backgroundColor: Color(ColorConstants.getBlueLight()),
                        labelWidget: Container(
                          alignment: Alignment.center,
                          height: 42.0,
                          width: 138.0,
                          decoration: BoxDecoration(
                            boxShadow: ElevationToShadow[4],
                            color: Color(ColorConstants.getPrimaryWhite()),
                            borderRadius: BorderRadius.circular(21.0),
                          ),
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'New contact',
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                        onTap: () {
                          NavigationUtil.showNewContactPage(context, null);
                          EventSender().sendEvent(eventName: EventNames.BT_ADD_NEW_CONTACT, properties: {EventNames.CONTACT_PARAM_COMING_FROM : "Dashboard Page"});
                        },
                      ),
                    ],
                  ),
              ),
                  pageState.profile != null && !pageState.profile!.isSubscribed! && !pageState.profile!.isFreeForLife! ? GestureDetector(
                    onTap: () {
                      NavigationUtil.onManageSubscriptionSelected(context, pageState.profile!);
                      EventSender().sendEvent(eventName: EventNames.BT_SUBSCRIBE_NOW);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 132,
                      alignment: Alignment.center,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Color(ColorConstants.getPeachDark()),
                        boxShadow: ElevationToShadow[6],
                      ),
                      child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          color: Color(ColorConstants.getPrimaryWhite()),
                          text: "Subscribe"
                      ),
                    ),
                  ) : const SizedBox(),
                ],
            ),
            body: Container(
              margin: DeviceType.getDeviceType() == Type.Tablet ? const EdgeInsets.only(left: 0, right: 0) : const EdgeInsets.only(left: 0, right: 0),
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Container(
                    alignment: Alignment.bottomRight,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Showcase(
                      key: _four,
                      targetPadding: const EdgeInsets.only(right: -8, left: 8, bottom: 55, top: -55),
                      targetShapeBorder: const CircleBorder(),
                      description: 'Get started here!  \nThis is your collections page where \nyou can setup the details for your business',
                      descTextStyle: TextStyle(
                        fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                        fontFamily: TextDandyLight.getFontFamily(),
                        fontWeight: TextDandyLight.getFontWeight(),
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                      child:const SizedBox(
                        height: 64,
                        width: 64,
                      ),
                    ),
                  ),
                  CustomScrollView(
                    physics: const ClampingScrollPhysics(),
                    controller: _scrollController,
                    slivers: <Widget>[
                      SliverAppBar(
                        systemOverlayStyle: const SystemUiOverlayStyle(
                          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
                          statusBarBrightness: Brightness.dark, // For iOS (dark icons)
                        ),
                        scrolledUnderElevation: 0,
                        iconTheme: IconThemeData(
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                        backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                        pinned: false,
                        floating: false,
                        forceElevated: true,
                        elevation: 2,
                        expandedHeight: DeviceType.getDeviceType() == Type.Tablet ? 564 : 224.0,
                        collapsedHeight: 64.0,
                        flexibleSpace: FlexibleSpaceBar(
                          background: GestureDetector(
                            onTap: () {
                              NavigationUtil.onEditBrandingSelected(context);
                              EventSender().sendEvent(eventName: EventNames.BRANDING_EDIT_FROM_DASHBOARD);
                            },
                            child: Container(
                            height: DeviceType.getDeviceType() == Type.Tablet ? 564: 224,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(0)
                                  ),
                                  child: (pageState.profile?.bannerImageSelected ?? false) && (pageState.profile?.bannerMobileUrl?.isNotEmpty ?? false) ? DandyLightNetworkImage(
                                    (pageState.profile?.bannerMobileUrl ?? '') ,
                                    color: ColorConstants.hexToColor(pageState.profile?.selectedColorTheme!.bannerColor),
                                    borderRadius: 0,
                                    resizeWidth: 1080,
                                  ) : Image.asset('assets/images/backgrounds/dashboard_banner_default.png', fit: BoxFit.cover, width: MediaQuery.of(context).size.width),
                                ),
                                Container(
                                  height: 164.0,
                                  decoration: BoxDecoration(
                                      color: Color(ColorConstants.getPrimaryWhite()),
                                      gradient: LinearGradient(
                                          begin: FractionalOffset.center,
                                          end: FractionalOffset.bottomCenter,
                                          colors: [
                                            Color(ColorConstants.getPrimaryBlack()).withOpacity(0.15),
                                            Colors.transparent
                                          ],
                                          stops: const [
                                            0.0,
                                            1.0
                                          ])),
                                ),
                                Container(
                                  height: DeviceType.getDeviceType() == Type.Tablet ? 596 : 308,
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 132.0,
                                    decoration: BoxDecoration(
                                        color: Color(ColorConstants.getPrimaryWhite()),
                                        gradient: LinearGradient(
                                            begin: FractionalOffset.center,
                                            end: FractionalOffset.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(.5),
                                            ],
                                            stops: const [
                                              0.0,
                                              1.0
                                            ])),
                                  ),
                                ),
                                pageState.profile?.hasSetupBrand ?? false ? Container(
                                  alignment: Alignment.bottomLeft,
                                  margin: const EdgeInsets.only(top: 64),
                                  height: DeviceType.getDeviceType() == Type.Tablet ? 564 : 308,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 16, bottom: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width - 182,
                                          child: Stack(
                                            alignment: Alignment.centerLeft,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: ElevationToShadow[2],
                                                  shape: BoxShape.circle,
                                                  color: Color(ColorConstants.getPrimaryWhite()),
                                                ),
                                                width: 42,
                                                height: 42,
                                              ),
                                              pageState.profile!.logoSelected! ? Container(
                                                child: pageState.profile!.logoUrl != null && pageState.profile!.logoUrl!.isNotEmpty && pageState.profile!.hasSetupBrand! ? ClipRRect(
                                                  borderRadius: BorderRadius.circular(82.0),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.iconColor!),
                                                      ),
                                                      width: 48,
                                                      height: 48,
                                                      child: DandyLightNetworkImage(
                                                        pageState.profile!.logoUrl ?? '',
                                                        color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.iconColor!),
                                                      )
                                                  ),
                                                ) : Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      alignment: Alignment.center,
                                                      height: 42,
                                                      width: 42,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Color(ColorConstants.getPeachDark())),
                                                    ),
                                                    Container(
                                                      child: LoadingAnimationWidget.fourRotatingDots(
                                                        color: Color(ColorConstants.getPrimaryWhite()),
                                                        size: 32,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ) : Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height: 42,
                                                    width: 42,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: pageState.profile!.logoSelected!
                                                            ? Color(ColorConstants.getPrimaryGreyMedium())
                                                            : ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.iconColor!)),
                                                  ),
                                                  TextDandyLight(
                                                    type: TextDandyLight.EXTRA_LARGE_TEXT,
                                                    fontFamily: pageState.profile!.selectedFontTheme!.iconFont!,
                                                    textAlign: TextAlign.center,
                                                    text: pageState.profile!.logoCharacter!.substring(0, 1),
                                                    color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.iconTextColor!),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(left: 48, bottom: 0),
                                                child: TextDandyLight(
                                                  type: TextDandyLight.SMALL_TEXT,
                                                  // text: pageState.profile?.businessName ?? '',
                                                  text: 'Vintage Vibes Photography',
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  fontFamily: pageState.profile?.selectedFontTheme?.mainFont!,
                                                  color: Color(ColorConstants.getPrimaryWhite()),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            NavigationUtil.showBookingPage(context);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                                            padding: const EdgeInsets.only(left: 0),
                                            height: 32.0,
                                            width: 134,
                                            decoration: BoxDecoration(
                                                color: Color(ColorConstants.getPrimaryWhite()),
                                                borderRadius: const BorderRadius.all(Radius.circular(16.0))),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 32,
                                                      alignment: Alignment.center,
                                                      child: Shimmer.fromColors(
                                                        baseColor: Color(ColorConstants.getPrimaryGreyDark()),
                                                        highlightColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                                        child: TextDandyLight(
                                                          type: TextDandyLight.SMALL_TEXT,
                                                          text: '2 New bookings!',
                                                          isBold: true,
                                                          textAlign: TextAlign.start,
                                                          color: Color(ColorConstants.getPrimaryBlack()),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // Container(
                                                //   width: 24,
                                                //   margin: const EdgeInsets.only(right: 8),
                                                //   alignment: Alignment.center,
                                                //   child: Icon(
                                                //     Icons.chevron_right,
                                                //     color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                                //   ),
                                                // )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ) : Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 84),
                                      width: MediaQuery.of(context).size.width,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            height: 108,
                                            width: 108,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                boxShadow: ElevationToShadow[4],
                                                color: Color(ColorConstants.getPrimaryGreyLight())),
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(bottom: 4),
                                                alignment: Alignment.center,
                                                height: 24.0,
                                                width: 24.0,
                                                child: Image.asset('assets/images/icons/file_upload.png', color: Color(ColorConstants.getPrimaryBlack()),),
                                              ),
                                              TextDandyLight(
                                                type: TextDandyLight.MEDIUM_TEXT,
                                                textAlign: TextAlign.center,
                                                text: 'Upload\nLogo',
                                                color: Color(ColorConstants.getPrimaryBlack()),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ),
                        ),
                        title: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 4.0),
                              alignment: Alignment.center,
                              child: Text(
                                'DandyLight',
                                textScaleFactor: 1,
                                style: TextStyle(
                                  fontSize: 36.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.getPrimaryWhite()),
                                ),
                              ),
                            ),
                            Container(
                              margin:
                              const EdgeInsets.only(left: 57.0, top: 2.0),
                              height: 64.0,
                              color: Colors.transparent,
                              child: Image.asset(ImageUtil.LOGIN_BG_LOGO_FLOWER, color: Color(ColorConstants.getPrimaryWhite())),
                            )
                          ],
                        ),
                        leading: Showcase(
                          key: _two,
                          targetPadding: const EdgeInsets.only(right: 13, bottom: 7, top: 6),
                          targetShapeBorder: const CircleBorder(),
                          description: 'Sunset & Weather',
                          descTextStyle: TextStyle(
                            fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                            fontFamily: TextDandyLight.getFontFamily(),
                            fontWeight: TextDandyLight.getFontWeight(),
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                          child: SlideTransition(
                            position: offsetAnimationDown,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => const SunsetWeatherPage()),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.only(left: 16.0),
                                height: 26.0,
                                width: 26.0,
                                child: Image.asset(
                                    'assets/images/icons/sunset_icon_white.png', color: Color(ColorConstants.getPrimaryWhite(),)),
                              ),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          SlideTransition(
                            position: offsetAnimationDown,
                            child: GestureDetector(
                                onTap: () {
                                  NavigationUtil.onNotificationsSelected(context);
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          RotationTransition(
                                              turns: Tween(begin: 0.0, end: -.05)
                                                  .chain(CurveTween(
                                                  curve: Curves.elasticIn))
                                                  .animate(_animationController!),
                                              child: Container(
                                                margin: const EdgeInsets.only(right: 16.0),
                                                height: 28.0,
                                                width: 28.0,
                                                child: Image.asset(
                                                    'assets/images/collection_icons/reminder_icon_white.png', color: Color(ColorConstants.getPrimaryWhite(),)),
                                              )),
                                        ],
                                      ),
                                    ),
                                    pageState.unseenNotificationCount! > 0 ? Container(
                                      margin: const EdgeInsets.only(bottom: 16.0),
                                      width: 8.0,
                                      height: 8.0,
                                      decoration: const BoxDecoration(
                                        color: Color(ColorConstants.error_red),
                                        shape: BoxShape.circle,
                                      ),
                                    ) : const SizedBox(),
                                  ],
                                )
                            ),
                          ),
                          SlideTransition(
                            position: offsetAnimationDown,
                            child: GestureDetector(
                              onTap: () {
                                NavigationUtil.onCalendarSelected(context);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 16.0),
                                height: 26.0,
                                width: 26.0,
                                child: Image.asset(
                                    'assets/images/icons/calendar.png', color: Color(ColorConstants.getPrimaryWhite(),)),
                              ),
                            ),
                          ),
                          SlideTransition(
                            position: offsetAnimationDown,
                            child: GestureDetector(
                              onTap: () {
                                NavigationUtil.onMainSettingsSelected(context);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 16.0),
                                height: 26.0,
                                width: 26.0,
                                child: Image.asset(
                                    'assets/images/icons/settings.png', color: Color(ColorConstants.getPrimaryWhite(),)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      pageState.areJobsLoaded ?? false ? SliverList(
                          delegate: SliverChildListDelegate(<Widget>[
                            SlideTransition(
                              position: offsetAnimationUp,
                              child: (pageState.profile?.progress.isComplete() ?? false) || !(pageState.profile?.progress.canShow ?? true) ? const SizedBox() : Dismissible(
                                confirmDismiss: (DismissDirection direction) async {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                                        surfaceTintColor: Colors.transparent,
                                        title: TextDandyLight(
                                            type: TextDandyLight.LARGE_TEXT,
                                            text: 'Remove Progress Bar'
                                        ),
                                        content: TextDandyLight(
                                            type: TextDandyLight.MEDIUM_TEXT,
                                            text: 'Are you sure you want to permanently remove the Getting Started Checklist"?'
                                        ),
                                        actions: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              pageState.updateProgressNoShow!();
                                              Navigator.of(context).pop(true);
                                            },
                                            child: Container(
                                                width: 96,
                                                height: 48,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(24),
                                                    color: Color(ColorConstants.getLightGreyWeb())
                                                ),
                                                child: TextDandyLight(
                                                  type: TextDandyLight.LARGE_TEXT,
                                                  text: 'Yes',
                                                  color: Color(ColorConstants.getPrimaryWhite()),
                                                )
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: Container(
                                                width: 96,
                                                height: 48,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(24),
                                                    color: Color(ColorConstants.getBlueDark())
                                                ),
                                                child: TextDandyLight(
                                                  type: TextDandyLight.LARGE_TEXT,
                                                  text: 'No',
                                                  color: Color(ColorConstants.getPrimaryWhite()),
                                                )
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                                key: const Key("dismissKey"),
                                child: const GettingStartedProgress(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SlideTransition(
                                position: offsetAnimationUp,
                                child: const RecentActivityCard()
                            ),
                            SlideTransition(
                                position: offsetAnimationUp,
                                child: WeeklyCalendarPage()
                            ),
                            SlideTransition(
                                position: offsetAnimationUp,
                                child: StageStatsHomeCard(pageState: pageState)
                            ),
                            SlideTransition(
                                position: offsetAnimationUp,
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 16, top: 0),
                                      child: TextDandyLight(
                                        type: TextDandyLight.SMALL_TEXT,
                                        text: 'Pose Library',
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => PosesPage(null, false, false, false)),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 8),
                                        child: TextDandyLight(
                                          type: TextDandyLight.SMALL_TEXT,
                                          text: 'View all',
                                          color: Color(ColorConstants.getPeachDark()),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            ),
                            SlideTransition(
                                position: offsetAnimationUp,
                                child: const PoseLibraryCard()
                            ),
                            SlideTransition(
                                position: offsetAnimationUp,
                                child:  Container(
                                  margin: const EdgeInsets.only(left: 16, top: 16),
                                  height: 32,
                                  child: TextDandyLight(
                                    type: TextDandyLight.SMALL_TEXT,
                                    text: 'Business Insights - ${DateTime.now().year}',
                                  ),
                                )
                            ),
                            SlideTransition(
                                position: offsetAnimationUp,
                                child: MonthlyProfitLineChart(pageState: pageState)
                            ),
                            SlideTransition(
                                position: offsetAnimationUp,
                                child: JobTypeBreakdownPieChart()
                            ),
                            SlideTransition(
                              position: offsetAnimationUp,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: buildLeadStatsWidget(pageState),
                              ),
                            ),
                            SlideTransition(
                              position: offsetAnimationUp,
                              child: LeadSourcesPieChart(),
                            ),
                          ])) : SliverList(delegate: SliverChildListDelegate(
                          <Widget>[]
                      )),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      );

  Widget buildLeadStatsWidget(DashboardPageState pageState) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: (MediaQuery.of(context).size.width / 2) - (25) - (DeviceType.getDeviceType() == Type.Tablet ? 150 : 0),
            height: 132.0,
            decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryGreyLight()).withOpacity(0.5),
                borderRadius: const BorderRadius.all(Radius.circular(12.0))),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextDandyLight(
                    type: TextDandyLight.SMALL_TEXT,
                    text: 'Lead\n Conversion Rate',
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.getPrimaryGreyDark()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 58.0),
                  child: Text(
                    '${pageState.leadConversionRate}%',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 38,
                      fontFamily: TextDandyLight.getFontFamily(),
                      fontWeight: TextDandyLight.getFontWeight(),
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              NavigationUtil.onUnconvertedLeadsSelected(context);
            },
            child: Container(
              width: (MediaQuery.of(context).size.width / 2) - (25) - (DeviceType.getDeviceType() == Type.Tablet ? 150 : 0),
              height: 132.0,
              decoration: BoxDecoration(
                  color: Color(ColorConstants.getPrimaryGreyLight()).withOpacity(0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(12.0))),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextDandyLight(
                      type: TextDandyLight.SMALL_TEXT,
                      text: 'Leads\nUnconverted',
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryGreyDark()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 58.0),
                    child: Text(
                      pageState.unconvertedLeadCount.toString(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 38,
                        fontFamily: TextDandyLight.getFontFamily(),
                        fontWeight: TextDandyLight.getFontWeight(),
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  getFabIcon() {
    if (isFabExpanded) {
      return Icon(Icons.close, color: Color(ColorConstants.getPrimaryWhite()));
    } else {
      return Icon(Icons.add, color: Color(ColorConstants.getPrimaryWhite()));
    }
  }

  bool containsSampleJobBool(List<Job> allJobs, String clientName) {
    bool contains = false;
    for (var job in allJobs) {
      if(job.clientName == clientName){
        contains = true;
      }
    }
    return contains;
  }

  void setupNotifications(NotificationHelper notificationHelper, List<Job> allJobs, List<JobReminder> allReminders) async {
    await notificationHelper.initNotifications(context);
    bool containsSampleJob = containsSampleJobBool(allJobs, "Example Client");
    if(containsSampleJob && allJobs.length == 1) {
      //do nothing
    } else {
      if(allReminders.isNotEmpty) {
        NotificationHelper().createAndUpdatePendingNotifications();
      }
    }
  }
}
