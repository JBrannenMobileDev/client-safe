import 'dart:async';

import 'package:dandylight/data_layer/local_db/daos/JobReminderDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/permissions/UserPermissionsUtil.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../data_layer/local_db/daos/JobDao.dart';

class NotificationHelper {
  static final NotificationHelper _singleton = NotificationHelper._SingletonConstructor();
  static const int NEXT_TASK_ID = 63;

  Function(NotificationResponse notificationResponse)? notificationTapBackground;

  factory NotificationHelper() {
    return _singleton;
  }

  void setTapBackgroundMethod(Function(NotificationResponse notificationResponse) notificationTapBackground) {
    this.notificationTapBackground = notificationTapBackground;
  }

  NotificationHelper._SingletonConstructor();

  FlutterLocalNotificationsPlugin? flutterNotificationPlugin;

  Future<void> initNotifications(BuildContext context) async {
    flutterNotificationPlugin = FlutterLocalNotificationsPlugin();

    const MethodChannel platform = MethodChannel('dandylight_mobile');

    const String portName = 'notification_send_port';

    String selectedNotificationPayload;

    /// A notification action which triggers a url launch event
    const String urlLaunchActionId = 'id_1';

    /// A notification action which triggers a App navigation event
    const String navigationActionId = 'id_3';

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));

    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = new DarwinInitializationSettings();

    var initializationSettings = new InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterNotificationPlugin!.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            print('Notification selected');
            if(notificationResponse.payload == JobReminder.MILEAGE_EXPENSE_ID) {
              UserOptionsUtil.showNewMileageExpenseSelected(context, null);
            }else if(notificationResponse.payload == JobReminder.POSE_FEATURED_ID) {
              Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
              profile!.showNewMileageExpensePage = true;
              ProfileDao.update(profile);
            } else {

            }
            break;
          case NotificationResponseType.selectedNotificationAction:
            print('Notification selected with action');
            if (notificationResponse.actionId == navigationActionId) {
              if(notificationResponse.payload == JobReminder.MILEAGE_EXPENSE_ID) {
                Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
                profile!.showNewMileageExpensePage = true;
                ProfileDao.update(profile);
              }
            }
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    createAndUpdatePendingNotifications();
  }

  void createAndUpdatePendingNotifications() async {
      bool isGranted = (await UserPermissionsUtil.getPermissionStatus(Permission.notification)).isGranted;
      if(isGranted) {
        List<JobReminder> pendingReminders = await JobReminderDao.getPendingJobReminders();
        clearAll();

        for(int index = 0;index < pendingReminders.length; index++) {
          if(index < 62) {
            JobReminder reminderToSchedule = pendingReminders.elementAt(index);
            if(reminderToSchedule.triggerTime != null) {
              scheduleNotification(
                index,
                'Reminder',
                '(' + (await JobDao.getJobById(reminderToSchedule.jobDocumentId))!.jobTitle! + ')\n' + reminderToSchedule.reminder!.description!,
                reminderToSchedule.payload!,
                reminderToSchedule.triggerTime!,
              );
              print("Reminder has been scheduled.   notificationId = " + index.toString() + "   jobReminderId = " + reminderToSchedule.documentId! + "   Trigger time = " + reminderToSchedule.triggerTime.toString());
            }
          }
        }
      }
  }

  Future<String> getNotificationJobId() async {
    String jobId = "";
    final NotificationAppLaunchDetails? notificationAppLaunchDetails = await flutterNotificationPlugin?.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      jobId = notificationAppLaunchDetails!.notificationResponse!.payload!;
    }
    print("Notification app launch JobId = $jobId");
    return jobId;
  }

  Future<void> clearAll() async {
    if(flutterNotificationPlugin != null) {
      await flutterNotificationPlugin!.cancelAll();
    }
  }

  Future<void> turnOffNotificationById(int id) async {
    if(flutterNotificationPlugin != null) {
      await flutterNotificationPlugin!.cancel(id);
    }
  }

  Future<void> scheduleNotification(
      int id,
      String title,
      String body,
      String payload,
      DateTime scheduledNotificationDateTime) async {
    bool isGranted = (await UserPermissionsUtil.getPermissionStatus(Permission.notification)).isGranted;
    if(isGranted && flutterNotificationPlugin != null) {
      await flutterNotificationPlugin!.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        const NotificationDetails(
            android: AndroidNotificationDetails(
              '1',
              'Standard',
              actions: <AndroidNotificationAction>[],
            )),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation
            .absoluteTime,
        payload: payload,
      );
    }
  }

  void scheduleNextTaskNotification(String emailType, DateTime sendDate) async {
    if(DateTime.now().isBefore(sendDate)) {
      scheduleNotification(
        NEXT_TASK_ID,
        getNextTaskTitle(emailType),
        getNextTaskBody(emailType),
        "next_task_reminder",
        sendDate,
      );
    }
  }

  String getNextTaskTitle(String emailType) {
    switch(emailType) {
      case 'view_client_portal':
        return 'You\'re doing great! Keep going and complete your next step.';
      case 'view_example_job':
        return 'Keep up the good work! Your next task awaits.';
      case 'setup_your_brand':
        return 'You\'re making excellent progress! Keep it up."';
      case 'create_price_package':
        return 'Stay motivated! Complete your next task now.';
      case 'add_first_client':
        return 'You\'re on a roll! Continue with your next step.';
      case 'create_first_job':
        return 'Keep the momentum! Your next step is just a click away.';
      case 'create_contract':
        return 'Take your business to the next level: Complete your next step.';
      case 'add_contract_to_job':
        return 'Almost there! Finish your next step to stay on track.';
      case 'add_invoice_to_job':
        return 'Great job so far! Just a few more steps to go.';
      case 'add_questionnaire_to_job':
        return 'You\'re making excellent progress! Keep it up.';
      case 'add_poses_to_job':
        return 'You\'re doing great! Keep going and complete your next step.';
      case 'add_location_to_job':
        return 'Keep up the good work! Your next task awaits.';
    }
    return 'Next Task!';
  }

  String getNextTaskBody(String emailType) {
    switch(emailType) {
      case 'view_client_portal':
        return 'View your client portal to complete your next step.';
      case 'view_example_job':
        return 'View an example job to complete your next step.';
      case 'setup_your_brand':
        return 'Setup your brand to complete your next step.';
      case 'create_price_package':
        return 'Create a price package to complete your next step.';
      case 'add_first_client':
        return 'Add your first client to complete your next step.';
      case 'create_first_job':
        return 'Create your first job to complete your next step.';
      case 'create_contract':
        return 'Create a contract to complete your next step.';
      case 'add_contract_to_job':
        return 'Add a contract to a job to complete your next step.';
      case 'add_invoice_to_job':
        return 'Add an invoice to a job to complete your next step.';
      case 'add_questionnaire_to_job':
        return 'Add a questionnaire to a job to complete your next step.';
      case 'add_poses_to_job':
        return 'Add poses to a job to complete your next step.';
      case 'add_location_to_job':
        return 'Add a location to a job to complete your next step.';
    }
    return 'Tap this notification to complete your next step.';
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  print('notification(${notificationResponse.id}) action tapped: ''${notificationResponse.actionId} with'' payload: ${notificationResponse.payload}');

  if(notificationResponse.payload?.isNotEmpty ?? false) {

  }
}
