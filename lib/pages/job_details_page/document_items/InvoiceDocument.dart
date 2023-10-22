import 'package:dandylight/pages/job_details_page/document_items/DocumentItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';

import '../../../widgets/TextDandyLight.dart';

class InvoiceDocument implements DocumentItem {
  final bool isPaid;
  final bool depositPaid;

  InvoiceDocument({this.isPaid = false, this.depositPaid = false});

  @override
  Widget buildIconItem(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 18.0, top: 0.0),
      height: 42.0,
      width: 42.0,
      child: Image.asset('assets/images/icons/invoice.png', color: Color(ColorConstants.getPeachDark()),),
    );
  }

  @override
  Widget buildTitle(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextDandyLight(
          type: TextDandyLight.MEDIUM_TEXT,
          text: 'Invoice',
          textAlign: TextAlign.start,
          color: Color(ColorConstants.getPrimaryBlack()),
        ),
        isPaid ? TextDandyLight(
          type: TextDandyLight.MEDIUM_TEXT,
          text: '(Paid)',
          textAlign: TextAlign.start,
          color: Color(ColorConstants.getPeachDark()),
        ) : depositPaid ? TextDandyLight(
          type: TextDandyLight.MEDIUM_TEXT,
          text: '(Deposit Paid)',
          textAlign: TextAlign.start,
          color: Color(ColorConstants.getPeachDark()),
        ) : SizedBox()
      ],
    );
  }

  @override
  String getDocumentType() {
    return DocumentItem.DOCUMENT_TYPE_INVOICE;
  }
}