import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/pages/new_job_page/widgets/NewJobTextField.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:dandylight/utils/permissions/UserPermissionsUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widgets/TextDandyLight.dart';

class PermissionDialog extends StatefulWidget {
  PermissionDialog({required this.permission, required this.isPermanentlyDenied, this.customMessage, this.callOnGranted});

  final Permission permission;
  final bool? isPermanentlyDenied;
  final String? customMessage;
  final Function? callOnGranted;

  @override
  _PermissionDialogState createState() {
    return _PermissionDialogState(permission, isPermanentlyDenied!, customMessage, callOnGranted);
  }
}

class _PermissionDialogState extends State<PermissionDialog> with AutomaticKeepAliveClientMixin {
  final Permission permission;
  bool isPermanentlyDenied;
  final String? customMessage;
  final Function? callOnGranted;

  _PermissionDialogState(this.permission, this.isPermanentlyDenied, this.customMessage, this.callOnGranted);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                width: 332,
                decoration: BoxDecoration(
                  color: Color(ColorConstants.getPrimaryWhite()),
                  borderRadius: BorderRadius.circular(16.0),
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 16, bottom: 16),
                            child: TextDandyLight(
                              type: TextDandyLight.LARGE_TEXT,
                              text: getTitle(permission!),
                            )
                        ),
                        Container(
                          height: 64,
                          child: Image.asset(getIconFileLocation(permission!), color: Color(ColorConstants.getPrimaryBlack()),),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 32, right: 32, top: 24, bottom: 32),
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              textAlign: TextAlign.center,
                              text: customMessage != null ? customMessage : isPermanentlyDenied! ? getBlockedMessage(permission!) :  getMessage(permission!),
                            )
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            style: Styles.getButtonStyle(),
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 48,
                              width: 142,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Color(ColorConstants.getPrimaryBackgroundGrey())
                              ),
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: 'Not now',
                                textAlign: TextAlign.center,
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                          ),
                          isPermanentlyDenied! ? TextButton(
                            style: Styles.getButtonStyle(),
                            onPressed: () {
                              openAppSettings();
                              Navigator.pop(context, false);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 48,
                              width: 142,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Color(ColorConstants.getPeachDark())
                              ),
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: 'Go to settings',
                                textAlign: TextAlign.center,
                                color: Color(ColorConstants.getPrimaryWhite()),
                              ),
                            ),
                          ) : TextButton(
                            style: Styles.getButtonStyle(),
                            onPressed: () async {
                              bool isGranted = false;
                              if(permission == Permission.calendarFullAccess) {
                                PermissionStatus status = await UserPermissionsUtil.requestPermission(permission: Permission.calendarWriteOnly, callOnGranted: null);
                                if(status.isGranted) {
                                  PermissionStatus fullAccessStatus = (await UserPermissionsUtil.requestPermission(permission: Permission.calendarFullAccess, callOnGranted: callOnGranted));
                                  isGranted = fullAccessStatus.isGranted;
                                  if(fullAccessStatus.isPermanentlyDenied) {
                                    setState(() {
                                      isPermanentlyDenied = true;
                                    });
                                  } else if(!fullAccessStatus.isGranted) {
                                    isGranted = (await UserPermissionsUtil.requestPermission(permission: permission, callOnGranted: callOnGranted)).isGranted;
                                  }
                                }
                              } else {
                                isGranted = (await UserPermissionsUtil.requestPermission(permission: permission, callOnGranted: callOnGranted)).isGranted;
                              }
                              if(!isPermanentlyDenied) {
                                Navigator.pop(context, isGranted);
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 48,
                              width: 142,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Color(ColorConstants.getPeachDark())
                              ),
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: 'OK',
                                textAlign: TextAlign.center,
                                color: Color(ColorConstants.getPrimaryWhite()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ),
            ),
    );
  }

  String getTitle(Permission permission) {
    if(permission == Permission.calendarFullAccess) {
      return "Calendar Permission";
    }
    if(permission == Permission.notification) {
      return "Notifications Permission";
    }
    if(permission == Permission.locationWhenInUse) {
      return "Location Permission";
    }
    if(permission == Permission.camera) {
      return "Camera Permission";
    }
    if(permission == Permission.contacts) {
      return "Contacts Permission";
    }
    if(permission == Permission.photos) {
      return "Photos Permission";
    }
    if(permission == Permission.storage) {
      return "File Storage Permission";
    }
    return "Permission";
  }

  String getIconFileLocation(Permission permission) {
    if(permission == Permission.calendarFullAccess) {
      return "assets/images/icons/calendar.png";
    }
    if(permission == Permission.notification) {
      return "assets/images/icons/reminder_icon_white.png";
    }
    if(permission == Permission.locationWhenInUse || permission == Permission.location || permission == Permission.locationAlways) {
      return "assets/images/icons/pin_white.png";
    }
    if(permission == Permission.camera) {
      return "assets/images/icons/camera.png";
    }
    if(permission == Permission.contacts) {
      return "assets/images/icons/contacts_icon.png";
    }
    if(permission == Permission.photos) {
      return "assets/images/icons/image_icon_white.png";
    }
    if(permission == Permission.storage) {
      return "assets/images/icons/folder_storage.png";
    }
    return "assets/images/icons/folder_storage.png";
  }

  String getMessage(Permission permission) {
    if(permission == Permission.calendarFullAccess || permission == Permission.calendarWriteOnly) {
      return "Calendar permission is required to sync your DandyLight calendar with your personal calendars.";
    }
    if(permission == Permission.notification) {
      return "Notifications permission is required to allow custom reminders and to notify you when a contract has been signed or invoice paid.";
    }
    if(permission == Permission.locationWhenInUse || permission == Permission.location || permission == Permission.locationAlways) {
      return "Location permission is required for the Sunset, Weather and location features to work properly.";
    }
    if(permission == Permission.camera) {
      return "Camera permission is needed to capture a picture for a location.";
    }
    if(permission == Permission.contacts) {
      return "Contacts permission is required to sync your DandyLight contacts with your device contacts.";
    }
    if(permission == Permission.photos) {
      return "Photos permission is required for uploading images.";
    }
    if(permission == Permission.storage) {
      return "File Storage permission is required for saving poses and location images.";
    }
    return "Permission";
  }

  String getBlockedMessage(Permission permission) {
    if(permission == Permission.calendarFullAccess) {
      return "Calendar permission was previously denied. To enable this permission please go to your device settings.";
    }
    if(permission == Permission.notification) {
      return "Notifications permission was previously denied. To enable this permission please go to your device settings.";
    }
    if(permission == Permission.locationWhenInUse || permission == Permission.location || permission == Permission.locationAlways) {
      return "Location permission was previously denied. To enable this permission please go to your device settings.";
    }
    if(permission == Permission.camera) {
      return "Camera permission was previously denied. To enable this permission please go to your device settings.";
    }
    if(permission == Permission.contacts) {
      return "Contacts permission was previously denied. To enable this permission please go to your device settings.";
    }
    if(permission == Permission.photos) {
      return "Photos permission was previously denied. To enable this permission please go to your device settings.";
    }
    if(permission == Permission.storage) {
      return "File Storage permission was previously denied. To enable this permission please go to your device settings.";
    }
    return "Permission";
  }

  @override
  bool get wantKeepAlive => true;
}
