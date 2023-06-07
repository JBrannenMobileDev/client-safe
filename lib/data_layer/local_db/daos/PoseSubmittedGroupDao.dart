import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/PoseSubmittedGroup.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';

import '../../firebase/collections/PoseSubmittedGroupCollection.dart';

class PoseSubmittedGroupDao extends Equatable{
  static const String POSE_SUBMITTED_GROUP_STORE_NAME = 'poseSubmittedGroup';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _PoseSubmittedGroupGroupStore = intMapStoreFactory.store(POSE_SUBMITTED_GROUP_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await SembastDb.instance.database;

  static Future<PoseSubmittedGroup> insert(PoseSubmittedGroup pose) async {
    pose.id = await _PoseSubmittedGroupGroupStore.add(await _db, pose.toMap());
    await PoseSubmittedGroupCollection().createPoseSubmittedGroup(pose);
    return pose;
  }

  static Future insertLocalOnly(PoseSubmittedGroup pose) async {
    pose.id = null;
    await _PoseSubmittedGroupGroupStore.add(await _db, pose.toMap());
  }

  static Future<PoseSubmittedGroup> insertOrUpdate(PoseSubmittedGroup pose) async {
    List<PoseSubmittedGroup> poseList = await getAllSortedMostFrequent();
    bool alreadyExists = false;
    for(PoseSubmittedGroup singlePoseSubmittedGroup in poseList){
      if(singlePoseSubmittedGroup.uid == pose.uid){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      return await update(pose);
    }else{
      return await insert(pose);
    }
  }

  static Future<PoseSubmittedGroup> getByUid(String uid) async{
    if((await getAllSortedMostFrequent()).length > 0) {
      final finder = Finder(filter: Filter.equals('uid', uid));
      final recordSnapshots = await _PoseSubmittedGroupGroupStore.find(await _db, finder: finder);
      // Making a List<profileId> out of List<RecordSnapshot>
      List<PoseSubmittedGroup> poses = recordSnapshots.map((snapshot) {
        final pose = PoseSubmittedGroup.fromMap(snapshot.value);
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

  static Future<PoseSubmittedGroup> update(PoseSubmittedGroup pose) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('uid', pose.uid));
    await _PoseSubmittedGroupGroupStore.update(
      await _db,
      pose.toMap(),
      finder: finder,
    );
    await PoseSubmittedGroupCollection().updatePoseSubmittedGroups(pose);
    return pose;
  }

  static Future updateLocalOnly(PoseSubmittedGroup pose) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('uid', pose.uid));
    await _PoseSubmittedGroupGroupStore.update(
      await _db,
      pose.toMap(),
      finder: finder,
    );
  }

  static Future delete(String uid) async {
    final finder = Finder(filter: Filter.equals('uid', uid));
    await _PoseSubmittedGroupGroupStore.delete(
      await _db,
      finder: finder,
    ).onError(
            (error, stackTrace) => null
    );
    await PoseSubmittedGroupCollection().deletePoseSubmittedGroup(uid);
  }

  static Future<List<PoseSubmittedGroup>> getAllSortedMostFrequent() async {
    final finder = Finder(sortOrders: [
      SortOrder('numOfSessionsAtThisPoseSubmittedGroup'),
    ]);

    final recordSnapshots = await _PoseSubmittedGroupGroupStore.find(await _db, finder: finder).catchError((error) {
      print(error);
    });

    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      if(snapshot == null) return null;
      final pose = PoseSubmittedGroup.fromMap(snapshot.value);
      pose.id = snapshot.key;
      return pose;
    }).toList();
  }

  static Future<void> syncAllFromFireStore() async {
    PoseSubmittedGroup poseSubmittedGroup = await getByUid(UidUtil().getUid());
    PoseSubmittedGroup fireStorePoseSubmittedGroup = await PoseSubmittedGroupCollection().getPoseSubmittedGroup();
    await _syncFireStoreToLocal(poseSubmittedGroup, fireStorePoseSubmittedGroup);
  }

  static Future<void> _deleteAllLocalPoseSubmittedGroups(List<PoseSubmittedGroup> allLocalPoseSubmittedGroups) async {
    for(PoseSubmittedGroup location in allLocalPoseSubmittedGroups) {
      final finder = Finder(filter: Filter.equals('uid', location.uid));
      await _PoseSubmittedGroupGroupStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static Future<void> _syncFireStoreToLocal(PoseSubmittedGroup localPoseSubmittedGroup, PoseSubmittedGroup fireStorePoseSubmittedGroup) async {
    if(fireStorePoseSubmittedGroup != null) {
      final finder = Finder(filter: Filter.equals('uid', fireStorePoseSubmittedGroup.uid));
      await _PoseSubmittedGroupGroupStore.update(
        await _db,
        fireStorePoseSubmittedGroup.toMap(),
        finder: finder,
      );
    } else {
      //PoseSubmittedGroup does nto exist on cloud. so delete from local.
      if(localPoseSubmittedGroup != null) {
        final finder = Finder(filter: Filter.equals('uid', localPoseSubmittedGroup.uid));
        await _PoseSubmittedGroupGroupStore.delete(
          await _db,
          finder: finder,
        );
      }
    }

    if(localPoseSubmittedGroup != null) {
      //do nothing. PoseSubmittedGroup already synced.
    } else {
      //add to local. does not exist in local and has not been synced yet.
      if(fireStorePoseSubmittedGroup != null) {
        fireStorePoseSubmittedGroup.id = null;
        await _PoseSubmittedGroupGroupStore.add(await _db, fireStorePoseSubmittedGroup.toMap());
      }
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static void deleteAllLocal() async {
    List<PoseSubmittedGroup> locations = await getAllSortedMostFrequent();
    _deleteAllLocalPoseSubmittedGroups(locations);
  }
}