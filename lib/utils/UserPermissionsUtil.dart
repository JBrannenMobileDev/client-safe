import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

class UserPermissionsUtil {

  static requestPermission(Permission permission) async{
    if (await permission.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
    }
  }

  static Future<PermissionStatus> getPermissionStatus(Permission permission) async {
    var status = await permission.status;
    if (status.isUndetermined) {
      // We didn't ask for permission yet.
    }

// You can can also directly ask the permission about its status.
    if (await Permission.location.isRestricted) {
      // The OS restricts access, for example because of parental controls.
    }
    return status;
  }
}