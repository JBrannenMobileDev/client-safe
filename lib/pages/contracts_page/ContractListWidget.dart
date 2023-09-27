import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/Contract.dart';
import '../../widgets/TextDandyLight.dart';

class ContractListWidget extends StatelessWidget {
  final Contract contract;
  var pageState;
  final Function onContractSelected;
  final Color backgroundColor;
  final Color textColor;

  ContractListWidget(this.contract, this.pageState, this.onContractSelected, this.backgroundColor, this.textColor);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: Styles.getButtonStyle(
          color: backgroundColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(8.0),
          ),
        ),
        onPressed: () {
          onContractSelected(pageState, context, contract);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 56.0,
              child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 16.0, left: 8.0),
                    height: 36.0,
                    width: 36.0,
                    child: Image.asset('assets/images/collection_icons/contract_icon_white.png', color: Color(ColorConstants.getBlueDark())),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 120,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: contract.contractName,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }
}
