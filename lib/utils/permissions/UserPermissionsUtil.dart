import 'dart:async';

import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/Profile.dart';
import 'PermissionDialog.dart';

class UserPermissionsUtil {

  static Future<bool> showPermissionRequest({
    required Permission? permission,
    required BuildContext? context,
    String? customMessage,
    Function? callOnGranted,
    Profile? profile,
  }) async {

    bool isPermanentlyDenied = await permission!.status.isPermanentlyDenied;
    bool isGranted = await permission.status.isGranted;
    print('isGranted = $isGranted');

    if(profile != null) {
      bool isProfilePermissionEnabled = isProfilePermissionGranted(permission, profile);
      if(!isGranted || !isProfilePermissionEnabled ) {
        print('Showing permission dialog 1');
        bool isGranted = await showDialog(
          context: context!,
          builder: (BuildContext context) {
            return PermissionDialog(
              permission: permission,
              isPermanentlyDenied: isPermanentlyDenied,
              customMessage: customMessage,
              callOnGranted: null,
            );
          },
        );
        return isGranted;
      } else if(isGranted && callOnGranted != null) {
        callOnGranted();
      }
    } else {
      if(!isGranted) {
        print('Showing permission dialog 2');
        bool isGranted = await showDialog(
          context: context!,
          builder: (BuildContext context) {
            return PermissionDialog(
              permission: permission,
              isPermanentlyDenied: isPermanentlyDenied,
              customMessage: customMessage,
              callOnGranted: null,
            );
          },
        );
        return isGranted;
      } else if(isGranted && callOnGranted != null) {
        callOnGranted();
      }
    }

    return isGranted;
  }

  static Future<PermissionStatus> requestPermission({required Permission permission, Function? callOnGranted}) async{
    PermissionStatus status = await permission.request();
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    switch(status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        if(permission == Permission.calendarFullAccess) {
          profile!.calendarEnabled = true;
        }
        if(permission == Permission.reminders) {
          profile!.pushNotificationsEnabled = true;
        }
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        if(permission == Permission.calendarFullAccess) {
          profile!.calendarEnabled = false;
        }
        if(permission == Permission.reminders) {
          profile!.pushNotificationsEnabled = false;
        }
        break;
      case PermissionStatus.provisional:
        if(permission == Permission.calendarFullAccess) {
          profile!.calendarEnabled = true;
        }
        if(permission == Permission.reminders) {
          profile!.pushNotificationsEnabled = true;
        }
        break;
    }
    if(status.isGranted && callOnGranted != null) callOnGranted();
    return status;
  }

  static Future<PermissionStatus> getPermissionStatus(Permission permission) async {
    return await permission.status;
  }

  static bool isProfilePermissionGranted(Permission permission, Profile profile) {
    bool granted = true;
    switch(permission) {
      case Permission.calendarFullAccess:
        granted = profile.calendarEnabled ?? false;
        print('Is calendar permission enabled on profile = $granted');
        break;
      case Permission.notification:
        granted = profile.pushNotificationsEnabled ?? false;
        print('Is calendar permission enabled on profile = $granted');
        break;
    }
    return granted;
  }
}