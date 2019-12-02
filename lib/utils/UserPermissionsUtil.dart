import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

class UserPermissionsUtil {

  static requestPermission(PermissionGroup permission) async{
    final List<PermissionGroup> permissions = <PermissionGroup>[permission];
    await PermissionHandler().requestPermissions(permissions);
  }

  static Future<PermissionStatus> getPermissionStatus(PermissionGroup permission) async {
    return await PermissionHandler().checkPermissionStatus(permission);
  }
}