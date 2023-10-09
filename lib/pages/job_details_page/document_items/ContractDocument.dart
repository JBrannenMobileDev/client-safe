import 'package:dandylight/pages/job_details_page/document_items/DocumentItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';

import '../../../widgets/TextDandyLight.dart';

class ContractDocument implements DocumentItem {
  final String contractName;
  final bool isSigned;
  ContractDocument({this.contractName, this.isSigned = false});

  @override
  Widget buildIconItem(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 18.0, top: 0.0),
      height: 42.0,
      width: 42.0,
      child: Image.asset(isSigned ? 'assets/images/icons/contract_signed.png' : 'assets/images/icons/contract.png', color: Color(ColorConstants.getPeachDark()),),
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
          text: contractName,
          textAlign: TextAlign.start,
          color: Color(ColorConstants.getPrimaryBlack()),
        ),
        isSigned ? TextDandyLight(
          type: TextDandyLight.MEDIUM_TEXT,
          text: '(Signed)',
          textAlign: TextAlign.start,
          color: Color(ColorConstants.getPeachDark()),
        ) : SizedBox()
      ],
    );
  }

  @override
  String getDocumentType() {
    return DocumentItem.DOCUMENT_TYPE_CONTRACT;
  }
}