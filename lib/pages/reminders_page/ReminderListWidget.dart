import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ReminderListWidget extends StatelessWidget {
  final ReminderDandyLight reminder;
  var pageState;
  final Function onReminderSelected;
  final Color backgroundColor;
  final Color textColor;

  ReminderListWidget(this.reminder, this.pageState, this.onReminderSelected, this.backgroundColor, this.textColor);

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
          onReminderSelected(reminder, pageState, context);
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
                        margin: EdgeInsets.only(right: 16.0),
                        height: 48.0,
                        width: 48.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: Image.asset('assets/images/icons/reminder_icon_blue_light.png').image,
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
                            reminder.description,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 22.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          Container(
                            child: Text(
                              reminder.when == 'on' ? 'Day of shoot' :
                              reminder.amount.toString() + ' ' + (reminder.amount == 1 ? reminder.daysWeeksMonths.substring(0, reminder.daysWeeksMonths.length - 1) : reminder.daysWeeksMonths) + ' ' + reminder.when,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'simple',
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
}
