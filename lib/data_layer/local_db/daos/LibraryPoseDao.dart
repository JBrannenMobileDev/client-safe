import 'dart:async';

import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/data_layer/repositories/FileStorage.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';

import '../../../models/Pose.dart';
import '../../firebase/collections/LibraryPoseCollection.dart';

class LibraryPoseDao extends Equatable{
  static const String POSE_STORE_NAME = 'library_pose';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _PoseStore = intMapStoreFactory.store(POSE_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await SembastDb.instance.database;

  static Future<Pose> insert(Pose pose) async {
    pose.documentId = Uuid().v1();
    pose.id = await _PoseStore.add(await _db, pose.toMap());
    await LibraryPoseCollection().createPose(pose);
    _updateLastChangedTime();
    return pose;
  }

  static Future insertLocalOnly(Pose pose) async {
    pose.id = null;
    await _PoseStore.add(await _db, pose.toMap());
  }

  static Future<void> _updateLastChangedTime() async {
    Profile profile = (await ProfileDao.getAll())!.elementAt(0);
    profile.posesLastChangeDate = DateTime.now();
    ProfileDao.update(profile);
  }

  static Future<Pose> insertOrUpdate(Pose pose) async {
    List<Pose>? poseList = await getAllSortedMostFrequent();
    bool alreadyExists = false;
    for(Pose singlePose in poseList!){
      if(singlePose.documentId == pose.documentId){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      return await update(pose);
    }else{
      return await insert(pose);
    }
  }

  static Future<Pose?> getById(String poseDocumentId) async{
    if((await getAllSortedMostFrequent())!.isNotEmpty) {
      final finder = Finder(filter: Filter.equals('documentId', poseDocumentId));
      final recordSnapshots = await _PoseStore.find(await _db, finder: finder);
      // Making a List<profileId> out of List<RecordSnapshot>
      List<Pose> poses = recordSnapshots.map((snapshot) {
        final pose = Pose.fromMap(snapshot.value);
        pose.id = snapshot.key;
        return pose;
      }).toList();
      if(poses.isNotEmpty) {
        return poses.elementAt(0);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<Stream<List<RecordSnapshot>>> getPosesStream() async {
    var query = _PoseStore.query();
    return query.onSnapshots(await _db);
  }

  static Future<Pose> update(Pose pose) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('documentId', pose.documentId));
    await _PoseStore.update(
      await _db,
      pose.toMap(),
      finder: finder,
    );
    await LibraryPoseCollection().updatePose(pose);
    return pose;
  }

  static Future updateLocalOnly(Pose pose) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('documentId', pose.documentId));
    await _PoseStore.update(
      await _db,
      pose.toMap(),
      finder: finder,
    );
  }

  static Future delete(String documentId) async {
    FileStorage.deletePoseFileImage(await getById(documentId));
    final finder = Finder(filter: Filter.equals('documentId', documentId));
    await _PoseStore.delete(
      await _db,
      finder: finder,
    );
    await LibraryPoseCollection().deletePose(documentId);
  }

  static Future<List<Pose>?> getAllSortedMostFrequent() async {
    final finder = Finder(sortOrders: [
      SortOrder('numOfSaves'),
    ]);

    final recordSnapshots = await _PoseStore.find(await _db, finder: finder).catchError((error) {
      print(error);
    });

    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final pose = Pose.fromMap(snapshot.value);
      pose.id = snapshot.key;
      return pose;
    }).toList().reversed.toList();
  }

  static Future<void> syncAllFromFireStore() async {
    List<Pose>? allLocalPoses = await getAllSortedMostFrequent();
    List<Pose>? allFireStorePoses = await LibraryPoseCollection().getAll();

    if(allLocalPoses != null && allLocalPoses.isNotEmpty) {
      if(allFireStorePoses != null && allFireStorePoses.isNotEmpty) {
        //both local and fireStore have Poses
        //fireStore is source of truth for this sync.
        await _syncFireStoreToLocal(allLocalPoses, allFireStorePoses);
      } else {
        //all Poses have been deleted in the cloud. Delete all local Poses also.
        _deleteAllLocalPoses(allLocalPoses);
      }
    } else {
      if(allFireStorePoses != null && allFireStorePoses.isNotEmpty){
        //no local Poses but there are fireStore Poses.
        await _copyAllFireStorePosesToLocal(allFireStorePoses);
      } else {
        //no Poses in either database. nothing to sync.
      }
    }
  }

  static Future<void> _deleteAllLocalPoses(List<Pose> allLocalPoses) async {
    for(Pose location in allLocalPoses) {
      final finder = Finder(filter: Filter.equals('documentId', location.documentId));
      await _PoseStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static Future<void> _copyAllFireStorePosesToLocal(List<Pose> allFireStorePoses) async {
    for (Pose PoseToSave in allFireStorePoses) {
      await _PoseStore.add(await _db, PoseToSave.toMap());
    }
  }

  static Future<void> _syncFireStoreToLocal(List<Pose> allLocalPoses, List<Pose> allFireStorePoses) async {
    for(Pose localPose in allLocalPoses) {
      //should only be 1 matching
      List<Pose> matchingFireStorePoses = allFireStorePoses.where((fireStorePose) => localPose.documentId == fireStorePose.documentId).toList();
      if(matchingFireStorePoses.isNotEmpty) {
        Pose fireStorePose = matchingFireStorePoses.elementAt(0);
        final finder = Finder(filter: Filter.equals('documentId', fireStorePose.documentId));
        await _PoseStore.update(
          await _db,
          fireStorePose.toMap(),
          finder: finder,
        );
      } else {
        //Pose does nto exist on cloud. so delete from local.
        final finder = Finder(filter: Filter.equals('documentId', localPose.documentId));
        await _PoseStore.delete(
          await _db,
          finder: finder,
        );
      }
    }

    for(Pose fireStorePose in allFireStorePoses) {
      List<Pose> matchingLocalPoses = allLocalPoses.where((localPose) => localPose.documentId == fireStorePose.documentId).toList();
      if(matchingLocalPoses.isNotEmpty) {
        //do nothing. Pose already synced.
      } else {
        //add to local. does not exist in local and has not been synced yet.
        fireStorePose.id = null;
        await _PoseStore.add(await _db, fireStorePose.toMap());
      }
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static void deleteAllLocal() async {
    List<Pose>? locations = await getAllSortedMostFrequent();
    _deleteAllLocalPoses(locations!);
  }

  static void deleteAllRemote() async {
    List<Pose>? poses = await getAllSortedMostFrequent();
    for(Pose pose in poses!) {
      await delete(pose.documentId!);
    }
  }
}