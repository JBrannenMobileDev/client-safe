
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/NextInvoiceNumber.dart';
import 'package:dandylight/utils/UidUtil.dart';

class NextInvoiceNumberCollection {
  static const String singletonItemId = 'singletonItem';
  Future<void> updateNextInvoiceNumber(NextInvoiceNumber number) async {
    final databaseReference = Firestore.instance;
    await databaseReference.collection('users')
        .document(UidUtil().getUid())
        .collection('nextInvoiceNumber')
        .document(singletonItemId)
        .setData(number.toMap());
  }

  Future<void> setStartingValue(int startingValue) async {
    final databaseReference = Firestore.instance;
    await databaseReference.collection('users')
        .document(UidUtil().getUid())
        .collection('nextInvoiceNumber')
        .document(singletonItemId)
        .setData(NextInvoiceNumber(highestInvoiceNumber: startingValue).toMap());
  }

  Future<NextInvoiceNumber> getNextInvoiceNumber(String uid) async {
    final databaseReference = Firestore.instance;
    return await  databaseReference
        .collection('users')
        .document(uid)
        .collection('nextInvoiceNumber')
        .document(singletonItemId)
        .get()
        .then((nextInvoiceNUmber) => NextInvoiceNumber.fromMap(nextInvoiceNUmber.data));
  }
}