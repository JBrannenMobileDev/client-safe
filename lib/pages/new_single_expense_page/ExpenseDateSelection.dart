import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_single_expense_page/NewSingleExpensePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import '../../widgets/TextDandyLight.dart';

class ExpenseDateSelection extends StatefulWidget {

  @override
  _ExpenseDateSelectionState createState() {
    return _ExpenseDateSelectionState();
  }
}

class _ExpenseDateSelectionState extends State<ExpenseDateSelection> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewSingleExpensePageState>(
      converter: (store) => NewSingleExpensePageState.fromStore(store),
      builder: (BuildContext context, NewSingleExpensePageState pageState) =>
      Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 32.0, right: 32),
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: 'Select the date that this expense was charged.',
                  textAlign: TextAlign.start,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 48.0),
                alignment: Alignment.center,
                child: TextButton(
                  style: Styles.getButtonStyle(),
                  onPressed: () {
                    DatePicker.showDatePicker(
                        context,
                        dateFormat: 'MMMM dd yyyy',
                        pickerMode: DateTimePickerMode.date,
                        pickerTheme: DateTimePickerTheme(
                          cancelTextStyle: TextStyle(
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                          confirmTextStyle: TextStyle(
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                        onConfirm: (dateTime, intList) {
                          pageState.onExpenseDateSelected!(dateTime);
                        }
                    );
                  },
                  child: pageState.expenseDate != null ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(16.0),
                        height: 76.0,
                        width: 76.0,
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
                          text: DateFormat('MMM dd, yyyy').format(pageState.expenseDate!),
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
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}