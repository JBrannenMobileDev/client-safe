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
          color: backgroundColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(8.0),
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
              height: 56.0,
              child: Row(

                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 16.0, left: 8.0),
                        height: 36.0,
                        width: 36.0,
                        child: Image.asset('assets/images/icons/reminder_icon_blue_light.png', color: Color(ColorConstants.getBlueDark()),),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 120,
                            child: Text(
                              reminder.description,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'simple',
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
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
            ),
          ],
        ),
      );
  }
}
