import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../widgets/TextDandyLight.dart';

class NewJobPriceProfileListWidget extends StatelessWidget {
  final PriceProfile priceProfile;
  var pageState;
  final Function onProfileSelected;
  final Color backgroundColor;
  final Color textColor;

  NewJobPriceProfileListWidget(this.priceProfile, this.pageState, this.onProfileSelected, this.backgroundColor, this.textColor);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: Styles.getButtonStyle(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(25.0),
          ),
        ),
        onPressed: () {
          onProfileSelected(priceProfile, pageState, context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 64.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 16.0, left: 16.0),
                        height: 36.0,
                        width: 36.0,
                        child: Image.asset(priceProfile.icon!, color: Color(ColorConstants.getPrimaryBlack()),),
                      ),
                      Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: priceProfile.profileName,
                                textAlign: TextAlign.start,
                                color: textColor,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextDandyLight(
                                    type: TextDandyLight.SMALL_TEXT,
                                    text: 'Price - ' + NumberFormat.simpleCurrency(name: 'USD', decimalDigits: 0).format(priceProfile.flatRate),
                                    textAlign: TextAlign.start,
                                    color: textColor,
                                  ),
                                ],
                              ),
                            ],
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
