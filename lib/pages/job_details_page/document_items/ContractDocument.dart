import 'package:dandylight/pages/job_details_page/document_items/DocumentItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';

import '../../../widgets/TextDandyLight.dart';

class ContractDocument implements DocumentItem {
  final String contractName;
  ContractDocument({this.contractName});

  @override
  Widget buildIconItem(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 18.0, top: 0.0),
      height: 42.0,
      width: 42.0,
      child: Image.asset('assets/images/collection_icons/contract_icon_white.png', color: Color(ColorConstants.getPeachDark()),),
    );
  }

  @override
  Widget buildTitle(BuildContext context) {
    return TextDandyLight(
      type: TextDandyLight.MEDIUM_TEXT,
      text: contractName,
      textAlign: TextAlign.start,
      color: Color(ColorConstants.getPrimaryBlack()),
    );
  }

  @override
  String getDocumentType() {
    return DocumentItem.DOCUMENT_TYPE_CONTRACT;
  }
}