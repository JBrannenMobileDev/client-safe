import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import '../../widgets/TextDandyLight.dart';

class DueDateSelectionPage extends StatefulWidget {

  @override
  _DueDateSelectionPageState createState() {
    return _DueDateSelectionPageState();
  }
}

class _DueDateSelectionPageState extends State<DueDateSelectionPage> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewInvoicePageState>(
      converter: (store) => NewInvoicePageState.fromStore(store),
      builder: (BuildContext context, NewInvoicePageState pageState) =>
      Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Center(
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'Select a due date',
                  textAlign: TextAlign.start,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16.0),
                alignment: Alignment.center,
                child: TextButton(
                  style: Styles.getButtonStyle(),
                  onPressed: () {
                    DatePicker.showDatePicker(
                        context,
                        dateFormat: 'MMMM dd yyyy',
                        pickerMode: DateTimePickerMode.date,
                        onConfirm: (dateTime, intList) {
                          pageState.onDueDateSelected(dateTime);
                        },
                        pickerTheme: DateTimePickerTheme(
                          cancelTextStyle: TextStyle(
                            color: Color(ColorConstants.getPrimaryBlack())
                          ),
                          confirmTextStyle: TextStyle(
                              color: Color(ColorConstants.getPrimaryBlack())
                          ),
                        )
                    );
                  },
                  child: pageState.dueDate != null ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(16.0),
                        height: 72.0,
                        width: 72.0,
                        decoration: BoxDecoration(
                          color: Color(ColorConstants.getBlueLight()),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                            'assets/images/icons/calendar.png', color: Color(ColorConstants.getPrimaryWhite()),),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 2.0, left: 16.0, right: 16.0),
                        alignment: Alignment.center,
                        height: 48.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(
                              width: 1,
                              color: Color(ColorConstants.getPeachDark())
                          ),
                        ),
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          text: DateFormat('MMM dd, yyyy').format(pageState.dueDate),
                          color: Color(ColorConstants.getPeachDark()),
                        ),
                      ),
                    ],
                  ) : Container(
                    padding: EdgeInsets.all(24.0),
                    height: 116.0,
                    width: 116.0,
                    decoration: BoxDecoration(
                      color: Color(ColorConstants.getBlueLight()),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/icons/calendar.png', color: Color(ColorConstants.getPrimaryWhite()),),
                  ),
                ),
              ),
              pageState.depositValue > 0 ? Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(top: 64),
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'Select a deposit due date',
                  textAlign: TextAlign.center,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ) : SizedBox(),
              pageState.depositValue > 0 ? Container(
                margin: EdgeInsets.only(top: 16.0),
                alignment: Alignment.center,
                child: TextButton(
                  style: Styles.getButtonStyle(),
                  onPressed: () {
                    DatePicker.showDatePicker(
                        context,
                        dateFormat: 'MMMM dd yyyy',
                        pickerMode: DateTimePickerMode.date,
                        onConfirm: (dateTime, intList) {
                          pageState.onDepositDueDateSelected(dateTime);
                        },
                        pickerTheme: DateTimePickerTheme(
                          cancelTextStyle: TextStyle(
                              color: Color(ColorConstants.getPrimaryBlack())
                          ),
                          confirmTextStyle: TextStyle(
                              color: Color(ColorConstants.getPrimaryBlack())
                          ),
                        )
                    );
                  },
                  child: pageState.depositDueDate != null ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(16.0),
                        height: 72.0,
                        width: 72.0,
                        decoration: BoxDecoration(
                          color: Color(ColorConstants.getBlueLight()),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/images/icons/calendar.png', color: Color(ColorConstants.getPrimaryWhite()),),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 2.0, left: 16.0, right: 16.0),
                        alignment: Alignment.center,
                        height: 48.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(
                              width: 1,
                              color: Color(ColorConstants.getPeachDark())
                          ),
                        ),
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          text: DateFormat('MMM dd, yyyy').format(pageState.depositDueDate),
                          color: Color(ColorConstants.getPeachDark()),
                        ),
                      ),
                    ],
                  ) : Container(
                    padding: EdgeInsets.all(24.0),
                    height: 116.0,
                    width: 116.0,
                    decoration: BoxDecoration(
                      color: Color(ColorConstants.getBlueLight()),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/icons/calendar.png', color: Color(ColorConstants.getPrimaryWhite()),),
                  ),
                ),
              ) : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}