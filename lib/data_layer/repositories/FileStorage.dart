import 'dart:io';

import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/LocationDao.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseGroupDao.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseLibraryGroupDao.dart';
import 'package:dandylight/models/Contract.dart';
import 'package:dandylight/models/PoseLibraryGroup.dart';
import 'package:dandylight/utils/EnvironmentUtil.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/Job.dart';
import '../../models/Location.dart';
import '../../models/Pose.dart';
import '../../models/PoseGroup.dart';
import '../../utils/DandylightCacheManager.dart';
import '../../utils/permissions/UserPermissionsUtil.dart';
import '../local_db/daos/PoseDao.dart';

class FileStorage {
  static saveLocationImageFile(String imagePath, Location location) async {
    await _uploadLocationImageFile(imagePath, location);
  }

  static savePoseImageFile(String path, Pose pose, PoseGroup group) async {
    await _uploadPoseImageFile(path, pose, group);
  }

  static saveLibraryPoseImageFile(String path, Pose pose, PoseLibraryGroup group) async {
    await _uploadLibraryPoseImageFile(path, pose, group);
  }

  static saveContractFile(String contractPath, Contract contract) async {
    await _uploadContractFile(contractPath, contract);
  }

  static void deleteLocationFileImage(Location location) async {
    _deleteLocationImageFileFromCloud(location);
  }

  static void deletePoseFileImage(Pose pose) async {
    _deletePoseImageFileFromCloud(pose);
  }

  static void deleteFileContract(Contract contract) async {
    _deleteContractFileFromCloud(contract);
  }

  static Future<File> getLocationImageFile(Location location) async {
    final storageRef = FirebaseStorage.instance.ref();
    final cloudFilePath = storageRef.child(location.address == "exampleJob" ? _buildExampleLocationImagePath(location) : _buildLocationImagePath(location));
    String imageUrl = null;
    try{
      imageUrl = await cloudFilePath.getDownloadURL();
    } catch(ex) {
      imageUrl = null;
    }

    if(imageUrl != null) {
      return await DandylightCacheManager.instance.getSingleFile(imageUrl);
    } else {
      return null;
    }
  }

  static Future<File> getPoseImageFile(Pose pose, PoseGroup group, bool isLibraryPose, Job job) async {
    String imageUrl = pose.imageUrl;
    if(imageUrl == null || imageUrl.isEmpty) {
      final storageRef = FirebaseStorage.instance.ref();
      final cloudFilePath = storageRef.child(isLibraryPose ? _buildPoseLibraryImagePath(pose) : _buildPoseImagePath(pose));
      imageUrl = await cloudFilePath.getDownloadURL();
      _updatePoseImageUrl(pose, imageUrl, group, job);
    }
    return await DandylightCacheManager.instance.getSingleFile(imageUrl);
  }

  static Future<File> getPoseLibraryImageFile(Pose pose, PoseLibraryGroup group) async {
    String imageUrl = pose.imageUrl;

    if(imageUrl == null || imageUrl.isEmpty) {
      final storageRef = FirebaseStorage.instance.ref();
      final cloudFilePath = storageRef.child(_buildPoseLibraryImagePath(pose));
      imageUrl = await cloudFilePath.getDownloadURL();
      _updatePoseLibraryImageUrl(pose, imageUrl, group);
    }
    return await DandylightCacheManager.instance.getSingleFile(imageUrl);
  }

  static _updatePoseLibraryImageUrl(Pose poseToUpdate, String imageUrl, PoseLibraryGroup group) async {
    poseToUpdate.imageUrl = imageUrl;
    if(group != null) {
      for(Pose pose in group.poses) {
        if(pose.documentId == poseToUpdate.documentId) {
          pose.imageUrl = imageUrl;
        }
      }
      await PoseLibraryGroupDao.update(group);
    }
  }

  static _updatePoseImageUrl(Pose poseToUpdate, String imageUrl, PoseGroup group, Job job) async {
    //update Pose
    poseToUpdate.imageUrl = imageUrl;
    await PoseDao.insertOrUpdate(poseToUpdate);

    //Update PoseGroup that includes this pose
    if(group != null) {
      for(Pose pose in group.poses) {
        if(pose.documentId == poseToUpdate.documentId) {
          pose.imageUrl = imageUrl;
        }
      }
      await PoseGroupDao.update(group);
    }

    //Update Job poses that include this pose
    if(job != null) {
      job.poses.removeWhere((pose) => pose.documentId == poseToUpdate.documentId);
      job.poses.add(poseToUpdate);
      JobDao.update(job);
    }
  }

