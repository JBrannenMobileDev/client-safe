import 'dart:async';

import 'package:dandylight/data_layer/firebase/collections/PoseLibraryGroupsCollection.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/PoseLibraryGroup.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';

import '../../../models/Profile.dart';

class PoseLibraryGroupDao extends Equatable{
  static const String POSE_GROUP_STORE_NAME = 'poseLibraryGroup';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _PoseLibraryGroupStore = intMapStoreFactory.store(POSE_GROUP_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await SembastDb.instance.database;

  static Future<PoseLibraryGroup> insert(PoseLibraryGroup pose) async {
    pose.documentId = Uuid().v1();
    pose.id = await _PoseLibraryGroupStore.add(await _db, pose.toMap());
    await PoseLibraryGroupsCollection().create(pose);
    return pose;
  }

  static Future insertLocalOnly(PoseLibraryGroup pose) async {
    pose.id = null;
    await _PoseLibraryGroupStore.add(await _db, pose.toMap());
  }

  static Future<PoseLibraryGroup> insertOrUpdate(PoseLibraryGroup pose) async {
    List<PoseLibraryGroup> poseList = await getAllSortedMostFrequent();
    bool alreadyExists = false;
    for(PoseLibraryGroup singlePoseGroup in poseList){
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

  static Future<PoseLibraryGroup?> getById(String poseDocumentId) async{
    if((await getAllSortedMostFrequent()).length > 0) {
      final finder = Finder(filter: Filter.equals('documentId', poseDocumentId));
      final recordSnapshots = await _PoseLibraryGroupStore.find(await _db, finder: finder);
      // Making a List<profileId> out of List<RecordSnapshot>
      List<PoseLibraryGroup> poses = recordSnapshots.map((snapshot) {
        final pose = PoseLibraryGroup.fromMap(snapshot.value);
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
    var query = _PoseLibraryGroupStore.query();
    return query.onSnapshots(await _db);
  }

  static Future<PoseLibraryGroup> update(PoseLibraryGroup pose) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('documentId', pose.documentId));
    await _PoseLibraryGroupStore.update(
      await _db,
      pose.toMap(),
      finder: finder,
    );
    await PoseLibraryGroupsCollection().update(pose);
    return pose;
  }

  static Future updateLocalOnly(PoseLibraryGroup pose) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('documentId', pose.documentId));
    await _PoseLibraryGroupStore.update(
      await _db,
      pose.toMap(),
      finder: finder,
    );
  }

  static Future delete(String documentId) async {
    final finder = Finder(filter: Filter.equals('documentId', documentId));
    await _PoseLibraryGroupStore.delete(
      await _db,
      finder: finder,
    );
    await PoseLibraryGroupsCollection().delete(documentId);
  }

  static Future<List<PoseLibraryGroup>> getAllSortedMostFrequent() async {
    final finder = Finder(sortOrders: [
      SortOrder('numOfSaves'),
    ]);

    final recordSnapshots = await _PoseLibraryGroupStore.find(await _db, finder: finder).catchError((error) {
      print(error);
    });

    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final pose = PoseLibraryGroup.fromMap(snapshot.value);
      pose.id = snapshot.key;
      return pose;
    }).toList().reversed.toList();
  }

  static Future<void> syncAllFromFireStore() async {
    List<PoseLibraryGroup> allLocalPoseGroups = await getAllSortedMostFrequent();
    List<PoseLibraryGroup> allFireStorePoseGroups = await PoseLibraryGroupsCollection().get();

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

  static Future<void> _deleteAllLocalPoseGroups(List<PoseLibraryGroup> allLocalPoseGroups) async {
    for(PoseLibraryGroup location in allLocalPoseGroups) {
      final finder = Finder(filter: Filter.equals('documentId', location.documentId));
      await _PoseLibraryGroupStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static Future<void> _copyAllFireStorePoseGroupsToLocal(List<PoseLibraryGroup> allFireStorePoseGroups) async {
    for (PoseLibraryGroup PoseGroupToSave in allFireStorePoseGroups) {
      await _PoseLibraryGroupStore.add(await _db, PoseGroupToSave.toMap());
    }
  }

  static Future<void> _syncFireStoreToLocal(List<PoseLibraryGroup> allLocalPoseGroups, List<PoseLibraryGroup> allFireStorePoseGroups) async {
    for(PoseLibraryGroup localPoseGroup in allLocalPoseGroups) {
      //should only be 1 matching
      List<PoseLibraryGroup> matchingFireStorePoseGroups = allFireStorePoseGroups.where((fireStorePoseGroup) => localPoseGroup.documentId == fireStorePoseGroup.documentId).toList();
      if(matchingFireStorePoseGroups !=  null && matchingFireStorePoseGroups.length > 0) {
        PoseLibraryGroup fireStorePoseGroup = matchingFireStorePoseGroups.elementAt(0);
        final finder = Finder(filter: Filter.equals('documentId', fireStorePoseGroup.documentId));
        await _PoseLibraryGroupStore.update(
          await _db,
          fireStorePoseGroup.toMap(),
          finder: finder,
        );
      } else {
        //PoseGroup does nto exist on cloud. so delete from local.
        final finder = Finder(filter: Filter.equals('documentId', localPoseGroup.documentId));
        await _PoseLibraryGroupStore.delete(
          await _db,
          finder: finder,
        );
      }
    }

    for(PoseLibraryGroup fireStorePoseGroup in allFireStorePoseGroups) {
      List<PoseLibraryGroup> matchingLocalPoseGroups = allLocalPoseGroups.where((localPoseGroup) => localPoseGroup.documentId == fireStorePoseGroup.documentId).toList();
      if(matchingLocalPoseGroups != null && matchingLocalPoseGroups.length > 0) {
        //do nothing. PoseGroup already synced.
      } else {
        //add to local. does not exist in local and has not been synced yet.
        fireStorePoseGroup.id = null;
        await _PoseLibraryGroupStore.add(await _db, fireStorePoseGroup.toMap());
      }
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static void deleteAllLocal() async {
    List<PoseLibraryGroup> locations = await getAllSortedMostFrequent();
    _deleteAllLocalPoseGroups(locations);
  }
}