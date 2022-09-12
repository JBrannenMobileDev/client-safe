import 'package:dandylight/models/Contract.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(32.0),
          ),
        ),
        onPressed: () {
          onContractSelected(contract, pageState, context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 64.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(

                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 16.0, left: 4.0),
                        height: 36.0,
                        width: 36.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: Image.asset('assets/images/icons/contract_icon_peach.png', color: Color(ColorConstants.getBlueLight()),).image,
                            fit: BoxFit.contain,
                          ),
                          color: Colors.transparent,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            contract.contractName,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 22.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }
}
