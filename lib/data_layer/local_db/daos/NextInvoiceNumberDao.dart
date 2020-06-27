import 'dart:async';

import 'package:dandylight/data_layer/firebase/collections/NextInvoiceNumberCollection.dart';
import 'package:dandylight/models/NextInvoiceNumber.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';

class NextInvoiceNumberDao extends Equatable{

  static void update(NextInvoiceNumber next) {
    NextInvoiceNumberCollection().updateNextInvoiceNumber(next);
  }

  static Future<NextInvoiceNumber> getNext() async {
    return await NextInvoiceNumberCollection().getNextInvoiceNumber(UidUtil().getUid());
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}