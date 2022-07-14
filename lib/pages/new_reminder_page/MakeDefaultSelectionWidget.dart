import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../models/Reminder.dart';
import '../../utils/ColorConstants.dart';
import 'NewReminderPageState.dart';

class MakeDefaultSelectionWidget extends StatefulWidget{
  final Reminder reminder;

  MakeDefaultSelectionWidget(this.reminder);

  @override
  _MakeDefaultSelectionWidgetState createState() {
    return _MakeDefaultSelectionWidgetState(reminder);
  }
}

class _MakeDefaultSelectionWidgetState extends State<MakeDefaultSelectionWidget> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final Reminder reminder;
  final descriptionTextController = TextEditingController();

  _MakeDefaultSelectionWidgetState(this.reminder);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewReminderPageState>(
      converter: (store) => NewReminderPageState.fromStore(store),
      builder: (BuildContext context, NewReminderPageState pageState) =>
          Scaffold(
            body: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Container(

                  padding: EdgeInsets.only(left: 32.0, right: 32.0),
                  decoration: BoxDecoration(
                    color: Color(ColorConstants.getPrimaryWhite()),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 32.0, top: 8.0),
                        child: Text(
                          "Would you like to add this reminder to all new jobs?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 24.0),
                            child: Text(
                              "NO",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'simple',
                                fontWeight: FontWeight.w600,
                                color: Color(ColorConstants.primary_black),
                              ),
                            ),
                          ),
                          Device.get().isIos ?
                              CupertinoSwitch(value: pageState.isDefault, onChanged: (bool value) {
                                pageState.onDefaultSelectionChanged(value);
                              }) :
                              Switch(value: pageState.isDefault, onChanged: (bool value) {
                                pageState.onDefaultSelectionChanged(value);
                              }),
                          Container(
                            margin: EdgeInsets.only(left: 24.0),
                            child: Text(
                              "YES",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'simple',
                                fontWeight: FontWeight.w600,
                                color: Color(ColorConstants.primary_black),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                ),
              ),
            ),
          ),
    );
  }
}