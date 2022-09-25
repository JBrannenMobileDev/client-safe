import 'dart:io';

import 'package:dandylight/data_layer/local_db/daos/PoseGroupDao.dart';
import 'package:dandylight/models/Contract.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/Location.dart';
import '../../models/Pose.dart';
import '../../models/PoseGroup.dart';
import '../../utils/CacheManagerDandylight.dart';
import '../../utils/UserPermissionsUtil.dart';
import '../local_db/daos/PoseDao.dart';

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

  static savePoseImageFile(String path, Pose pose, PoseGroup group) async {
    _uploadPoseImageFile(path, pose, group);
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

  static Future<File> getPoseImageFile(Pose pose, PoseGroup group) async {
    String imageUrl = pose.imageUrl;
    if(imageUrl == null || imageUrl.isEmpty) {
      final storageRef = FirebaseStorage.instance.ref();
      final cloudFilePath = storageRef.child(_buildPoseImagePath(pose));
      imageUrl = await cloudFilePath.getDownloadURL();
      _updatePoseImageUrl(pose, imageUrl, group);
    }
    return await DefaultCacheManager().getSingleFile(imageUrl);
  }

  static _updatePoseImageUrl(Pose poseToUpdate, String imageUrl, PoseGroup group) {
    poseToUpdate.imageUrl = imageUrl;
    PoseDao.update(poseToUpdate);
    for(Pose pose in group.poses) {
      if(pose.documentId == poseToUpdate.documentId) {
        pose.imageUrl = imageUrl;
      }
    }
    PoseGroupDao.update(group);
  }

  static updatePosesImageUrl(PoseGroup poseGroup, List<Pose> newPoses) async {
    for(Pose pose in newPoses) {
      final storageRef = FirebaseStorage.instance.ref();
      final cloudFilePath = storageRef.child(_buildPoseImagePath(pose));
      String imageUrl = await cloudFilePath.getDownloadURL();
      poseGroup.poses.firstWhere((groupPose) => groupPose.documentId == pose.documentId)?.imageUrl = imageUrl;
    }
    await PoseGroupDao.update(poseGroup);
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

  static _uploadPoseImageFile(String imagePath, Pose pose, PoseGroup group) async {
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
          _fetchAndSaveDownloadUrl(pose, group);
          break;
      }
    });
  }

  static _fetchAndSaveDownloadUrl(Pose pose, PoseGroup group) async {
    final storageRef = FirebaseStorage.instance.ref();
    final cloudFilePath = storageRef.child(_buildPoseImagePath(pose));
    _updatePoseImageUrl(pose, await cloudFilePath.getDownloadURL(), group);
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