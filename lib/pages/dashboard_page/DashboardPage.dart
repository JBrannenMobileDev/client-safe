import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobReminderDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageActions.dart';
import 'package:dandylight/pages/dashboard_page/GoToJobPosesBottomSheet.dart';
import 'package:dandylight/pages/dashboard_page/widgets/ContractsCard.dart';
import 'package:dandylight/pages/dashboard_page/widgets/JobTypeBreakdownPieChart.dart';
import 'package:dandylight/pages/dashboard_page/widgets/ProfileAndJobsCard.dart';
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
import 'package:permission_handler/permission_handler.dart';
import 'package:redux/redux.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../models/Job.dart';
import '../../models/Profile.dart';
import '../../utils/NotificationHelper.dart';
import '../../utils/PushNotificationsManager.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';
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
      builder: Builder(builder: (context) => HolderPage(comingFromLogin: comingFromLogin)),
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
        return RequestAppReviewBottomSheet();
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
        return RequestPMFSurveyBottomSheet();
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
        return AppUpdateBottomSheet();
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
                if(store.state.dashboardPageState!.subscriptionState!.entitlements.all['standard']!.isActive || store.state.dashboardPageState!.subscriptionState!.entitlements.all['standard_1699']!.isActive) {
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
            bool isCalendarGranted = profile.deviceTokens!.length > 1 ? (await UserPermissionsUtil.showPermissionRequest(permission: Permission.calendarFullAccess, context: context)) : (await UserPermissionsUtil.getPermissionStatus(Permission.calendarFullAccess)).isGranted;
            if(isCalendarGranted && store.state.dashboardPageState!.profile != null) {
              Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
              if(profile!.calendarEnabled == false) {
                profile.calendarEnabled = true;
                ProfileDao.update(profile);
                UserOptionsUtil.showCalendarSelectionDialog(context, null);
              }
            } else if(!isCalendarGranted && store.state.dashboardPageState!.profile != null && store.state.dashboardPageState!.profile!.calendarEnabled!){
              Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
              profile!.calendarEnabled = false;
              ProfileDao.update(profile);
            }
          }
        },
        onDidChange: (previous, current) async {
          if(!hasSeenAPpUpdate && !previous!.shouldShowAppUpdate! && current.shouldShowAppUpdate!) {
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
            backgroundColor: Color(ColorConstants.getBlueLight()),
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
                          UserOptionsUtil.showNewJobDialog(context, false);
                          EventSender().sendEvent(eventName: EventNames.BT_START_NEW_JOB, properties: {EventNames.JOB_PARAM_COMING_FROM : "Dashboard"});
                        },
                      ),
                      SpeedDialChild(
                        child: const Icon(Icons.person_add),
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
                          UserOptionsUtil.showNewContactDialog(context, false);
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
              margin: DeviceType.getDeviceType() == Type.Tablet ? const EdgeInsets.only(left: 150, right: 150) : const EdgeInsets.only(left: 0, right: 0),
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  // Container(
                  //   height: 264,
                  //   width: MediaQuery.of(context).size.width,
                  //   child: ClipRRect(
                  //     borderRadius: new BorderRadius.only(
                  //       topRight: Radius.circular(16),
                  //       topLeft: Radius.circular(16),
                  //       bottomRight: Radius.circular(16),
                  //       bottomLeft: Radius.circular(16)
                  //     ),
                  //     child: DandyLightNetworkImage(
                  //       pageState.profile.bannerMobileUrl,
                  //       color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.bannerColor),
                  //       borderRadius: 0,
                  //     ),
                  //   ),
                  // ),
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
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Color(ColorConstants.getBlueLight()),
                  //   ),
                  // ),
                  CustomScrollView(
                    physics: const ClampingScrollPhysics(),
                    controller: _scrollController,
                    slivers: <Widget>[
                      SliverAppBar(
                        iconTheme: IconThemeData(
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        pinned: false,
                        floating: false,
                        forceElevated: false,
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
                                      builder: (context) => SunsetWeatherPage()),
                                );
                                EventSender().sendEvent(eventName: EventNames.NAV_TO_SUNSET_WEATHER);
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
                                  EventSender().sendEvent(eventName: EventNames.NAV_TO_NOTIFICATIONS);
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
                                EventSender().sendEvent(eventName: EventNames.NAV_TO_CALENDAR);
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
                                EventSender().sendEvent(eventName: EventNames.NAV_TO_SETTINGS_MAIN);
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
                        ], systemOverlayStyle: SystemUiOverlayStyle.dark,
                      ),
                      pageState.areJobsLoaded! ? SliverList(
                          delegate: SliverChildListDelegate(<Widget>[
                            SlideTransition(
                              position: offsetAnimationUp,
                              child: Showcase(
                                  key: _three,
                                  targetPadding: const EdgeInsets.only(right: 0, left: 0, bottom: 0, top: 0),
                                  targetShapeBorder: const CircleBorder(),
                                  description: 'Setup your Brand and view your upcoming jobs here! \nWhen sharing items with your clients, \nyour brand will be used to style your Client Portal.',
                                  descTextStyle: TextStyle(
                                    fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                                    fontFamily: TextDandyLight.getFontFamily(),
                                    fontWeight: TextDandyLight.getFontWeight(),
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                  child: const ProfileAndJobsCard()
                              ),
                            ),
                            SlideTransition(
                              position: offsetAnimationUp,
                              child: pageState.activeJobs == null || pageState.activeJobs!.isEmpty ? StartAJobButton(pageState: pageState) : const SizedBox(),
                            ),
                            SlideTransition(
                                position: offsetAnimationUp,
                                child: StageStatsHomeCard(pageState: pageState)
                            ),
                            SlideTransition(
                                position: offsetAnimationUp,
                                child: const ContractsCard()
                            ),
                            SlideTransition(
                                position: offsetAnimationUp,
                                child:  Padding(
                                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: 'Business Insights - ${DateTime.now().year}',
                                    textAlign: TextAlign.center,
                                    color: Color(ColorConstants.getPrimaryWhite()),
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
                color: Color(ColorConstants.getPrimaryWhite()),
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
                    color: Color(ColorConstants.getPrimaryBlack()),
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
                  color: Color(ColorConstants.getPrimaryWhite()),
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
                      color: Color(ColorConstants.getPrimaryBlack()),
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