  static _updateLibraryPoseImageUrl(Pose poseToUpdate, String imageUrl, PoseLibraryGroup group) async {
    poseToUpdate.imageUrl = imageUrl;
    for(Pose pose in group.poses) {
      if(pose.documentId == poseToUpdate.documentId) {
        pose.imageUrl = imageUrl;
      }
    }
    await PoseLibraryGroupDao.update(group);
  }

  static _updateLocationImageUrl(Location locationToUpdate, String imageUrl) async {
    locationToUpdate.imageUrl = imageUrl;
    await LocationDao.update(locationToUpdate);
  }

  static updatePosesImageUrl(PoseGroup poseGroup, List<Pose> newPoses) async {
    for(Pose pose in newPoses) {
      final storageRef = FirebaseStorage.instance.ref();
      final cloudFilePath = await storageRef.child(_buildPoseImagePath(pose));
      String imageUrl = await cloudFilePath.getDownloadURL();
      poseGroup.poses.firstWhere((groupPose) => groupPose.documentId == pose.documentId)?.imageUrl = imageUrl;
    }
    await PoseGroupDao.update(poseGroup);
  }

  static Future<File> getContractFile(Contract contract) async {
    final storageRef = FirebaseStorage.instance.ref();
    final cloudFilePath = storageRef.child(_buildContractFilePath(contract));
    String contractUrl = await cloudFilePath.getDownloadURL();
    return await DandylightCacheManager.instance.getSingleFile(contractUrl);
  }

  static _deleteLocationImageFileFromCloud(Location location) async {
    try{
      if(location != null) {
        final storageRef = FirebaseStorage.instance.ref();
        await storageRef.child(_buildLocationImagePath(location)).delete();
      }
    } catch (e) {
      print(e);
    }
  }

  static _deletePoseImageFileFromCloud(Pose pose) async {
    try{
      if(pose != null) {
        final storageRef = FirebaseStorage.instance.ref();
        await storageRef.child(_buildPoseImagePath(pose)).delete();
      }
    } catch (e) {
      print(e);
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
          _fetchAndSaveLocationImageDownloadUrl(location);
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
          _fetchAndSavePoseImageDownloadUrl(pose, group);
          break;
      }
    });
  }

  static _uploadLibraryPoseImageFile(String imagePath, Pose pose, PoseLibraryGroup group) async {
    final storageRef = FirebaseStorage.instance.ref();

    final uploadTask = storageRef
        .child(_buildPoseLibraryImagePath(pose))
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
          _fetchAndSaveLibraryPoseImageDownloadUrl(pose, group);
          break;
      }
    });
  }

  static _fetchAndSaveLibraryPoseImageDownloadUrl(Pose pose, PoseLibraryGroup group) async {
    final storageRef = FirebaseStorage.instance.ref();
    final cloudFilePath = storageRef.child(_buildPoseLibraryImagePath(pose));
    _updateLibraryPoseImageUrl(pose, await cloudFilePath.getDownloadURL(), group);
  }

  static _fetchAndSavePoseImageDownloadUrl(Pose pose, PoseGroup group) async {
    final storageRef = FirebaseStorage.instance.ref();
    final cloudFilePath = storageRef.child(_buildPoseImagePath(pose));
    _updatePoseImageUrl(pose, await cloudFilePath.getDownloadURL(), group, null);
  }

  static _fetchAndSaveLocationImageDownloadUrl(Location location) async {
    final storageRef = FirebaseStorage.instance.ref();
    final cloudFilePath = storageRef.child(_buildLocationImagePath(location));
    _updateLocationImageUrl(location, await cloudFilePath.getDownloadURL());
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

  static String _buildExampleLocationImagePath(Location location) {
    return "/env/${EnvironmentUtil().getCurrentEnvironment()}/images/dandyLight/exampleLocation/Screen Shot 2023-05-20 at 9.58.02 AM.png";
  }

  static String _buildLocationImagePath(Location location) {
    return "/env/${EnvironmentUtil().getCurrentEnvironment()}/images/${UidUtil().getUid()}/locations/${location.documentId}.jpg";
  }

  static String _buildPoseImagePath(Pose pose) {
    return "/env/${EnvironmentUtil().getCurrentEnvironment()}/images/${UidUtil().getUid()}/poses/${pose.documentId}.jpg";
  }

  static String _buildPoseLibraryImagePath(Pose pose) {
    return "/env/${EnvironmentUtil().getCurrentEnvironment()}/images/dandyLight/libraryPoses/${pose.documentId}.jpg";
  }

  static String _buildContractFilePath(Contract contract) {
    return "/env/${EnvironmentUtil().getCurrentEnvironment()}/files/${UidUtil().getUid()}/contracts/${contract.documentId}.pdf";
  }
}