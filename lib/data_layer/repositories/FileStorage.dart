import 'dart:io';

import 'package:dandylight/models/Contract.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/Location.dart';
import '../../models/Pose.dart';
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

  static saveLocationImageFile(String imagePath, Location location) async {
    _uploadLocationImageFile(imagePath, location);
  }

  static savePoseImageFile(String path, Pose pose) async {
    _uploadPoseImageFile(path, pose);
  }

  static saveContractFile(String contractPath, Contract contract) async {
    _uploadContractFile(contractPath, contract);
  }

  static void deleteLocationFileImage(Location location) async {
    if(await _requestStoragePermission()) {
      _deleteLocationImageFileFromCloud(location);
    }
  }

  static void deletePoseFileImage(Pose pose) async {
    if(await _requestStoragePermission()) {
      _deletePoseImageFileFromCloud(pose);
    }
  }

  static void deleteFileContract(Contract contract) async {
    if(await _requestStoragePermission()) {
      _deleteContractFileFromCloud(contract);
    }
  }

  static Future<File> getLocationImageFile(Location location) async {
    final storageRef = FirebaseStorage.instance.ref();
    final cloudFilePath = storageRef.child(_buildLocationImagePath(location));
    String imageUrl = await cloudFilePath.getDownloadURL();
    return await DefaultCacheManager().getSingleFile(imageUrl);
  }

  static Future<File> getPoseImageFile(Pose pose) async {
    final storageRef = FirebaseStorage.instance.ref();
    final cloudFilePath = storageRef.child(_buildPoseImagePath(pose));
    String imageUrl = await cloudFilePath.getDownloadURL();
    return await DefaultCacheManager().getSingleFile(imageUrl);
  }

  static Future<File> getContractFile(Contract contract) async {
    final storageRef = FirebaseStorage.instance.ref();
    final cloudFilePath = storageRef.child(_buildContractFilePath(contract));
    String contractUrl = await cloudFilePath.getDownloadURL();
    return await DefaultCacheManager().getSingleFile(contractUrl);
  }

  static _deleteLocationImageFileFromCloud(Location location) async {
    if(location != null) {
      final storageRef = FirebaseStorage.instance.ref();
      await storageRef.child(_buildLocationImagePath(location)).delete();
    }
  }

  static _deletePoseImageFileFromCloud(Pose pose) async {
    if(pose != null) {
      final storageRef = FirebaseStorage.instance.ref();
      await storageRef.child(_buildPoseImagePath(pose)).delete();
    }
  }

  static _deleteContractFileFromCloud(Contract contract) async {
    if(contract != null) {
      final storageRef = FirebaseStorage.instance.ref();
      await storageRef.child(_buildContractFilePath(contract)).delete();
    }
  }

  static _uploadLocationImageFile(String imagePath, Location location) async {
    final storageRef = FirebaseStorage.instance.ref();

    final uploadTask = storageRef
        .child(_buildLocationImagePath(location))
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

  static _uploadPoseImageFile(String imagePath, Pose pose) async {
    final storageRef = FirebaseStorage.instance.ref();

    final uploadTask = storageRef
        .child(_buildPoseImagePath(pose))
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

  static _uploadContractFile(String contractPath, Contract contract) async {
    final storageRef = FirebaseStorage.instance.ref();

    final uploadTask = storageRef
        .child(_buildContractFilePath(contract))
        .putFile(File(contractPath));

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

  static String _buildLocationImagePath(Location location) {
    return "/images/${UidUtil().getUid()}/locations/${location.documentId}.jpg";
  }

  static String _buildPoseImagePath(Pose pose) {
    return "/images/${UidUtil().getUid()}/poses/${pose.documentId}.jpg";
  }

  static String _buildContractFilePath(Contract contract) {
    return "/files/${UidUtil().getUid()}/contracts/${contract.documentId}.pdf";
  }
}