import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/EnvironmentUtil.dart';
import 'package:dandylight/utils/UidUtil.dart';

import '../../../models/DiscountCodes.dart';

class DiscountCodesCollection {
  Future<void> createDiscountCodes(DiscountCodes discount) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('discountCodes')
        .doc(discount.type)
        .set(discount.toMap())
        .catchError((error) => print(error));
  }

  Future<void> deleteDiscountCodes(String type) async{
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('discountCodes')
          .doc(type)
          .delete()
          .catchError((error) => print(error));
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<DocumentSnapshot> getDiscountCodesStream(String type) {
    return FirebaseFirestore.instance
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('discountCodes')
        .doc(type)
        .snapshots();
  }

  Future<List<DiscountCodes>?> getAll() async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('discountCodes')
        .get()
        .then((discounts) => _buildDiscountCodesList(discounts));
  }

  List<DiscountCodes> _buildDiscountCodesList(QuerySnapshot jobs) {
    List<DiscountCodes> list = [];
    for(DocumentSnapshot snapshot in jobs.docs){
      DiscountCodes discount = DiscountCodes.fromMap(snapshot.data() as Map<String, dynamic>);
      list.add(discount);
    }
    return list;
  }

  Stream<QuerySnapshot> getResponseStream() {
    return FirebaseFirestore.instance
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('discountCodes')
        .snapshots();
  }

  Future<DiscountCodes> getDiscountCodes(String type) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('discountCodes')
        .doc(type)
        .get()
        .then((discountCodes) {
          DiscountCodes discounts = DiscountCodes.fromMap(discountCodes.data() as Map<String, dynamic>);
          return discounts;
        })
        .catchError((error) => print(error));
  }

  Future<void> updateDiscountCodes(DiscountCodes discountCodes) async{
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('discountCodes')
          .doc(discountCodes.type)
          .update(discountCodes.toMap())
          .catchError((error) => print(error));
    } catch (e) {
      print(e.toString());
    }
  }
}