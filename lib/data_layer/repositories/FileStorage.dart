import 'dart:io';

import 'package:dandylight/utils/UidUtil.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/Location.dart';
import '../../utils/CacheManagerDandylight.dart';
import '../../utils/UserPermissionsUtil.dart';

class FileStorage {
  static Future<bool> _requestStoragePermission() async {
    PermissionStatus status = await UserPermissionsUtil.getPermissionStatus(Permission.storage);
    if(!status.isGranted) {
      await UserPermissionsUtil.requestPermission(Permission.storage);
    }
    return await UserPermissionsUtil.getPermissionStatus(Permission.storage).isGranted;
  }

  static saveImageFile(String imagePath, Location location) async {
    _uploadImageFile(imagePath, location);
  }

  static void deleteFileImage(Location location) async {
    if(await _requestStoragePermission()) {
      _deleteFromCloud(location);
    }
  }

  static Future<File> getImageFile(Location location) async {
    final storageRef = FirebaseStorage.instance.ref();
    final cloudFilePath = storageRef.child(_buildImagePath(location));
    String imageUrl = await cloudFilePath.getDownloadURL();
    return await DefaultCacheManager().getSingleFile(imageUrl);
  }

  static _deleteFromCloud(Location location) async {
    if(location != null) {
      final storageRef = FirebaseStorage.instance.ref();
      await storageRef.child(_buildImagePath(location)).delete();
    }
  }

  static _uploadImageFile(String imagePath, Location location) async {
    final storageRef = FirebaseStorage.instance.ref();

    final uploadTask = storageRef
        .child(_buildImagePath(location))
        .putFile(File(imagePath));

    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress = 100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
        // Handle unsuccessful uploads
          break;
        case TaskState.success:
        // Handle successful uploads on complete
        // ...
          break;
      }
    });
  }

  static String _buildImagePath(Location location) {
    return "/images/${UidUtil().getUid()}/locations/${location.documentId}.jpg";
  }
}