import 'dart:async';

import 'package:dandylight/data_layer/firebase/collections/LocationCollection.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';

class LocationDao extends Equatable{

  static void insert(Location location) {
    LocationCollection().createLocation(location);
  }

  static Future insertOrUpdate(Location location) async {
    bool alreadyExists = location.documentId.isNotEmpty;
    if(alreadyExists){
      update(location);
    }else{
      insert(location);
    }
  }

  static Future update(Location location) async {
    LocationCollection().updateLocation(location);
  }

  static void delete(String documentId) {
    LocationCollection().deleteJob(documentId);
  }

  static Future<List<Location>> getAll() async {
    return await LocationCollection().getAll(UidUtil().getUid());
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}