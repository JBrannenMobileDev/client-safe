import 'dart:convert';
import 'dart:io';

import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/LocationDao.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseGroupDao.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseLibraryGroupDao.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseSubmittedGroupDao.dart';
import 'package:dandylight/models/Contract.dart';
import 'package:dandylight/models/PoseLibraryGroup.dart';
import 'package:dandylight/utils/EnvironmentUtil.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/Job.dart';
import '../../models/LocationDandy.dart';
import '../../models/Pose.dart';
import '../../models/PoseGroup.dart';
import '../../models/Profile.dart';
import '../../utils/DandylightCacheManager.dart';
import '../local_db/daos/PoseDao.dart';
import '../local_db/daos/ProfileDao.dart';

class FileStorage {
  static saveLocationImageFile(String imagePath, LocationDandy location) async {
    await _uploadLocationImageFile(imagePath, location);
  }

  static savePoseImageFile(String pathLarge, Pose pose, PoseGroup group) async {
    await _uploadPoseImageFile(pathLarge, pose, group);
  }

  static saveLibraryPoseImageFile(String pathLarge, Pose pose, PoseLibraryGroup group) async {
    await _uploadLibraryPoseImageFile(pathLarge, pose, group);
  }

  static saveSubmittedPoseImageFile(String pathLarge, Pose pose) async {
    await _uploadSubmittedPoseImageFile(pathLarge, pose);
  }

  static saveProfileIconImageFile(String pathLarge, Profile profile, Function(TaskSnapshot) handleProgress) async {
    await _uploadProfileIconImageFile(pathLarge, profile, handleProgress);
  }

  static saveProfilePreviewIconImageFile(String pathLarge, Profile profile, Function(TaskSnapshot) handleProgress) async {
    await _uploadProfilePreviewIconImageFile(pathLarge, profile, handleProgress);
  }

  static saveBannerWebImageFile(String pathLarge, Profile profile, Function(TaskSnapshot) handleProgress) async {
    await _uploadBannerWebImageFile(pathLarge, profile, handleProgress);
  }

  static saveBannerMobileImageFile(String pathLarge, Profile profile, Function(TaskSnapshot) handleProgress) async {
    await _uploadBannerMobileImageFile(pathLarge, profile, handleProgress);
  }

  static savePreviewBannerWebImageFile(String pathLarge, Profile profile, Function(TaskSnapshot) handleProgress) async {
    await _uploadPreviewBannerWebImageFile(pathLarge, profile, handleProgress);
  }

  static savePreviewBannerMobileImageFile(String pathLarge, Profile profile, Function(TaskSnapshot) handleProgress) async {
    await _uploadPreviewBannerMobileImageFile(pathLarge, profile, handleProgress);
  }

  static void deleteLocationFileImage(LocationDandy location) async {
    _deleteLocationImageFileFromCloud(location);
  }

  static void deletePoseFileImage(Pose pose) async {
    _deletePoseImageFileFromCloud(pose);
  }

  //Intended for flutter web
  static void webDownload(Object bytes, String fileName) {
    Uri uri = Uri.parse("data:application/octet-stream;base64,${base64Encode(bytes)}");
    launchUrl(uri);
  }

  static Future<File> getLocationImageFile(LocationDandy location) async {
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

  static Future<File> getSubmittedPoseImageFile(Pose pose) async {
    String imageUrl = pose.imageUrl;

    if(imageUrl == null || imageUrl.isEmpty) {
      final storageRef = FirebaseStorage.instance.ref();
      final cloudFilePath = storageRef.child(_buildPoseLibraryImagePath(pose));
      imageUrl = await cloudFilePath.getDownloadURL();
      await _updateSubmittedPoseImageUrlLarge(pose, imageUrl);
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

  static _updateSubmittedPoseImageUrlLarge(Pose poseToUpdate, String imageUrl) async {
    poseToUpdate.imageUrl = imageUrl;
    await PoseDao.update(poseToUpdate);
    await PoseSubmittedGroupDao.updatePoseInGroup(poseToUpdate, UidUtil().getUid());
  }

  static _updateProfileIconImageUrlLarge(Profile profileToUpdate, String imageUrl) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.logoUrl = imageUrl;
    await ProfileDao.update(profile);
  }

  static _updateProfilePreviewIconImageUrlLarge(Profile profileToUpdate, String imageUrl) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.previewLogoUrl = imageUrl;
    await ProfileDao.update(profile);
  }

  static _updateBannerWebImageUrlLarge(Profile profileToUpdate, String imageUrl) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.bannerWebUrl = imageUrl;
    await ProfileDao.update(profile);
  }

