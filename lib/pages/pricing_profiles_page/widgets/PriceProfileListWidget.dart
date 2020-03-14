import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PriceProfileListWidget extends StatelessWidget {
  final PriceProfile priceProfile;
  var pageState;
  final Function onProfileSelected;
  final Color backgroundColor;
  final Color textColor;

  PriceProfileListWidget(this.priceProfile, this.pageState, this.onProfileSelected, this.backgroundColor, this.textColor);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: () {
          onProfileSelected(priceProfile, pageState, context);
        },
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(16.0),
        ),
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
                        margin: EdgeInsets.only(right: 16.0),
                        height: 48.0,
                        width: 48.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(priceProfile.icon),
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
                            priceProfile.profileName,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          Container(
                            child: Text(
                              priceProfile.rateType + ' - ' + _getRate(priceProfile),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                                color: textColor,
                              ),
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

  String _getRate(PriceProfile priceProfile) {
    String rateString = '';
    switch(priceProfile.rateType){
      case Invoice.RATE_TYPE_FLAT_RATE:
        rateString = '\$' + priceProfile.flatRate.toInt().toString();
        break;
      case Invoice.RATE_TYPE_HOURLY:
        rateString = '\$' + priceProfile.hourlyRate.toInt().toString() + ' (per hour)';
        break;
      case Invoice.RATE_TYPE_QUANTITY:
        rateString = '\$' + priceProfile.itemRate.toInt().toString() + ' (per item)';
        break;
    }
    return rateString;
  }
}
