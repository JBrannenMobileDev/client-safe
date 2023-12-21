import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/material.dart';

import '../../models/Contract.dart';
import '../../widgets/TextDandyLight.dart';

class QuestionnaireListWidget extends StatelessWidget {
  final Contract contract;
  var pageState;
  final Function onContractSelected;
  final Color backgroundColor;
  final Color textColor;

  QuestionnaireListWidget(this.contract, this.pageState, this.onContractSelected, this.backgroundColor, this.textColor, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: Styles.getButtonStyle(
          color: backgroundColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: () {
          onContractSelected(pageState, context, contract);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 56.0,
              child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 16.0, left: 8.0),
                    height: 36.0,
                    width: 36.0,
                    child: Image.asset('assets/images/collection_icons/contract_icon_white.png', color: Color(ColorConstants.getBlueDark())),
                  ),
                  SizedBox(
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
