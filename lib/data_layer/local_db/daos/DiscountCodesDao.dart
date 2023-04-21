import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/data_layer/firebase/collections/DiscountCodesCollection.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/DiscountCodes.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';

import '../../../models/Profile.dart';

class DiscountCodesDao extends Equatable{
  static const String DISCOUNT_CODES_STORE_NAME = 'discountCodes';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _discountCodesStore = intMapStoreFactory.store(DISCOUNT_CODES_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await SembastDb.instance.database;

  static Future insert(DiscountCodes discountCodes) async {
    await _discountCodesStore.add(await _db, discountCodes.toMap());
    await DiscountCodesCollection().createDiscountCodes(discountCodes);
    _updateLastChangedTime();
  }

  static Future<void> _updateLastChangedTime() async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.discountCodesLastChangedTime = DateTime.now();
    ProfileDao.update(profile);
  }

  static Future insertLocal(DiscountCodes discounts) async {
    await _discountCodesStore.add(await _db, discounts.toMap());
  }

  static Future insertOrUpdate(DiscountCodes discount) async {
    List<DiscountCodes> discounts = await getAll();
    bool alreadyExists = false;
    for(DiscountCodes singleDiscount in discounts){
      if(singleDiscount.type == discount.type){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      await update(discount);
    }else{
      await insert(discount);
    }
  }

  static Future update(DiscountCodes discount) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('type', discount.type));
    await _discountCodesStore.update(
      await _db,
      discount.toMap(),
      finder: finder,
    );
    await DiscountCodesCollection().updateDiscountCodes(discount);
    _updateLastChangedTime();
  }

  static Future updateLocalOnly(DiscountCodes discount) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('type', discount.type));
    await _discountCodesStore.update(
      await _db,
      discount.toMap(),
      finder: finder,
    );
  }

  static Future delete(DiscountCodes discount) async {
    final finder = Finder(filter: Filter.equals('type', discount.type));
    await _discountCodesStore.delete(
      await _db,
      finder: finder,
    );
    await DiscountCodesCollection().deleteDiscountCodes(discount.type);
  }

  static Future<List<DiscountCodes>> getAll() async {
    final recordSnapshots = await _discountCodesStore.find(await _db);
    return recordSnapshots.map((snapshot) {
      final discount = DiscountCodes.fromMap(snapshot.value);
      return discount;
    }).toList();
  }

  static Future<void> syncAllFromFireStore() async {
    List<DiscountCodes> discounts = await getAll();
    List<DiscountCodes> fireStoreDiscounts = await DiscountCodesCollection().getAll();

    if(discounts != null && discounts.length > 0) {
      if(fireStoreDiscounts != null && fireStoreDiscounts.length > 0) {
        //both local and fireStore have Locations
        //fireStore is source of truth for this sync.
        await _syncFireStoreToLocal(discounts, fireStoreDiscounts);
      } else {
        //all Locations have been deleted in the cloud. Delete all local Locations also.
        _deleteAllLocal(discounts);
      }
    } else {
      if(fireStoreDiscounts != null && fireStoreDiscounts.length > 0){
        //no local Locations but there are fireStore Locations.
        await _copyAllFireStoreToLocal(fireStoreDiscounts);
      } else {
        //no Locations in either database. nothing to sync.
      }
    }
  }

  static Future<void> _deleteAllLocal(List<DiscountCodes> discounts) async {
    for(DiscountCodes discount in discounts) {
      final finder = Finder(filter: Filter.equals('type', discount.type));
      await _discountCodesStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static Future<void> _copyAllFireStoreToLocal(List<DiscountCodes> allFireStore) async {
    for (DiscountCodes discountToSave in allFireStore) {
      await _discountCodesStore.add(await _db, discountToSave.toMap());
    }
  }

  static Future<void> _syncFireStoreToLocal(List<DiscountCodes> allLocal, List<DiscountCodes> allFireStore) async {
    for(DiscountCodes localDiscount in allLocal) {
      //should only be 1 matching
      List<DiscountCodes> matchingFireStore = allFireStore.where((fireStore) => localDiscount.type == fireStore.type).toList();
      if(matchingFireStore !=  null && matchingFireStore.length > 0) {
        DiscountCodes fireStore = matchingFireStore.elementAt(0);
        final finder = Finder(filter: Filter.equals('type', fireStore.type));
        await _discountCodesStore.update(
          await _db,
          fireStore.toMap(),
          finder: finder,
        );
      } else {
        //Location does nto exist on cloud. so delete from local.
        final finder = Finder(filter: Filter.equals('type', localDiscount.type));
        await _discountCodesStore.delete(
          await _db,
          finder: finder,
        );
      }
    }

    for(DiscountCodes fireStore in allFireStore) {
      List<DiscountCodes> matchingLocal = allLocal.where((local) => local.type == fireStore.type).toList();
      if(matchingLocal != null && matchingLocal.length > 0) {
        //do nothing. Location already synced.
      } else {
        //add to local. does not exist in local and has not been synced yet.
        await _discountCodesStore.add(await _db, fireStore.toMap());
      }
    }
  }

  static Future<DiscountCodes> getDiscountCodesByType(String type) async{
    if((await getAll()).length > 0) {
      final finder = Finder(filter: Filter.equals('type', type));
      final recordSnapshots = await _discountCodesStore.find(await _db, finder: finder);
      List<DiscountCodes> discounts = recordSnapshots.map((snapshot) {
        final expense = DiscountCodes.fromMap(snapshot.value);
        return expense;
      }).toList();
      if(discounts.length > 0) return discounts.elementAt(0);
      return null;
    } else {
      return null;
    }
  }

  static Stream<QuerySnapshot> getDiscountCodesStreamFromFireStore() {
    return DiscountCodesCollection().getResponseStream();
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static void deleteAllLocal() async {
    List<DiscountCodes> locations = await getAll();
    _deleteAllLocal(locations);
  }

  static void deleteAllRemote() async {
    List<DiscountCodes> discounts = await getAll();
    for(DiscountCodes discount in discounts) {
      await delete(discount);
    }
  }
}