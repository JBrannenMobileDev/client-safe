import 'package:dandylight/pages/job_details_page/document_items/DocumentItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';

import '../../../models/Contract.dart';
import '../../../widgets/TextDandyLight.dart';

class ContractDocument implements DocumentItem {
  final String? contractName;
  final bool isSigned;
  final bool isVoid;
  final Contract contract;
  ContractDocument({this.contractName, this.isSigned = false, this.isVoid = false, required this.contract});

  @override
  Widget buildIconItem(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 18.0, top: 0.0),
      height: 42.0,
      width: 42.0,
      child: Image.asset(chooseIcon(isSigned, isVoid), color: Color(ColorConstants.getPeachDark()),),
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
        isVoid ? TextDandyLight(
          type: TextDandyLight.MEDIUM_TEXT,
          text: '(Contract is void)',
          textAlign: TextAlign.start,
          color: Color(ColorConstants.getPeachDark()),
        ) : isSigned ? TextDandyLight(
          type: TextDandyLight.MEDIUM_TEXT,
          text: '(Signed)',
          textAlign: TextAlign.start,
          color: Color(ColorConstants.getPeachDark()),
        ) : const SizedBox()
      ],
    );
  }

  @override
  String getDocumentType() {
    return DocumentItem.DOCUMENT_TYPE_CONTRACT;
  }

  String chooseIcon(bool isSigned, bool isVoid) {
    if(isVoid) return 'assets/images/icons/void_contract.png';
    if(isSigned) {
      return 'assets/images/icons/contract_signed.png';
    } else {
      return 'assets/images/icons/contract.png';
    }
  }
}