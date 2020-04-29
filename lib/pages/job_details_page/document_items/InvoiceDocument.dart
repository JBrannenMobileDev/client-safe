import 'package:client_safe/pages/job_details_page/document_items/DocumentItem.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';

class InvoiceDocument implements DocumentItem {
  @override
  Widget buildIconItem(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 18.0, top: 0.0),
      height: 42.0,
      width: 42.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/icons/invoices_icon_peach.png'),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      'Invoice',
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: 20.0,
        fontFamily: 'simple',
        fontWeight: FontWeight.w800,
        color: Color(ColorConstants.getPrimaryBlack()),
      ),
    );
  }

  @override
  String getDocumentType() {
    return DocumentItem.DOCUMENT_TYPE_INVOICE;
  }
}