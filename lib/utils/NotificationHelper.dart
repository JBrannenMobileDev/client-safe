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
  static final int START_FIRST_JOB_ID = 63;
  static final int ONE_WEEK_LEFT_ID = 62;

  Function(NotificationResponse notificationResponse) notificationTapBackground;

  factory NotificationHelper() {
    return _singleton;
  }

  void setTapBackgroundMethod(Function(NotificationResponse notificationResponse) notificationTapBackground) {
    this.notificationTapBackground = notificationTapBackground;
  }

  NotificationHelper._SingletonConstructor();

  FlutterLocalNotificationsPlugin flutterNotificationPlugin;

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

    await flutterNotificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            print('Notification selected');
            if(notificationResponse.payload == JobReminder.MILEAGE_EXPENSE_ID) {
              UserOptionsUtil.showNewMileageExpenseSelected(context, null);
            }else if(notificationResponse.payload == JobReminder.POSE_FEATURED_ID) {
              Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
              profile.showNewMileageExpensePage = true;
              ProfileDao.update(profile);
            } else {
              // Job job = await JobDao.getJobById(notificationResponse.payload);
              NavigationUtil.onJobTapped(context, false);
            }
            break;
          case NotificationResponseType.selectedNotificationAction:
            print('Notification selected with action');
            if (notificationResponse.actionId == navigationActionId) {
              if(notificationResponse.payload == JobReminder.MILEAGE_EXPENSE_ID) {
                Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
                profile.showNewMileageExpensePage = true;
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
        List<Job> allJobs = await JobDao.getAllJobs();
        clearAll();

        if(allJobs.length == 1 && allJobs.elementAt(0).clientName == "Example Client") {
          scheduleStartFirstJobReminder();
        }

        for(int index = 0;index < pendingReminders.length; index++) {
          if(index < 62) {
            JobReminder reminderToSchedule = pendingReminders.elementAt(index);
            if(reminderToSchedule.triggerTime != null) {
              scheduleNotification(
                index,
                'Reminder',
                '(' + (await JobDao.getJobById(reminderToSchedule.jobDocumentId)).jobTitle + ')\n' + reminderToSchedule.reminder.description,
                reminderToSchedule.payload,
                reminderToSchedule.triggerTime,
              );
              print("Reminder has been scheduled.   notificationId = " + index.toString() + "   jobReminderId = " + reminderToSchedule.documentId + "   Trigger time = " + reminderToSchedule.triggerTime.toString());
            }
          }
        }
      }
  }

  Future<String> getNotificationJobId() async {
    String jobId = "";
    final NotificationAppLaunchDetails notificationAppLaunchDetails = await flutterNotificationPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      jobId = notificationAppLaunchDetails.notificationResponse?.payload;
    }
    print("Notification app launch JobId = $jobId");
    return jobId;
  }

  Future<void> clearAll() async {
    if(flutterNotificationPlugin != null) {
      await flutterNotificationPlugin.cancelAll();
    }
  }

  Future<void> turnOffNotificationById(num id) async {
    if(flutterNotificationPlugin != null) {
      await flutterNotificationPlugin.cancel(id);
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
      await flutterNotificationPlugin.zonedSchedule(
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

  void scheduleStartFirstJobReminder() async {
    DateTime profileCreatedDate = (await ProfileDao.getMatchingProfile(UidUtil().getUid())).accountCreatedDate;
    profileCreatedDate = profileCreatedDate.add(Duration(days: 3));

    if(DateTime.now().isBefore(profileCreatedDate)) {
      DateTime triggerDateTime = DateTime(profileCreatedDate.year, profileCreatedDate.month, profileCreatedDate.day, 9);
      scheduleNotification(
        START_FIRST_JOB_ID,
        "Start your first job!",
        "Have you booked a job recently? Track it in DandyLight to save time by staying organized! Don't forget to add poses to your job to make the shoot a breeze.",
        "first_job_reminder",
        triggerDateTime,
      );
    }
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  print('notification(${notificationResponse.id}) action tapped: ''${notificationResponse.actionId} with'' payload: ${notificationResponse.payload}');

  if(notificationResponse.payload?.isNotEmpty ?? false) {

  }
}