  static _updateBannerMobileImageUrlLarge(Profile profileToUpdate, String imageUrl) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.bannerMobileUrl = imageUrl;
    await ProfileDao.update(profile);
  }

  static _updatePreviewBannerWebImageUrlLarge(Profile profileToUpdate, String imageUrl) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.previewBannerWebUrl = imageUrl;
    await ProfileDao.update(profile);
  }

  static _updatePreviewBannerMobileImageUrlLarge(Profile profileToUpdate, String imageUrl) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.previewBannerMobileUrl = imageUrl;
    await ProfileDao.update(profile);
  }

  static _updateLocationImageUrl(LocationDandy locationToUpdate, String imageUrl) async {
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

  static _deleteLocationImageFileFromCloud(LocationDandy location) async {
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

  static _uploadLocationImageFile(String imagePath, LocationDandy location) async {
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

  static _uploadLibraryPoseImageFile(String imagePathLarge, Pose pose, PoseLibraryGroup group) async {
    final storageRef = FirebaseStorage.instance.ref();

    if(imagePathLarge != null) {
      final uploadTask = storageRef
          .child(_buildPoseLibraryImagePath(pose))
          .putFile(File(imagePathLarge));

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
  }

  static _uploadSubmittedPoseImageFile(String imagePathLarge, Pose pose) async {
    final storageRef = FirebaseStorage.instance.ref();

    if(imagePathLarge != null) {
      final uploadTaskLarge = storageRef
          .child(_buildPoseLibraryImagePath(pose))
          .putFile(File(imagePathLarge));

      uploadTaskLarge.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
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
            _fetchAndSaveSubmittedPoseImageDownloadUrlLarge(pose);
            break;
        }
      });
    }
  }

  static _uploadProfileIconImageFile(String imagePathLarge, Profile profile, Function(TaskSnapshot) handleProgress) async {
    final storageRef = FirebaseStorage.instance.ref();

    if(imagePathLarge != null) {
      final uploadTaskLarge = storageRef
          .child(_buildProfileIconImagePath(imagePathLarge))
          .putFile(File(imagePathLarge));

      uploadTaskLarge.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        handleProgress(taskSnapshot);
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
            print("Upload was successful");
            _fetchAndSaveProfileIconImageDownloadUrlLarge(imagePathLarge, profile);
            break;
        }
      });
    }
  }

  static _uploadProfilePreviewIconImageFile(String imagePathLarge, Profile profile, Function(TaskSnapshot) handleProgress) async {
    final storageRef = FirebaseStorage.instance.ref();

    if(imagePathLarge != null) {
      final uploadTaskLarge = storageRef
          .child(_buildProfilePreviewIconImagePath(imagePathLarge))
          .putFile(File(imagePathLarge));

      uploadTaskLarge.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        handleProgress(taskSnapshot);
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
            _fetchAndSaveProfilePreviewIconImageDownloadUrlLarge(imagePathLarge, profile);
            break;
        }
      });
    }
  }

  static _uploadBannerWebImageFile(String imagePathLarge, Profile profile, Function(TaskSnapshot) handleProgress) async {
    final storageRef = FirebaseStorage.instance.ref();

    if(imagePathLarge != null) {
      final uploadTaskLarge = storageRef
          .child(_buildBannerWebImagePath(imagePathLarge))
          .putFile(File(imagePathLarge));

      uploadTaskLarge.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        handleProgress(taskSnapshot);
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
            _fetchAndSaveBannerWebImageDownloadUrlLarge(imagePathLarge, profile);
            break;
        }
      });
    }
  }

  static _uploadBannerMobileImageFile(String imagePathLarge, Profile profile, Function(TaskSnapshot) handleProgress) async {
    final storageRef = FirebaseStorage.instance.ref();

    if(imagePathLarge != null) {
      final uploadTaskLarge = storageRef
          .child(_buildBannerMobileImagePath(imagePathLarge))
          .putFile(File(imagePathLarge));

      uploadTaskLarge.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        handleProgress(taskSnapshot);
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
            _fetchAndSaveBannerMobileImageDownloadUrlLarge(imagePathLarge, profile);
            break;
        }
      });
    }
  }

  static _uploadPreviewBannerWebImageFile(String imagePathLarge, Profile profile, Function(TaskSnapshot) handleProgress) async {
    final storageRef = FirebaseStorage.instance.ref();

    if(imagePathLarge != null) {
      final uploadTaskLarge = storageRef
          .child(_buildPreviewBannerWebImagePath(imagePathLarge))
          .putFile(File(imagePathLarge));

      uploadTaskLarge.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        handleProgress(taskSnapshot);
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
            _fetchAndSavePreviewBannerWebImageDownloadUrlLarge(imagePathLarge, profile);
            break;
        }
      });
    }
  }

  static _uploadPreviewBannerMobileImageFile(String imagePathLarge, Profile profile, Function(TaskSnapshot) handleProgress) async {
    final storageRef = FirebaseStorage.instance.ref();

    if(imagePathLarge != null) {
      final uploadTaskLarge = storageRef
          .child(_buildPreviewBannerMobileImagePath(imagePathLarge))
          .putFile(File(imagePathLarge));

      uploadTaskLarge.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        handleProgress(taskSnapshot);
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
            _fetchAndSavePreviewBannerMobileImageDownloadUrlLarge(imagePathLarge, profile);
            break;
        }
      });
    }
  }

  static _fetchAndSaveLibraryPoseImageDownloadUrl(Pose pose, PoseLibraryGroup group) async {
    final storageRef = FirebaseStorage.instance.ref();
    final cloudFilePath = storageRef.child(_buildPoseLibraryImagePath(pose));
    _updateLibraryPoseImageUrl(pose, await cloudFilePath.getDownloadURL(), group);
  }

  static _fetchAndSaveSubmittedPoseImageDownloadUrlLarge(Pose pose) async {
    final storageRef = FirebaseStorage.instance.ref();
    final cloudFilePath = storageRef.child(_buildPoseLibraryImagePath(pose));
    await _updateSubmittedPoseImageUrlLarge(pose, await cloudFilePath.getDownloadURL());
  }

  static _fetchAndSaveProfileIconImageDownloadUrlLarge(String imagePathLarge, Profile profile) async {
    final storageRef = FirebaseStorage.instance.ref();
    final cloudFilePath = storageRef.child(_buildProfileIconImagePath(imagePathLarge));
    await _updateProfileIconImageUrlLarge(profile, await cloudFilePath.getDownloadURL());
  }

  static _fetchAndSaveProfilePreviewIconImageDownloadUrlLarge(String imagePathLarge, Profile profile) async {
    final storageRef = FirebaseStorage.instance.ref();
    final cloudFilePath = storageRef.child(_buildProfilePreviewIconImagePath(imagePathLarge));
    await _updateProfilePreviewIconImageUrlLarge(profile, await cloudFilePath.getDownloadURL());
  }

  static _fetchAndSaveBannerWebImageDownloadUrlLarge(String imagePathLarge, Profile profile) async {
    final storageRef = FirebaseStorage.instance.ref();
    final cloudFilePath = storageRef.child(_buildBannerWebImagePath(imagePathLarge));
    await _updateBannerWebImageUrlLarge(profile, await cloudFilePath.getDownloadURL());
  }

  static _fetchAndSaveBannerMobileImageDownloadUrlLarge(String imagePathLarge, Profile profile) async {
    final storageRef = FirebaseStorage.instance.ref();
    final cloudFilePath = storageRef.child(_buildBannerMobileImagePath(imagePathLarge));
    await _updateBannerMobileImageUrlLarge(profile, await cloudFilePath.getDownloadURL());
  }

  static _fetchAndSavePreviewBannerWebImageDownloadUrlLarge(String imagePathLarge, Profile profile) async {
    final storageRef = FirebaseStorage.instance.ref();
    final cloudFilePath = storageRef.child(_buildPreviewBannerWebImagePath(imagePathLarge));
    await _updatePreviewBannerWebImageUrlLarge(profile, await cloudFilePath.getDownloadURL());
  }

  static _fetchAndSavePreviewBannerMobileImageDownloadUrlLarge(String imagePathLarge, Profile profile) async {
    final storageRef = FirebaseStorage.instance.ref();
    final cloudFilePath = storageRef.child(_buildPreviewBannerMobileImagePath(imagePathLarge));
    await _updatePreviewBannerMobileImageUrlLarge(profile, await cloudFilePath.getDownloadURL());
  }

  static _fetchAndSavePoseImageDownloadUrl(Pose pose, PoseGroup group) async {
    final storageRef = FirebaseStorage.instance.ref();
    final cloudFilePath = storageRef.child(_buildPoseImagePath(pose));
    _updatePoseImageUrl(pose, await cloudFilePath.getDownloadURL(), group, null);
  }

  static _fetchAndSaveLocationImageDownloadUrl(LocationDandy location) async {
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

  static String _buildExampleLocationImagePath(LocationDandy location) {
    return "/env/${EnvironmentUtil().getCurrentEnvironment()}/images/dandyLight/exampleLocation/Screen Shot 2023-05-20 at 9.58.02 AM.png";
  }

  static String _buildLocationImagePath(LocationDandy location) {
    return "/env/${EnvironmentUtil().getCurrentEnvironment()}/images/${UidUtil().getUid()}/locations/${location.documentId}.jpg";
  }

  static String _buildPoseImagePath(Pose pose) {
    return "/env/${EnvironmentUtil().getCurrentEnvironment()}/images/${UidUtil().getUid()}/poses/${pose.documentId}.jpg";
  }
  
  static String _buildPoseImagePathSmall(Pose pose) {
    return "/env/${EnvironmentUtil().getCurrentEnvironment()}/images/${UidUtil().getUid()}/poses/${pose.documentId}small.jpg";
  }
  
  static String _buildPoseLibraryImagePath(Pose pose) {
    return "/env/${EnvironmentUtil().getCurrentEnvironment()}/images/dandyLight/libraryPoses/${pose.documentId}.jpg";
  }

  static String _buildProfileIconImagePath(String localImagePath) {
    return "/env/${EnvironmentUtil().getCurrentEnvironment()}/images/${UidUtil().getUid()}/profile/${localImagePath}logoImage.jpg";
  }

  static String _buildProfilePreviewIconImagePath(String localImagePath) {
    return "/env/${EnvironmentUtil().getCurrentEnvironment()}/images/${UidUtil().getUid()}/profile/${localImagePath}previewLogoImage.jpg";
  }

  static String _buildBannerWebImagePath(String localImagePath) {
    return "/env/${EnvironmentUtil().getCurrentEnvironment()}/images/${UidUtil().getUid()}/profile/${localImagePath}bannerWebImage.jpg";
  }

  static String _buildBannerMobileImagePath(String localImagePath) {
    return "/env/${EnvironmentUtil().getCurrentEnvironment()}/images/${UidUtil().getUid()}/profile/${localImagePath}bannerMobileImage.jpg";
  }

  static String _buildPreviewBannerWebImagePath(String localImagePath) {
    return "/env/${EnvironmentUtil().getCurrentEnvironment()}/images/${UidUtil().getUid()}/profile/${localImagePath}previewBannerWebImage.jpg";
  }

  static String _buildPreviewBannerMobileImagePath(String localImagePath) {
    return "/env/${EnvironmentUtil().getCurrentEnvironment()}/images/${UidUtil().getUid()}/profile/${localImagePath}previewBannerMobileImage.jpg";
  }

  static String _buildPoseLibraryImagePathSmall(Pose pose) {
    return "/env/${EnvironmentUtil().getCurrentEnvironment()}/images/dandyLight/libraryPoses/${pose.documentId}small.jpg";
  }

  static String _buildContractFilePath(Contract contract) {
    return "/env/${EnvironmentUtil().getCurrentEnvironment()}/files/${UidUtil().getUid()}/contracts/${contract.documentId}.pdf";
  }
}