import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPage.dart';
import 'package:dandylight/pages/clients_page/ClientsPage.dart';
import 'package:dandylight/pages/clients_page/ClientsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../utils/styles/Styles.dart';
import 'CalendarSelectionPageState.dart';

class CalendarWidget extends StatefulWidget {
  final int index;

  CalendarWidget(this.index);

  @override
  State<StatefulWidget> createState() {
    return _CalendarWidgetState(index);
  }
}

  class _CalendarWidgetState extends State<CalendarWidget> with TickerProviderStateMixin {
    bool checkedValue = false;
    int index;

    _CalendarWidgetState(this.index);

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

    @override
    Widget build(BuildContext context) {
      return StoreConnector<AppState, CalendarSelectionPageState>(
        converter: (store) => CalendarSelectionPageState.fromStore(store),
        builder: (BuildContext context, CalendarSelectionPageState pageState) =>
            Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 8.0, right: 16.0),
                  height: 44.0,
                  width: 44.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/icons/calendar_icon_peach.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  height: 64.0,
                  margin: EdgeInsets.only(left: 64.0, right: 64.0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          pageState.writableCalendars
                              .elementAt(index)
                              .accountName,

                          textAlign: TextAlign.start,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w600,
                            color: const Color(ColorConstants.primary_black),
                          ),
                        ),
                        Text(
                          pageState.writableCalendars
                              .elementAt(index)
                              .name,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w600,
                            color:
                            const Color(ColorConstants.primary_bg_grey_dark),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    alignment: Alignment.centerRight,
                    child: Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: checkedValue,
                        onChanged: (isChecked) {
                          setState(() {
                            checkedValue = isChecked;
                          });
                          pageState.onCalendarSelected(
                              pageState.writableCalendars.elementAt(index),
                              isChecked);
                        }
                    ),
                  ),
              ],
            ),
      );
    }
  }

