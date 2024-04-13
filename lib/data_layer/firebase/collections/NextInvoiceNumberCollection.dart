
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/NextInvoiceNumber.dart';
import 'package:dandylight/utils/UidUtil.dart';

import '../../../utils/EnvironmentUtil.dart';

class NextInvoiceNumberCollection {
  static const String singletonItemId = 'singletonItem';
  Future<void> updateNextInvoiceNumber(NextInvoiceNumber number) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('nextInvoiceNumber')
        .doc(singletonItemId)
        .set(number.toMap());
  }

  Stream<DocumentSnapshot> getStream() {
    return FirebaseFirestore.instance
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('nextInvoiceNumber')
        .doc(singletonItemId)
        .snapshots();
  }

  Future<void> setStartingValue(int startingValue) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('nextInvoiceNumber')
        .doc(singletonItemId)
        .set(NextInvoiceNumber(highestInvoiceNumber: startingValue).toMap());
  }

  Future<NextInvoiceNumber?> getNextInvoiceNumber(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await  databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(uid)
        .collection('nextInvoiceNumber')
        .doc(singletonItemId)
        .get()
        .then((nextInvoiceNUmber) => NextInvoiceNumber.fromMap(nextInvoiceNUmber.data() as Map<String, dynamic>));
  }
}