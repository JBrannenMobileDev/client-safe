import 'package:dandylight/pages/new_job_types_page/NewJobTypePageState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../utils/ColorConstants.dart';
import '../../widgets/TextDandyLight.dart';

class ReminderSelectionListWidget extends StatelessWidget {
  final NewJobTypePageState pageState;
  final int index;

  ReminderSelectionListWidget(this.pageState, this.index);

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Color(ColorConstants.getPrimaryBlack());
      }
      return Color(ColorConstants.getPeachDark());
    }

    return Column(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 16.0),
                      height: 38.0,
                      width: 38.0,
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
                        Container(
                          width: MediaQuery.of(context).size.width - 181,
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: pageState.allDandyLightReminders.elementAt(index).description,
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                        Container(
                          child: TextDandyLight(
                            type: TextDandyLight.EXTRA_SMALL_TEXT,
                            text: pageState.allDandyLightReminders.elementAt(index).when == 'on' ? 'Day of shoot' :
                            pageState.allDandyLightReminders.elementAt(index).amount.toString() + ' ' + (pageState.allDandyLightReminders.elementAt(index).amount == 1 ? pageState.allDandyLightReminders.elementAt(index).daysWeeksMonths.substring(0, pageState.allDandyLightReminders.elementAt(index).daysWeeksMonths.length - 1) : pageState.allDandyLightReminders.elementAt(index).daysWeeksMonths) + ' ' + pageState.allDandyLightReminders.elementAt(index).when,
                            textAlign: TextAlign.start,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 8.0, right: 0.0, top: 2.0, bottom: 2.0),
                  child: Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: pageState.selectedReminders.contains(pageState.allDandyLightReminders.elementAt(index)),
                    onChanged: (bool isChecked) {
                      pageState.onReminderSelected(index, isChecked);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
    );
  }
}
