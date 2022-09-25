import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/PoseGroup.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';

import '../../firebase/collections/PoseGroupCollection.dart';

class PoseGroupDao extends Equatable{
  static const String POSE_GROUP_STORE_NAME = 'poseGroup';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _PoseGroupGroupStore = intMapStoreFactory.store(POSE_GROUP_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await SembastDb.instance.database;

  static Future<PoseGroup> insert(PoseGroup pose) async {
    pose.documentId = Uuid().v1();
    pose.id = await _PoseGroupGroupStore.add(await _db, pose.toMap());
    await PoseGroupCollection().createPoseGroup(pose);
    _updateLastChangedTime();
    return pose;
  }

  static Future insertLocalOnly(PoseGroup pose) async {
    pose.id = null;
    await _PoseGroupGroupStore.add(await _db, pose.toMap());
  }

  static Future<void> _updateLastChangedTime() async {
    Profile profile = (await ProfileDao.getAll()).elementAt(0);
    profile.poseGroupsLastChangeDate = DateTime.now();
    ProfileDao.update(profile);
  }

  static Future<PoseGroup> insertOrUpdate(PoseGroup pose) async {
    List<PoseGroup> poseList = await getAllSortedMostFrequent();
    bool alreadyExists = false;
    for(PoseGroup singlePoseGroup in poseList){
      if(singlePoseGroup.documentId == pose.documentId){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      return await update(pose);
    }else{
      return await insert(pose);
    }
  }

  static Future<PoseGroup> getById(String poseDocumentId) async{
    if((await getAllSortedMostFrequent()).length > 0) {
      final finder = Finder(filter: Filter.equals('documentId', poseDocumentId));
      final recordSnapshots = await _PoseGroupGroupStore.find(await _db, finder: finder);
      // Making a List<profileId> out of List<RecordSnapshot>
      List<PoseGroup> poses = recordSnapshots.map((snapshot) {
        final pose = PoseGroup.fromMap(snapshot.value);
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

  static Future<Stream<List<RecordSnapshot>>> getPoseGroupsStream() async {
    var query = _PoseGroupGroupStore.query();
    return query.onSnapshots(await _db);
  }

  static Stream<QuerySnapshot> getPoseGroupsStreamFromFireStore() {
    return PoseGroupCollection().getPoseGroupStream();
  }

  static Future<PoseGroup> update(PoseGroup pose) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('documentId', pose.documentId));
    await _PoseGroupGroupStore.update(
      await _db,
      pose.toMap(),
      finder: finder,
    );
    await PoseGroupCollection().updatePoseGroups(pose);
    _updateLastChangedTime();
    return pose;
  }

  static Future updateLocalOnly(PoseGroup pose) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('documentId', pose.documentId));
    await _PoseGroupGroupStore.update(
      await _db,
      pose.toMap(),
      finder: finder,
    );
  }

  static Future delete(String documentId) async {
    final finder = Finder(filter: Filter.equals('documentId', documentId));
    await _PoseGroupGroupStore.delete(
      await _db,
      finder: finder,
    ).onError(
            (error, stackTrace) => null
    );
    await PoseGroupCollection().deletePoseGroup(documentId);
    _updateLastChangedTime();
  }

  static Future<List<PoseGroup>> getAllSortedMostFrequent() async {
    final finder = Finder(sortOrders: [
      SortOrder('numOfSessionsAtThisPoseGroup'),
    ]);

    final recordSnapshots = await _PoseGroupGroupStore.find(await _db, finder: finder).catchError((error) {
      print(error);
    });

    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final pose = PoseGroup.fromMap(snapshot.value);
      pose.id = snapshot.key;
      return pose;
    }).toList();
  }

  static Future<void> syncAllFromFireStore() async {
    List<PoseGroup> allLocalPoseGroups = await getAllSortedMostFrequent();
    List<PoseGroup> allFireStorePoseGroups = await PoseGroupCollection().getAll(UidUtil().getUid());

    if(allLocalPoseGroups != null && allLocalPoseGroups.length > 0) {
      if(allFireStorePoseGroups != null && allFireStorePoseGroups.length > 0) {
        //both local and fireStore have PoseGroups
        //fireStore is source of truth for this sync.
        await _syncFireStoreToLocal(allLocalPoseGroups, allFireStorePoseGroups);
      } else {
        //all PoseGroups have been deleted in the cloud. Delete all local PoseGroups also.
        _deleteAllLocalPoseGroups(allLocalPoseGroups);
      }
    } else {
      if(allFireStorePoseGroups != null && allFireStorePoseGroups.length > 0){
        //no local PoseGroups but there are fireStore PoseGroups.
        await _copyAllFireStorePoseGroupsToLocal(allFireStorePoseGroups);
      } else {
        //no PoseGroups in either database. nothing to sync.
      }
    }
  }

  static Future<void> _deleteAllLocalPoseGroups(List<PoseGroup> allLocalPoseGroups) async {
    for(PoseGroup location in allLocalPoseGroups) {
      final finder = Finder(filter: Filter.equals('documentId', location.documentId));
      await _PoseGroupGroupStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static Future<void> _copyAllFireStorePoseGroupsToLocal(List<PoseGroup> allFireStorePoseGroups) async {
    for (PoseGroup PoseGroupToSave in allFireStorePoseGroups) {
      await _PoseGroupGroupStore.add(await _db, PoseGroupToSave.toMap());
    }
  }

  static Future<void> _syncFireStoreToLocal(List<PoseGroup> allLocalPoseGroups, List<PoseGroup> allFireStorePoseGroups) async {
    for(PoseGroup localPoseGroup in allLocalPoseGroups) {
      //should only be 1 matching
      List<PoseGroup> matchingFireStorePoseGroups = allFireStorePoseGroups.where((fireStorePoseGroup) => localPoseGroup.documentId == fireStorePoseGroup.documentId).toList();
      if(matchingFireStorePoseGroups !=  null && matchingFireStorePoseGroups.length > 0) {
        PoseGroup fireStorePoseGroup = matchingFireStorePoseGroups.elementAt(0);
        final finder = Finder(filter: Filter.equals('documentId', fireStorePoseGroup.documentId));
        await _PoseGroupGroupStore.update(
          await _db,
          fireStorePoseGroup.toMap(),
          finder: finder,
        );
      } else {
        //PoseGroup does nto exist on cloud. so delete from local.
        final finder = Finder(filter: Filter.equals('documentId', localPoseGroup.documentId));
        await _PoseGroupGroupStore.delete(
          await _db,
          finder: finder,
        );
      }
    }

    for(PoseGroup fireStorePoseGroup in allFireStorePoseGroups) {
      List<PoseGroup> matchingLocalPoseGroups = allLocalPoseGroups.where((localPoseGroup) => localPoseGroup.documentId == fireStorePoseGroup.documentId).toList();
      if(matchingLocalPoseGroups != null && matchingLocalPoseGroups.length > 0) {
        //do nothing. PoseGroup already synced.
      } else {
        //add to local. does not exist in local and has not been synced yet.
        fireStorePoseGroup.id = null;
        await _PoseGroupGroupStore.add(await _db, fireStorePoseGroup.toMap());
      }
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static void deleteAllLocal() async {
    List<PoseGroup> locations = await getAllSortedMostFrequent();
    _deleteAllLocalPoseGroups(locations);
  }
}