import 'dart:async';

import 'package:dandylight/data_layer/firebase/collections/PriceProfileCollection.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';

class PriceProfileDao extends Equatable{

  static void insert(PriceProfile profile) {
    PriceProfileCollection().createJob(profile);
  }

  static void insertOrUpdate(PriceProfile profile) {
    bool alreadyExists = profile.documentId.isNotEmpty;

    if(alreadyExists){
      update(profile);
    }else{
      insert(profile);
    }
  }

  static void update(PriceProfile profile) {
    PriceProfileCollection().updateJob(profile);
  }

  static void delete(PriceProfile profile) {
    PriceProfileCollection().deleteJob(profile.documentId);
  }

  static Future<List<PriceProfile>> getAll() async {
    return await PriceProfileCollection().getAll(UidUtil().getUid());
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}